//
//  EHUserLoginViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/12.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserLoginViewController.h"
#import "EHUserLoginService.h"
#import "EHUserRegistViewController.h"
#import "EHGlobalSingleton.h"
#import "EHForgetPasswordFirstViewController.h"

@interface EHUserLoginViewController ()

@property (nonatomic, weak)UITextField *usernameTextField;
@property (nonatomic, weak)UITextField *passwordTextField;

@end

@implementation EHUserLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    
    [self initSubViews];
}

- (void)initSubViews
{
    self.title = @"登录";
    
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
    
    // 密码
    UIView *passwordView = [UIView new];
    
    passwordView.layer.cornerRadius = 5;
    passwordView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    passwordView.layer.borderWidth = 1;
    
    [self.view addSubview:passwordView];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    
    passwordTextField.placeholder = @"输入您的密码";
    passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passwordTextField];
    
    self.passwordTextField = passwordTextField;
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView);
        make.left.equalTo(passwordView).with.offset(10);
        make.right.equalTo(passwordView).with.offset(-5);
        make.bottom.equalTo(passwordView);
    }];
    
    // 记住我
    UIButton *rememberMeButton = [[UIButton alloc] init];
    
    [rememberMeButton setImage:[UIImage imageNamed:@"Checkbox Unchecked-50"] forState:UIControlStateNormal];
    [rememberMeButton setImage:[UIImage imageNamed:@"Checkbox Checked-50"] forState:UIControlStateSelected];
    [rememberMeButton setImage:[UIImage imageNamed:@"Checkbox Checked-50"] forState:UIControlStateHighlighted];
    
    [rememberMeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [rememberMeButton setTitle:@"记住我" forState:UIControlStateNormal];
    rememberMeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    rememberMeButton.selected = YES;
    [rememberMeButton addTarget:self action:@selector(rememberMeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:rememberMeButton];
    
    [rememberMeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).with.offset(15);
        make.left.equalTo(passwordView);
        make.width.equalTo(rememberMeButton.mas_width);
    }];
    
    // 忘记密码
    UIButton *forgetPasswordButton = [UIButton new];
    [forgetPasswordButton setTitleColor:UIColorFromRGB(0x31b0e1) forState:UIControlStateNormal];
    
    [forgetPasswordButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPasswordButton.titleLabel.font = [UIFont systemFontOfSize:12];
    
    [forgetPasswordButton addTarget:self action:@selector(forgetPasswordButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetPasswordButton];
    
    [forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rememberMeButton);
        make.right.equalTo(passwordView);
    }];
    
    // 登录按钮
    UIButton *loginButton = [UIButton new];
    
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    
    [loginButton setBackgroundColor:UIColorFromRGB(0x3dc6fb)];
    loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    loginButton.layer.cornerRadius = 5;
    
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
        make.left.equalTo(@20);
        make.top.equalTo(forgetPasswordButton.mas_bottom).with.offset(20);
    }];
    
    // 注册按钮
    UIButton *registButton = [UIButton new];
    
    [registButton setTitle:@"没有账号，立刻注册" forState:UIControlStateNormal];
    
    [registButton setBackgroundColor:UIColorFromRGB(0x27c20d)];
    registButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [registButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    registButton.layer.cornerRadius = 5;
    
    [registButton addTarget:self action:@selector(registButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registButton];
    
    [registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
        make.left.equalTo(@20);
        make.top.equalTo(loginButton.mas_bottom).with.offset(15);
    }];
}

- (void)rememberMeButtonClicked:(UIButton *)button
{
    button.selected = !button.selected;
}

- (void)forgetPasswordButtonClicked:(UIButton *)button
{
    EHForgetPasswordFirstViewController *vc = [EHForgetPasswordFirstViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loginButtonClicked:(UIButton *)button
{
    if (![self isInputContentValidated]) {
        return;
    }
    
    [HTToastUtils showLoadingAnimationForView:self.view message:@"加载中..."];
    
    [[EHUserLoginService clientInstance] loginWithPhone:self.usernameTextField.text password:self.passwordTextField.text block:^(EHUserRootModel *data, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        NSLog(@"%@", [[EHGlobalSingleton sharedInstance] userInfo]);
        
        if ([[data status] integerValue] == RequestSuccess) {
            
            [HTToastUtils showToastViewWithMessage:@"登录成功" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
                [EHGlobalSingleton sharedInstance].userInfo = data.result;
                [(EHUserLoginViewController *)([SlideNavigationController sharedInstance].leftMenu) performSelector:@selector(updateUserInfo)];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
        }
    }];
}

- (BOOL)isInputContentValidated
{
    BOOL result = YES;
    
    if ([self.usernameTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入用户名" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入密码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    }
    
    return result;
}

- (void)registButtonClicked:(UIButton *)button
{
    EHUserRegistViewController *registVC = [[EHUserRegistViewController alloc] init];
    
    [self.navigationController pushViewController:registVC animated:YES];
}

@end
