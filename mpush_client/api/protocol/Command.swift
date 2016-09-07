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
     HEARTBEAT = 1,
     HANDSHAKE = 2,
     LOGIN = 3,
     LOGOUT = 4,
     BIND = 5,
     UNBIND = 6,
     FAST_CONNECT = 7,
     PAUSE = 8,
     RESUME = 9,
     ERROR = 10,
     OK = 11,
     HTTP_PROXY = 12,
     KICK = 13,
     GATEWAY_KICK = 14,
     PUSH = 15,
     GATEWAY_PUSH = 16,
     NOTIFICATION = 17,
     GATEWAY_NOTIFICATION = 18,
     CHAT = 19,
     GATEWAY_CHAT = 20,
     GROUP = 21,
     GATEWAY_GROUP = 22,
     ACK = 23,
     UNKNOWN = -1;
}