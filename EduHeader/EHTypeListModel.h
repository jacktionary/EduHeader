//
//  EHTypeListModel.h
//  EduHeader
//
//  Created by Hao King on 15/9/10.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseModel.h"

@interface EHTypeListRootModel : HTBaseModel

@property (nonatomic, strong)NSArray *result;

@end

@interface EHTypeListModel : HTBaseModel

@property (nonatomic, strong)NSNumber *id;
@property (nonatomic, strong)NSString *name;

@end
