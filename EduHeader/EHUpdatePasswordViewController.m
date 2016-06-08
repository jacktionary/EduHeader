//
//  EHUpdatePasswordViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUpdatePasswordViewController.h"
#import "EHUserUpdateService.h"
#import "EHGlobalSingleton.h"

@interface EHUpdatePasswordViewController ()

@property (nonatomic, weak)UITextField *oldPasswordTextField;
@property (nonatomic, weak)UITextField *passwordTextField;
@property (nonatomic, weak)UITextField *checkPasswordTextField;

@end

@implementation EHUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViews];
}

- (void)initSubViews
{
    self.title = @"修改密码";
    
    // 旧密码
    UIView *oldPasswordView = [UIView new];
    
    oldPasswordView.layer.cornerRadius = 5;
    oldPasswordView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    oldPasswordView.layer.borderWidth = 1;
    
    [self.view addSubview:oldPasswordView];
    
    [oldPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64 + 15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *oldPasswordTextField = [[UITextField alloc] init];
    
    oldPasswordTextField.placeholder = @"输入原密码";
    oldPasswordTextField.secureTextEntry = YES;
    
    [self.view addSubview:oldPasswordTextField];
    
    self.oldPasswordTextField = oldPasswordTextField;
    
    [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPasswordView);
        make.left.equalTo(oldPasswordView).with.offset(10);
        make.right.equalTo(oldPasswordView).with.offset(-5);
        make.bottom.equalTo(oldPasswordView);
    }];
    
    // 密码
    UIView *passwordView = [UIView new];
    
    passwordView.layer.cornerRadius = 5;
    passwordView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    passwordView.layer.borderWidth = 1;
    
    [self.view addSubview:passwordView];
    
    [passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oldPasswordView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *passwordTextField = [[UITextField alloc] init];
    
    passwordTextField.placeholder = @"输入新密码";
    passwordTextField.secureTextEntry = YES;
    
    [self.view addSubview:passwordTextField];
    
    self.passwordTextField = passwordTextField;
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView);
        make.left.equalTo(passwordView).with.offset(10);
        make.right.equalTo(passwordView).with.offset(-5);
        make.bottom.equalTo(passwordView);
    }];
    
    // 确认密码
    UIView *checkPasswordView = [UIView new];
    
    checkPasswordView.layer.cornerRadius = 5;
    checkPasswordView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    checkPasswordView.layer.borderWidth = 1;
    
    [self.view addSubview:checkPasswordView];
    
    [checkPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(passwordView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *checkPasswordTextField = [[UITextField alloc] init];
    
    checkPasswordTextField.placeholder = @"确认新密码";
    checkPasswordTextField.secureTextEntry = YES;
    
    [self.view addSubview:checkPasswordTextField];
    
    self.checkPasswordTextField = checkPasswordTextField;
    
    [self.checkPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(checkPasswordView);
        make.left.equalTo(checkPasswordView).with.offset(10);
        make.right.equalTo(checkPasswordView).with.offset(-5);
        make.bottom.equalTo(checkPasswordView);
    }];
    
    // 完成
    UIButton *completeButton = [UIButton new];
    
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [completeButton setBackgroundColor:UIColorFromRGB(0x3dc6fb)];
    completeButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    completeButton.layer.cornerRadius = 5;
    
    [completeButton addTarget:self action:@selector(completeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:completeButton];
    
    [completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
        make.left.equalTo(@20);
        make.top.equalTo(checkPasswordView.mas_bottom).with.offset(25);
    }];
}

- (void)completeButtonClicked:(UIButton *)button
{
    if (![self isInputContentValidated]) {
        return;
    }
    
    [HTToastUtils showLoadingAnimationForView:self.view message:vLoadingMessage];
    [[EHUserUpdateService clientInstance] updateUserInfoForUser:[[[EHGlobalSingleton sharedInstance] userInfo] uid] password:self.oldPasswordTextField.text newPassword:self.passwordTextField.text block:^(EHUserRootModel *data, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        if ([[data status] integerValue] == RequestSuccess) {
            
            [HTToastUtils showToastViewWithMessage:@"修改密码成功" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
                
                [EHGlobalSingleton sharedInstance].userInfo = data.result;
                
                [[SlideNavigationController sharedInstance].leftMenu performSelector:@selector(updateUserInfo)];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
        }
    }];
}

- (BOOL)isInputContentValidated
{
    BOOL result = YES;
    
    if ([self.oldPasswordTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入原密码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.passwordTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入新密码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.checkPasswordTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入确认密码" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if (![self.passwordTextField.text isEqualToString:self.checkPasswordTextField.text]) {
        [HTToastUtils showToastViewWithMessage:@"两次输入密码不一致" ForView:self.view forTimeInterval:3];
        
        result = NO;
    }
    
    return result;
}

@end
