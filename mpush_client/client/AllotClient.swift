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
    
   fileprivate func getServerAddressList() -> [String] {
        guard let allot = ClientConfig.I.allotServer else {
            if let serverHost = ClientConfig.I.serverHost {
                serverList = [serverHost + ":" + ClientConfig.I.serverPort!.description];
            }
            return serverList;
        }
        
        if let url = URL(string: allot) {
            
            let semaphore: DispatchSemaphore = DispatchSemaphore(value: 0);
            
            URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
                if let e = error {
                    print(e)
                    semaphore.signal();
                    return;
                }
                
                if let d = data {
                    self.serverList = NSString(data: d, encoding: String.Encoding.utf8.rawValue)!.components(separatedBy: ",");
                    semaphore.signal();
                }
           }) .resume();
        
            semaphore.wait(timeout: DispatchTime.distantFuture);
        }
        return serverList;
    }
}
