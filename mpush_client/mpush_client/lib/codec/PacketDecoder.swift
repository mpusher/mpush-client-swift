//
//  PacketDecoder.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class PacketDecoder {
  
    class func decode(_ buffer:UnsafeBuffer) -> Packet? {
        if let hb = decodeHeartbeat(buffer) {
            return hb;
        }
        return decodeFrame(buffer);
    }
    
    
    class func decodeHeartbeat(_ buffer:UnsafeBuffer) -> Packet? {
        if(buffer.hasRemaining()){
            buffer.mark();
            if(buffer.readByte() == Packet.HB_PACKET_BYTE){
                return Packet.HB_PACKET;
            }
            buffer.reset();
        }
        return nil;
    }
    
    class func decodeFrame(_ buffer:UnsafeBuffer) -> Packet? {
        if (buffer.readableBytes() >= Packet.HEADER_LEN) {
            buffer.mark();
            let bufferSize = buffer.readableBytes();
            let bodyLength = Int(buffer.readInt());
            if (bufferSize >= (bodyLength + Packet.HEADER_LEN)) {
                return readPacket(buffer, bodyLength: bodyLength);
            }
            buffer.reset();
        }
        return nil;
    }
    
    class func readPacket(_ buffer:UnsafeBuffer, bodyLength:Int) -> Packet? {
        let command = buffer.readByte();
        let cc = buffer.readShort();
        let flags = buffer.readByte()
        let sessionId = buffer.readInt();
        let lrc = buffer.readByte();
        
        var body:Data?;
        if (bodyLength > 0) {
            let data = buffer.readBytes(bodyLength)
            
            
            body = Data(bytes: data, count: data.count);
        }
        return Packet(cmd: command, cc: cc, flags: flags, sessionId: sessionId, lrc: lrc, body: body);
    }
    
}
