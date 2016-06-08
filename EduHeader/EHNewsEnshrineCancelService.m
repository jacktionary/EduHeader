//
//  EHNewsEnshrineCancelService.m
//  EduHeader
//
//  Created by Hao King on 15/10/23.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsEnshrineCancelService.h"

@implementation EHNewsEnshrineCancelService

- (void)cancelNewsEnshrineWithUID:(NSString *)uid newsid:(NSString *)newsid block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/enshrine/cancel"
        parameters:@{@"uid":uid,
                     @"newsid":newsid}
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
