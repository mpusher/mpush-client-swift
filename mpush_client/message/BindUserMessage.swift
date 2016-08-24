//
//  BindUserMessage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class BindUserMessage:ByteBufMessage, CustomDebugStringConvertible{
    var userId: String!;
    var alias: String?;
    var tags: String?;
    
    init(cmd: Command, connection: Connection) {
        super.init(packet: Packet(cmd: cmd, sessionId: BaseMessage.genSessionId()), conn: connection);
    }
    
    class func  buildBind(connection: Connection) -> BindUserMessage {
        return BindUserMessage(cmd: Command.BIND, connection: connection);
    }
    
    class func buildUnbind(connection: Connection) -> BindUserMessage{
        return BindUserMessage(cmd: Command.UNBIND, connection: connection);
    }
    
    func setUserId(userId: String) -> BindUserMessage {
        self.userId = userId;
        return self;
    }
    
    override func encode(body: RFIWriter) {
        body.writeString(userId);
        body.writeString(alias);
        body.writeString(tags);
    }
    
    var debugDescription: String {
        return "BindUserMessage={userId:\(userId)}"
    }
    
}