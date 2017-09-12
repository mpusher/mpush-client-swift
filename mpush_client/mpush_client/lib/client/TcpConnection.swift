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
    fileprivate enum State: Int32 {
        case connecting, connected, disconnecting, disconnected
    }
    
    var fd: Int32 = 0;
    var client: Client;
    var context: SessionContext;
    
    
    fileprivate let connLock = NSCondition();
    fileprivate let config:ClientConfig ;
    fileprivate let logger:Logger;
    fileprivate let listener:ClientListener;
    
    fileprivate var state = State.disconnected.rawValue;
   
    fileprivate var writer: PacketWriter!;
    fileprivate var reader: PacketReader!;
    
    fileprivate var lastReadTime:Double = 0;
    fileprivate var lastWriteTime:Double = 0;
    
    fileprivate var totalReconnectCount = 0;
    fileprivate var reconnectCount = 0;
    fileprivate var autoConnect = true;
    fileprivate let connectThread = ConnectThread();
    fileprivate let allotClient = AllotClient();
    

    init(client:Client, receiver:PacketReceiver){
        self.client = client;
        self.context = SessionContext();
        self.config = ClientConfig.I;
        self.logger = config.logger;
        self.listener = config.clientListener;
        self.reader = PacketReader(conn: self, receiver: receiver);
        self.writer = PacketWriter(conn: self, connLock: connLock);
    }
    
    fileprivate func onConnected(_ fd: Int32) {
        self.reconnectCount = 0;
        self.fd = fd;
        self.context = SessionContext();
        self.state = State.connected.rawValue;
        self.reader.startRead();
        logger.w("connection connected !!!");
        listener.onConnected(client);
    }
    
    func close() {
        if(compareAndSwapState(old: .connected, new: .disconnecting)) {
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
    fileprivate func doClose() {
        connLock.lock();
        if fd > 0 {
            tcpsocket_close(fd)
            self.fd = 0;
            listener.onDisConnected(client);
            logger.w("fd closed !!!");
        }
        state = State.disconnected.rawValue;
        connLock.unlock();
    }
    
    func connect() {
        if(compareAndSwapState(old: .disconnected, new: .connecting)) {
            connectThread.start();
            connectThread.addTask(self.doReconnect)
        }
    }
    
    func reconnect() {
        close();
        connect();
    }
    
    fileprivate func doReconnect() -> Bool {
        if (totalReconnectCount > TcpConnection.MAX_TOTAL_RESTART_COUNT || !autoConnect) {// 过载保护
            logger.w({"doReconnect failure reconnect count over limit or autoConnect off,"
                + "total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
            state = State.disconnected.rawValue;
            return true;
        }
    
        reconnectCount += 1;    // 记录重连次数
        totalReconnectCount += 1;
        
        connLock.lock();
        logger.d({"try doReconnect, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
        
        if (reconnectCount > TcpConnection.MAX_RESTART_COUNT) {    // 超过此值 sleep 10min
            if (connLock.wait(until: Date().addingTimeInterval(10 * 60))) {
                state = State.disconnected.rawValue;
                connLock.unlock();
                return true;
            } else {
                reconnectCount = 0;
            }
        } else if (reconnectCount > 2) {             // 第二次重连时开始按秒sleep，然后重试
            if (connLock.wait(until: Date().addingTimeInterval(Double(reconnectCount)))) {
                state = State.disconnected.rawValue;
                connLock.unlock();
                return true;
            }
        }
        connLock.unlock();
        
        if (state != State.connecting.rawValue || !autoConnect) {
            logger.w({"doReconnect failure, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
            state = State.disconnected.rawValue;
            return true;
        }
    
        logger.w({"doReconnect, count=\(self.reconnectCount), total=\(self.totalReconnectCount), state=\(self.state), autoConnect=\(self.autoConnect)"});
        return doConnect();
    }
    
    fileprivate func doConnect() -> Bool {
        var address = allotClient.getServerAddress();
        
        for i in 0 ..< address.count {
           let host_ip =  address[i].components(separatedBy: ":");
            if(host_ip.count == 2){
                let host = host_ip[0];
                let port = Int32(host_ip[1]);
                return doConnect(host, port: port!);
            }
            
            address.remove(at: i);
        }
        
        return false;
    }
    
    fileprivate func doConnect(_ host:String, port:Int32, timeout:Int32 = 3) -> Bool {
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
    
    func setAutoConnect(_ autoConnect: Bool) {
        self.connLock.lock();
        self.autoConnect = autoConnect;
        self.connLock.broadcast();
        self.connLock.unlock();
    }
    
    func isConnected() -> Bool {
        return fd > 0 && state == State.connected.rawValue;
    }
    
    func send(_ packet:Packet) {
        writer.write(packet);
    }
    
    func isReadTimeout() -> Bool {
        let last = CFTimeInterval() - lastReadTime;
        let hb = Double(context.heartbeat/1000) + 1;
        return last > hb;
    }
    
    func isWriteTimeout() -> Bool {
        let last = CFTimeInterval() - lastWriteTime;
        let hb = Double(context.heartbeat/1000) - 1;
        return last > hb;
    }
    
    func setLastReadTime() {
        lastReadTime = CFTimeInterval();
    }
    
    func setLastWriteTime() {
        lastWriteTime = CFTimeInterval();
    }

    fileprivate func compareAndSwapState(old: State, new: State) -> Bool {
        return OSAtomicCompareAndSwap32(old.rawValue, new.rawValue, &state);
    }
}

// Use XCTAssert and related functions to verify your tests produce the correct results.
