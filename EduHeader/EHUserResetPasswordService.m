//
//  EHUserResetPasswordService.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserResetPasswordService.h"
#import "HTDesUtil.h"

@implementation EHUserResetPasswordService

- (void)resetPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password block:(ServiceCallBackBlock)block
{
    [self postPath:@"user/reset/password"
        parameters:@{@"phone":phone,
                     @"code":code,
                     @"password":[HTDesUtil DESEncrypt:password]}
        modelClass:[HTBaseModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
