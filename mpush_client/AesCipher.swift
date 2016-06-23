//
//  AesCipher.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class AesCipher: Cipher, CustomStringConvertible {
    let iv:[Int8];
    let key:[Int8];
    
    init(key:[Int8], iv:[Int8]){        
        self.key = key;
        self.iv = iv;
    }
    
    init(iv:NSData, key:NSData){
        self.iv = iv.toBytes();
        self.key = key.toBytes();
    }
    
    func decrypt(data:NSData) throws -> NSData? {
        return AESUtils.decrypt(data, iv:iv, key: key)!
    }
    
    func encrypt(data:NSData) -> NSData? {
        return AESUtils.encrypt(data, iv:iv, key: key);
    }
    
    
    var description: String  {
        return AesCipher.toString(key) + "," + AesCipher.toString(iv);
    }
    
    class func toString(array: [Int8]) -> String {
        var result = "";
        for i in 0 ..< array.count {
            if(i != 0){
                result += "|";
            }
            result += array[i].description;
        }
        return result;
    }
    
    class func toArray(value:String) -> [Int8]? {
        let array = value.componentsSeparatedByString("|");
        if(array.count != 16){
            return nil;
        }
        
        var bytes = [Int8](count:array.count,repeatedValue:0x0);
        
        for i in 0 ..< array.count {
            bytes[i] = Int8(array[i])!;
        }
        
        return bytes;
    }
}