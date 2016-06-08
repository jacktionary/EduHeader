//
//  EHUserRegisterPhoneService.h
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHUserModel.h"

@interface EHUserRegisterPhoneService : HTBaseService

- (void)registUserWithPhone:(NSString *)phone city:(NSString *)city code:(NSString *)code password:(NSString *)password block:(ServiceCallBackBlock)block;

@end
