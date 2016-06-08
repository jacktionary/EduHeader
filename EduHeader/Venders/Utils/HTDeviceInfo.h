//
//  DeviceInfo.h
//  EduHeader
//
//  Created by Alien Wang on 14-8-22.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDeviceInfo : NSObject

/*
 *  获取系统版本号
 */
+ (float)systemVersion;

/*
 *  获取用户设备唯一标识
 */
+ (NSString *)deviceID;

/*
 *  获取当前时间
 */
+(NSString *)getDate;

/*
 *  获取app bundleID
 */
+(NSString *)bundleID;

/*
 *  获取MAC地址 唯一表示
 */
+(NSString *)macAddress;

/*
 *  获取操作系统类型
 */
+(NSString *)systemName;

/*
 * 获取设备类型
 */
+(NSString *)deviceName;

/*
 * 获取设备分辨率
 */
+(NSString *)resolution;

/*
 * 获取运营商标示
 */
+(NSString *)carrier;

/*
 *  获取当前联网方式。
 *  wifi/3g/nonetwork
 */
+(NSString *)checkNetWoriking;

/*
 *  判断设备是否越狱
 */

+(NSString *)checkJailBroken;

/*
 *  检查是否连接到网络
 */
+(BOOL) isConnectedToNetwork;

@end
