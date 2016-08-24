//
//  Cipher.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol Cipher {
    
    //func decrypt(bytes:[Int8]) -> [Int8];
    
    //func encrypt(bytes:[Int8]) -> [Int8];
    
    func decrypt(data:NSData) throws -> NSData?;
    
    func encrypt(data:NSData) -> NSData?;
    
}