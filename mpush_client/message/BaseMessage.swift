//
//  BaseMessage.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

enum MessageError:ErrorType {
    case DecodeError;
}

class BaseMessage:Message {
    static var SID_SEQ:Int32 = 0;
    let connection:Connection;
    let packet:Packet;
    
    init(packet:Packet, conn:Connection) {
        self.packet = packet;
        self.connection = conn;
    }
    
    final func decodeBody() throws {
        guard var body = packet.body else {return};
                
        if body.length > 0 {
            //1.解密
            if (packet.hasFlag(Packet.FLAG_CRYPTO)) {
                if let cipher = connection.context.cipher {
                    if let tmp = try cipher.decrypt(body){
                        body = tmp;
                    }
                }
            }
            
            //2.解压
            if (packet.hasFlag(Packet.FLAG_COMPRESS)) {
                body = try body.decompress();
            }
            
            if (body.length == 0) {
                throw MessageError.DecodeError;
            }
            packet.body = body;
            
            decode(body);
        }
    }
    
    final func encodeBody() {
        var body = encode()
        if body.length > 0 {
            //1.压缩
            if (body.length > ClientConfig.I.compressLimit) {
                let result = body.compress();
                if (result.length > 0) {
                    body = result;
                    packet.addFlag(Packet.FLAG_COMPRESS);
                }
            }
            
            //2.加密
            if let cipher = connection.context.cipher {
                if let result = cipher.encrypt(body) {
                    body = result;
                    packet.addFlag(Packet.FLAG_CRYPTO);
                }
            }
            
            packet.body = body;
        }
    }
    
    func decode(body:NSData) {
        fatalError("implement me!");
    }
    
    func encode() -> NSData {
        fatalError("implement me!");
    }
    
    
    final func getPacket() -> Packet {
        return packet;
    }
    
    final func getConnection() -> Connection {
        return connection;
    }
    
    func send() {
        encodeBody();
        connection.send(packet);
    }
    
    func sendRaw() {
        packet.body = encode();
        connection.send(packet);
    }
    
    func createResponse() -> Packet {
        return Packet(cmd: packet.cmd, sessionId: packet.sessionId);
    }
    
    func getSessionId() -> Int32 {
        return packet.sessionId;
    }
    
    final class func genSessionId() -> Int32 {
        return OSAtomicIncrement32(&SID_SEQ);
    }
}
