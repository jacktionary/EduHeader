//
//  EHNewsListNormalViewController.h
//  EduHeader
//
//  Created by Hao King on 15/9/10.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHBaseViewController.h"
#import "EHNewsListViewController.h"

typedef enum {
    EHNewsListType_Normal   = 0,
    EHNewsListType_SearchBar,
} EHNewsListType;

@interface EHNewsListNormalViewController : EHBaseViewController

@property (nonatomic, weak)EHNewsListViewController *listViewController;
@property (nonatomic, strong)NSString *menuID;
@property (nonatomic, assign)EHNewsListType type;

@end
