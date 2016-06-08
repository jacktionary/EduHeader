//
//  EHNewsListModel.m
//  EduHeader
//
//  Created by Hao King on 15/9/12.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHNewsQueryListModel.h"

@implementation EHNewsQueryListRootModel

+ (Class)result_class
{
    return [EHNewsListModel class];
}

+ (Class)result2_class
{
    return [EHNewsListModel class];
}

@end