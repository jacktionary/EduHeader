//
//  EHUserCodeSendService.m
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserCodeSendService.h"

@implementation EHUserCodeSendService

- (void)requestCodeWithPhone:(NSString *)phone block:(ServiceCallBackBlock)block
{
    [self postPath:@"user/code/send"
        parameters:@{@"phone" : phone}
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
