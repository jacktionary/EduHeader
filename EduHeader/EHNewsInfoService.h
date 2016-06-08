//
//  EHNewsInfoService.h
//  EduHeader
//
//  Created by Hao King on 15/10/24.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsInfoModel.h"

@interface EHNewsInfoService : HTBaseService

- (void)requestNewsInfoWith:(NSString *)uid newsid:(NSString *)newsid block:(ServiceCallBackBlock)block;

@end
