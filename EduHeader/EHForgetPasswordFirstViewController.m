//
//  EHForgetPasswordFirstViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHForgetPasswordFirstViewController.h"
#import "EHUserCodeSendService.h"
#import "EHForgetPasswordSecondViewController.h"

#define vMaxSeconds 60

@interface EHForgetPasswordFirstViewController ()

@property (nonatomic, weak)UITextField *usernameTextField;
@property (nonatomic, weak)UITextField *verifyTextField;
@property (nonatomic, weak)UIButton *verifyButton;
@property (nonatomic, assign)NSInteger secondLeft;

@end

@implementation EHForgetPasswordFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
    
    self.secondLeft = vMaxSeconds;
}

- (void)initSubViews
{
    self.title = @"忘记密码";
    
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
    
    [self.view addSubview:usernameTextField];
    
    self.usernameTextField = usernameTextField;
    
    usernameTextField.keyboardType = UIKeyboardTypePhonePad;
    
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
    
    // 注册钮
    UIButton *nextButton = [UIButton new];
    
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    
    [nextButton setBackgroundColor:UIColorFromRGB(0x3dc6fb)];
    nextButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    nextButton.layer.cornerRadius = 5;
    
    [nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:nextButton];
    
    [nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@50);
        make.left.equalTo(@20);
        make.top.equalTo(verifyView.mas_bottom).with.offset(25);
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

- (void)nextButtonClicked:(UIButton *)button
{
    if (![self isInputContentValidated]) {
        return;
    }
    
    EHForgetPasswordSecondViewController *vc = [EHForgetPasswordSecondViewController new];
    
    vc.phone = self.usernameTextField.text;
    vc.code = self.verifyTextField.text;
    
    [self.navigationController pushViewController:vc animated:YES];
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
    }
    
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
