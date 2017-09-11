//
//  MessageHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol MessageHandler {
    func handle(_ packet:Packet, connection:Connection) throws;
}
