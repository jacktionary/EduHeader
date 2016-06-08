//
//  EHNewsCommentAddService.h
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHNewsCommentAddService : HTBaseService

- (void)addCommentWithUID:(NSString *)uid newsID:(NSString *)newsid comment:(NSString *)comment block:(ServiceCallBackBlock)block;

@end
