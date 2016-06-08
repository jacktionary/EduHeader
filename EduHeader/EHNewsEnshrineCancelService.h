//
//  EHNewsEnshrineCancelService.h
//  EduHeader
//
//  Created by Hao King on 15/10/23.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHNewsEnshrineCancelService : HTBaseService

- (void)cancelNewsEnshrineWithUID:(NSString *)uid newsid:(NSString *)newsid block:(ServiceCallBackBlock)block;

@end
