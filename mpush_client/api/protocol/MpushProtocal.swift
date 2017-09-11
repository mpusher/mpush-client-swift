//
//  MpushProtocal.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol MpushProtocal {
    
    func healthCheck() -> Bool;
    
    func fastConnect();
    
    func handshake();
    
    func bindUser(_ userId: String?);
    
    func unbindUser();
    
    func ack(_ messageId: Int32);
    
    func sendHttp(_ request: HttpRequest) -> ResponseFuture;
}
