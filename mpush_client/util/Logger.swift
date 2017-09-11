//
//  Logger.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class Logger {
    fileprivate static let TAG = "[mpush]";
    fileprivate static let formatter = DateFormatter();
    
    fileprivate var enable = true;
    
    func enable(_ enabled: Bool) {
        self.enable = enabled;
    }
    
    init(){
        Logger.formatter.dateFormat = "HH:mm:ss.SSS"
    }

    
    func printLog(_ message: Any, file: String = #file, method: String = #function, line: Int = #line, column: Int = #column){
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line):\(column)], \(method): \(message)")
        #endif
    }
    
    func d(_ message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [D] \(Logger.TAG) \(message())");
        }
    }
    
    func i(_ message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [I] \(Logger.TAG) \(message())");
        }
    }
    
    func w(_ message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [W] \(Logger.TAG) \(message())");
        }
    }
    
    func e(_ message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [E] \(Logger.TAG) \(message)");
        }
    }
    
    func d(_ message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [D] \(Logger.TAG) \(message)");
        }
    }
    
    func i(_ message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [I] \(Logger.TAG) \(message)");
        }
    }
    
    func w(_ message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [W] \(Logger.TAG) \(message)");
        }
    }
    
    func e(_ message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.string(from: Date())) [E] \(Logger.TAG) \(message)");
        }
    }

}
