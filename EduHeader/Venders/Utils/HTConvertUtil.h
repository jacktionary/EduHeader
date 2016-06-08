//
//  HTConvertUtil.h
//  
//
//  Created by HaoKing on 14-3-3.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTConvertUtil : NSObject

/**
 64编码
 */
+(NSString *)base64Encoding:(NSData*) text;

/**
 字节转化为16进制数
 */
+(NSString *) parseByte2HexString:(Byte *) bytes;

/**
 字节数组转化16进制数
 */
+(NSString *) parseByteArray2HexString:(Byte[]) bytes;

/*
 将16进制数据转化成NSData 数组
 */
+(NSData*) parseHexToByteArray:(NSString*) hexString;

/*
 计算从传入年份到当前位置的年龄
 */
+ (NSString *)ageFromDate:(NSDate *)date;

@end
