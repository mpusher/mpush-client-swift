//
//  SessionStorage.swift
//  mpush_client
//
//  Created by ohun on 16/6/16.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

protocol SessionStorage {
    
    func saveSession(sessionContext: String);
    
    func getSession() -> String?;
    
    func clearSession();
}