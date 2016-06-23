//
//  AESUtils.swift
//  mpush-client
//
//  Created by OHUN on 16/6/3.
//  Copyright © 2016年 OHUN. All rights reserved.
//

import Foundation


public final class AESUtils {

/**
*  aes加密方法
*
*  @param enData 需要加密的数据
*  @param iv     加密指数
*  @param key    加密key
*
*  @return 加密后的data
*/
class func encrypt(data:NSData, iv:[Int8], key:[Int8]) -> NSData? {
    
    let encryptBufferSize = data.length + kCCBlockSizeAES128;
    var encryptBuffer = [Int8](count: encryptBufferSize, repeatedValue: 0);
    
    var numBytesEncrypted = 0;
    let cryptStatus = CCCrypt(UInt32(kCCEncrypt),
        UInt32(kCCAlgorithmAES128),
        UInt32(kCCOptionPKCS7Padding),
        key,
        kCCKeySizeAES128,
        iv ,/* initialization vector (optional) */
        data.bytes,
        data.length, /* input */
        &encryptBuffer,
        encryptBufferSize, /* output */
        &numBytesEncrypted);
    
    if (cryptStatus == Int32(kCCSuccess)) {
        return NSData(bytes: &encryptBuffer, length:numBytesEncrypted);
    }
    
    return nil;
}
    
/**
*  aes解密方法
*
*  @param enData 需要解密的数据
*  @param iv     加密指数
*  @param key    加密key
*
*  @return 解密后的data
*/
class func decrypt(data:NSData, iv:[Int8], key:[Int8]) -> NSData? {
    
    
    let decryptBufferSize = data.length + kCCBlockSizeAES128;
    var decryptBuffer = [Int8](count: decryptBufferSize, repeatedValue: 0);
    
    var numBytesDecrypted = 0;
    let cryptStatus = CCCrypt(UInt32(kCCDecrypt),
        UInt32(kCCAlgorithmAES128),
        UInt32(kCCOptionPKCS7Padding),
        key,
        kCCKeySizeAES128,
        iv ,/* initialization vector (optional) */
        data.bytes,
        data.length, /* input */
        &decryptBuffer,
        decryptBufferSize, /* output */
        &numBytesDecrypted);
    

    if (cryptStatus == Int32(kCCSuccess)) {
        return NSData(bytes: &decryptBuffer, length:numBytesDecrypted);
    }
    
    return nil;
}

}
