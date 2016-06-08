//
//  EHUserRegistViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/14.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserRegistViewController.h"
#import "EHUserCodeSendService.h"
#import "EHUserRegisterPhoneService.h"
#import "EHUserInfoCompleteViewController.h"
#import "EHWebViewController.h"
#import "EHGlobalSingleton.h"
#import "EHUserProfileLeftMenuTableViewController.h"

#define vMaxSeconds 60

@interface EHUserRegistViewController ()

@property (nonatomic, weak)UITextField *usernameTextField;
@property (nonatomic, weak)UITextField *verifyTextField;
@property (nonatomic, weak)UITextField *passwordTextField;
@property (nonatomic, weak)UIButton *verifyButton;
@property (nonatomic, assign)NSInteger secondLeft;

@end

@implementation EHUserRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    self.secondLeft = vMaxSeconds;
}

- (void)initSubViews
{
    self.title = @"注册";
    
    // 用户名
    UIView *userNameView = [UIView new];
    
    userNameView.layer.cornerRadius = 5;
    userNameView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    userNameView.layer.borderWidth = 1;
    
    [self.view addSubview:userNameView];
    
    [userNameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64 + 15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
    }];
    
    UITextField *usernameTextField = [[UITextField alloc] init];
    
    usernameTextField.placeholder = @"输入您的手机号";
    usernameTextField.keyboardType = UIKeyboardTypePhonePad;
    
    [self.view addSubview:usernameTextField];
    
    self.usernameTextField = usernameTextField;
    
    [self.usernameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameView);
        make.left.equalTo(userNameView).with.offset(10);
        make.right.equalTo(userNameView).with.offset(-5);
        make.bottom.equalTo(userNameView);
    }];
    
    // 验证码textfield
    UIView *verifyView = [UIView new];
    
    verifyView.layer.cornerRadius = 5;
    verifyView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    verifyView.layer.borderWidth = 1;
    
    [self.view addSubview:verifyView];
    
    [verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2).multipliedBy(0.66);
        make.height.equalTo(@50);
    }];
    
    UITextField *verifyTextField = [[UITextField alloc] init];
    
    verifyTextField.placeholder = @"输入验证码";
    verifyTextField.secureTextEntry = YES;
    verifyTextField.keyboardType = UIKeyboardTypePhonePad;
    
    [self.view addSubview:verifyTextField];
    
    self.verifyTextField = verifyTextField;
    
    [self.verifyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyView);
        make.left.equalTo(verifyView).with.offset(10);
        make.width.equalTo(verifyView);
        make.bottom.equalTo(verifyView);
    }];
    
    // 验证码button
    UIButton *verifyButton = [UIButton new];
    [verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [verifyButton setBackgroundColor:UIColorFromRGB(0xf5f5f5)];
    [verifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    verifyButton.layer.cornerRadius = 5;
    [verifyButton addTarget:self action:@selector(verifyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:verifyButton];
    
    self.verifyButton = verifyButton;
    
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyView);
        make.left.equalTo(verifyView.mas_right).with.offset(5);
        make.right.equalTo(userNameView);
        make.bottom.equalTo(verifyView);
    }];
    
    // 密码
    UIView *passwordView = [UIView new];
    
    passwordView.layer.cornerRadius = 5;
    passwordView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    passwordView.layer.borderWidth = 1;
    
    [self.view addSubview:passwordView];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    
    passwordTextField.placeholder = @"设置您的登录密码";
    passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passwordTextField];
    
    self.passwordTextField = passwordTextField;
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView);
        make.left.equalTo(passwordView).with.offset(10);
        make.right.equalTo(passwordView).with.offset(-5);
        make.bottom.equalTo(passwordView);
    }];
    
    // 注册钮
    UIButton *registButton = [UIButton new];
    
    [registButton setTitle:@"注册" forState:UIControlStateNormal];
    
    [registButton setBackgroundColor:UIColorFromRGB(0x3dc6fb)];
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    registButton.layer.cornerRadius = 5;
    
    [registButton addTarget:self action:@selector(registButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registButton];
    
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
        make.left.equalTo(@20);
        make.top.equalTo(passwordView.mas_bottom).with.offset(25);
    }];
    
    // 同意
    UIButton *agreeButton = [[UIButton alloc] init];
    
    [agreeButton setImage:[UIImage imageNamed:@"Checkbox Unchecked-50"] forState:UIControlStateNormal];
    [agreeButton setImage:[UIImage imageNamed:@"Checkbox Checked-50"] forState:UIControlStateSelected];
    [agreeButton setImage:[UIImage imageNamed:@"Checkbox Checked-50"] forState:UIControlStateHighlighted];
    
    [agreeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    agreeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    agreeButton.selected = YES;
    [agreeButton addTarget:self action:@selector(agreeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:agreeButton];
    
    [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registButton.mas_bottom).with.offset(15);
        make.left.equalTo(registButton);
    }];
    
    // 今日教育资讯平台用户协议
    UIButton *licenceButton = [UIButton new];
    
    [licenceButton setTitleColor:UIColorFromRGB(0x31b0e1) forState:UIControlStateNormal];
    [licenceButton setTitle:@"《今日教育资讯平台用户协议》" forState:UIControlStateNormal];
    licenceButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [licenceButton addTarget:self action:@selector(licenceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:licenceButton];
    
    [licenceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(agreeButton);
        make.left.equalTo(agreeButton.mas_right);
        make.centerY.equalTo(agreeButton);
    }];
    
    // gray line
    UIView *grayLine = [UIView new];
    grayLine.backgroundColor = UIColorFromRGB(0xebebed);
    
    [self.view addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(licenceButton.mas_bottom).with.offset(15);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    // 已有账号，立刻登录
    UILabel *loginLabel = [UILabel new];
    loginLabel.font = [UIFont systemFontOfSize:15];
    
    loginLabel.text = @"已有账号，";
    loginLabel.textColor = [UIColor blackColor];
    
    [self.view addSubview:loginLabel];
    
    [loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).multipliedBy(0.5);
        make.top.equalTo(grayLine).with.offset(25);
    }];
    
    UIButton *loginButton = [UIButton new];
    
    [loginButton setTitleColor:UIColorFromRGB(0x31b0e1) forState:UIControlStateNormal];
    [loginButton setTitle:@"立刻登录" forState:UIControlStateNormal];
    loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(loginLabel);
        make.left.equalTo(loginLabel.mas_right);
        make.centerY.equalTo(loginLabel);
    }];
}

