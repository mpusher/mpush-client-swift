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
    
    init(data:NSData, index:Int=0){
        self.buffer = NSMutableData(data: data);
        self.readIndex = index;
    }
    
    init(buffer:NSMutableData = NSMutableData()){
        self.buffer = buffer;
    }
    
    func encodeByte(inout data:Int8) {
        buffer.appendBytes(&data, length:1)
    }
    
    func encodeInt16(data:Int16) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 4)
    }
    
    func encodeInt32(data:Int32) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 4)
    }
    
    func encodeInt64(data:Int64) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 8)
    }
    
    func encodeByte(inout data:UInt8) {
        buffer.appendBytes(&data, length:1)
    }
    
    func encodeInt16(data:UInt16) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 4)
    }
    
    func encodeInt32(data:UInt32) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 4)
    }
    
    func encodeInt64(data:UInt64) {
        var d = data.bigEndian
        buffer.appendBytes(&d, length: 8)
    }
    
    func encodeString(data:String?) {
        if let s = data {
            encodeBytes(Array(s.utf8))
        }else{
            encodeBytes([UInt8](count: 0, repeatedValue: 0))
        }
    }
    
    func encodeBytes(data:[UInt8]?) {
        if let b = data {
            var len:UInt16 = UInt16(b.count).bigEndian
            buffer.appendBytes(&len, length: 2)
            if(len > 0) {
                buffer.appendBytes(b, length: b.count)
            }
        }else{
            var len:UInt16 = 0
            buffer.appendBytes(&len, length: 2)
        }
    }
    
    func encodeBytes(data:[Int8]?) {
        if let b = data {
            var len:UInt16 = UInt16(b.count).bigEndian
            buffer.appendBytes(&len, length: 2)
            if(len > 0) {
                buffer.appendBytes(b, length: b.count)
            }
        }else{
            var len:UInt16 = 0
            buffer.appendBytes(&len, length: 2)
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
            return String(data: data, encoding: NSUTF8StringEncoding)
        }
        return nil;
    }
    
    func decodeData() -> NSData? {
        let length = Int(decodeInt16());
        if(length > 0){
            let data =  buffer.subdataWithRange(NSRange(location: readIndex, length: length));
            readIndex += length;
            return data;
        }
        return nil;
    }
    
    func decodeBytes() -> [Int8]? {
        let length = Int(decodeInt16());
        if(length > 0){
            var data = [Int8](count: length, repeatedValue: 0)
            buffer.getBytes(&data, range: NSRange(location: readIndex, length: length))
            readIndex += length
            return data;
        }
        return nil;
    }
}