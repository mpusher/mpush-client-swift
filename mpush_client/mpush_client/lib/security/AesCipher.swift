//
//  AesCipher.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class AesCipher: Cipher, CustomStringConvertible {
    let iv:[UInt8];
    let key:[UInt8];
    
    init(key:[UInt8], iv:[UInt8]){
        self.key = key;
        self.iv = iv;
    }
    
    init(iv:Data, key:Data){
        self.iv = iv.toBytes();
        self.key = key.toBytes();
    }
    
    func decrypt(_ data:Data) throws -> Data? {
        return AESUtils.decrypt(data, iv:iv, key: key)!
    }
    
    func encrypt(_ data:Data) -> Data? {
        return AESUtils.encrypt(data, iv:iv, key: key);
    }
    
    
    var description: String  {
        return AesCipher.toString(key) + "," + AesCipher.toString(iv);
    }
    
    class func toString(_ array: [UInt8]) -> String {
        var result = "";
        for i in 0 ..< array.count {
            if(i != 0){
                result += "|";
            }
            result += array[i].description;
        }
        return result;
    }
    
    class func toArray(_ value:String) -> [UInt8]? {
        let array = value.components(separatedBy: "|");
        if(array.count != 16){
            return nil;
        }
        
        var bytes = [UInt8](repeating: 0x0,count: array.count);
        
        for i in 0 ..< array.count {
            bytes[i] = UInt8(array[i])!;
        }
        
        return bytes;
    }
}
