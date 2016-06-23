//
//  ClientConfig.swift
//  mpush-client-ios
//
//  Created by OHUN on 16/5/31.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation

public class ClientConfig {
    
    static let I = ClientConfig();
    
    private init(){}
    
    var allotServer:String?;
    var serverHost:String?;
    var serverPort:Int?;
    var publicKey:String!;
    var deviceId:String!;
    var osName:String = "ios";
    var osVersion:String = "9.0";
    var clientVersion:String = "1.0";
    var userId:String?;
    var maxHeartbeat:Int32 = 1800000;
    var minHeartbeat:Int32 = 1800000;
    var aesKeyLength:Int = 16;
    var compressLimit:Int = 10240;
    var sessionStorageDir:String?;
    var logEnabled:Bool = true;
    var enableHttpProxy:Bool = true;
    let logger = Logger();
    internal let clientListener = DefaultClientListener();
    let sessionStorage = FileSessionStorage();
    
    
    class func build() -> ClientConfig {
        return ClientConfig.I;
    }
    
    func create() -> Client {
        return MpushClient(config: self);
    }
    
    func setClientListener(listener: ClientListener) {
        clientListener.setListener(listener);
    }
    
}