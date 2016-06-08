//
//  AppUtil.m
//  EduHeader
//
//  Created by HaoKing on 8/8/14.
//  Copyright (c) 2014 EduHeader. All rights reserved.
//

#import "HTAppUtil.h"

@implementation HTAppUtil

+ (NSString *)appVersion;
{
    NSDictionary * dicInfo =[[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [dicInfo objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}

@end
