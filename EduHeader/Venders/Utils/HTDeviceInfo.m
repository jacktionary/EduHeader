//
//  DeviceInfo.m
//  EduHeader
//
//  Created by Alien Wang on 14-8-22.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import "HTDeviceInfo.h"
#import "HTReachAbility.h"
#import "sys/utsname.h"

#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation HTDeviceInfo

+ (float)systemVersion
{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

/*
 *  获取当前时间
 */
+(NSString *)getDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat =@"yyyy-MM-dd HH:mm:ss";
    NSString * userDate =[formatter stringFromDate:[NSDate date]];
    
    //日期特殊情况处理
    NSArray *dateArr = [NSArray arrayWithObjects:@"AM", @"PM", @"上午", @"下午", @"午前", @"午后", nil];
    
    //PM,下午和午,时间＋12
    for (int i = 1; i < dateArr.count; i+=2) {
        if ([userDate rangeOfString:[dateArr objectAtIndex:i]].length) {
            NSRange range = [userDate rangeOfString:@":"];
            NSString *hourStr = [userDate substringWithRange:NSMakeRange(range.location-2, 2)];
            int hourInt = [hourStr intValue] + 12;
            hourStr = [NSString stringWithFormat:@"%d",hourInt];
            userDate = [userDate stringByReplacingCharactersInRange:NSMakeRange(range.location-2, 2) withString:hourStr];
        }
    }
    
    //删除汉字和AM\PM,防止无法入库的风险
    for (NSString *dateStr in dateArr) {
        if ([userDate rangeOfString:dateStr].length) {
            userDate = [userDate stringByReplacingOccurrencesOfString:dateStr withString:@""];
        }
    }
    
    return userDate;
}

+(NSString *)deviceID{
    
    NSString *uid;
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
    {
        uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        
    }else if ([[[UIDevice currentDevice]systemVersion]floatValue] <= 5.0)
    {
        uid = [NSString stringWithString:[HTDeviceInfo macAddress]];
        
    } else {
        uid = [NSString stringWithString:[HTDeviceInfo macAddress]];
        if (uid == nil || [uid isEqualToString:@""]) {
            uid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        }
    }
    
    return uid;
    
}

+(NSString *)bundleID
{
    NSDictionary * dicInfo =[[NSBundle mainBundle] infoDictionary];
    NSString *bundleId = [dicInfo objectForKey:@"CFBundleIdentifier"];
    return bundleId;
}

/*
 *  获取MAC地址 唯一表示
 */
