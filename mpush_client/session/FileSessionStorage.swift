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
    fileprivate let fileName = "mpush-token.dat";

    func saveSession(_ sessionContext: String) {
        
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName)
            
            //writing
            do {
                try sessionContext.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }    
    }
    
    func getSession() -> String? {//reading
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {

            let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName);
            let fileManager = FileManager.default;
            if(fileManager.fileExists(atPath: path.path)) {
                do {
                    let sessionContext = try String(contentsOf: path, encoding: String.Encoding.utf8);
                    return sessionContext;
                }
                catch {/* error handling here */}
            }
        }
        return nil;
    
    }
    
    func clearSession(){
        if let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true).first {
            let path = URL(fileURLWithPath: dir).appendingPathComponent(fileName);
            let fileManager = FileManager.default;
            do{
                try fileManager.removeItem(at: path);
            }catch {/* error handling here */}
        }
    }
}
