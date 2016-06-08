//
//  EHNewsEnshrineAddService.h
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHNewsEnshrineAddService : HTBaseService

- (void)addNewsEnshrineWithUID:(NSString *)uid newsID:(NSString *)newsid block:(ServiceCallBackBlock)block;

@end
