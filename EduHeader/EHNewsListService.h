//
//  EHNewsListService.h
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsListModel.h"

//0=“默认打开”
static NSString *vPullRequestAction_FirstTimeOpen   = @"0";
//1=“下拉刷新”
static NSString *vPullRequestAction_Refresh         = @"1";
//2=“上滑加载”
static NSString *vPullRequestAction_LoadMore        = @"2";

@interface EHNewsListService : HTBaseService

- (void)requestNewsListWithTypeID:(NSString *)typeID UID:(NSString *)uid one_newsid:(NSString *)one_newsid action:(NSString *)action start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block;

@end
