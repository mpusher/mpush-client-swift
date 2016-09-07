//
//  Packet.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

class Packet {
    static let HEADER_LEN:Int = 13;
    
    static let FLAG_CRYPTO:Int8 = 0x1;
    static let FLAG_COMPRESS:Int8 = 0x2;
    static let FLAG_BIZ_ACK:Int8 = 0x4;
    static let FLAG_AUTO_ACK:Int8 = 0x8;
    
    static let HB_PACKET_BYTE:Int8 = -33;
    static let HB_PACKET_BYTES:[Int8] = [HB_PACKET_BYTE];
    static let HB_PACKET = Packet(cmd: Command.HEARTBEAT);
    
    let cmd:Int8;
    let cc:Int16;
    var flags:Int8;
    let sessionId:Int32;
    let lrc:Int8;
    var body:NSData?;
    
    init(cmd:Int8, cc:Int16=0, flags:Int8=0, sessionId:Int32=0, lrc:Int8 = 0, body:NSData?=nil){
        self.cmd = cmd;
        self.cc = cc;
        self.flags = flags;
        self.sessionId = sessionId;
        self.lrc = lrc;
        self.body = body;
    }
    
    convenience init(cmd: Command, sessionId: Int32 = 0){
        self.init(cmd: cmd.rawValue, sessionId:sessionId);
    }
    
    func addFlag(flag:Int8){
        self.flags |= flag;
    }
    
    func hasFlag(flag:Int8) -> Bool {
        return (flags&flag) != 0;
    }
    
    func getBodyLength() -> Int {
        if let b = self.body {
            return b.length
        }
        return 0;
    }
}


extension Packet: CustomDebugStringConvertible {
    var debugDescription: String {
        return "{cmd:\(cmd), cc:\(cc), flags:\(flags), sessionId:\(sessionId), lrc:\(lrc), bodyLength:\(getBodyLength())}"
    }
}