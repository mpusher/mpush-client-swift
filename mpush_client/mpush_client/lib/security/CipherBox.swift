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
    class func randomAESIV() -> Data {
        let buffer = RFIWriter(capacity:16);
        for _ in 1...4 {
            buffer?.write(Int32(arc4random_uniform(UInt32(Int32.max))));
        }
        return buffer!.getBuffer() as Data
    }

    class func randomAESKey() -> Data {
        let buffer = RFIWriter(capacity:16);
        for _ in 1...4 {
            buffer?.write(Int32(arc4random_uniform(UInt32(Int32.max))));
        }
        return buffer!.getBuffer() as Data
    }
    
    class func  mixKey(_ clientKey:[UInt8], serverKey:[UInt8]) -> [UInt8] {
        var sessionKey = [UInt8](repeating: 0x0, count: 16);
        for i in 0 ..< 16 {
            let a = Int32(clientKey[i]);
            let b = Int32(serverKey[i]);
            let sum = abs(a + b);
            let c = (sum % 2 == 0) ? a ^ b : b ^ a;
            sessionKey[i] = UInt8(c);
        }
        return sessionKey;
    }
    
}
