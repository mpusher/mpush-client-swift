//
//  UnsafeBuffer.swift
//  mpush-client
//
//  Created by OHUN on 16/6/3.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

final class UnsafeBuffer {
    enum BufferError:ErrorType {
        case ReadIndexError;
    }
    var buffer:UnsafeMutablePointer<Int8>;
    var capacity:Int;
    
    var readPointer:UnsafeMutablePointer<Int8>;
    var writePointer:UnsafeMutablePointer<Int8>;
    var readMark:UnsafeMutablePointer<Int8>?;
    var writeMark:UnsafeMutablePointer<Int8>?;
    
    init(initCapacity:Int){
        self.capacity = initCapacity;
        self.buffer = UnsafeMutablePointer<Int8>.alloc(initCapacity);
        self.readPointer = buffer;
        self.writePointer = buffer;
    }
    
    func dealloc() {
        buffer.destroy()
        buffer.dealloc(capacity)
        readPointer=nil;
        writePointer=nil;
        //free(buffer);
    }
    
    func writeableBytes() -> Int {
        return capacity - (writePointer - buffer);
    }
    
    func readableBytes() -> Int {
        return writePointer - readPointer;
    }
    
    func ensureCapacity(ensureBytes:Int){
        let remind = writeableBytes();
        
        if (ensureBytes > remind) {
            let additionalBytes = ensureBytes - remind;
            
            let newCapacity = capacity + additionalBytes;
            let newBuffer = realloc(buffer, newCapacity);
            
            let readPointerOffset = readPointer - buffer;
            let writePointerOffset = writePointer - buffer;
            
            self.buffer = unsafeBitCast(newBuffer, UnsafeMutablePointer<Int8>.self);
            self.capacity = newCapacity;
            
            self.readPointer = buffer + readPointerOffset;
            self.writePointer = buffer + writePointerOffset;
        }
    }
    
    func hasRemaining() -> Bool {
        return readableBytes() > 0
    }
    
    func compact(){
        if(readPointer == buffer){
            return;
        }
        let count = readableBytes() - 1;
        for i in 0 ... count {
            buffer[i] = readPointer[i];
        }
        readPointer = buffer;
        writePointer = buffer + count;
    }
    
    func mark(){
        readMark = readPointer;
        writeMark = writePointer;
    }
    
    func reset(){
        if let rm = readMark, wm = writeMark{
            readPointer = rm
            writePointer = wm;
            readMark=nil
            writeMark=nil
        }
    }
    
    func clear() {
        readPointer  = buffer;
        writePointer = buffer;
    }
    
    func write(count:Int) {
        writePointer += count;
    }
    
    func writeBuffer() -> UnsafeMutablePointer<Int8> {
        return writePointer;
    }
    
    func readBuffer() -> UnsafeMutablePointer<Int8> {
        return readPointer;
    }
    
    func read(count:Int){
        readPointer += count;
        
        if (readPointer == writePointer){
            // The prebuffer has been drained. Reset pointers.
            clear();
        }
    }
    
    func checkReadIndex(count:Int) throws {
        let readableBytes = self.readableBytes();
        if(count == 0 || count > readableBytes||readableBytes == 0){
            throw BufferError.ReadIndexError;
        }
    }
    
    func readByte() -> Int8 {
        let readCount = 1;
        try!checkReadIndex(readCount);
        //let memory = UnsafeBufferPointer(start: readPointer, count: readCount);
        //read(readCount)
        //return memory[0];
        let data = readPointer[0]
        read(readCount)
        return data;
    }
    
    func readShort() -> Int16 {
        let readCount = 2;
        try!checkReadIndex(readCount);
        //let memory = UnsafeBufferPointer(start: readPointer, count: readCount);
        //read(readCount)
        
        //let b1 = Int16(memory[0])<<8;
        //let b2 = Int16(memory[1])&0xff;
        
        
        let b1 = Int16(readPointer[0])<<8;
        let b2 = Int16(readPointer[1])&0xff;
        read(readCount)
        return b1 | b2;
    }
    
