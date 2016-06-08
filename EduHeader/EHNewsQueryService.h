//
//  EHNewsQueryService.h
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsListModel.h"
#import "EHNewsQueryListModel.h"

@interface EHNewsQueryService : HTBaseService

- (void)queryWithTitle:(NSString *)title city:(NSString *)city createdate:(NSString *)createdate start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block;

@end
