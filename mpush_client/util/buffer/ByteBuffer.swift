//
//  ByteBuffer.swift
//  mpush-client
//
//  Created by OHUN on 16/6/3.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class ByteBuffer {
    
    var buffer:NSMutableData
    lazy var readIndex = 0;
    
    init(data:[UInt8], index:Int=0){
        self.buffer = NSMutableData(bytes: data, length:data.count);
        self.readIndex = index;
    }
    
    init(data:Data, index:Int=0){
        self.buffer = NSData(data: data) as Data as Data as! NSMutableData;
        self.readIndex = index;
    }
    
    init(buffer:NSMutableData = NSMutableData()){
        self.buffer = buffer;
    }
    
    func encodeByte(_ data:inout Int8) {
        buffer.append(&data, length:1)
    }
    
    func encodeInt16(_ data:Int16) {
        var d = data.bigEndian
        buffer.append(&d, length: 4)
    }
    
    func encodeInt32(_ data:Int32) {
        var d = data.bigEndian
        buffer.append(&d, length: 4)
    }
    
    func encodeInt64(_ data:Int64) {
        var d = data.bigEndian
        buffer.append(&d, length: 8)
    }
    
    func encodeByte(_ data:inout UInt8) {
        buffer.append(&data, length:1)
    }
    
    func encodeInt16(_ data:UInt16) {
        var d = data.bigEndian
        buffer.append(&d, length: 4)
    }
    
    func encodeInt32(_ data:UInt32) {
        var d = data.bigEndian
        buffer.append(&d, length: 4)
    }
    
    func encodeInt64(_ data:UInt64) {
        var d = data.bigEndian
        buffer.append(&d, length: 8)
    }
    
    func encodeString(_ data:String?) {
        if let s = data {
            encodeBytes(Array(s.utf8))
        }else{
            encodeBytes([UInt8](repeating: 0, count: 0))
        }
    }
    
    func encodeBytes(_ data:[UInt8]?) {
        if let b = data {
            var len:UInt16 = UInt16(b.count).bigEndian
            buffer.append(&len, length: 2)
            if(len > 0) {
                buffer.append(b, length: b.count)
            }
        }else{
            var len:UInt16 = 0
            buffer.append(&len, length: 2)
        }
    }
    
    func encodeBytes(_ data:[Int8]?) {
        if let b = data {
            var len:UInt16 = UInt16(b.count).bigEndian
            buffer.append(&len, length: 2)
            if(len > 0) {
                buffer.append(b, length: b.count)
            }
        }else{
            var len:UInt16 = 0
            buffer.append(&len, length: 2)
        }
    }
    
    func decodeByte() -> Int8 {
        var data:Int8 = 0
        buffer.getBytes(&data, range: NSRange(location: readIndex, length: 1))
        readIndex += 1
        return data;
    }
    
    func decodeInt16() -> Int16 {
        var data:Int16 = 0
        buffer.getBytes(&data, range: NSRange(location: readIndex, length: 2))
        readIndex += 2
        return data.bigEndian;
    }
    
    func decodeInt() -> Int32 {
        var data:Int32 = 0;
        buffer.getBytes(&data, range: NSRange(location: readIndex, length: 4))
        readIndex += 4
        return data.bigEndian;
    }
    
    func decodeInt64() -> Int64 {
        var data:Int64 = 0;
        buffer.getBytes(&data, range: NSRange(location: readIndex, length: 8))
        readIndex += 8
        return data.bigEndian;
    }
    
    func decodeString() -> String? {
        if let data = decodeData() {
            return String(data: data, encoding: String.Encoding.utf8)
        }
        return nil;
    }
    
    func decodeData() -> Data? {
        let length = Int(decodeInt16());
        if(length > 0){
            let data =  buffer.subdata(with: NSRange(location: readIndex, length: length));
            readIndex += length;
            return data;
        }
        return nil;
    }
    
    func decodeBytes() -> [Int8]? {
        let length = Int(decodeInt16());
        if(length > 0){
            var data = [Int8](repeating: 0, count: length)
            buffer.getBytes(&data, range: NSRange(location: readIndex, length: length))
            readIndex += length
            return data;
        }
        return nil;
    }
}
