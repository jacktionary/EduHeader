//
//  EHGlobalSingleton.h
//  EduHeader
//
//  Created by HaoKing on 15/10/16.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EHUserModel.h"

@interface EHGlobalSingleton : NSObject

@property (nonatomic, strong)EHUserModel *userInfo;
@property (nonatomic, strong)NSString *gpsCity;

+ (instancetype)sharedInstance;

@end
