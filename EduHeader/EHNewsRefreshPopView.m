//
//  EHNewsRefreshPopView.m
//  EduHeader
//
//  Created by JackCheng on 15/12/4.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsRefreshPopView.h"
#import "EHMacro.h"
#import "Masonry.h"

@implementation EHNewsRefreshPopView

+ (instancetype)sharedInstance
{
    static EHNewsRefreshPopView *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.backgroundColor = UIColorFromRGB(0xfba042);
        
        self.alpha = 0.0;
        
        UILabel *alertMessage = [[UILabel alloc] init];
        
        alertMessage.textColor = [UIColor whiteColor];
        alertMessage.font = [UIFont systemFontOfSize:16];
        
        [self addSubview:alertMessage];
        
        [alertMessage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
        }];
        
        self.messageLabel = alertMessage;
    }
    
    return self;
}

@end
