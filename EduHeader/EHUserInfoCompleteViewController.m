//
//  EHUserInfoCompleteViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHUserInfoCompleteViewController.h"
#import "EHImageUploadService.h"
#import "HTConvertUtil.h"
#import "EHUserUpdateService.h"
#import "EHGlobalSingleton.h"
#import "UIButton+WebCache.h"
#import "EHUserProfileLeftMenuTableViewController.h"

@interface EHUserInfoCompleteViewController ()<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak)UIButton *userPhotoButton;
@property (nonatomic, strong)NSString *userPhotoURL;
@property (nonatomic, weak)UITextField *nicknameTextField;
@property (nonatomic, weak)UITextField *ageTextField;
@property (nonatomic, weak)UIDatePicker *datePicker;
@property (nonatomic, weak)UITextField *cityTextField;

@end

@implementation EHUserInfoCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.type == EHUserInfoType_UserInfo) {
        [self commitUserInfo];
    }
}

- (void)initSubViews
{
    if ([[EHGlobalSingleton sharedInstance] userInfo]) {
        self.title = @"个人信息";
    } else {
        self.title = @"完善信息";
    }
    
    // 用户头像
    UIButton *userPhotoButton = [UIButton new];
    
    if ([[[EHGlobalSingleton sharedInstance] userInfo] photo] && ![[[[EHGlobalSingleton sharedInstance] userInfo] photo] isEqualToString:@""]) {
        [userPhotoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[EHGlobalSingleton sharedInstance] userInfo] photo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"P-4-user"]];
    } else {
        [userPhotoButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[[[EHGlobalSingleton sharedInstance] userInfo] photo]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"P-4-user"]];
        [userPhotoButton setImage:[UIImage imageNamed:@"P-4-photo"] forState:UIControlStateNormal];
        [userPhotoButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, -50, 0)];
    }
    
    [userPhotoButton addTarget:self action:@selector(userPhotoButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:userPhotoButton];
    
    self.userPhotoButton = userPhotoButton;
    
    self.userPhotoButton.layer.cornerRadius = 30;
    self.userPhotoButton.clipsToBounds = YES;
    
    [userPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(@(64+15));
        make.width.and.height.equalTo(@59);
    }];
    // 昵称
    UIView *nicknameView = [UIView new];
    
    nicknameView.layer.cornerRadius = 5;
    nicknameView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    nicknameView.layer.borderWidth = 1;
    
    [self.view addSubview:nicknameView];
    
    [nicknameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userPhotoButton.mas_bottom).with.offset(25);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *nicknameTextField = [[UITextField alloc] init];
    
    nicknameTextField.placeholder = @"请输入昵称";
    
    [self.view addSubview:nicknameTextField];
    
    self.nicknameTextField = nicknameTextField;
    
    [self.nicknameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicknameView);
        make.left.equalTo(nicknameView).with.offset(10);
        make.right.equalTo(nicknameView).with.offset(-5);
        make.bottom.equalTo(nicknameView);
    }];
    
    // 年龄
    UIView *ageView = [UIView new];
    
    ageView.layer.cornerRadius = 5;
    ageView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    ageView.layer.borderWidth = 1;
    
    [self.view addSubview:ageView];
    
    [ageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nicknameView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *ageTextField = [[UITextField alloc] init];
    
    ageTextField.placeholder = @"请输入年龄";
    
    [self.view addSubview:ageTextField];
    
    self.ageTextField = ageTextField;
    self.ageTextField.delegate = self;
    
    // create a UIPicker view as a custom keyboard view
    UIDatePicker* pickerView = [[UIDatePicker alloc] init];
    
    pickerView.date = [NSDate date];
    
    pickerView.datePickerMode = UIDatePickerModeDate;
    
    self.ageTextField.inputView = pickerView;
    
    // Prepare done button
    UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
    keyboardDoneButtonView.barStyle = UIBarStyleBlack;
    keyboardDoneButtonView.translucent = YES;
    keyboardDoneButtonView.tintColor = nil;
    [keyboardDoneButtonView sizeToFit];
    
    UIBarButtonItem* doneButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成"
                                                                    style:UIBarButtonItemStyleBordered target:self
                                                                   action:@selector(doneButtonItemClicked:)];
    [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButtonItem, nil]];
    
    self.ageTextField.inputAccessoryView = keyboardDoneButtonView;
    self.datePicker = pickerView;
    
    [self.ageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageView);
        make.left.equalTo(ageView).with.offset(10);
        make.right.equalTo(ageView).with.offset(-5);
        make.bottom.equalTo(ageView);
    }];
    
    // 城市
    UIView *cityView = [UIView new];
    
    cityView.layer.cornerRadius = 5;
    cityView.layer.borderColor = UIColorFromRGB(0xd7d7d7).CGColor;
    cityView.layer.borderWidth = 1;
    
    [self.view addSubview:cityView];
    
    [cityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ageView.mas_bottom).with.offset(15);
        make.left.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view).with.offset(-20*2);
        make.height.equalTo(@40);
    }];
    
    UITextField *cityTextField = [[UITextField alloc] init];
    
    cityTextField.placeholder = @"您的所在地";
    
    [self.view addSubview:cityTextField];
    
    self.cityTextField = cityTextField;
    
    self.cityTextField.enabled = NO;
    self.cityTextField.textColor = UIColorFromRGB(0xcdcdcd);
    self.cityTextField.text = [EHGlobalSingleton sharedInstance].gpsCity;
    
    [self.cityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cityView);
        make.left.equalTo(cityView).with.offset(10);
        make.right.equalTo(cityView).with.offset(-5);
        make.bottom.equalTo(cityView);
    }];
    
    if (self.type == EHUserInfoType_UserInfo) {
        UIButton *logoutButton = [UIButton new];
        
        [logoutButton setTitle:@"注销账户" forState:UIControlStateNormal];
        
        [logoutButton setBackgroundColor:UIColorFromRGB(0xebebeb)];
        logoutButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [logoutButton setTitleColor:UIColorFromRGB(0xcfcece) forState:UIControlStateNormal];
        
        logoutButton.layer.cornerRadius = 5;
        
        [logoutButton addTarget:self action:@selector(logoutButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:logoutButton];
        
        [logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view).with.offset(-20*2);
            make.height.equalTo(@40);
            make.left.equalTo(@20);
            make.bottom.equalTo(self.view).with.offset(-22);
        }];
    } else {
        // 完成
        UIButton *doneButton = [UIButton new];
        
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        
        [doneButton setBackgroundColor:UIColorFromRGB(0x3dc6fb)];
        doneButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        doneButton.layer.cornerRadius = 5;
        
        [doneButton addTarget:self action:@selector(doneButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:doneButton];
        
        [doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view).with.offset(-20*2);
            make.height.equalTo(@40);
            make.left.equalTo(@20);
            make.top.equalTo(cityView.mas_bottom).with.offset(30);
        }];
        
        // 跳过
        UILabel *notFillLabel = [UILabel new];
        
        notFillLabel.text = @"先不填，";
        notFillLabel.textColor = [UIColor blackColor];
        notFillLabel.font = [UIFont systemFontOfSize:15];
        
        [self.view addSubview:notFillLabel];
        
        [notFillLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(doneButton.mas_bottom).with.offset(20);
            make.right.equalTo(self.view).multipliedBy(0.5);
        }];
        
        UIButton *passButton = [UIButton new];
        
        [passButton setTitle:@"跳过" forState:UIControlStateNormal];
        [passButton setTitleColor:UIColorFromRGB(0x3dc6fb) forState:UIControlStateNormal];
        passButton.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [passButton addTarget:self action:@selector(passButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:passButton];
        
        [passButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.baseline.equalTo(notFillLabel);
            make.left.equalTo(notFillLabel.mas_right);
        }];
    }
    
    [self updateUserInfo];
}

