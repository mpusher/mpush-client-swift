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
    
    class func  buildBind(_ connection: Connection) -> BindUserMessage {
        return BindUserMessage(cmd: Command.bind, connection: connection);
    }
    
    class func buildUnbind(_ connection: Connection) -> BindUserMessage{
        return BindUserMessage(cmd: Command.unbind, connection: connection);
    }
    
    func setUserId(_ userId: String) -> BindUserMessage {
        self.userId = userId;
        return self;
    }
    
    override func encode(_ body: RFIWriter) {
        body.write(userId);
        body.write(alias);
        body.write(tags);
    }
    
    var debugDescription: String {
        return "BindUserMessage={userId:\(userId)}"
    }
    
}
