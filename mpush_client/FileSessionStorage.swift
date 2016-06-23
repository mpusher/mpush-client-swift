//
//  FileSessionStorage.swift
//  mpush_client
//
//  Created by ohun on 16/6/20.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class FileSessionStorage: SessionStorage {
    
    //private let rootDir: String;
    private let fileName = "mpush-token.dat";

    func saveSession(sessionContext: String) {
        
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(fileName)
            
            //writing
            do {
                try sessionContext.writeToURL(path, atomically: false, encoding: NSUTF8StringEncoding)
            }
            catch {/* error handling here */}
        }    
    }
    
    func getSession() -> String? {//reading
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {

            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(fileName);
            let fileManager = NSFileManager.defaultManager();
            if(fileManager.fileExistsAtPath(path.path!)) {
                do {
                    let sessionContext = try String(contentsOfURL: path, encoding: NSUTF8StringEncoding);
                    return sessionContext;
                }
                catch {/* error handling here */}
            }
        }
        return nil;
    
    }
    
    func clearSession(){
        if let dir = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
            let path = NSURL(fileURLWithPath: dir).URLByAppendingPathComponent(fileName);
            let fileManager = NSFileManager.defaultManager();
            do{
                try fileManager.removeItemAtURL(path);
            }catch {/* error handling here */}
        }
    }
}