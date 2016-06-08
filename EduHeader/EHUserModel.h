//
//  EHUserModel.h
//  EduHeader
//
//  Created by Hao King on 15/10/14.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseModel.h"

@interface EHUserModel : HTBaseModel
//Integer uid;//'UID',
@property (nonatomic, strong) NSString *uid;
//String phone;//'手机',
@property (nonatomic, strong) NSString *phone;
//String code;//'验证码',
@property (nonatomic, strong) NSString *code;
//String password;//'密码',
@property (nonatomic, strong) NSString *password;
//String photo;//'用户头像',
@property (nonatomic, strong) NSString *photo;
//String nickname;//'用户昵称',
@property (nonatomic, strong) NSString *nickname;
//Integer age;//'用户年龄',
@property (nonatomic, strong) NSString *age;
//String location;//'用户位置',
@property (nonatomic, strong) NSString *location;
//Date createdate;//'创建时间',
@property (nonatomic, strong) NSString *createdate;

@end

@interface EHUserRootModel : HTBaseModel

@property (nonatomic, strong) EHUserModel *result;

@end
