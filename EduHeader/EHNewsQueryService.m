//
//  EHNewsQueryService.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsQueryService.h"
#import "EHGlobalSingleton.h"

@implementation EHNewsQueryService

- (void)queryWithTitle:(NSString *)title city:(NSString *)city createdate:(NSString *)createdate start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:title forKey:@"title"];
    [paramDic setObject:city forKey:@"city"];
    [paramDic setObject:start forKey:@"start"];
    [paramDic setObject:size forKey:@"size"];
    
    if (createdate) {
        [paramDic setObject:createdate forKey:@"createdate"];
    }
    if ([[[EHGlobalSingleton sharedInstance] userInfo] uid]) {
        [paramDic setObject:[[[EHGlobalSingleton sharedInstance] userInfo] uid] forKey:@"uid"];
    }
    
    [self postPath:@"news/query"
        parameters:paramDic
        modelClass:[EHNewsQueryListRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           } failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
