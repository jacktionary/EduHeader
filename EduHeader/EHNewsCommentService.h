//
//  EHNewsCommentService.h
//  EduHeader
//
//  Created by Hao King on 15/9/9.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsCommentModel.h"

@interface EHNewsCommentService : HTBaseService

- (void)requestNewsCommentWithNewsID:(NSString *)newsID start:(NSString *)start size:(NSString *)size block:(ServiceCallBackBlock)block;

@end
