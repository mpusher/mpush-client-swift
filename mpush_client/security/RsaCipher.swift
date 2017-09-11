//
//  RsaCipher.swift
//  mpush_client
//
//  Created by ohun on 16/6/18.
//  Copyright © 2016年 mpusher. All rights reserved.
//

import Foundation

final class RsaCipher: Cipher {

    func decrypt(_ data:Data) throws -> Data? {
        fatalError("unsupported");
    }
    
    func encrypt(_ data:Data) -> Data? {
        do{
            return try RSAUtils.encrypt(data, publicKeyPEM: ClientConfig.I.publicKey);
        }catch _ {
            
        }
        return nil;
    }

}
