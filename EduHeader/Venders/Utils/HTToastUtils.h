//
//  ToastUtils.h
//  
//
//  Created by HaoKing on 14-2-18.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface HTToastUtils : NSObject

+ (void)showToastViewWithMessage:(NSString *)message ForView:(UIView *)view forTimeInterval:(NSTimeInterval)timeInterval;

+ (void)showToastViewWithMessage:(NSString *)message ForView:(UIView *)view forTimeInterval:(NSTimeInterval)timeInterval completionBlock:(MBProgressHUDCompletionBlock)completionBlock;

+ (void)showLoadingAnimationForView:(UIView *)view message:(NSString *)message;

+ (void)hideLoadingAnimationForView:(UIView *)view;

+ (void)hideAllLoadingAnimationForView:(UIView *)view;

@end
