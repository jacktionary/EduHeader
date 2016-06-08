//
//  EHUserLoginService.m
//  EduHeader
//
//  Created by Hao King on 15/10/14.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserLoginService.h"
#import "HTDesUtil.h"

@implementation EHUserLoginService

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password block:(ServiceCallBackBlock)block
{
    [self postPath:@"user/login"
        parameters:@{@"phone":phone,
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
