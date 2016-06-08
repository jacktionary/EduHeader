//
//  HTDesUtil.h
//  
//
//  Created by HaoKing on 14-3-3.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTDesUtil : NSObject

+ (NSString *)DESEncrypt:(NSString *)string;
+ (NSString *)DESDecrypt:(NSString *)dataString;

@end
