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
    
    func bindUser(userId: String?);
    
    func unbindUser();
    
    func sendHttp(request: HttpRequest) -> ResponseFuture;
}