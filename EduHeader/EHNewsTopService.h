//
//  EHNewsTopService.h
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHNewsTopService : HTBaseService

- (void)postNewsTopWithID:(NSString *)ID block:(ServiceCallBackBlock)block;

@end
