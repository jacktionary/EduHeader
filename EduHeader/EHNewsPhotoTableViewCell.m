//
//  EHNewsBigPicTableViewCell.m
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHNewsPhotoTableViewCell.h"
#import "EHNewsCommentAddService.h"
#import "HTStringUtils.h"
#import "EHUserLoginViewController.h"
#import "EHNewsInfoService.h"
#import "EHNewsEnshrineCancelService.h"
#import "EHNewsRecommendService.h"
#import "EHNewsCommentService.h"
#import "EHNewsTopService.h"
#import "EHNewsTreadService.h"
#import "EHNewsEnshrineAddService.h"
#import "EHGlobalSingleton.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

#import "EHNewsCommentListViewController.h"

#define vButtonStatus_Clicked   @"0"
#define vButtonStatusNum_Clicked    @0
#define vButtonStatus_UnClicked @"1"
#define vButtonStatusNum_UnClicked  @1
#define vButtonType_Top @"0"
#define vButtonType_Treap @"1"

@interface EHNewsPhotoTableViewCell()

@property (nonatomic, weak)UIButton *starButton;

@end

@implementation EHNewsPhotoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:titleLabel];
        
        self.titleLabel = titleLabel;
        
        self.titleLabel.font = [UIFont systemFontOfSize:20];
        self.titleLabel.textColor = UIColorFromRGB(0x343434);
        self.titleLabel.numberOfLines = 2;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(self.contentView).with.offset(-30);
        }];
        
        // source
        UILabel *sourceLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:sourceLabel];
        
        self.sourceLabel = sourceLabel;
        
        self.sourceLabel.font = [UIFont systemFontOfSize:10];
        self.sourceLabel.textColor = [UIColor lightGrayColor];
        self.sourceLabel.numberOfLines = 1;
        
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(65);
            make.left.equalTo(self.contentView).with.offset(15);
        }];
        
        // timeLabel
        UILabel *timeLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.numberOfLines = 1;
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(65);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        // img1View
        UIImageView *img1View = [[UIImageView alloc] init];
        
        [self.contentView addSubview:img1View];
        
        self.img1View = img1View;
        
        CGFloat rate = 1;
        
        if (iPhone6) {
            rate = 1.16;
        } else if (iPhone6Plus) {
            rate = 1.28;
        }
        
        NSInteger imgWidth = 300 * rate;
        NSInteger imgHeight = 327 * rate;
        
        [self.img1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sourceLabel.mas_bottom).with.offset(10);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@(imgWidth));
            make.height.equalTo(@(imgHeight));
        }];
        
        // topButton
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [topButton setImage:[UIImage imageNamed:@"P-2-like-1"] forState:UIControlStateNormal];
        [topButton setImage:[UIImage imageNamed:@"P-2-like-5"] forState:UIControlStateHighlighted];
        [topButton setImage:[UIImage imageNamed:@"P-2-like-5"] forState:UIControlStateSelected];
        
        [topButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:topButton];
        
        [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.img1View.mas_bottom).with.offset(12);
            make.left.equalTo(self.contentView).with.offset(15);
        }];
        
        // topLabel
        UILabel *topLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:topLabel];
        
        self.topLabel = topLabel;
        
        self.topLabel.font = [UIFont systemFontOfSize:10];
        self.topLabel.textColor = [UIColor lightGrayColor];
        self.topLabel.numberOfLines = 1;
        
        [self.topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.left.equalTo(topButton.mas_right).with.offset(5);
        }];
        
        // treadButton
        UIButton *treadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [treadButton setImage:[UIImage imageNamed:@"P-2-like-3"] forState:UIControlStateNormal];
        [treadButton setImage:[UIImage imageNamed:@"P-2-like-6"] forState:UIControlStateHighlighted];
        [treadButton setImage:[UIImage imageNamed:@"P-2-like-6"] forState:UIControlStateSelected];
        
        [treadButton addTarget:self action:@selector(treapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[NSString stringWithFormat:@"%@", [self newsInfoModel].is_tread] isEqualToString:vButtonStatus_Clicked]) {
            treadButton.selected = YES;
        }
        
        [self.contentView addSubview:treadButton];
        
        [treadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.left.equalTo(self.topLabel.mas_right).with.offset(15);
        }];
        
        // treadLabel
        UILabel *treadLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:treadLabel];
        
        self.treadLabel = treadLabel;
        
        self.treadLabel.font = [UIFont systemFontOfSize:10];
        self.treadLabel.textColor = [UIColor lightGrayColor];
        self.treadLabel.numberOfLines = 1;
        
        [self.treadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.left.equalTo(treadButton.mas_right).with.offset(5);
        }];
        
        // commentButton
        UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [commentButton setImage:[UIImage imageNamed:@"P-3-bubbles"] forState:UIControlStateNormal];
        
        [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:commentButton];
        
        [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.left.equalTo(self.treadLabel.mas_right).with.offset(15);
        }];
        
        // commentDownLabel
        UILabel *commentDownLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:commentDownLabel];
        
        self.commentDownLabel = commentDownLabel;
        
        self.commentDownLabel.font = [UIFont systemFontOfSize:10];
        self.commentDownLabel.textColor = [UIColor lightGrayColor];
        self.commentDownLabel.numberOfLines = 1;
        
        [self.commentDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.left.equalTo(commentButton.mas_right).with.offset(5);
        }];
        
        // shareButton
        UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [shareButton setImage:[UIImage imageNamed:@"P-2-share"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:shareButton];
        
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        // starButton
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [starButton setImage:[UIImage imageNamed:@"P-2-star"] forState:UIControlStateNormal];
        [starButton setImage:[UIImage imageNamed:@"P-2-star-2"] forState:UIControlStateHighlighted];
        [starButton setImage:[UIImage imageNamed:@"P-2-star-2"] forState:UIControlStateSelected];
        
        [self.contentView addSubview:starButton];
        
        [starButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [starButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(topButton);
            make.right.equalTo(shareButton.mas_left).with.offset(-18);
        }];
        
        self.starButton = starButton;
        
        UIView *sepratorLine = [[UIView alloc] init];
        
        sepratorLine.backgroundColor = UIColorFromRGB(0xcdcdcd);
        
        [self.contentView addSubview:sepratorLine];
        
        [sepratorLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.width.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)setStarButtonWithModel:(EHNewsListModel *)newsInfoModel
{
    if ([newsInfoModel.is_enshrine isEqual:ident_yes]) {
        self.starButton.selected = YES;
    } else {
        self.starButton.selected = NO;
    }
}

- (void)setNewsInfoModel:(EHNewsListModel *)newsInfoModel
{
    _newsInfoModel = newsInfoModel;
    
    [self setStarButtonWithModel:newsInfoModel];
}

- (void)shareButtonClicked:(UIButton *)button
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
   
    [shareParams SSDKSetupShareParamsByText:self.newsInfoModel.title
                                     images:self.newsInfoModel.title_img1
                                        url:nil
                                      title:self.newsInfoModel.title
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",self.newsInfoModel.title, self.newsInfoModel.sns_url]
                                               title:self.newsInfoModel.title
                                               image:self.newsInfoModel.title_img1
                                                 url:nil
                                            latitude:0
                                           longitude:0
                                            objectID:nil
                                                type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:@[
                                     @(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformTypeSinaWeibo)
                                     ]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
                   
               }];
}

