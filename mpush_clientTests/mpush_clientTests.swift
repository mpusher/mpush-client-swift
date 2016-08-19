//
//  mpush_clientTests.swift
//  mpush_clientTests
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import XCTest
@testable import mpush_client

class mpush_clientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let config = ClientConfig.build();
        config.serverHost = "111.1.57.148";
        config.serverPort = 20882;
        config.publicKey = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCghPCWCobG8nTD24juwSVataW7iViRxcTkey/B792VZEhuHjQvA3cAJgx2Lv8GnX8NIoShZtoCg3Cx6ecs+VEPD2fBcg2L4JK7xldGpOJ3ONEAyVsLOttXZtNXvyDZRijiErQALMTorcgi79M5uVX9/jMv2Ggb2XAeZhlLD28fHwIDAQAB";
        config.deviceId = "dfadfadfadfwerwer2323";
        config.userId = "user_0";
        config.maxHeartbeat = 10000;
        config.minHeartbeat = 10000;
        
        config.setClientListener(L());
        let client = config.create();
        client.start();
        
        sleep(1000)
        client.stop();        
    }
    
    class L: ClientListener {
        
        func onConnected(client: Client){}
        
        func onDisConnected(client: Client){}
        
        func onHandshakeOk(client: Client, heartbeat: Int){
            
            let request = HttpRequest.get("http://baidu.com");
            request.timeout = 10000;
            let future = client.sendHttp(request);
            let response = future.get();
            if let body = response.body {
                let content = String(data: body, encoding:NSUTF8StringEncoding);
                ClientConfig.I.logger.w({">>> receive http response=\(content)"});
            }else {
                ClientConfig.I.logger.w({">>> receive http response=\(response.statusCode), headers=\(response.reasonPhrase)"});
            }
        }
        
        func onReceivePush(client: Client, content: NSData){}
        
        func onKickUser(deviceId: String, userId: String){}
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
}
