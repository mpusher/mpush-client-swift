//
//  HttpRequestQueue.swift
//  mpush_client
//
//  Created by ohun on 16/6/21.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation



final class HttpRequestQueue {
    
    static let response408 = HttpResponse(statusCode: 408, reasonPhrase: "Request Timeout");
    
    private var qeueue = Dictionary<Int32, RequestTask>();
    private let httpTimerQueue = dispatch_queue_create("http_timer_queue", DISPATCH_QUEUE_CONCURRENT);
   
    
    func add(sessionId: Int32, request: HttpRequest) -> ResponseFuture {
        let task = RequestTask(sessionId: sessionId, request: request, queue: self);
        qeueue.updateValue(task, forKey: sessionId)
        setTimer(sessionId, timeout: task.timeout);
        return task;
    }
    
    private func setTimer(sessionId: Int32, timeout: Int) {
        let delay = (Int64)(UInt64(timeout/1000 - 1) * NSEC_PER_SEC)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delay), httpTimerQueue) {
            if let task = self.getAndRemove(sessionId) {
                task.onTimeout();
            }
        }
    }
    
    func getAndRemove(sessionId: Int32) -> RequestTask? {
        return qeueue.removeValueForKey(sessionId);
    }
}



final class RequestTask: ResponseFuture {
    static let FLAG_WAITE: Int32 = 0;
    static let FLAG_COMPLETE: Int32 = 1;
    
    var timeout:Int = 3000;
    var completeFlag: Int32 = FLAG_WAITE;
    var lock: NSCondition?;
    var callback: HttpCallback?;
    let sessionId: Int32;
    let uri: String;
    
    var sendTime = CACurrentMediaTime();
    
    var response: HttpResponse = HttpRequestQueue.response408;
    
    var queue :HttpRequestQueue;
    
    init(sessionId: Int32, request: HttpRequest, queue: HttpRequestQueue) {
        self.sessionId = sessionId;
        self.timeout = request.timeout;
        self.callback = request.callback;
        self.uri = request.uri;
        self.queue = queue;
    }
    
    func cancel() {
        if(tryComplete()) {
            queue.getAndRemove(sessionId);
            if let lock = self.lock {
                self.lock = nil;
                lock.lock();
                lock.broadcast();
                lock.unlock();
            }
            
            if let callback = self.callback {
                self.callback = nil;
                callback.onCancelled();
            }
            
            ClientConfig.I.logger.d({"one request task cancelled, sessionId=\(self.sessionId), costTime=\(CACurrentMediaTime() - self.sendTime), response=\(self.response), uri=\(self.uri)"});
        }
    }
    
    func onTimeout() {
        onResponse(HttpRequestQueue.response408)
    }
    
    func onResponse(response: HttpResponse) {
        if(tryComplete()) {
            self.response = response;
            if let lock = self.lock {
                self.lock = nil;
                lock.lock();
                lock.broadcast();
                lock.unlock();
            }
            
            ClientConfig.I.logger.d({"one request task end, sessionId=\(self.sessionId), costTime=\(CACurrentMediaTime() - self.sendTime), response=\(response), uri=\(self.uri)"});
            
            if let callback = self.callback {
                self.callback = nil;
                callback.onResponse(response);
            }
        }
    }
    
    func get() -> HttpResponse {
        
        if(isComplete()){
            return response;
        }
        
        if(self.lock == nil){
            self.lock = NSCondition();
        }
        
        if let lock = self.lock {
            lock.lock();
            lock.waitUntilDate(NSDate().dateByAddingTimeInterval(Double(timeout / 1000)));
            lock.unlock();
        }
        return response;
        
    }
    
    func isComplete() -> Bool {
        return completeFlag != RequestTask.FLAG_WAITE;
    }
    
    func tryComplete() -> Bool {
        return OSAtomicCompareAndSwap32(RequestTask.FLAG_WAITE, RequestTask.FLAG_COMPLETE, &completeFlag);
    }
    
}