- (void)topButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@", [self newsInfoModel].is_top] isEqualToString:vButtonStatus_Clicked]) {
        return;
    }
    
    [[EHNewsTopService clientInstance] postNewsTopWithID:[self newsInfoModel].id block:^(__weak id data, NSError *error) {
        if ([[data status] integerValue] == RequestSuccess) {
            button.selected = YES;
            [self newsInfoModel].is_top = vButtonStatusNum_Clicked;
            
            self.topLabel.text = [NSString stringWithFormat:@"%ld", (long)([self.newsInfoModel.top integerValue] + 1)];
            
            [HTToastUtils showToastViewWithMessage:@"顶新闻成功" ForView:[self.dataSource mainView] forTimeInterval:vMessageShowDuration completionBlock:^{
                
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:[self.dataSource mainView] forTimeInterval:3];
        }
    }];
}

- (BOOL)isUserLogin
{
    BOOL result = NO;
    
    if ([[EHGlobalSingleton sharedInstance] userInfo]) {
        result = YES;
    } else {
        EHUserLoginViewController *vc = [EHUserLoginViewController new];
        
        [[self.dataSource mainNavigationController] pushViewController:vc animated:YES];
    }
    
    return result;
}

- (void)treapButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@", [self newsInfoModel].is_tread] isEqualToString:vButtonStatus_Clicked]) {
        return;
    }
    
    [[EHNewsTreadService clientInstance] postNewsTreadWithID:[self newsInfoModel].id block:^(__weak id data, NSError *error) {
        if ([[data status] integerValue] == RequestSuccess) {
            [self modifyButton:button WithType:vButtonType_Treap ClickStatus:vButtonStatus_Clicked andNumber:[NSString stringWithFormat:@"%ld", (long)([[self newsInfoModel].tread integerValue] + 1)]];
            [self newsInfoModel].is_tread = vButtonStatusNum_UnClicked;
            
            self.treadLabel.text = [NSString stringWithFormat:@"%ld", (long)([self.newsInfoModel.tread integerValue] + 1)];
            
            [HTToastUtils showToastViewWithMessage:@"踩新闻成功" ForView:[self.dataSource mainView] forTimeInterval:vMessageShowDuration completionBlock:^{
                
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:[self.dataSource mainView] forTimeInterval:3];
        }
    }];
}

