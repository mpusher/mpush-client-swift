//
//  OkMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class OkMessage: ByteBufMessage, CustomDebugStringConvertible {
    var cmd:Int8 = 0;
    var code:Int8 = 0;
    var data:String?;
    
    override func decode(_ body: RFIReader) {
        cmd = body.readByte();
        code = body.readByte();
        data = body.readString();
    }
    
    
    var debugDescription: String {
        return "OkMessage={cmd:\(cmd), code:\(code), data:\(data!)}"
    }
}
