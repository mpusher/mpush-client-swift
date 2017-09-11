//
//  MPUtils.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


final class MPUtils {
    
    
    class func headerToString(_ headers: Dictionary<String,String>?) -> String? {
        if (headers != nil && headers?.count > 0) {
            var  sb = "";
            for (k, v) in headers! {
                sb += k + ":" + v + "\n";
            }
            return sb;
        }
        return nil;
    }
    
    
    class func headerFromString(_ headersString: String?) -> Dictionary<String,String>? {
    
        guard let hs = headersString else {return nil};
        
        let headerArray = hs.components(separatedBy: "\n")
        var headers = Dictionary<String,String>(minimumCapacity: headerArray.count);
        
        for h in headerArray {
            let name_value =  h.components(separatedBy: ":");
            if(name_value.count == 2){
                let name = name_value[0];
                let value = name_value[1];
                headers[name] = value;
            }
        }
        
        return headers;
    }
}
