//
//  PacketReceiver.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol PacketReceiver {
    
    func onReceive(packet:Packet, connection:Connection);
    
}