- (void)verifyButtonClicked:(UIButton *)button
{
    if (self.secondLeft == vMaxSeconds) {
        
        [HTToastUtils showLoadingAnimationForView:self.view message:@"加载中..."];
        
        [[EHUserCodeSendService clientInstance] requestCodeWithPhone:self.usernameTextField.text block:^(HTBaseModel *data, NSError *error) {
            [HTToastUtils hideAllLoadingAnimationForView:self.view];
            
            if ([[data status] integerValue] == RequestSuccess) {
                [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFire:) userInfo:nil repeats:YES];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
            }
        }];
        
        
    }
}

- (void)timerFire:(NSTimer *)timer
{
    if (self.secondLeft > 1) {
        self.secondLeft = self.secondLeft - 1;
        
        [self.verifyButton setTitle:[NSString stringWithFormat:@"%ld秒后重发", (long)self.secondLeft] forState:UIControlStateNormal];
    } else {
        [timer invalidate];
        self.secondLeft = vMaxSeconds;
        [self.verifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)registButtonClicked:(UIButton *)button
{
    [HTToastUtils showLoadingAnimationForView:self.view message:@"加载中..."];
    [[EHUserRegisterPhoneService clientInstance] registUserWithPhone:self.usernameTextField.text city:[EHGlobalSingleton sharedInstance].gpsCity code:self.verifyTextField.text password:self.passwordTextField.text block:^(EHUserRootModel *data, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        if ([[data status] integerValue] == RequestSuccess) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLeftMenuUpdateUserInfo object:nil];
            [EHGlobalSingleton sharedInstance].userInfo = data.result;
            
            EHUserInfoCompleteViewController *vc = [EHUserInfoCompleteViewController new];
            
            vc.phone = self.usernameTextField.text;
            vc.code = self.verifyTextField.text;
            
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
        }
    }];
}

- (BOOL)isInputContentValidated
{
    BOOL result = YES;
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入手机号码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.verifyTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入验证码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入密码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    }
    
    return result;
}

- (void)agreeButtonClicked:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)licenceButtonClicked:(UIButton *)button
{
    EHWebViewController *vc = [EHWebViewController new];
    
    vc.title = @"用户协议";
    
    vc.urlString = @"http://123.57.191.41:8080/FocusAPI/protocol.jsp";
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonClicked:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
