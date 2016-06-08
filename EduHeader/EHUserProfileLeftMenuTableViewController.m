//
//  EHUserProfileLeftMenuTableViewController.m
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHUserProfileLeftMenuTableViewController.h"
#import "EHUserLoginViewController.h"
#import "EHGlobalSingleton.h"
#import "EHUserInfoCompleteViewController.h"
#import "EHUpdatePasswordViewController.h"
#import "EHNewsEnshrineViewController.h"
#import "APService.h"

static NSInteger vCellHeight = 45;
static NSInteger vCenterOffSetX = -30;

@interface EHUserProfileLeftMenuTableViewController()

@property (nonatomic, weak)UIImageView *userImg;
@property (nonatomic, weak)UIButton *loginNowButton;

@end

@implementation EHUserProfileLeftMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initSubViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserInfo) name:kNotificationLeftMenuUpdateUserInfo object:nil];
}

- (void)updateUserInfo
{
    [self.userImg setImageWithURL:[NSURL URLWithString:[[[EHGlobalSingleton sharedInstance] userInfo] photo]] placeholderImage:[UIImage imageNamed:@"P-4-user"]];
    
    if ([[[EHGlobalSingleton sharedInstance] userInfo] uid]) {
        if (![[[[EHGlobalSingleton sharedInstance] userInfo] nickname] isEqualToString:@""]) {
           [self.loginNowButton setTitle:[[[EHGlobalSingleton sharedInstance] userInfo] nickname] forState:UIControlStateNormal];
        } else {
           [self.loginNowButton setTitle:[[[EHGlobalSingleton sharedInstance] userInfo] phone] forState:UIControlStateNormal];
        }
    } else {
        [self.loginNowButton setTitle:@"立刻登录" forState:UIControlStateNormal];
    }
}

