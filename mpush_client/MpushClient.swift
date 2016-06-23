//
//  MpushClient.swift
//  mpush-client-ios
//
//  Created by OHUN on 16/5/31.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class MpushClient:Client {
    private static let MAX_HB_TIMEOUT_COUNT = 2;
    private let receiver = MessageDispatcher();
    private let config:ClientConfig;
    private let logger:Logger;
    private var hbTimeoutTimes = 0;
    private var connection:Connection!;
    private var httpQueue: HttpRequestQueue!;
    
    init(config: ClientConfig) {
        self.config = config;
        self.logger = config.logger
        self.connection = TcpConnection(client: self, receiver: receiver);
        if(config.enableHttpProxy){
            self.httpQueue = HttpRequestQueue();
            receiver.register(Command.HTTP_PROXY, handler: HttpProxyHandler(queue: httpQueue));
        }
    }
    
    func start() {
        connection.setAutoConnect(true);
        connection.connect();
        logger.w("do start client ...");
    }
    
    func stop() {
        logger.w("client shutdown !!!, state=\(self)");
        connection.setAutoConnect(false);
        connection.close();
    }
    
    func destroy() {
        stop();
    }
    
    func isRunning() -> Bool {
        return connection.isConnected();
    }    
    
    func fastConnect() {
        let storage = config.sessionStorage;
        
        guard let  ss = storage.getSession() else {
            handshake();
            return;
        }
        
        guard let session = PersistentSession.decode(ss) else {
            storage.clearSession();
            logger.w({"fast connect failure session decode error, session=\(ss)"});
            handshake();
            return;
        }
        
        if (session.isExpired()) {
            storage.clearSession();
            logger.w({"fast connect failure session expired, session=\(session)"});
            handshake();
            return;
        }
        
        let message = FastConnectMessage(connection: connection);
        message.deviceId = config.deviceId;
        message.sessionId = session.sessionId;
        message.maxHeartbeat = config.maxHeartbeat;
        message.minHeartbeat = config.minHeartbeat;
        message.sendRaw();
        
        connection.context.changeCipher(session.cipher);
        
        logger.w({"<<< do fast connect, message=\(message)"});
    }
    
    func handshake() {
        let message = HandshakeMessage(connection: connection);
        message.deviceId = config.deviceId;
        message.osName = config.osName;
        message.osVersion = config.osVersion;
        message.clientVersion = config.clientVersion;
        message.iv = CipherBox.randomAESIV();
        message.clientKey = CipherBox.randomAESKey();
        message.minHeartbeat = config.minHeartbeat;
        message.maxHeartbeat = config.maxHeartbeat;
        
        connection.context.changeCipher(RsaCipher());
        message.send();
        connection.context.changeCipher(AesCipher(iv: message.iv, key: message.clientKey));
        
        logger.w({"<<< do handshake, message=\(message)"});
    }
    
    func bindUser(userId: String?) {
        guard let uid = userId else {
            logger.w("bind user is null");
            return;
        }

        let context = connection.context;
        if (uid == context.bindUser) {return;}
        
        context.setBindUser(uid);
        config.userId = uid;
        BindUserMessage
            .buildBind(connection)
            .setUserId(uid)
            .send();
        
        logger.w({"<<< do bind user, userId=\(uid)"});
    }
    
    func unbindUser() {
        guard let uid = ClientConfig.I.userId else {
            logger.w("unbind user is null");
            return;
        }
        
        connection.context.setBindUser(nil);
        config.userId = nil;
        
        BindUserMessage
            .buildUnbind(connection)
            .setUserId(uid)
            .send();
        
        logger.w({"<<< do unbind user, userId=\(uid)"});
    }
    
    func sendHttp(request: HttpRequest) -> ResponseFuture {
        if (connection.context.handshakeOk()) {
            let message = HttpRequestMessage(connection: connection);
            message.method = request.method.rawValue;
            message.uri = request.uri;
            message.headers = request.getHeaders();
            message.body = request.getBody();
            message.send();
            logger.d({"<<< send http proxy, request=\(request)"});
            return httpQueue.add(message.getSessionId(), request: request);
        }
        fatalError("not handshake ok")
    }
    
    func healthCheck() -> Bool {
        
        if (connection.isReadTimeout()) {
            hbTimeoutTimes += 1;
            logger.w({"heartbeat read timeout times=\(self.hbTimeoutTimes)"});
        } else {
            hbTimeoutTimes = 0;
        }
        
        if (hbTimeoutTimes >= MpushClient.MAX_HB_TIMEOUT_COUNT) {
            logger.w("heartbeat read timeout times=\(self.hbTimeoutTimes) over limit=\(MpushClient.MAX_HB_TIMEOUT_COUNT), client restart");
            hbTimeoutTimes = 0;
            connection.reconnect();
            return false;
        }
        
        if (connection.isWriteTimeout()) {
            logger.d("<<< send heartbeat ping...");
            connection.send(Packet.HB_PACKET);
        }
        
        return true;
    }
}
