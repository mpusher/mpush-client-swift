//
//  HttpResponse.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

open class HttpResponse {
    let statusCode: Int;
    let reasonPhrase: String;
    let headers: Dictionary<String,String>?;
    var body: Data?;
    
    init(statusCode: Int, reasonPhrase: String, headers: Dictionary<String,String>? = nil, body: Data? = nil){
        self.statusCode = statusCode;
        self.reasonPhrase = reasonPhrase;
        self.headers = headers;
        self.body = body;
    }

}
