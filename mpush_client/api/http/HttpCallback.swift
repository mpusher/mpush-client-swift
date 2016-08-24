//
//  HttpCallback.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol HttpCallback {
    
    func onResponse(response: HttpResponse);
    
    func onCancelled();
}