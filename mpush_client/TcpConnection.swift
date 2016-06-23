//
//  TcpConnection.swift
//  mpush-client
//
//  Created by OHUN on 16/5/31.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class TcpConnection: Connection {
    static let MAX_TOTAL_RESTART_COUNT = 1000;
    static let MAX_RESTART_COUNT = 10;
    private enum State: Int32 {
        case Connecting, Connected, Disconnecting, Disconnected
    }
    
    var fd: Int32 = 0;
    var client: Client;
    var context: SessionContext;
    
    
    private let connLock = NSCondition();
    private let config:ClientConfig ;
    private let logger:Logger;
    private let listener:ClientListener;
    
    private var state = State.Disconnected.rawValue;
   
    private var writer: PacketWriter!;
    private var reader: PacketReader!;
    
    private var lastReadTime:Double = 0;
    private var lastWriteTime:Double = 0;
    
    private var totalReconnectCount = 0;
    private var reconnectCount = 0;
    private var autoConnect = true;
    private let connectThread = ConnectThread();
    private let allotClient = AllotClient();
    

    init(client:Client, receiver:PacketReceiver){
        self.client = client;
        self.context = SessionContext();
        self.config = ClientConfig.I;
        self.logger = config.logger;
        self.listener = config.clientListener;
        self.reader = PacketReader(conn: self, receiver: receiver);
        self.writer = PacketWriter(conn: self, connLock: connLock);
    }
    
    private func onConnected(fd: Int32) {
        self.reconnectCount = 0;
        self.fd = fd;
        self.context = SessionContext();
        self.state = State.Connected.rawValue;
        self.reader.startRead();
        logger.w("connection connected !!!");
        listener.onConnected(client);
    }
    
    func close() {
        if(compareAndSwapState(old: .Connected, new: .Disconnecting)) {
            connectThread.stop();
            reader.stopRead();
            doClose();
            logger.w("connection closed !!!");
        }
    }
    
    /*
     * close socket
     * return success or fail with message
     */
    private func doClose() {
        connLock.lock();
        if fd > 0 {
            tcpsocket_close(fd)
            self.fd = 0;
            listener.onDisConnected(client);
            logger.w("fd closed !!!");
        }
        state = State.Disconnected.rawValue;
        connLock.unlock();
    }
    
    func connect() {
        if(compareAndSwapState(old: .Disconnected, new: .Connecting)) {
            connectThread.start();
            connectThread.addTask(self.doReconnect)
        }
    }
    
    func reconnect() {
        close();
        connect();
    }
    
    private func doReconnect() -> Bool {
        if (totalReconnectCount > TcpConnection.MAX_TOTAL_RESTART_COUNT || !autoConnect) {// 过载保护
            logger.w({"doReconnect failure reconnect count over limit or autoConnect off,"
                + "total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
            state = State.Disconnected.rawValue;
            return true;
        }
    
        reconnectCount += 1;    // 记录重连次数
        totalReconnectCount += 1;
        
        connLock.lock();
        logger.d({"try doReconnect, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
        
        if (reconnectCount > TcpConnection.MAX_RESTART_COUNT) {    // 超过此值 sleep 10min
            if (connLock.waitUntilDate(NSDate().dateByAddingTimeInterval(10 * 60))) {
                state = State.Disconnected.rawValue;
                connLock.unlock();
                return true;
            } else {
                reconnectCount = 0;
            }
        } else if (reconnectCount > 2) {             // 第二次重连时开始按秒sleep，然后重试
            if (connLock.waitUntilDate(NSDate().dateByAddingTimeInterval(Double(reconnectCount)))) {
                state = State.Disconnected.rawValue;
                connLock.unlock();
                return true;
            }
        }
        connLock.unlock();
        
        if (state != State.Connecting.rawValue || !autoConnect) {
            logger.w({"doReconnect failure, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
            state = State.Disconnected.rawValue;
            return true;
        }
    
        logger.w({"doReconnect, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
        return doConnect();
    }
    
    private func doConnect() -> Bool {
        var address = allotClient.getServerAddress();
        
        for i in 0 ..< address.count {
           let host_ip =  address[i].componentsSeparatedByString(":");
            if(host_ip.count == 2){
                let host = host_ip[0];
                let port = Int32(host_ip[1]);
                return doConnect(host, port: port!);
            }
            
            address.removeAtIndex(i);
        }
        
        return false;
    }
    
    private func doConnect(host:String, port:Int32, timeout:Int32 = 3) -> Bool {
        connLock.lock();
        defer {connLock.unlock()};
        logger.w({"try connect server [\(host):\(port)]"});
        let fd = tcpsocket_connect(host, port, timeout);
        if fd > 0 {
            logger.w({"connect server success [\(host):\(port)]"});
            onConnected(fd);
            connLock.broadcast();
            return true;
        } else {
            logger.w({
                var message = "unknow err."
                switch fd {
                    case -1: message = "qeury server fail";
                    case -2: message = "connection closed";
                    case -3: message = "connect timeout";
                    default: message = "unknow err."
                }
                return "connect server ex, [\(host):\(port)], fd=\(fd), message=\(message)"
            });
            return false;
        }    
    }
    
    func setAutoConnect(autoConnect: Bool) {
        self.connLock.lock();
        self.autoConnect = autoConnect;
        self.connLock.broadcast();
        self.connLock.unlock();
    }
    
    func isConnected() -> Bool {
        return fd > 0 && state == State.Connected.rawValue;
    }
    
    func send(packet:Packet) {
        writer.write(packet);
    }
    
    func isReadTimeout() -> Bool {
        let last = CACurrentMediaTime() - lastReadTime;
        let hb = Double(context.heartbeat/1000) + 1;
        return last > hb;
    }
    
    func isWriteTimeout() -> Bool {
        let last = CACurrentMediaTime() - lastWriteTime;
        let hb = Double(context.heartbeat/1000) - 1;
        return last > hb;
    }
    
    func setLastReadTime() {
        lastReadTime = CACurrentMediaTime();
    }
    
    func setLastWriteTime() {
        lastWriteTime = CACurrentMediaTime();
    }

    private func compareAndSwapState(old old: State, new: State) -> Bool {
        return OSAtomicCompareAndSwap32(old.rawValue, new.rawValue, &state);
    }
}

// Use XCTAssert and related functions to verify your tests produce the correct results.