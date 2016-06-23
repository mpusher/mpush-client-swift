//
//  Logger.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class Logger {
    private static let TAG = "[mpush]";
    private static let formatter = NSDateFormatter();
    
    private var enable = true;
    
    func enable(enabled: Bool) {
        self.enable = enabled;
    }
    
    init(){
        Logger.formatter.dateFormat = "HH:mm:ss.SSS"
    }

    
    func printLog(message: Any, file: String = #file, method: String = #function, line: Int = #line, column: Int = #column){
        #if DEBUG
            print("\((file as NSString).lastPathComponent)[\(line):\(column)], \(method): \(message)")
        #endif
    }
    
    func d(message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [D] \(Logger.TAG) \(message())");
        }
    }
    
    func i(message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [I] \(Logger.TAG) \(message())");
        }
    }
    
    func w(message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [W] \(Logger.TAG) \(message())");
        }
    }
    
    func e(message:() -> String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [E] \(Logger.TAG) \(message)");
        }
    }
    
    func d(message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [D] \(Logger.TAG) \(message)");
        }
    }
    
    func i(message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [I] \(Logger.TAG) \(message)");
        }
    }
    
    func w(message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [W] \(Logger.TAG) \(message)");
        }
    }
    
    func e(message:String) {
        if(enable) {
            debugPrint("\(Logger.formatter.stringFromDate(NSDate())) [E] \(Logger.TAG) \(message)");
        }
    }

}