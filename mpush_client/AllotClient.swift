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
            
            NSURLSession.sharedSession().dataTaskWithURL(url) { data, response, error in
                if let e = error {
                    print(e)
                    return;
                }
                
                if let d = data {
                    self.serverList = String(d).componentsSeparatedByString(",")
                }
           }.resume();
            
        }
        return serverList;
    }
}