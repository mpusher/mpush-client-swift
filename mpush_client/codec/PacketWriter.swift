//
//  PacketWriter.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class PacketWriter {
    static let DEFAULT_WRITE_TIMEOUT:Double = 10;
    let connection:Connection;
    let writeQueue = DispatchQueue(label: "packet_write_queue", attributes: []);
    let buffer = UnsafeBuffer(initCapacity: 10240);
    let connLock:NSCondition;
    let logger = ClientConfig.I.logger;
    init(conn:Connection, connLock:NSCondition){
        self.connection = conn;
        self.connLock = connLock;
    }
    
    func write(_ packet:Packet) {
        let sendTime = CACurrentMediaTime();
        writeQueue.async(execute: {
            self.buffer.clear();
            PacketEncoder.encode(packet, out: self.buffer);
            while(self.buffer.hasRemaining()){
                let ret = self.write(self.buffer);
                if(ret == 1) {
                    self.connection.setLastWriteTime();
                } else if(ret == 0) {
                    self.logger.e({"write packet failure, do reconnect, packet=\(packet)"});
                    if(self.isTimeout(sendTime)){
                        self.logger.w({"ignored timeout packet=\(packet), sendTime=\(sendTime)"});
                        return;
                    }
                    self.connection.reconnect();
                } else if(self.isTimeout(sendTime)){
                    self.logger.w({"ignored timeout packet=\(packet), sendTime=\(sendTime)"});
                    return;
                } else {
                    self.connLock.lock();
                    self.connLock.wait(until: Date().addingTimeInterval(PacketWriter.DEFAULT_WRITE_TIMEOUT));
                    self.connLock.unlock();
                }
            }
            //self.buffer.compact();
        });
    }
    
    fileprivate func isTimeout(_ start:CFTimeInterval) -> Bool{
        return CACurrentMediaTime() - start > PacketWriter.DEFAULT_WRITE_TIMEOUT;
    }
    
    /*
     * write data
     * return success or fail with message
     */
   fileprivate func write(_ buffer:UnsafeBuffer) -> Int {
        if connection.fd > 0 {
            let readableBytes = buffer.readableBytes();
            let writeLen:Int32 = tcpsocket_write(connection.fd, buffer.readBuffer(), Int32(readableBytes))
            if Int(writeLen) == readableBytes {
                buffer.read(readableBytes);
                return 1;
            } else {
                return 0;
            }
        } else{
            return -1;
        }
    }
    
    
    deinit {
        buffer.dealloc();
    }
    
}
