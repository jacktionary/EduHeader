//
//  HTBaseModel.h
//  创建Model基类，方便以后扩展
//  LafasoPad
//
//  Created by HaoKing on 13-6-26.
//  Copyright (c) 2013年 EduHeader. All rights reserved.
//

#import "HTJastor.h"

#define RequestSuccess  0

@interface HTBaseModel : HTJastor

@property (nonatomic, strong)NSString *info;
@property (nonatomic, strong)NSNumber *status;

@end
