//
//  EHNewsCommentAddService.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsCommentAddService.h"

@implementation EHNewsCommentAddService

- (void)addCommentWithUID:(NSString *)uid newsID:(NSString *)newsid comment:(NSString *)comment block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/comment/add"
        parameters:@{@"uid":uid,
                     @"newsid":newsid,
                     @"comment":comment}
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
