//
//  Command.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation
enum Command:Int8 {
     case
     heartbeat = 1,
     handshake = 2,
     login = 3,
     logout = 4,
     bind = 5,
     unbind = 6,
     fast_CONNECT = 7,
     pause = 8,
     resume = 9,
     error = 10,
     ok = 11,
     http_PROXY = 12,
     kick = 13,
     gateway_KICK = 14,
     push = 15,
     gateway_PUSH = 16,
     notification = 17,
     gateway_NOTIFICATION = 18,
     chat = 19,
     gateway_CHAT = 20,
     group = 21,
     gateway_GROUP = 22,
     ack = 23,
     unknown = -1;
}
