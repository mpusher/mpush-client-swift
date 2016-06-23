//
//  Message.swift
//  mpush_client
//
//  Created by ohun on 16/6/17.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol Message {
    
    var connection:Connection{get};
    
    var packet:Packet{get};
    
    func send();
    
    func sendRaw();
    
}