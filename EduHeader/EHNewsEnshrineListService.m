//
//  EHNewsEnshrineListService.m
//  EduHeader
//
//  Created by Hao King on 15/10/23.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsEnshrineListService.h"

@implementation EHNewsEnshrineListService

- (void)requestEnshrineListWithUID:(NSString *)uid block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/enshrine/list"
        parameters:@{@"uid":uid}
        modelClass:[EHNewsListRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