+(NSString *)macAddress
{
    //设置参数
    //Mac地址为6组共12个字符，格式为：XX:XX:XX:XX:XX:XX
    int mib[6];
    size_t len;
    char  *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    /*
     设置信息资源库
     */
    //请求网络子系统
    mib[0]=CTL_NET;
    //路由表信息
    mib[1]=AF_ROUTE;
    mib[2]=0;
    //链路层信息
    mib[3]=AF_LINK;
    //配置端口信息
    mib[4]=NET_RT_IFLIST;
    //判断En0地址是否存在，除联通3GS太监外，都存在
    if ((mib[5]=if_nametoindex("en0"))==0) {
        
        return NULL;
        
    }
    //获取数据的大小
    if (sysctl(mib, 6, NULL, &len, NULL, 0)<0) {
        
        return NULL;
        
    }
    //分配内存的基础上调用
    if ((buf=malloc(len))==NULL) {
        
        return NULL;
        
    }
    //获取系统信息，存储在缓冲区
    if ((sysctl(mib, 6, buf, &len, NULL, 0))<0) {
        
        free(buf);
        
        return NULL;
        
    }
    //获取接口电气性结构
    ifm=(struct if_msghdr *)buf;
    sdl=(struct sockaddr_dl *)(ifm+1);
    ptr=(unsigned char *)LLADDR(sdl);
    //获取Mac地址信息：读取字符数组到一个字符串对象，设置为传统的Mac地址，即XX:XX:XX:XX:XX:XX
    NSString *outString=[NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                         *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    //返回Mac地址信息
    return outString;
    
}

/*
 *  获取操作系统类型
 */
+(NSString *)systemName
{
    NSString * sysName = [[UIDevice currentDevice] systemName];
    sysName = [sysName stringByAppendingString:[[UIDevice currentDevice] systemVersion]];
    return sysName;
}

/*
 * 获取设备类型
 */
+(NSString *)deviceName
{    
    NSString * deviceName = [HTDeviceInfo platformString];
    
    return deviceName;
}

/*
 * 获取设备分辨率
 */
+(NSString *)resolution
{
    CGRect rectscreen = [[UIScreen mainScreen] bounds];
    CGSize rectsize = rectscreen.size;
    CGFloat rect_width = rectsize.width;
    CGFloat rect_height = rectsize.height;
    NSString * strwidth =[NSString stringWithFormat:@"%f",rect_width];
    NSString * strheight =[NSString stringWithFormat:@"%f",rect_height];
    NSString * width = [strwidth substringToIndex:3];
    NSString * height =[strheight substringToIndex:4];
    NSArray * SeparatorArray = [height componentsSeparatedByString:@"."];
    NSString * hight = [SeparatorArray objectAtIndex:0];
    NSMutableString *resolution =[[NSMutableString alloc] init];
    [resolution appendString:hight];
    [resolution appendString:@"*"];
    [resolution appendString:width];
    return resolution;
}

/*
 * 获取运营商标示
 */
+(NSString *)carrier
{
    NSString *ret = [[NSString alloc]init];
    ret = @"0";
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    if (carrier == nil) {
        return @"0";
    }
    
    NSString *code = [carrier mobileNetworkCode];
    
    if ([code isEqualToString:@"0"] ) {
        return @"0";
    }
    if ([code isEqualToString:@"00"] || [code isEqualToString:@"02"] || [code isEqualToString:@"07"]) {
        ret = @"移动";
    }
    if ([code isEqualToString:@"01"]|| [code isEqualToString:@"06"] ) {
        ret = @"联通";
    }
    if ([code isEqualToString:@"03"]|| [code isEqualToString:@"05"] ) {
        ret = @"电信";;
    }
    
    return ret;
    
}

+(NSString *)checkNetWoriking
{
    HTReachAbility *reachability =[HTReachAbility reachabilityWithHostName:@"www.apple.com"];
    NSString * networking =[[NSString alloc]init];
    switch ([reachability currentReachabilityStatus]) {
            
        case NotReachable:
            networking =@"nonetwork";
            break;
            
        case ReachableViaWiFi:
            networking =@"wifi";
            break;
        case ReachableViaWWAN:
            networking =@"3G";
            break;
    }
    return networking;
}

/*
 * 判断设备是否越狱
 */

+(NSString *)checkJailBroken
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    NSString * jlbroken =[NSString stringWithFormat:@"%i",jailbroken];
    return jlbroken;
}

+(BOOL) isConnectedToNetwork
{
    //创建零地址，0.0.0.0的地址表示查询本机的网络连接状态
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    //获得连接的标志
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    //如果不能获取连接标志，则不能连接网络，直接返回
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    //根据获得的连接标志进行判断
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+ (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}

+ (NSString *) platformString{
    NSString *platform = [self platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (GSM)";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air (CDMA)";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2 (WiFi)";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([platform isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (CDMA)";
    if ([platform isEqualToString:@"iPad4,7"])      return @"iPad Mini 3 (WiFi)";
    if ([platform isEqualToString:@"iPad4,8"])      return @"iPad Mini 3 (CDMA)";
    if ([platform isEqualToString:@"iPad4,9"])      return @"iPad Mini 3 (CDMA)";
    
    
    if ([platform isEqualToString:@"i386"])         return [UIDevice currentDevice].model;
    if ([platform isEqualToString:@"x86_64"])       return [UIDevice currentDevice].model;
    
    return platform;
}

@end
