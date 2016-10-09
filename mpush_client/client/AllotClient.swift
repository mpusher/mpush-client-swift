//
//  AllotClient.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class AllotClient:NSObject, NSURLConnectionDataDelegate {
    var serverList:[String] = [];
    
    func getServerAddress() -> [String] {
        if(serverList.count == 0){
            return getServerAddressList();
        }
        
        return serverList;
    }
    
   private func getServerAddressList() -> [String] {
        guard let allot = ClientConfig.I.allotServer else {
            if let serverHost = ClientConfig.I.serverHost {
                serverList = [serverHost + ":" + ClientConfig.I.serverPort!.description];
            }
            return serverList;
        }
        
        if let url = NSURL(string: allot) {
            
            let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
            
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                if let e = error {
                    print(e)
                    dispatch_semaphore_signal(semaphore);
                    return;
                }
                
                if let d = data {
                    self.serverList = NSString(data: d, encoding: NSUTF8StringEncoding)!.componentsSeparatedByString(",");
                    dispatch_semaphore_signal(semaphore);
                }
           }.resume();
        
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        }
        return serverList;
    }
}