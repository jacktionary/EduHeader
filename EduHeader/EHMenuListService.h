//
//  EHMenuListService.h
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHTypeListModel.h"

@interface EHMenuListService : HTBaseService

- (void)requestMenuListWithBlock:(ServiceCallBackBlock)block;

@end
