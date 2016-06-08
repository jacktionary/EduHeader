//
//  EHNewsCommentService.m
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHNewsCommentService.h"

@implementation EHNewsCommentService

- (void)requestNewsCommentWithNewsID:(NSString *)newsID start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/comment/list"
        parameters:@{@"newsid" : newsID,
                     @"start" : start,
                     @"size" : size}
        modelClass:[EHNewsCommentRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
