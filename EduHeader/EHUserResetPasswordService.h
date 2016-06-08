//
//  EHUserResetPasswordService.h
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"

@interface EHUserResetPasswordService : HTBaseService

- (void)resetPasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password block:(ServiceCallBackBlock)block;

@end
