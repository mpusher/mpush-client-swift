//
//  Connection.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol Connection {
    
    var context: SessionContext{get};
    
    var fd: Int32{get};
    
    var client: Client{get};
    
    func connect();
    
    func close();
    
    func reconnect();
    
    func isConnected() -> Bool;
    
    func send(_ packet:Packet);
    
    func isReadTimeout() -> Bool;
    
    func isWriteTimeout() -> Bool;
    
    func setLastReadTime();
    
    func setLastWriteTime();
    
    func setAutoConnect(_ autoConnect: Bool);

}