- (void)updateUserInfo
{
    self.nicknameTextField.text = [[[EHGlobalSingleton sharedInstance] userInfo] nickname];
    self.ageTextField.text = [NSString stringWithFormat:@"%@", [[[EHGlobalSingleton sharedInstance] userInfo] age] ? [[[EHGlobalSingleton sharedInstance] userInfo] age] : @"0"];
    self.cityTextField.text = [[[EHGlobalSingleton sharedInstance] userInfo] location];
}

- (void)logoutButtonClicked:(UIButton *)button
{
    [EHGlobalSingleton sharedInstance].userInfo = nil;
    
    [[SlideNavigationController sharedInstance].leftMenu performSelector:@selector(updateUserInfo)];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)commitUserInfo
{
    [[EHUserUpdateService clientInstance] updateUserInfoForUser:[[[EHGlobalSingleton sharedInstance] userInfo] uid] photo:self.userPhotoURL nickname:self.nicknameTextField.text age:self.ageTextField.text phone:self.phone code:self.code block:^(EHUserRootModel *data, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        if ([[data status] integerValue] == RequestSuccess) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLeftMenuUpdateUserInfo object:nil];
            
            [EHGlobalSingleton sharedInstance].userInfo = data.result;
            
            [[SlideNavigationController sharedInstance].leftMenu performSelector:@selector(updateUserInfo)];
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
        }
    }];
}

