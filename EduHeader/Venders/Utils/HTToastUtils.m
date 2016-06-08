//
//  HTToastUtils.m
//  
//
//  Created by HaoKing on 14-2-18.
//  Copyright (c) 2014年 EduHeader. All rights reserved.
//

#import "HTToastUtils.h"

@implementation HTToastUtils
#pragma mark -
#pragma mark LoadingAnimation

+ (void)showToastViewWithMessage:(NSString *)message ForView:(UIView *)view forTimeInterval:(NSTimeInterval)timeInterval
{
    [HTToastUtils showToastViewWithMessage:message ForView:view forTimeInterval:timeInterval completionBlock:NULL];
}

+ (void)showToastViewWithMessage:(NSString *)message ForView:(UIView *)view forTimeInterval:(NSTimeInterval)timeInterval completionBlock:(MBProgressHUDCompletionBlock)completionBlock
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 20.f;
    hud.yOffset = 0.f;
    hud.removeFromSuperViewOnHide = YES;
    
    if (completionBlock) {
        hud.completionBlock = completionBlock;
    }
    
    [hud hide:YES afterDelay:timeInterval];
}

+ (void)showLoadingAnimationForView:(UIView *)view message:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.margin = 10.f;
    hud.yOffset = 0.f;
    
    [hud show:YES];
}

+ (void)hideLoadingAnimationForView:(UIView *)view
{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)hideAllLoadingAnimationForView:(UIView *)view
{
    [MBProgressHUD hideAllHUDsForView:view animated:YES];
}

@end
