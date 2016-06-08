//
//  EHUserRegisterPhoneService.m
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserRegisterPhoneService.h"
#import "HTDesUtil.h"

@implementation EHUserRegisterPhoneService

- (void)registUserWithPhone:(NSString *)phone city:(NSString *)city code:(NSString *)code password:(NSString *)password block:(ServiceCallBackBlock)block
{
    [self postPath:@"user/register/phone"
        parameters:@{@"phone":phone,
                     @"city":city,
                     @"code":code,
                     @"password":[HTDesUtil DESEncrypt:password]}
        modelClass:[EHUserRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
