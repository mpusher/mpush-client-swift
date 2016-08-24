//
//  Extention.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

extension NSData {
    
    func toBytes() -> [Int8]{
        var bytes = [Int8](count:self.length,repeatedValue:0x0)
        getBytes(&bytes,length: self.length);
        return bytes;
    }
}

extension String {
    
    func indexOf(string: String) -> String.Index? {
        return rangeOfString(string, options: .LiteralSearch, range: nil, locale: nil)?.startIndex
    }
}