- (void)initSubViews
{
    // 背景图片
    UIImageView *headerImgBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-3-welcometopbg"]];
    
    [self.view addSubview:headerImgBg];
    
    [headerImgBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@150);
    }];
    
    // 用户头像
    UIImageView *userImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-user"]];
    
    [userImg setImageWithURL:[NSURL URLWithString:[[[EHGlobalSingleton sharedInstance] userInfo] photo]] placeholderImage:[UIImage imageNamed:@"P-4-user"]];
    
    [self.view addSubview:userImg];
    
    self.userImg = userImg;
    
    self.userImg.layer.cornerRadius = 30;
    self.userImg.clipsToBounds = YES;
    
    [userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImgBg).with.offset(vCenterOffSetX);
        make.centerY.equalTo(headerImgBg).with.offset(-20);
        make.width.and.height.equalTo(@59);
    }];
    
    UITapGestureRecognizer *userImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginButtonClicked:)];

    userImg.userInteractionEnabled = YES;
    
    [userImg addGestureRecognizer:userImgTap];
    
    // 立刻登录
    UIButton *loginNowButton = [[UIButton alloc] init];
    
    if ([[[EHGlobalSingleton sharedInstance] userInfo] uid]) {
        if (![[[[EHGlobalSingleton sharedInstance] userInfo] nickname] isEqualToString:@""]) {
            [loginNowButton setTitle:[[[EHGlobalSingleton sharedInstance] userInfo] nickname] forState:UIControlStateNormal];
        } else {
            [loginNowButton setTitle:[[[EHGlobalSingleton sharedInstance] userInfo] phone] forState:UIControlStateNormal];
        }
    } else {
        [loginNowButton setTitle:@"立刻登录" forState:UIControlStateNormal];        
    }

    [loginNowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginNowButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [loginNowButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginNowButton];
    self.loginNowButton = loginNowButton;
    
    [loginNowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImgBg).with.offset(vCenterOffSetX);
        make.top.equalTo(userImg.mas_bottom).with.offset(14);
    }];
    
    // 控件y轴位移
    NSInteger controlOffsetY = 16;
    
    // 我的收藏
    // P-2-star
    UIImageView *starImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-2-star"]];
    
    [self.view addSubview:starImgView];
    
    [starImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(headerImgBg.mas_bottom).with.offset(controlOffsetY);
    }];
    
    // 我的收藏label
    UIButton *myCollectionUIButton = [[UIButton alloc] init];
   
    [myCollectionUIButton setTitle:@"我的收藏" forState:UIControlStateNormal];
    [myCollectionUIButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [myCollectionUIButton addTarget:self action:@selector(myCollectionUIButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    myCollectionUIButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:myCollectionUIButton];
    
    [myCollectionUIButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(starImgView.mas_centerY);
        make.left.equalTo(starImgView.mas_right).with.offset(10);
    }];
    
    myCollectionUIButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [myCollectionUIButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-100);
    }];
    // 灰色分割线
    UIView *grayLineCollect = [[UIView alloc] init];
    
    grayLineCollect.backgroundColor = UIColorFromRGB(0xcbcbcb);
    
    [self.view addSubview:grayLineCollect];
    
    [grayLineCollect mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
        make.left.equalTo(self.view);
        make.top.equalTo(headerImgBg.mas_bottom).with.offset(vCellHeight);
    }];
    
    // 清理缓存
    // P-4-trash
    UIImageView *trashImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-trash"]];
    
    [self.view addSubview:trashImgView];
    
    [trashImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(grayLineCollect.mas_bottom).with.offset(controlOffsetY);
    }];
    
    // 清理缓存label
    UIButton *cleanCacheButton = [[UIButton alloc] init];
    
    [cleanCacheButton setTitle:@"清理缓存" forState:UIControlStateNormal];
    [cleanCacheButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [cleanCacheButton addTarget:self action:@selector(cleanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    cleanCacheButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:cleanCacheButton];
    
    [cleanCacheButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(trashImgView.mas_centerY);
        make.left.equalTo(trashImgView.mas_right).with.offset(10);
    }];
    
    cleanCacheButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [cleanCacheButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-100);
    }];
    // 灰色分割线
    UIView *grayLineClean = [[UIView alloc] init];
    
    grayLineClean.backgroundColor = UIColorFromRGB(0xcbcbcb);
    
    [self.view addSubview:grayLineClean];
    
    [grayLineClean mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
        make.left.equalTo(self.view);
        make.top.equalTo(grayLineCollect.mas_bottom).with.offset(vCellHeight);
    }];
    
    /*
    // 推送开关
    // P-4-bell
    UIImageView *bellImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-bell"]];
    
    [self.view addSubview:bellImgView];
    
    [bellImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(grayLineClean.mas_bottom).with.offset(controlOffsetY);
    }];
    
    // 推送开关label
    UILabel *pushSwitchLabel = [[UILabel alloc] init];
    
    pushSwitchLabel.text = @"推送开关";
    pushSwitchLabel.textColor = [UIColor blackColor];
    pushSwitchLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:pushSwitchLabel];
    
    [pushSwitchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bellImgView.mas_centerY);
        make.left.equalTo(bellImgView.mas_right).with.offset(10);
    }];
    
    UISwitch *pushSwitch = [[UISwitch alloc] init];
    
    [pushSwitch addTarget:self action:@selector(pushSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    NSString *isOn = [[NSUserDefaults standardUserDefaults] stringForKey:@"vPushSwitchValue"];
    
    [pushSwitch setOn:[isOn boolValue] animated:YES];
    
    [self.view addSubview:pushSwitch];
    
    [pushSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(pushSwitchLabel.mas_right).with.offset(140);
        make.centerY.equalTo(pushSwitchLabel);
    }];
    
    // 灰色分割线
    UIView *grayLinePush = [[UIView alloc] init];
    
    grayLinePush.backgroundColor = UIColorFromRGB(0xcbcbcb);
    
    [self.view addSubview:grayLinePush];
    
    [grayLinePush mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
        make.left.equalTo(self.view);
        make.top.equalTo(grayLineClean.mas_bottom).with.offset(vCellHeight);
    }];
    */
     
    // 修改密码
    // P-4-key
    UIImageView *keyImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-key"]];
    
    [self.view addSubview:keyImgView];
    
    [keyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
//        make.top.equalTo(grayLinePush.mas_bottom).with.offset(controlOffsetY);
        make.top.equalTo(grayLineClean.mas_bottom).with.offset(controlOffsetY);
    }];
    
    // 修改密码label
    UIButton *changePasswordButton = [[UIButton alloc] init];
    
    [changePasswordButton setTitle:@"修改密码" forState:UIControlStateNormal];
    [changePasswordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [changePasswordButton addTarget:self action:@selector(changePasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    changePasswordButton.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:changePasswordButton];
    
    [changePasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(keyImgView.mas_centerY);
        make.left.equalTo(keyImgView.mas_right).with.offset(10);
    }];
    
    changePasswordButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [changePasswordButton.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-100);
    }];
    
    // 灰色分割线
    UIView *grayLinePassword = [[UIView alloc] init];
    
    grayLinePassword.backgroundColor = UIColorFromRGB(0xcbcbcb);
    
    [self.view addSubview:grayLinePassword];
    
    [grayLinePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
        make.left.equalTo(self.view);
        make.top.equalTo(grayLineClean.mas_bottom).with.offset(vCellHeight);
     }];
    
    // 客服电话
    UIButton *customerServiceNo = [[UIButton alloc] init];
    
    [customerServiceNo setTitle:@"客服QQ-2717716262" forState:UIControlStateNormal];
    [customerServiceNo setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    customerServiceNo.titleLabel.font = [UIFont systemFontOfSize:13];
    
    [self.view addSubview:customerServiceNo];
    
    [customerServiceNo addTarget:self action:@selector(customerServiceNoTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [customerServiceNo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headerImgBg).with.offset(vCenterOffSetX);
        make.bottom.equalTo(@(-30));
    }];
}

