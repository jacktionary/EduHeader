//
//  EHNewsListService.m
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHNewsListService.h"

@implementation EHNewsListService

- (void)requestNewsListWithTypeID:(NSString *)typeID UID:(NSString *)uid one_newsid:(NSString *)one_newsid action:(NSString *)action start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:typeID forKey:@"typeid"];
    [paramDic setObject:start forKey:@"start"];
    [paramDic setObject:size forKey:@"size"];
    if (one_newsid) {
        [paramDic setObject:one_newsid forKey:@"one_newsid"];
    }
    
    if (action) {
        [paramDic setObject:action forKey:@"action"];
    }
    
    if (uid) {
        [paramDic setObject:uid forKey:@"uid"];
    }
    
    [self postPath:@"news/list"
        parameters:paramDic
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
