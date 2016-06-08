//
//  EHNewsEnshrineAddService.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsEnshrineAddService.h"

@implementation EHNewsEnshrineAddService

- (void)addNewsEnshrineWithUID:(NSString *)uid newsID:(NSString *)newsid block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/enshrine/add"
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
