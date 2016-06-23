//
//  HttpProxyHandler.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class HttpProxyHandler: BaseMessageHandler<HttpResponseMessage> {
    let queue: HttpRequestQueue;
    
    init(queue: HttpRequestQueue) {
        self.queue = queue;
    }
    
    override func decode(packet:Packet, connection:Connection) -> HttpResponseMessage {
        return HttpResponseMessage(packet: packet, conn: connection);
    }
    
    override func handle(message: HttpResponseMessage) {        
        ClientConfig.I.logger.w({">>> receive one response, sessionId=\(message.getSessionId()), statusCode=\(message.statusCode)"});
        
        if let task = queue.getAndRemove(message.getSessionId()) {
            task.onResponse(HttpResponse(statusCode: message.statusCode, reasonPhrase: message.reasonPhrase,
                headers: message.headers, body: message.body));
        }
        
    }
}