- (void)doneButtonClicked:(UIButton *)button
{
    if (![self isInputContentValidated]) {
        return;
    }
    
    [HTToastUtils showLoadingAnimationForView:self.view message:@"加载中..."];
    
    [self commitUserInfo];
}

- (BOOL)isInputContentValidated
{
    BOOL result = YES;
    
    if ([self.nicknameTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请输入昵称" ForView:self.view forTimeInterval:3];
        
        result = NO;
    } else if ([self.ageTextField.text isEqualToString:@""]) {
        [HTToastUtils showToastViewWithMessage:@"请选择年龄" ForView:self.view forTimeInterval:3];
        
        result = NO;
    }
    
    return result;
}

- (void)passButtonClicked:(UIButton *)button
{
    [[SlideNavigationController sharedInstance].leftMenu performSelector:@selector(updateUserInfo)];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)doneButtonItemClicked:(UIButton *)button
{
    [self.ageTextField resignFirstResponder];
    
    NSString *age = [HTConvertUtil ageFromDate:self.datePicker.date];
    
    self.ageTextField.text = age;
}

#pragma UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)agePickerValueChanged:(UIDatePicker *)picker
{
    
}

- (void)userPhotoButtonClicked:(UIButton *)button
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                             delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"0");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == 1) {
        NSLog(@"1");
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSData *data;
    NSString *fileName;
    
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
        fileName = @"user.jpg";
    }
    else
    {
        data = UIImagePNGRepresentation(image);
        fileName = @"user.png";
    }
    
    // Create paths to output images
    NSString  *filePath = [NSString stringWithFormat:@"%@/%@", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"], fileName];
    
    [data writeToFile:filePath atomically:YES];
    
    [HTToastUtils showLoadingAnimationForView:self.view message:@"上传图片中..."];
    [self dismissViewControllerAnimated:YES completion:^{
        [[EHImageUploadService clientInstance] uploadImageWithFilePath:filePath fileName:fileName block:^(EHImageUploadModel *data, NSError *error) {
            [HTToastUtils hideAllLoadingAnimationForView:self.view];
            
            if ([[data status] integerValue] == RequestSuccess) {
                self.userPhotoURL = data.result;
                
                [self.userPhotoButton setBackgroundImage:nil forState:UIControlStateNormal];
                [self.userPhotoButton setImage:image forState:UIControlStateNormal];
                [self.userPhotoButton setImageEdgeInsets:UIEdgeInsetsZero];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
            }
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
