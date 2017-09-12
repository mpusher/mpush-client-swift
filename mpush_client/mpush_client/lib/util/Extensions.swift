//
//  Extention.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

extension Data {
    
    func toBytes() -> [UInt8]{
//        var bytes = [Int8](repeatElement(0x0, count: self.count))
////        var bytes = [Int8](repeating: 0x0,count: self.count)
//        
//        getBytes(bytes,length: self.count);
        let bytes = [UInt8](self)
        return bytes;
    }
}

extension String {
    
    func indexOf(_ string: String) -> String.Index? {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound
    }
}
