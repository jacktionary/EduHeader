//
//  EHBaseViewController.h
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"
#import "SlideNavigationController.h"
#import "EHMacro.h"
#import "SVPullToRefresh.h"
#import "HTToastUtils.h"
#import "HTBaseService.h"

static NSInteger vPageSize = 10;
static NSInteger vMessageShowDuration = 2;
static NSString *vLoadingMessage = @"加载中...";
static NSString *vFirstMostNewsIDForTheLastRequest = @"vLastRequestTimeStamp";

@interface EHBaseViewController : UIViewController

- (void)viewDidCurrentView;

@end
