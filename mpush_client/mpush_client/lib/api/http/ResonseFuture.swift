//
//  ResonseFuture.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

public protocol ResponseFuture {
    
    func get() -> HttpResponse;
    
    func cancel();
 
}