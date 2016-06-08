//
//  EHGlobalSingleton.m
//  EduHeader
//
//  Created by HaoKing on 15/10/16.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHGlobalSingleton.h"
#import "HTUserDefaultConfig.h"

@implementation EHGlobalSingleton

@synthesize userInfo = _userInfo;

- (NSString *)gpsCity
{
    if (!_gpsCity) {
        _gpsCity = @"北京";
    }
    
    return _gpsCity;
}

+ (instancetype)sharedInstance
{
    static EHGlobalSingleton *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (EHUserModel *)userInfo
{
    if (!_userInfo) {
        NSDictionary *userDict = [HTUserDefaultConfig getValueForKey:@"userInfo"];
        
        if (userDict) {
            _userInfo = [[EHUserModel alloc] initWithDictionary:userDict];
        }
    }
    
    return _userInfo;
}

- (void)setUserInfo:(EHUserModel *)userInfo
{
    _userInfo = userInfo;
    
    [HTUserDefaultConfig setKey:@"userInfo" forValue:[userInfo toDictionary]];
}

@end
