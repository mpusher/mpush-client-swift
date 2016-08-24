//
//  ConnectThread.swift
//  mpush_client
//
//  Created by ohun on 16/6/19.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class ConnectThread {
    private var connTask:ConnTask?;
    private let connectQueue = dispatch_queue_create("connect_queue", nil);
    private var isShutdown = false;
    
    func start() {
        objc_sync_enter(self)
        isShutdown = false;
        objc_sync_exit(self)
    }
    
    func addTask(task:() throws -> Bool) {
        objc_sync_enter(self)
        if(!isShutdown) {        
            if let t = connTask {
                t.stop();
            }
            self.connTask = ConnTask(runningTask: task);
            dispatch_async(connectQueue, {
                self.connTask?.run();
            });
        }
        objc_sync_exit(self)
    }
    
    func stop() {
        objc_sync_enter(self)
        self.isShutdown = true;
        if let t = connTask {
            t.stop();
        }
        objc_sync_exit(self)
    }
    
    private class ConnTask {
        
        private var runningFlag = true;
        private var runningTask:() throws -> Bool;
        
        init (runningTask:() throws -> Bool){
            self.runningTask = runningTask;
        }
        
        func stop() {
            self.runningFlag = false;
        }
        
        private func run() {
            while (runningFlag) {
                do {
                    if (try runningTask()) {
                        return;
                    }
                } catch _ {
                    ClientConfig.I.logger.e("run connect task error");
                }
            }
        }
    }
}