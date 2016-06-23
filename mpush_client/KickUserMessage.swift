//
//  KickUserMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class KickUserMessage:ByteBufMessage, CustomDebugStringConvertible{
    var deviceId: String!;
    var userId: String!;
    
    
    override func decode(body: RFIReader) {
        deviceId = body.readString();
        userId = body.readString();
    }
    
    var debugDescription: String {
        return "KickUserMessage={deviceId:\(deviceId), userId:\(userId)}"
    }

}