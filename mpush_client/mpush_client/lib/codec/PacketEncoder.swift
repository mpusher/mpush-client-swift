//
//  PacketEncoder.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class PacketEncoder {
    
    class func encode(_ packet:Packet, out:UnsafeBuffer){
        switch packet.cmd {
        case Command.heartbeat.rawValue:
            out.writeByte(Packet.HB_PACKET_BYTE)
        default:
            let length = packet.getBodyLength();
            out.writeInt(Int32(length))
            out.writeByte(packet.cmd)
            out.writeShort(packet.cc)
            out.writeByte(packet.flags)
            out.writeInt(packet.sessionId)
            out.writeByte(packet.lrc)
            if(length > 0) {
                out.writeData(packet.body!)
            }
        }
    }
}
