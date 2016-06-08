//
//  EHNewsInfoService.m
//  EduHeader
//
//  Created by Hao King on 15/10/24.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsInfoService.h"

@implementation EHNewsInfoService

- (void)requestNewsInfoWith:(NSString *)uid newsid:(NSString *)newsid block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/info"
        parameters:@{@"uid" : uid,
                     @"id" : newsid}
        modelClass:[EHNewsInfoRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block (model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block (model, operation.error);
           }];
}

@end