- (void)modifyButton:(UIButton *)button WithType:(NSString *)buttonType ClickStatus:(NSString *)status andNumber:(NSString *)number
{
    UIColor *backgroundColor;
    NSInteger borderWidth;
    UIColor *borderColor;
    NSString *imgName;
    UIColor *textColor;
    
    if (!status || [status isEqualToString:@""] || [status isEqualToString:@"(null)"]) {
        status = vButtonStatus_UnClicked;
    }
    
    if ([status isEqualToString:vButtonStatus_Clicked]) {
        backgroundColor = UIColorFromRGB(0x3dc6fb);
        borderWidth = 1;
        borderColor = [UIColor whiteColor];
        
        if ([buttonType isEqualToString:vButtonType_Top]) {
            imgName = @"P-2-like-2";
        } else if ([buttonType isEqualToString:vButtonType_Treap]) {
            imgName = @"P-2-like-4";
        }
        
        textColor = [UIColor whiteColor];
    } else if ([status isEqualToString:vButtonStatus_UnClicked]) {
        backgroundColor = UIColorFromRGB(0xfafafa);
        borderWidth = 1;
        borderColor = UIColorFromRGB(0xEAEAEA);
        
        if ([buttonType isEqualToString:vButtonType_Top]) {
            imgName = @"P-2-like-1";
        } else if ([buttonType isEqualToString:vButtonType_Treap]) {
            imgName = @"P-2-like-3";
        }
        
        textColor = UIColorFromRGB(0xbdbdbd);
    }
    
    button.backgroundColor = backgroundColor;
    button.layer.borderWidth = borderWidth;
    button.layer.borderColor = borderColor.CGColor;
    
    // img
    UIImageView *img = (UIImageView *)[button viewWithTag:101];
    
    if (!img) {
        img = [UIImageView new];
        
        img.tag = 101;
        
        [button addSubview:img];
    }
    
    img.image = [UIImage imageNamed:imgName];
    
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(button.mas_right).multipliedBy(0.45);
        make.centerY.equalTo(button.mas_centerY);
    }];
    
    // text
    UILabel *label = (UILabel *)[button viewWithTag:102];
    
    if (!label) {
        label = [UILabel new];
        label.tag = 102;
        [label setFont:[UIFont systemFontOfSize:14]];
        
        [button addSubview:label];
    }
    
    label.textColor = textColor;
    label.text = number;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).with.offset(5);
    }];
}

- (void)collectButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([[self newsInfoModel].is_enshrine isEqual:ident_yes]) {
        [[EHNewsEnshrineCancelService clientInstance] cancelNewsEnshrineWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsid:[self newsInfoModel].id block:^(__weak id data, NSError *error) {
            if ([[data status] integerValue] == RequestSuccess) {
                
                button.selected = NO;
                [HTToastUtils showToastViewWithMessage:@"取消收藏" ForView:[self.dataSource mainView] forTimeInterval:vMessageShowDuration completionBlock:^{
                    [self newsInfoModel].is_enshrine = ident_no;
                    
                    [self setStarButtonWithModel:self.newsInfoModel];
                }];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:[self.dataSource mainView] forTimeInterval:3];
            }
        }];
    } else {
        [[EHNewsEnshrineAddService clientInstance] addNewsEnshrineWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsID:[self newsInfoModel].id block:^(__weak id data, NSError *error) {
            if ([[data status] integerValue] == RequestSuccess) {
                
                button.selected = YES;
                [HTToastUtils showToastViewWithMessage:@"收藏成功" ForView:[self.dataSource mainView] forTimeInterval:vMessageShowDuration completionBlock:^{
                    [self newsInfoModel].is_enshrine = ident_yes;
                    
                    [self setStarButtonWithModel:self.newsInfoModel];
                }];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:[self.dataSource mainView] forTimeInterval:3];
            }
        }];
    }
}

- (void)commentButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    EHNewsCommentListViewController *commentVC = [EHNewsCommentListViewController new];
    
    commentVC.newsID = self.newsInfoModel.id;
    
    [[self.dataSource mainNavigationController] pushViewController:commentVC animated:YES];
}

@end
