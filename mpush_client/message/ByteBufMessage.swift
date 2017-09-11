//
//  ByteBufMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class ByteBufMessage: BaseMessage {
    

    override func decode(_ body:Data) {
        decode(RFIReader(data: body));
    }
    
    
    override func encode() -> Data {
        let body = RFIWriter(capacity: 1024);
        encode(body!);
        return body!.getBuffer() as Data;
    }
    
    func decode(_ body:RFIReader){
    
    }
    
    func encode(_ body:RFIWriter){
    
    }
    
    func encodeString(_ body:RFIWriter, field:String) {
        body.write(field);
    }
    
    func encodeByte(_ body:RFIWriter, field:Int8) {
         body.writeByte(field);
    }
    
    func encodeInt(_ body:RFIWriter, field:Int) {
        body.write(Int32(field));
    }
    
    func encodeLong(_ body:RFIWriter, field:Int64) {
        body.write(field);
    }
    
    func encodeBytes(_ body:RFIWriter, bytes:[Int8]) {
        body.writeData(Data(bytes: bytes, count: bytes.count))
    }
    
    func decodeString(_ body:RFIReader) -> String {
        return body.readString();
    }
    
    func decodeBytes(_ body:RFIReader) -> Data {
        return body.readData();
    }
    
    func decodeByte(_ body:RFIReader)  -> Int8 {
        return body.readByte();
    }
    
    func decodeInt(_ body:RFIReader) -> Int32 {
        return body.readInt32();
    }
    
    func decodeLong(_ body:RFIReader) -> Int64 {
        return body.readInt64();
    }
}