    func readInt() -> Int32 {
        let readCount = 4;
        try!checkReadIndex(readCount);
        //let memory = UnsafeBufferPointer(start: readPointer, count: readCount);
        //read(readCount)
        
        //let b1 = Int(memory[0])&0xff<<24;
        //let b2 = Int(memory[1])&0xff<<16;
        //let b3 = Int(memory[2])&0xff<<8;
        //let b4 = Int(memory[3])&0xff;
        
        let b1 = (Int32(readPointer[0])&0xff)<<24;
        let b2 = (Int32(readPointer[1])&0xff)<<16;
        let b3 = (Int32(readPointer[2])&0xff)<<8;
        let b4 = (Int32(readPointer[3])&0xff);
        
        read(readCount)
        
        return b1|b2|b3|b4;
    }
    
    func readLong() throws -> Int64 {
        let readCount = 8;
        try!checkReadIndex(readCount);
        //let memory = UnsafeBufferPointer(start: readPointer, count: readCount);
        //read(readCount)
        
        //let b1 = Int64(memory[0])&0xff<<56;
        //let b2 = Int64(memory[1])&0xff<<48;
        //let b3 = Int64(memory[2])&0xff<<40;
        //let b4 = Int64(memory[3])&0xff<<32;
        //let b5 = Int64(memory[4])&0xff<<24;
        //let b6 = Int64(memory[5])&0xff<<16;
        //let b7 = Int64(memory[6])&0xff<<8;
        //let b8 = Int64(memory[7])&0xff;
        
        let b1 = (Int64(readPointer[0])&0xff)<<56;
        let b2 = (Int64(readPointer[1])&0xff)<<48;
        let b3 = (Int64(readPointer[2])&0xff)<<40;
        let b4 = (Int64(readPointer[3])&0xff)<<32;
        let b5 = (Int64(readPointer[4])&0xff)<<24;
        let b6 = (Int64(readPointer[5])&0xff)<<16;
        let b7 = (Int64(readPointer[6])&0xff)<<8;
        let b8 = (Int64(readPointer[7])&0xff);
        read(readCount)
        
        return b1|b2|b3|b4|b5|b6|b7|b8;
    }
    
    
    func readBytes(readCount:Int=0) -> [Int8] {
        let readableBytes = self.readableBytes();
        var readBytes = readCount;
        if(readCount <= 0 || readCount > readableBytes){
            readBytes = readableBytes;
        }
        
        try!checkReadIndex(readBytes);
        
        var temp = [Int8](count: readBytes, repeatedValue: 0)
        memcpy(&temp, readPointer, readBytes);
        
        read(readBytes)
        
        return temp;
    }
    
    func writeByte(byte:Int8){
        ensureCapacity(1);
        writePointer[0] = byte;
        write(1);
    }
    
    func writeShort(short:Int16){
        ensureCapacity(2);
        let value = short;
        writePointer[0] = Int8(truncatingBitPattern:value>>8);
        writePointer[1] = Int8(truncatingBitPattern:value);
        write(2);
    }
    
    func writeInt(int:Int32){
        ensureCapacity(4);
        let value = int;
        writePointer[0] = Int8(truncatingBitPattern:value>>24);
        writePointer[1] = Int8(truncatingBitPattern:value>>16);
        writePointer[2] = Int8(truncatingBitPattern:value>>8);
        writePointer[3] = Int8(truncatingBitPattern:value);
        write(4)
    }
    
    func writeLong(long:Int64){
        ensureCapacity(8);
        let value = long;
        writePointer[0] = Int8(truncatingBitPattern:value>>56);
        writePointer[1] = Int8(truncatingBitPattern:value>>48);
        writePointer[2] = Int8(truncatingBitPattern:value>>40);
        writePointer[3] = Int8(truncatingBitPattern:value>>32);
        writePointer[4] = Int8(truncatingBitPattern:value>>24);
        writePointer[5] = Int8(truncatingBitPattern:value>>16);
        writePointer[6] = Int8(truncatingBitPattern:value>>8);
        writePointer[7] = Int8(truncatingBitPattern:value);
        write(8)
    }
        
    func writeBytes(bytes:[Int8]){
        ensureCapacity(bytes.count);
        memcpy(writePointer, bytes, bytes.count)
        write(bytes.count)
    }
    
    func writeData(data:NSData){
        ensureCapacity(data.length);
        memcpy(writePointer, data.bytes, data.length)
        write(data.length)
    }
}