- (void)pushSwitchValueChanged:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%d", isButtonOn] forKey:@"vPushSwitchValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (isButtonOn) {
        // Required
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        } else {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
        
    }else {
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

- (void)customerServiceNoTapped:(UIButton *)gesture
{
    /*
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://01088570353"]];
     */
}

- (void)loginButtonClicked:(UIButton *)loginButton
{
    if ([[EHGlobalSingleton sharedInstance] userInfo]) {
        EHUserInfoCompleteViewController *userVC = [EHUserInfoCompleteViewController new];
        
        userVC.phone = [[[EHGlobalSingleton sharedInstance] userInfo] phone];
        userVC.code = [[[EHGlobalSingleton sharedInstance] userInfo] code];
        
        userVC.type = EHUserInfoType_UserInfo;
        
        [[SlideNavigationController sharedInstance] pushViewController:userVC animated:YES];
    } else {
        EHUserLoginViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EHUserLoginViewController"];
        
        [[SlideNavigationController sharedInstance] pushViewController:userVC animated:YES];
    }
}

- (void)changePasswordButtonClicked:(UIButton *)button
{
    if ([[EHGlobalSingleton sharedInstance] userInfo]) {
        EHUpdatePasswordViewController *vc = [EHUpdatePasswordViewController new];
        
        [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
    } else {
        EHUserLoginViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EHUserLoginViewController"];
        
        [[SlideNavigationController sharedInstance] pushViewController:userVC animated:YES];
    }
}

- (void)cleanButtonClicked:(UIButton *)button
{
    [HTToastUtils showToastViewWithMessage:@"清理缓存中..." ForView:self.view forTimeInterval:vMessageShowDuration/3 completionBlock:^{
        [HTToastUtils showToastViewWithMessage:@"清理完毕." ForView:self.view forTimeInterval:vMessageShowDuration];
    }];
}

- (void)myCollectionUIButtonClicked:(UIButton *)button
{
    if ([[EHGlobalSingleton sharedInstance] userInfo]) {
        EHNewsEnshrineViewController *vc = [EHNewsEnshrineViewController new];
        
        [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
    } else {
        EHUserLoginViewController *userVC = [self.storyboard instantiateViewControllerWithIdentifier:@"EHUserLoginViewController"];
        
        [[SlideNavigationController sharedInstance] pushViewController:userVC animated:YES];
    }
}

@end
