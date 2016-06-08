//
//  MNUserUploadService.h
//  EduHeader
//
//  Created by Hao King on 15/10/21.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHUserModel.h"

@interface EHUserUpdateService : HTBaseService

- (void)updateUserInfoForUser:(NSString *)uid photo:(NSString *)photoURL nickname:(NSString *)nickname age:(NSString *)age phone:(NSString *)phone code:(NSString *)code block:(ServiceCallBackBlock)block;

- (void)updateUserInfoForUser:(NSString *)uid password:(NSString *)password newPassword:(NSString *)newPassword block:(ServiceCallBackBlock)block;
@end
