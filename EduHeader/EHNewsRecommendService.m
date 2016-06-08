//
//  EHNewsRecommendService.m
//  EduHeader
//
//  Created by Hao King on 15/10/9.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsRecommendService.h"

@implementation EHNewsRecommendService

- (void)requestRecommentWithNewsID:(NSString *)newsID block:(ServiceCallBackBlock)block
{
    [self postPath:@"news/recommend"
        parameters:@{@"newsid" : newsID
                     }
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
