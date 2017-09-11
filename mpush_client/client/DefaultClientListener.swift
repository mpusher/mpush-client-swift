//
//  DefaultClientListener.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class DefaultClientListener: ClientListener {
    fileprivate let hb_queue = DispatchQueue(label: "hb_queue", attributes: []);
    fileprivate let dispatch_queue = DispatchQueue(label: "dispatch_queue", attributes: DispatchQueue.Attributes.concurrent);
    fileprivate var listener:ClientListener?;
    
    func setListener(_ listener:ClientListener) {
        self.listener = listener;
    }
    
    func onConnected(_ client: Client) {
        client.fastConnect();
        if let listener = self.listener {
            dispatch_queue.async(execute: {listener.onConnected(client)})
        }
    }
    
    func onDisConnected(_ client: Client) {
        if let listener = self.listener {
            dispatch_queue.async(execute: {listener.onDisConnected(client)})
        }
    }
    
    func onHandshakeOk(_ client: Client, heartbeat: Int) {
        client.bindUser(ClientConfig.I.userId);
        let delay = (Int64)(UInt64(heartbeat/1000 - 1) * NSEC_PER_SEC)
        sendHB(client, delay: delay);
        if let listener = self.listener {
            dispatch_queue.async(execute: {listener.onHandshakeOk(client, heartbeat: heartbeat)})
        }
    }
    
    func onReceivePush(_ client: Client, content: Data, messageId: Int32) {
        if let listener = self.listener {
            dispatch_queue.async(execute: {listener.onReceivePush(client, content: content, messageId: messageId)})
        }
    }
    
    func onKickUser(_ deviceId: String, userId: String) {
        if let listener = self.listener {
            dispatch_queue.async(execute: {listener.onKickUser(deviceId, userId: userId)})
        }
    }
    
    
    func sendHB(_ client: Client, delay:Int64) {
        if(client.isRunning()) {
            client.healthCheck();
            self.hb_queue.asyncAfter(deadline: DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC), execute: {
                self.sendHB(client, delay: delay);
            });
        }
    }
}
