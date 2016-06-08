//
//  EHNewsRefreshPopView.h
//  EduHeader
//
//  Created by JackCheng on 15/12/4.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EHNewsRefreshPopView : UIView

@property (nonatomic, weak)UILabel *messageLabel;

+ (instancetype)sharedInstance;

@end
