//
//  EHMenuListService.m
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHMenuListService.h"
#import "EHGlobalSingleton.h"

@implementation EHMenuListService

- (void)requestMenuListWithBlock:(ServiceCallBackBlock)block
{
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    [paramDic setObject:[EHGlobalSingleton sharedInstance].gpsCity forKey:@"city"];

    if ([[[EHGlobalSingleton sharedInstance] userInfo] uid]) {
        [paramDic setObject:[[[EHGlobalSingleton sharedInstance] userInfo] uid] forKey:@"uid"];
    }
    
    [self postPath:@"type/list"
        parameters:paramDic
        modelClass:[EHTypeListRootModel class]
     keyPathInJson:nil
           success:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }
           failure:^(HTHTTPRequestOperation *operation, id model) {
               block(model, operation.error);
           }];
}

@end
