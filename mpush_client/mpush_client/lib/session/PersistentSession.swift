//
//  PersistentSession.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation


final class PersistentSession {
    let sessionId: String;
    let expireTime: Int64;
    let cipher: Cipher;
    
    init(sessionId: String, expireTime: Int64, cipher: Cipher){
        self.sessionId = sessionId;
        self.expireTime = expireTime;
        self.cipher = cipher;
    }
    
    func isExpired() -> Bool {
        return Double(expireTime / 1000) < CFTimeInterval();
    }
    
    class func encode(_ session:PersistentSession) -> String {
        return "\(session.sessionId),\(session.expireTime),\(session.cipher)";
    }
    
    class func decode(_ value:String) -> PersistentSession? {
        let array = value.components(separatedBy: ",");
        if (array.count != 4) {return nil;}
        

        let sessionId = array[0];
        let expireTime = Int64(array[1]);
        
        let key = AesCipher.toArray(array[2]);
        let iv = AesCipher.toArray(array[3]);
        if let k = key, let i = iv {
            let cipher = AesCipher(key: k, iv: i);
            return PersistentSession(sessionId: sessionId, expireTime: expireTime!, cipher: cipher);
        }
        return nil;
    }
}
