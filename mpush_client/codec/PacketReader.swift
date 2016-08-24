//
//  PacketReader.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class PacketReader {
    let connection:Connection;
    let receiver:PacketReceiver;
    let buffer = UnsafeBuffer(initCapacity: 10240);
    let readQueue = dispatch_queue_create("packet_read_queue", DISPATCH_QUEUE_SERIAL);
    var readSource: dispatch_source_t?;
    
    init(conn:Connection, receiver:PacketReceiver){
        self.connection = conn;
        self.receiver = receiver;
    }
    
    func startRead(){
        //self.thread = NSThread(target: self, selector:#selector(PacketReader.doRead), object: nil)
        //self.thread!.start()
        if connection.fd > 0 {
            let source = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, UInt(connection.fd), 0, readQueue);
            self.readSource = source;
            self.buffer.clear();
            dispatch_source_set_event_handler(source, doRead);
            dispatch_source_set_cancel_handler(source, {
                print("read source cancelled");
            });
            dispatch_resume(source);
        }
    }
    
    func stopRead() {
        //self.thread!.cancel();
        if let source = readSource {
            dispatch_source_cancel(source)
        }
    }
    
    func doRead() {
        buffer.ensureCapacity(1024);
        if(read(buffer)) {
            decodePacket(buffer);
            buffer.compact();
        } else {
            self.connection.reconnect();
        }
    }
    
    func decodePacket(buffer:UnsafeBuffer) {
        while let packet = PacketDecoder.decode(buffer) {
            receiver.onReceive(packet, connection: self.connection)
        }
    }
    
    /*
     * read data with expect length
     * return success or fail with message
     */
    func read(buffer:UnsafeBuffer, timeout:Int = -1) -> Bool {
        if connection.fd > 0 {
            let readLen:Int32 = tcpsocket_read(connection.fd, buffer.writeBuffer(), Int32(buffer.writeableBytes()), Int32(timeout))
            if readLen > 0 {
                buffer.write(Int(readLen));
                connection.setLastReadTime();
                return true;
            }
        }
        return false;
    }
   
    deinit {
        buffer.dealloc();
    }

}