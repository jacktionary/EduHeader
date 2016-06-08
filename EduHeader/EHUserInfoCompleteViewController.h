//
//  EHUserInfoCompleteViewController.h
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHBaseViewController.h"

typedef enum {
    EHUserInfoType_Regist     = 0,
    EHUserInfoType_UserInfo,
} EHUserInfoType;

@interface EHUserInfoCompleteViewController : EHBaseViewController

@property (nonatomic, strong)NSString *phone;
@property (nonatomic, strong)NSString *code;

@property (nonatomic, assign)EHUserInfoType type;

@end
