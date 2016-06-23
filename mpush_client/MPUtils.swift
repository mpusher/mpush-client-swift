//
//  MPUtils.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class MPUtils {
    
    
    class func headerToString(headers: Dictionary<String,String>?) -> String? {
        if (headers != nil && headers?.count > 0) {
            var  sb = "";
            for (k, v) in headers! {
                sb += k + ":" + v + "\n";
            }
            return sb;
        }
        return nil;
    }
    
    
    class func headerFromString(headersString: String?) -> Dictionary<String,String>? {
    
        guard let hs = headersString else {return nil};
        
        let headerArray = hs.componentsSeparatedByString("\n")
        var headers = Dictionary<String,String>(minimumCapacity: headerArray.count);
        
        for h in headerArray {
            let name_value =  h.componentsSeparatedByString(":");
            if(name_value.count == 2){
                let name = name_value[0];
                let value = name_value[1];
                headers[name] = value;
            }
        }
        
        return headers;
    }
}