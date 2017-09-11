//
//  BaseMessage.swift
//  mpush-client
//
//  Created by OHUN on 16/6/8.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

enum MessageError:Error {
    case decodeError;
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
                
        if body.count > 0 {
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
//                body = try body.decompress();
                body = try body.gunzipped();
            }
            
            if (body.count == 0) {
                throw MessageError.decodeError;
            }
            packet.body = body;
            
            decode(body as Data);
        }
    }
    
    final func encodeBody() {
        var body = encode()
        if body.count > 0 {
            //1.压缩
            if (body.count > ClientConfig.I.compressLimit) {
//                let result = body.compress();
                do {
                    let result = try body.gzipped();
                    if (result.count > 0) {
                        body = result;
                        packet.addFlag(Packet.FLAG_COMPRESS);
                    }
                    
                } catch  { }
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
    
    func decode(_ body:Data) {
        fatalError("implement me!");
    }
    
    func encode() -> Data {
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
