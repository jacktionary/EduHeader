//
//  EHNewsRecommendService.h
//  EduHeader
//
//  Created by Hao King on 15/10/9.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsListModel.h"

@interface EHNewsRecommendService : HTBaseService

- (void)requestRecommentWithNewsID:(NSString *)newsID block:(ServiceCallBackBlock)block;

@end
