//
//  RFIWriter.m
//  mpush-client
//
//  Created by OHUN on 16/6/3.
//  Copyright © 2016年 OHUN. All rights reserved.
//

#import "RFIWriter.h"

@implementation RFIWriter

+ (instancetype)writerWithData:(NSMutableData *)data
{
    return [[RFIWriter alloc] initWithData:data];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity;
{
   self = [self initWithData: [[NSMutableData alloc] initWithCapacity:capacity]];
   return self;
}

- (instancetype)initWithData:(NSMutableData *)data
{
    self = [super init];
    if (!data)
        return nil;
    
    _data = data;
    return self;
}

- (void)writeData:(NSData*)data
{
    [self writeUInt16: data.length];
    if(data.length) [_data appendData:data];
}

- (void)writeBytes:(const char*)rawBytes length:(uint32_t)length
{
    if(length) [_data appendBytes:rawBytes length:length];
}

- (void)writeInt32:(int32_t)value
{
    HTONL(value);
    [self writeBytes:(const char *)&value length:sizeof(int32_t)];
}

- (void)writeInt64:(int64_t)value
{
    HTONLL(value);
    [self writeBytes:(const char *)&value length:sizeof(int64_t)];
}

- (void)writeInt16:(int16_t)value
{
    HTONS(value);
    [self writeBytes:(const char *)&value length:sizeof(int16_t)];
}

- (void)writeUInt32:(uint32_t)value
{
    HTONL(value);
    [self writeBytes:(const char *)&value length:sizeof(uint32_t)];
}

- (void)writeUInt64:(uint64_t)value
{
    HTONLL(value);
    [self writeBytes:(const char *)&value length:sizeof(uint64_t)];
}

- (void)writeUInt16:(uint16_t)value
{
    HTONS(value);
    [self writeBytes:(const char *)&value length:sizeof(uint16_t)];
}

- (void)writeByte:(char)byte
{
    [self writeBytes:(const char *)&byte length:sizeof(char)];
}

- (void)writeBool:(BOOL)value
{
    [self writeByte:value ? 1 : 0];
}

- (void)writeString:(NSString*)str
{
    [self writeData:[str dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)writeFloat:(float)value
{
    [self writeBytes:(const char *)&value length:sizeof(float)];
}

- (void)writeDouble:(double)value
{
    [self writeBytes:(const char *)&value length:sizeof(double)];
}

- (NSMutableData*)getBuffer
{
    return _data;
}

@end
