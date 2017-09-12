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
    let readQueue = DispatchQueue(label: "packet_read_queue", attributes: []);
    var readSource: DispatchSource?;
    
    init(conn:Connection, receiver:PacketReceiver){
        self.connection = conn;
        self.receiver = receiver;
    }
    
    func startRead(){
        //self.thread = NSThread(target: self, selector:#selector(PacketReader.doRead), object: nil)
        //self.thread!.start()
        if connection.fd > 0 {
            let source = DispatchSource.makeReadSource(fileDescriptor: connection.fd, queue: readQueue);
            self.readSource = source as! DispatchSource;
            self.buffer.clear();
            source.setEventHandler(handler: doRead);
            source.setCancelHandler(handler: {
                print("read source cancelled");
            });
            source.resume();
        }
    }
    
    func stopRead() {
        //self.thread!.cancel();
        if let source = readSource {
            source.cancel()
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
    
    func decodePacket(_ buffer:UnsafeBuffer) {
        while let packet = PacketDecoder.decode(buffer) {
            receiver.onReceive(packet, connection: self.connection)
        }
    }
    
    /*
     * read data with expect length
     * return success or fail with message
     */
    func read(_ buffer:UnsafeBuffer, timeout:Int = -1) -> Bool {
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
