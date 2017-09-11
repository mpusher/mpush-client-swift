//
//  HandshakeHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class HandshakeOkHandler: BaseMessageHandler<HandshakeOkMessage> {
    
    override func decode(_ packet:Packet, connection:Connection) -> HandshakeOkMessage {
        return HandshakeOkMessage(packet: packet, conn: connection);
    }
    
    override func handle(_ message: HandshakeOkMessage) {
        let connection = message.getConnection();
        let context = connection.context;
        
        context.setHeartbeat(message.heartbeat);
        
        //更换密钥
        let cipher:AesCipher = context.cipher as! AesCipher;
        let sessionKey = CipherBox.mixKey(cipher.key, serverKey: message.serverKey.toBytes());
        context.changeCipher(AesCipher(key: sessionKey, iv: cipher.iv));
        
        let listener =  ClientConfig.I.clientListener;
        listener.onHandshakeOk(connection.client, heartbeat: message.heartbeat);
        saveToken(message, context: context);
        ClientConfig.I.logger.w({">>> handshake ok message=\(message), context=\(context)"});
    }
    
    fileprivate func saveToken(_ message: HandshakeOkMessage, context:SessionContext) {
        let storage = ClientConfig.I.sessionStorage;
        let session = PersistentSession(sessionId: message.sessionId, expireTime: message.expireTime, cipher: context.cipher!);
        storage.saveSession(PersistentSession.encode(session));
    }
}
