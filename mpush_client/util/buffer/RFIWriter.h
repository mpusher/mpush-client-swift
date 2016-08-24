//
//  RFIWriter.h
//  mpush-client
//
//  Created by OHUN on 16/6/3.
//  Copyright © 2016年 OHUN. All rights reserved.
//

#ifndef RFIWriter_h
#define RFIWriter_h
#import <Foundation/Foundation.h>

@interface RFIWriter : NSObject

@property (nonatomic, assign) uint32_t poz;
@property (nonatomic, strong, readonly) NSMutableData *data;

+ (instancetype)writerWithData:(NSMutableData*)data;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithData:(NSMutableData*)data;


- (void)writeData:(NSData*)data;
- (void)writeInt32:(int32_t)value;
- (void)writeInt64:(int64_t)value;
- (void)writeInt16:(int16_t)value;
- (void)writeUInt32:(uint32_t)value;
- (void)writeUInt64:(uint64_t)value;
- (void)writeUInt16:(uint16_t)value;
- (void)writeByte:(char)byte;
- (void)writeBool:(BOOL)value;
- (void)writeString:(NSString*)str;
- (void)writeFloat:(float)value;
- (void)writeDouble:(double)value;
- (NSMutableData*)getBuffer;
@end

#endif /* RFIWriter_h */
