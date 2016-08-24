//
//  HttpRequest.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

public enum HttpMethod:Int8 {
    case GET = 0, POST = 1, PUT = 2, DELETE = 3;
}

public final class HttpRequest {
    static let CONTENT_TYPE_FORM = "application/x-www-form-urlencoded; charset=";
    static let HTTP_HEAD_READ_TIMEOUT = "readTimeout";
    let method: HttpMethod;
    let uri: String;
    private var headers = Dictionary<String,String>();
    private var body:NSData?;
    var callback:HttpCallback?;
    var timeout:Int = 3000;

    init(method: HttpMethod = .GET, uri: String){
        self.method = method;
        self.uri = uri;
    }
    
    class func get(url:String) -> HttpRequest {
        return HttpRequest(method: HttpMethod.GET, uri: url)
    }
    
    class func post(url:String) -> HttpRequest {
        return HttpRequest(method: HttpMethod.GET, uri: url)
    }
    
    func getHeaders() -> Dictionary<String, String> {
        headers.updateValue(timeout.description, forKey: HttpRequest.HTTP_HEAD_READ_TIMEOUT);
        return headers;
    }
    
    func setHeaders(headers: Dictionary<String, String>) -> HttpRequest {
        for (k, v) in headers {
            self.headers.updateValue(v, forKey: k)
        }
        return self;
    }
    
    func getBody() -> NSData? {
        return body;
    }
    
    func setBody(body: NSData, contentType:String) -> HttpRequest {
        self.body = body;
        headers.updateValue(contentType, forKey: "Content-Type");
        return self;
    }
    
    func setPostParams(params: Dictionary<String,String>, paramsEncoding:NSStringEncoding) -> HttpRequest {
        if let bytes = encodeParameters(headers, paramsEncoding: paramsEncoding){
            setBody(bytes, contentType: HttpRequest.CONTENT_TYPE_FORM + String.localizedNameOfStringEncoding(paramsEncoding));
        }
        return self;
    }
    
    
    func encodeParameters(params: Dictionary<String,String>, paramsEncoding:NSStringEncoding) -> NSData? {
        var encodedParams: String = "";
        for (k, v) in params {
            encodedParams += k.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            encodedParams += "="
            encodedParams += v.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
            encodedParams += "&"
        }
        return encodedParams.dataUsingEncoding(paramsEncoding)
    }
    
    
}