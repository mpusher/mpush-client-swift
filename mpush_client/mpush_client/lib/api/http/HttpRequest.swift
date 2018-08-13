//
//  HttpRequest.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

public enum HttpMethod:Int8 {
    case get = 0, post = 1, put = 2, delete = 3;
}

public final class HttpRequest {
    static let CONTENT_TYPE_FORM = "application/x-www-form-urlencoded; charset=";
    static let HTTP_HEAD_READ_TIMEOUT = "readTimeout";
    let method: HttpMethod;
    let uri: String;
    fileprivate var headers = Dictionary<String,String>();
    fileprivate var body:Data?;
    var callback:HttpCallback?;
    var timeout:Int = 3000;

    init(method: HttpMethod = .get, uri: String){
        self.method = method;
        self.uri = uri;
    }
    
    class func get(_ url:String) -> HttpRequest {
        return HttpRequest(method: HttpMethod.get, uri: url)
    }
    
    class func post(_ url:String) -> HttpRequest {
        return HttpRequest(method: HttpMethod.post, uri: url)
    }
    
    func getHeaders() -> Dictionary<String, String> {
        headers.updateValue(timeout.description, forKey: HttpRequest.HTTP_HEAD_READ_TIMEOUT);
        return headers;
    }
    
    func setHeaders(_ headers: Dictionary<String, String>) -> HttpRequest {
        for (k, v) in headers {
            self.headers.updateValue(v, forKey: k)
        }
        return self;
    }
    
    func getBody() -> Data? {
        return body;
    }
    
    func setBody(_ body: Data, contentType:String) -> HttpRequest {
        self.body = body;
        headers.updateValue(contentType, forKey: "Content-Type");
        return self;
    }
    
    func setPostParams(_ params: Dictionary<String,String>, paramsEncoding:String.Encoding) -> HttpRequest {
        if let bytes = encodeParameters(headers, paramsEncoding: paramsEncoding){
            setBody(bytes, contentType: HttpRequest.CONTENT_TYPE_FORM + String.localizedName(of: paramsEncoding));
        }
        return self;
    }
    
    
    func encodeParameters(_ params: Dictionary<String,String>, paramsEncoding:String.Encoding) -> Data? {
        var encodedParams: String = "";
        for (k, v) in params {
            encodedParams += k.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            encodedParams += "="
            encodedParams += v.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
            encodedParams += "&"
        }
        return encodedParams.data(using: paramsEncoding)
    }
    
    
}
