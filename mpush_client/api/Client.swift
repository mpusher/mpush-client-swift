//
//  Client.swift
//  mpush-client-swift
//
//  Created by ohun on 16/6/15.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol Client: MpushProtocal {
    
    func start();
    
    func stop();
    
    func destroy();
    
    func isRunning() -> Bool;
    
}