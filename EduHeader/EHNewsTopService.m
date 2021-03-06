//
//  EHNewsTopService.m
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHNewsTopService.h"
#import "EHGlobalSingleton.h"

@implementation EHNewsTopService

- (void)postNewsTopWithID:(NSString *)ID block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/top"
        parameters:@{@"id" : ID,
                     @"uid" : [[[EHGlobalSingleton sharedInstance] userInfo] uid]}
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
