//
//  MNUserUploadService.m
//  EduHeader
//
//  Created by Hao King on 15/10/21.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserUpdateService.h"
#import "HTDesUtil.h"

@implementation EHUserUpdateService

- (void)updateUserInfoForUser:(NSString *)uid photo:(NSString *)photoURL nickname:(NSString *)nickname age:(NSString *)age phone:(NSString *)phone code:(NSString *)code block:(ServiceCallBackBlock)block
{
    NSDictionary *paramDict = nil;
    
    if (!uid) {
        uid = @"0";
    }
    if (photoURL) {
        paramDict = @{@"uid" : uid,
                      @"photo" : photoURL? photoURL : @"",
                      @"nickname" : nickname? nickname : @"",
                      @"age" : age? age : @"",
                      @"phone" : phone? age : @"",
                      @"code" : code? code : @"",};
    } else {
        paramDict = @{@"uid" : uid,
                      @"nickname" : nickname ? nickname : @"",
                      @"age" : age ? age : @"",
                      @"phone" : phone? phone : @"",
                      @"code" : code? code : @"",};
    }
    
    [self postPath:@"user/update"
        parameters:paramDict
        modelClass:[EHUserRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

- (void)updateUserInfoForUser:(NSString *)uid password:(NSString *)password newPassword:(NSString *)newPassword block:(ServiceCallBackBlock)block
{
    NSDictionary *paramDict = @{@"uid":uid,
                                @"password":[HTDesUtil DESEncrypt:password],
                                @"newPassword":[HTDesUtil DESEncrypt:newPassword]};
    
    [self postPath:@"user/update"
        parameters:paramDict
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
