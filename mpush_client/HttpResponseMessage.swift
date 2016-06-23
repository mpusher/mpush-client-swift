//
//  HttpResponseMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

class HttpResponseMessage: ByteBufMessage, CustomDebugStringConvertible {
    
    var statusCode: Int!;
    var reasonPhrase: String!;
    var headers: Dictionary<String,String>!;
    var body: NSData?;
   
    override func decode(body: RFIReader) {
        statusCode = Int(body.readInt32());
        reasonPhrase = body.readString();
        headers = MPUtils.headerFromString(body.readString());
        self.body = body.readData();
    }
    
    var debugDescription: String {
        return "HttpRequestMessage={statusCode:\(statusCode), reasonPhrase=\(reasonPhrase), headers=\(headers), body=\(body)}"
    }
}