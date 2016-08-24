//
//  PushMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class PushMessage: BaseMessage, CustomDebugStringConvertible {
    var content:NSData!;
    
    override func decode(body:NSData) {
        content = body;
    }
    
    var debugDescription: String {
        return "PushMessage={content:\(content.length)}"
    }
}