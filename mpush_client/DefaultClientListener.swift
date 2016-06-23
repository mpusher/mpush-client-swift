//
//  DefaultClientListener.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class DefaultClientListener: ClientListener {
    private let hb_queue = dispatch_queue_create("hb_queue", nil);
    private let dispatch_queue = dispatch_queue_create("dispatch_queue", DISPATCH_QUEUE_CONCURRENT);
    private var listener:ClientListener?;
    
    func setListener(listener:ClientListener) {
        self.listener = listener;
    }
    
    func onConnected(client: Client) {
        client.fastConnect();
        if let listener = self.listener {
            dispatch_async(dispatch_queue, {listener.onConnected(client)})
        }
    }
    
    func onDisConnected(client: Client) {
        if let listener = self.listener {
            dispatch_async(dispatch_queue, {listener.onDisConnected(client)})
        }
    }
    
    func onHandshakeOk(client: Client, heartbeat: Int) {
        client.bindUser(ClientConfig.I.userId);
        let delay = (Int64)(UInt64(heartbeat/1000 - 1) * NSEC_PER_SEC)
        sendHB(client, delay: delay);
        if let listener = self.listener {
            dispatch_async(dispatch_queue, {listener.onHandshakeOk(client, heartbeat: heartbeat)})
        }
    }
    
    func onReceivePush(client: Client, content: String) {
        if let listener = self.listener {
            dispatch_async(dispatch_queue, {listener.onReceivePush(client, content: content)})
        }
    }
    
    func onKickUser(deviceId: String, userId: String) {
        if let listener = self.listener {
            dispatch_async(dispatch_queue, {listener.onKickUser(deviceId, userId: userId)})
        }
    }
    
    
    func sendHB(client: Client, delay:Int64) {
        if(client.isRunning()) {
            client.healthCheck();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), self.hb_queue, {
                self.sendHB(client, delay: delay);
            });
        }
    }
}