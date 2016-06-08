//
//  EHUserLoginService.h
//  EduHeader
//
//  Created by Hao King on 15/10/14.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHUserModel.h"

@interface EHUserLoginService : HTBaseService

- (void)loginWithPhone:(NSString *)phone password:(NSString *)password block:(ServiceCallBackBlock)block;

@end
