//
//  EHNewsEnshrineListService.h
//  EduHeader
//
//  Created by Hao King on 15/10/23.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHNewsListModel.h"

@interface EHNewsEnshrineListService : HTBaseService

- (void)requestEnshrineListWithUID:(NSString *)uid block:(ServiceCallBackBlock)block;

@end
