//
//  ByteBufMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class ByteBufMessage: BaseMessage {
    

    override func decode(body:NSData) {
        decode(RFIReader(data: body));
    }
    
    
    override func encode() -> NSData {
        let body = RFIWriter(capacity: 1024);
        encode(body);
        return body.getBuffer();
    }
    
    func decode(body:RFIReader){
    
    }
    
    func encode(body:RFIWriter){
    
    }
    
    func encodeString(body:RFIWriter, field:String) {
        body.writeString(field);
    }
    
    func encodeByte(body:RFIWriter, field:Int8) {
         body.writeByte(field);
    }
    
    func encodeInt(body:RFIWriter, field:Int) {
        body.writeInt32(Int32(field));
    }
    
    func encodeLong(body:RFIWriter, field:Int64) {
        body.writeInt64(field);
    }
    
    func encodeBytes(body:RFIWriter, bytes:[Int8]) {
        body.writeData(NSData(bytes: bytes, length: bytes.count))
    }
    
    func decodeString(body:RFIReader) -> String {
        return body.readString();
    }
    
    func decodeBytes(body:RFIReader) -> NSData {
        return body.readData();
    }
    
    func decodeByte(body:RFIReader)  -> Int8 {
        return body.readByte();
    }
    
    func decodeInt(body:RFIReader) -> Int32 {
        return body.readInt32();
    }
    
    func decodeLong(body:RFIReader) -> Int64 {
        return body.readInt64();
    }
}