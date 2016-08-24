//
//  SessionContext.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation
final class SessionContext {
    
    var heartbeat:Int = 0;
    var cipher:Cipher?;
    var bindUser:String?;
    
    func changeCipher(cipher:Cipher) {
        self.cipher = cipher;
    }
    
    func setHeartbeat(heartbeat:Int){
        self.heartbeat = heartbeat;
    }
    
    func setBindUser(userId: String?) {
        self.bindUser = userId;
    }
    
    func handshakeOk() -> Bool {
        return heartbeat > 0;
    }

}