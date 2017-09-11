//
//  ConnectThread.swift
//  mpush_client
//
//  Created by ohun on 16/6/19.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class ConnectThread {
    fileprivate var connTask:ConnTask?;
    fileprivate let connectQueue = DispatchQueue(label: "connect_queue", attributes: []);
    fileprivate var isShutdown = false;
    
    func start() {
        objc_sync_enter(self)
        isShutdown = false;
        objc_sync_exit(self)
    }
    
    func addTask(_ task:@escaping () throws -> Bool) {
        objc_sync_enter(self)
        if(!isShutdown) {        
            if let t = connTask {
                t.stop();
            }
            self.connTask = ConnTask(runningTask: task);
            connectQueue.async(execute: {
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
    
    fileprivate class ConnTask {
        
        fileprivate var runningFlag = true;
        fileprivate var runningTask:() throws -> Bool;
        
        init (runningTask:@escaping () throws -> Bool){
            self.runningTask = runningTask;
        }
        
        func stop() {
            self.runningFlag = false;
        }
        
        fileprivate func run() {
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
