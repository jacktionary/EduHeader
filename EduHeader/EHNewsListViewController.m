//
//  EHNewsListViewController.m
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHNewsListViewController.h"
#import "EHMenuListService.h"
#import "EHNewsListService.h"
#import "EHNewsQueryService.h"
#import "EHNewsInfoService.h"
#import "EHNewsTopService.h"
#import "EHNewsTreadService.h"
#import "EHNewsRecommendService.h"
#import "EHNewsCommentService.h"

#import "SVPullToRefresh.h"
#import "QCSlideSwitchView.h"

#import "EHNewsListNormalViewController.h"
#import "EHNewsListWithSearchBarViewController.h"

#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface EHNewsListViewController()<SlideNavigationControllerDelegate, UISearchBarDelegate, QCSlideSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet QCSlideSwitchView *slideSwitchView;

@property (nonatomic, strong)NSArray *menuDataArr;
@property (nonatomic, strong)NSMutableArray *newsListViewControllerArr;
@property (nonatomic, strong)NSMutableArray *newsListDataArr;

@property (nonatomic, strong) EHBaseViewController *vc1;
@property (nonatomic, strong) EHBaseViewController *vc2;
@property (nonatomic, strong) EHBaseViewController *vc3;
@property (nonatomic, strong) EHBaseViewController *vc4;
@property (nonatomic, strong) EHBaseViewController *vc5;
@property (nonatomic, strong) EHBaseViewController *vc6;

@property (nonatomic, strong)NSString *currentCity;
@property (nonatomic, strong)CLLocationManager *manager;

@property (nonatomic, assign)NSInteger currentIndexOfMenu;

@end

@implementation EHNewsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentIndexOfMenu = -1;
    
    self.slideSwitchView.tabItemNormalColor = [UIColor whiteColor];
    self.slideSwitchView.tabItemSelectedColor = [QCSlideSwitchView colorFromHexRGB:@"3dc6fb"];
    self.slideSwitchView.shadowImage = [UIImage imageNamed:@"red_line_and_shadow"];
    
    // 设置可滑动区域
    [SlideNavigationController sharedInstance].panGestureSideOffset = 50;
    
    self.newsListViewControllerArr = [[NSMutableArray alloc] init];
    
    [self requestMenuData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gpsCityChanged:) name:kNotification_GpsCityChanged object:nil];
}

- (void)gpsCityChanged:(NSNotification *)notification
{
    if (self.newsListViewControllerArr && [self.newsListViewControllerArr count] > 0) {
        EHBaseViewController *vc = nil;
        
        vc = [self.newsListViewControllerArr objectAtIndex:self.currentIndexOfMenu];
        
        [vc viewDidCurrentView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)requestMenuData
{
    [HTToastUtils showLoadingAnimationForView:self.view message:@"加载中..."];
    __weak EHNewsListViewController *weakself = self;
    
    [[EHMenuListService clientInstance] requestMenuListWithBlock:^(EHTypeListRootModel *root, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:weakself.view];
        if ([root.status integerValue] == RequestSuccess) {
            weakself.menuDataArr = root.result;
            
            [weakself.slideSwitchView buildUI];
        }
    }];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return [self.menuDataArr count];
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIViewController *vc;
    if (number == 0) {
        vc = [[EHNewsListNormalViewController alloc] init];
        [(EHNewsListNormalViewController *)vc setType:EHNewsListType_SearchBar];
        
        vc.title = [[self.menuDataArr objectAtIndex:number] name];
        
        if ([vc respondsToSelector:@selector(setMenuID:)]) {
            [vc performSelector:@selector(setMenuID:) withObject:[[self.menuDataArr objectAtIndex:number] id]];
        }
        
        if ([vc respondsToSelector:@selector(setListViewController:)]) {
            [vc performSelector:@selector(setListViewController:) withObject:self];
        }
        
        [self.newsListViewControllerArr addObject:vc];
        
        return vc;
    } else if (number < [self.menuDataArr count]) {
        vc = [[EHNewsListNormalViewController alloc] init];
        vc.title = [[self.menuDataArr objectAtIndex:number] name];
        
        if ([vc respondsToSelector:@selector(setMenuID:)]) {
            [vc performSelector:@selector(setMenuID:) withObject:[[self.menuDataArr objectAtIndex:number] id]];
        }
        
        if ([vc respondsToSelector:@selector(setListViewController:)]) {
            [vc performSelector:@selector(setListViewController:) withObject:self];
        }
        
        [self.newsListViewControllerArr addObject:vc];
        
        return vc;
    } else {
        return nil;
    }
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    if (self.newsListViewControllerArr && [self.newsListViewControllerArr count] > 0) {
        self.currentIndexOfMenu = number;
        
        EHBaseViewController *vc = nil;
        
        vc = [self.newsListViewControllerArr objectAtIndex:number];
        
        [vc viewDidCurrentView];
    }
}

- (void)pushNewsDetail:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma SlideNavigationControllerDelegate

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
