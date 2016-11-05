//
//  CipherBox.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class CipherBox {
    static let AES_KEY_LENGTH:Int = 16;
    class func randomAESIV() -> NSData {
        let buffer = RFIWriter(capacity:16);
        for _ in 1...4 {
            buffer.writeInt32(Int32(arc4random_uniform(UInt32(Int32.max))));
        }
        return buffer.getBuffer()
    }

    class func randomAESKey() -> NSData {
        let buffer = RFIWriter(capacity:16);
        for _ in 1...4 {
            buffer.writeInt32(Int32(arc4random_uniform(UInt32(Int32.max))));
        }
        return buffer.getBuffer()
    }
    
    class func  mixKey(clientKey:[Int8], serverKey:[Int8]) -> [Int8] {
        var sessionKey = [Int8](count:16, repeatedValue:0x0);
        for i in 0 ..< 16 {
            let a = Int32(clientKey[i]);
            let b = Int32(serverKey[i]);
            let sum = abs(a + b);
            let c = (sum % 2 == 0) ? a ^ b : b ^ a;
            sessionKey[i] = Int8(c);
        }
        return sessionKey;
    }
    
}
