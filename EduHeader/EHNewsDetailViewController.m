//
//  EHNewsDetailViewController.m
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHNewsDetailViewController.h"
#import "EHNewsRecommendService.h"
#import "EHNewsCommentService.h"
#import "EHNewsTopService.h"
#import "EHNewsTreadService.h"
#import "EHNewsEnshrineAddService.h"
#import "EHGlobalSingleton.h"
#import "SVPullToRefresh.h"
#import "EHNewsCommentTableViewCell.h"
#import "JSQMessages.h"
#import "EHNewsCommentAddService.h"
#import "HTStringUtils.h"
#import "EHUserLoginViewController.h"
#import "EHNewsInfoService.h"
#import "EHNewsEnshrineCancelService.h"

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

#import "BlurCommentView.h"
#import "TYAlertController.h"
#import "UIImageView+WebCache.h"
#import "EHWebViewController.h"

#define vButtonStatus_Clicked   @"0"
#define vButtonStatusNum_Clicked    @0
#define vButtonStatus_UnClicked @"1"
#define vButtonStatusNum_UnClicked  @1
#define vButtonType_Top @"0"
#define vButtonType_Treap @"1"

static NSInteger vMaxNetworkDoneCounter = 3;
static NSString *vUserDefaultKey_SelectedFontSize = @"vUserDefaultKey_SelectedFontSize";
static NSString *cellReuseIdentifierForEHNewsCommentTableViewCell = @"cellReuseIdentifierForEHNewsCommentTableViewCell";

@interface EHNewsDetailViewController()<UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak)UIScrollView *scrollView;
@property (nonatomic, weak)UIView *contentView;
@property (nonatomic, weak)UIWebView *webView;
@property (nonatomic, weak)UITableView *commentTableView;
@property (nonatomic, assign)NSInteger networkDoneCounter;
@property (nonatomic, strong)EHNewsCommentRootModel *commentModel;
@property (nonatomic, strong)EHNewsListRootModel *newsListModel;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, weak)UIButton *topButton;
@property (nonatomic, weak)UIButton *treapButton;
@property (nonatomic, weak)UIButton *enshirineButton;

@property (nonatomic, weak)UIView *toolBar;

@property (nonatomic, strong)EHNewsInfoModel *newsInfoModel;

@property (nonatomic, weak)UISegmentedControl *fontSegmentedControl;
@property (nonatomic, weak)TYAlertController *alertController;

@property (nonatomic, weak)UILabel *noCommentLabel;

@property (nonatomic, weak)id topObj;
@property (nonatomic, assign)BOOL hasLoaded;

@end

@implementation EHNewsDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.hasLoaded) {
        [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.toolBar.mas_top);
            make.top.equalTo(@(0));
        }];
        
        return;
    } else {
        self.hasLoaded = YES;
    }
    
    self.networkDoneCounter = 0;
    
    [self initSubViews];
    
    [self requestData];
}

- (void)requestNewsComment
{
    [[EHNewsCommentService clientInstance] requestNewsCommentWithNewsID:self.newsID start:@"0" size:@"1000" block:^(__weak id data, NSError *error) {
        NSLog(@"%@", data);
        
        self.commentModel = data;
        [self addNetworkDoneCounter];
    }];
}

- (void)requestData
{
    [HTToastUtils showLoadingAnimationForView:self.view message:vLoadingMessage];
    
    [[EHNewsInfoService clientInstance] requestNewsInfoWith:[[EHGlobalSingleton sharedInstance] userInfo] ? [[[EHGlobalSingleton sharedInstance] userInfo] uid] : @"" newsid:self.newsID block:^(EHNewsInfoRootModel *data, NSError *error) {
        
        if ([[data status] integerValue] == RequestSuccess) {
            self.newsInfoModel = data.result;
        }
        
        [self loadWebView];
        
        [[EHNewsRecommendService clientInstance] requestRecommentWithNewsID:self.newsID block:^(__weak id data, NSError *error) {
            NSLog(@"%@", data);
            
            self.newsListModel = data;
            [self addNetworkDoneCounter];
        }];
        
        [self requestNewsComment];
    }];
}

- (void)loadWebView
{
    id topObj = self.scrollView;
    
    NSLog(@"source:%@, source_img:%@", self.newsInfoModel.source, self.newsInfoModel.source_img);
    
    NSLog(@"导航条%@", self.navigationController.navigationBarHidden? @"隐藏" : @"显示");
    
    if (![self.newsInfoModel.source isEqualToString:@""] || ![self.newsInfoModel.source_img isEqualToString:@""]) {
        // icon
        UIImageView *iconImageView = [[UIImageView alloc] init];
        
        [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.newsInfoModel.source_img]];
        
        [self.scrollView addSubview:iconImageView];
        
        [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView).with.offset(10);
            make.left.equalTo(self.scrollView).with.offset(15);
            make.width.height.equalTo(@15);
        }];
        
        // name
        UIButton *sourceNameButton = [UIButton new];
        [sourceNameButton setTitle:[NSString stringWithFormat:@"出自：%@", self.newsInfoModel.source] forState:UIControlStateNormal];
        
        if (self.newsInfoModel.source_url && ![self.newsInfoModel.source_url isEqualToString:@""]) {
            [sourceNameButton setTitleColor:UIColorFromRGB(0x7fd5fc) forState:UIControlStateNormal];
        } else {
            [sourceNameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [sourceNameButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [sourceNameButton addTarget:self action:@selector(sourceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:sourceNameButton];
        
        [sourceNameButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(iconImageView.mas_right).with.offset(5);
            make.centerY.equalTo(iconImageView);
        }];
        
        // gray line
        UIView *grayLine = [UIView new];
        
        grayLine.backgroundColor = UIColorFromRGB(0xcdcdcd);
        grayLine.alpha = 0.5;
        
        [self.scrollView addSubview:grayLine];
        
        [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(iconImageView.mas_bottom).with.offset(7);
            make.left.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
            make.height.equalTo(@1);
        }];
        
        topObj = grayLine;
    }
    
    self.topObj = topObj;
    
    // 加载webview
    UIWebView *webView = [[UIWebView alloc] init];
    webView.delegate = self;
    webView.scrollView.bounces = NO;
    
    [self.scrollView addSubview:webView];
    
    self.webView = webView;
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView).with.offset(-CGRectGetHeight(self.toolBar.frame));
        make.top.equalTo(self.topObj).with.offset(5);
    }];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.newsInfoModel.content_html]]];
}

- (void)updateUIElements
{
    // grayLine
    UIView *grayLine = [UIView new];
    
    grayLine.backgroundColor = UIColorFromRGB(0xebebed);
    
    [self.view addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).with.offset(1);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    // top
    UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:topButton];
    
    self.topButton = topButton;
    
    [self modifyButton:topButton WithType:vButtonType_Top ClickStatus:[NSString stringWithFormat:@"%@", self.newsInfoModel.is_top]  andNumber:[NSString stringWithFormat:@"%@", self.newsInfoModel.top]];
    
    [topButton addTarget:self action:@selector(topButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.webView.mas_bottom).with.offset(20);
        make.left.equalTo(self.scrollView).with.offset(15);
        make.width.equalTo(@((CGRectGetWidth(self.view.frame) - 20*3)/2));
        make.height.equalTo(@46);
    }];
    
    // treap
    UIButton *treapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.view addSubview:treapButton];
    
    self.treapButton = treapButton;
    
    [self modifyButton:treapButton WithType:vButtonType_Treap ClickStatus:[NSString stringWithFormat:@"%@", self.newsInfoModel.is_tread] andNumber:[NSString stringWithFormat:@"%@", self.newsInfoModel.tread]];
    [treapButton addTarget:self action:@selector(treapButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [treapButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topButton.mas_top);
        make.left.equalTo(topButton.mas_right).with.offset(20);
        make.width.equalTo(@((CGRectGetWidth(self.view.frame) - 20*3)/2));
        make.height.equalTo(@46);
    }];
    
    // recommend news
    UIView *recommendNewsView = [[UIView alloc] init];
    recommendNewsView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self.scrollView addSubview:recommendNewsView];
    
    // 热门新闻1
    if (self.newsListModel.result && [self.newsListModel.result count] > 0) {
        
        [recommendNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.scrollView);
            make.height.equalTo(@(38*([self.newsListModel.result count] + 1)));
            make.top.equalTo(topButton.mas_bottom).with.offset(20);
            make.left.equalTo(self.scrollView);
        }];
        
        // 热门推荐
        UILabel *recommendTitleLabel = [UILabel new];
        
        recommendTitleLabel.text = @"热门推荐";
        recommendTitleLabel.textColor = UIColorFromRGB(0x343434);
        recommendTitleLabel.font = [UIFont systemFontOfSize:15];
        
        [recommendNewsView addSubview:recommendTitleLabel];
        
        [recommendTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recommendNewsView).with.offset(10);
            make.left.equalTo(recommendNewsView).with.offset(10);
        }];
        
        UIView *lastView = recommendTitleLabel;
        
        for (int i = 0; i < [self.newsListModel.result count]; i++) {
            UIButton *recommentNewsButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [recommentNewsButton1 setTitle:[[self.newsListModel.result objectAtIndex:i] title] forState:UIControlStateNormal];
            [recommentNewsButton1 setTitleColor:UIColorFromRGB(0x343434) forState:UIControlStateNormal];
            recommentNewsButton1.titleLabel.font = [UIFont systemFontOfSize:15];
            recommentNewsButton1.tag = i;
            
            [recommentNewsButton1 addTarget:self action:@selector(recommentNewsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:recommentNewsButton1];
            
            recommentNewsButton1.titleLabel.textAlignment = NSTextAlignmentLeft;
            recommentNewsButton1.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            
            [recommentNewsButton1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).with.offset(10);
                make.left.equalTo(recommendTitleLabel);
            }];
            
            [recommentNewsButton1.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(self.view).with.offset(-20);
                make.left.equalTo(recommentNewsButton1.mas_left);
                make.right.equalTo(recommentNewsButton1.mas_right);
            }];
            
            lastView = recommentNewsButton1;
        }
    } else {
        
        [recommendNewsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.scrollView);
            make.height.equalTo(@75);
            make.top.equalTo(topButton.mas_bottom).with.offset(20);
            make.left.equalTo(self.scrollView);
        }];
    
        // 热门推荐
        UILabel *recommendTitleLabel = [UILabel new];
        
        recommendTitleLabel.text = @"热门推荐";
        recommendTitleLabel.textColor = UIColorFromRGB(0x343434);
        recommendTitleLabel.font = [UIFont systemFontOfSize:15];
        
        [recommendNewsView addSubview:recommendTitleLabel];
        
        [recommendTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recommendNewsView).with.offset(10);
            make.left.equalTo(recommendNewsView).with.offset(10);
        }];
        // 暂无推荐
        UILabel *noRecommendLabel = [UILabel new];
        
        noRecommendLabel.text = @"暂无推荐";
        noRecommendLabel.textColor = UIColorFromRGB(0x343434);
        noRecommendLabel.font = [UIFont systemFontOfSize:15];
        
        [recommendNewsView addSubview:noRecommendLabel];
        
        [noRecommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(recommendTitleLabel.mas_bottom).with.offset(20);
            make.left.equalTo(recommendNewsView).with.offset(10);
        }];
    }
    
    // 热门评论label
    UILabel *commentTitleLabel = [UILabel new];
    
    commentTitleLabel.text = @"热门评论";
    commentTitleLabel.textColor = UIColorFromRGB(0x343434);
    commentTitleLabel.font = [UIFont systemFontOfSize:15];
    
    [self.scrollView addSubview:commentTitleLabel];
    
    [commentTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(recommendNewsView.mas_bottom).with.offset(20);
        make.left.equalTo(self.scrollView).with.offset(10);
    }];
    
    UITableView *commentTableView = [[UITableView alloc] init];
    
    [self.scrollView addSubview:commentTableView];
    
    self.commentTableView = commentTableView;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentTitleLabel.mas_bottom);
        make.left.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
        make.height.equalTo(@10);
    }];
    
    [self.commentTableView addInfiniteScrollingWithActionHandler:^{
        self.page += 1;
    }];
    
    [self.commentTableView registerClass:[EHNewsCommentTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsCommentTableViewCell];
    
    // 热门评论tableView
    if (self.commentModel.result && [self.commentModel.result count] > 0) {
        self.commentTableView.hidden = NO;
    } else {
        self.commentTableView.hidden = YES;
        UILabel *noCommentLabel = [UILabel new];
        
        noCommentLabel.text = @"暂无评论";
        noCommentLabel.textColor = UIColorFromRGB(0x343434);
        noCommentLabel.font = [UIFont systemFontOfSize:15];
        
        [self.scrollView addSubview:noCommentLabel];
        self.noCommentLabel = noCommentLabel;
        
        [noCommentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(commentTitleLabel.mas_bottom).with.offset(20);
            make.left.equalTo(self.scrollView).with.offset(20);
        }];
    }
    
    [self.view bringSubviewToFront:self.toolBar];
}

- (void)initSubViews
{
    // 修改字体tabbaritem
    UIImage *fontImage = [UIImage imageNamed:@"P-2-font"];
    UIButton *fontButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fontButton.bounds = CGRectMake( 0, 0, fontImage.size.width, fontImage.size.height );
    [fontButton setImage:fontImage forState:UIControlStateNormal];
    UIBarButtonItem *fontBtn = [[UIBarButtonItem alloc] initWithCustomView:fontButton];
    
    [fontButton addTarget:self action:@selector(fontButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *actionButtonItems = @[fontBtn];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    // 底部工具条
    UIView *toolBar = [[UIView alloc] init];
    
    toolBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self.view addSubview:toolBar];
    self.toolBar = toolBar;
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    
    // 最下层滚动视图
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(toolBar.mas_top);
        make.top.equalTo(@(64));
    }];
    
    // 发表评论
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    commentButton.backgroundColor = [UIColor clearColor];
    [commentButton setTitle:@"发表评论" forState:UIControlStateNormal];
    [commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [commentButton setImage:[UIImage imageNamed:@"P-2-edit"] forState:UIControlStateNormal];
    [commentButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    [commentButton addTarget:self action:@selector(commentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [toolBar addSubview:commentButton];
    
    [commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(toolBar).with.offset(15);
        make.top.equalTo(toolBar).with.offset(20);
    }];
    
    // 转发
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    shareButton.backgroundColor = [UIColor clearColor];
    [shareButton setTitle:@"转发" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [shareButton setImage:[UIImage imageNamed:@"P-2-share"] forState:UIControlStateNormal];
    [shareButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:shareButton];
    
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentButton);
        make.right.equalTo(toolBar.mas_right).with.offset(-15);
    }];
    
    // 收藏
    UIButton *collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    collectButton.backgroundColor = [UIColor clearColor];
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [collectButton setImage:[UIImage imageNamed:@"P-2-star"] forState:UIControlStateNormal];
    [collectButton setImage:[UIImage imageNamed:@"P-2-star-2"] forState:UIControlStateSelected];
    [collectButton setImage:[UIImage imageNamed:@"P-2-star-2"] forState:UIControlStateHighlighted];
    [collectButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
    
    collectButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [collectButton addTarget:self action:@selector(collectButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolBar addSubview:collectButton];
    
    self.enshirineButton = collectButton;
    
    [collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(commentButton);
        make.right.equalTo(shareButton.mas_left).with.offset(-15);
    }];
    
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), 500);
}

- (void)sourceButtonClicked:(UIButton *)button
{
    if (!self.newsInfoModel.source_url || [self.newsInfoModel.source_url isEqualToString:@""]) {
        return;
    }
    
    EHWebViewController *web = [EHWebViewController new];
    web.urlString = [NSString stringWithFormat:@"%@", self.newsInfoModel.source_url];
    
    [self.navigationController pushViewController:web animated:YES];
}

- (void)fontButtonClicked:(UIButton *)fontButton
{
    CGRect rect = self.view.bounds;
    
    NSInteger vViewHeight = 115;
    NSInteger vButtonHeight = 43;
    NSInteger vMarginSmall = 20;
    NSInteger vMarginBig = 25;
    
    UIView *settingModelView = [[UIView alloc] init];
    
    settingModelView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), vViewHeight);
    settingModelView.backgroundColor = [UIColor whiteColor];
    
    // 字体大小
    UILabel *fontSizeLabel = [[UILabel alloc] init];
    
    fontSizeLabel.text = @"字体大小";
    
    [settingModelView addSubview:fontSizeLabel];
    [fontSizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(vMarginSmall));
        make.top.equalTo(@(vMarginBig));
    }];
    
    // 选择字体
    NSArray *items = @[@"小", @"中", @"大", @"最大"];
    UISegmentedControl *fontControl = [[UISegmentedControl alloc] initWithItems:items];
    
    for (int i = 0; i < [items count]; i++) {
        [fontControl setWidth:40 forSegmentAtIndex:i];
    }
    
    NSInteger selectedItem = 0;
    
    if (nil == [[NSUserDefaults standardUserDefaults] objectForKey:vUserDefaultKey_SelectedFontSize]) {
        selectedItem = 1;
    } else {
        selectedItem = [[NSUserDefaults standardUserDefaults] integerForKey:vUserDefaultKey_SelectedFontSize];
    }
    
    fontControl.selectedSegmentIndex = selectedItem;
    
    [settingModelView addSubview:fontControl];
    
    self.fontSegmentedControl = fontControl;
    [self.fontSegmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(settingModelView).with.offset(-(vMarginBig));
        make.baseline.equalTo(fontSizeLabel);
    }];
    
    // gray line
    UIView *grayLine = [[UIView alloc] initWithFrame:CGRectMake(0, vViewHeight - vButtonHeight, rect.size.width, 1)];
    
    grayLine.backgroundColor = UIColorFromRGB(0xcdcdcd);
    grayLine.alpha = 0.5;
    
    [settingModelView addSubview:grayLine];
    
    UIButton *commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commentButton.frame = CGRectMake(0, vViewHeight - vButtonHeight, CGRectGetWidth(rect), vButtonHeight);
    commentButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    [commentButton setTitle:@"完成" forState:UIControlStateNormal];
    [commentButton setTitleColor:UIColorFromRGB(0x343434) forState:UIControlStateNormal];
    [commentButton addTarget:self action:@selector(complete:) forControlEvents:UIControlEventTouchUpInside];
    [settingModelView addSubview:commentButton];
    
    TYAlertController *alertController = [TYAlertController alertControllerWithAlertView:settingModelView preferredStyle:TYAlertControllerStyleActionSheet];
    alertController.backgoundTapDismissEnable = YES;
    [self presentViewController:alertController animated:YES completion:nil];
    
    self.alertController = alertController;
}

- (void)complete:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults] setInteger:self.fontSegmentedControl.selectedSegmentIndex forKey:vUserDefaultKey_SelectedFontSize];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.alertController dismissViewControllerAnimated:YES];
    
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"change(%ld)", (self.fontSegmentedControl.selectedSegmentIndex)]];
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

- (void)topButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@", self.newsInfoModel.is_top] isEqualToString:vButtonStatus_Clicked]) {
        return;
    }
    
    [[EHNewsTopService clientInstance] postNewsTopWithID:self.newsInfoModel.id block:^(__weak id data, NSError *error) {
        if ([[data status] integerValue] == RequestSuccess) {
            [self modifyButton:self.topButton WithType:vButtonType_Top ClickStatus:vButtonStatus_Clicked andNumber:[NSString stringWithFormat:@"%ld", (long)([self.newsInfoModel.top integerValue] + 1)]];
            self.newsInfoModel.is_top = vButtonStatusNum_Clicked;
            [HTToastUtils showToastViewWithMessage:@"顶新闻成功" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
               
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
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
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    return result;
}

- (void)treapButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([[NSString stringWithFormat:@"%@", self.newsInfoModel.is_tread] isEqualToString:vButtonStatus_Clicked]) {
        return;
    }
    
    [[EHNewsTreadService clientInstance] postNewsTreadWithID:self.newsInfoModel.id block:^(__weak id data, NSError *error) {
        if ([[data status] integerValue] == RequestSuccess) {
            [self modifyButton:self.treapButton WithType:vButtonType_Treap ClickStatus:vButtonStatus_Clicked andNumber:[NSString stringWithFormat:@"%ld", (long)([self.newsInfoModel.tread integerValue] + 1)]];
            self.newsInfoModel.is_tread = vButtonStatusNum_UnClicked;
            [HTToastUtils showToastViewWithMessage:@"踩新闻成功" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
                
            }];
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
        }
    }];
}

- (void)collectButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    if ([self.newsInfoModel.is_enshrine isEqual:ident_yes]) {
        [[EHNewsEnshrineCancelService clientInstance] cancelNewsEnshrineWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsid:self.newsInfoModel.id block:^(__weak id data, NSError *error) {
            if ([[data status] integerValue] == RequestSuccess) {
                
                button.selected = NO;
                [HTToastUtils showToastViewWithMessage:@"取消收藏" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
                    self.newsInfoModel.is_enshrine = ident_no;
                }];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
            }
        }];
    } else {
        [[EHNewsEnshrineAddService clientInstance] addNewsEnshrineWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsID:self.newsInfoModel.id block:^(__weak id data, NSError *error) {
            if ([[data status] integerValue] == RequestSuccess) {
                
                button.selected = YES;
                [HTToastUtils showToastViewWithMessage:@"收藏成功" ForView:self.view forTimeInterval:vMessageShowDuration completionBlock:^{
                    self.newsInfoModel.is_enshrine = ident_yes;
                }];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:3];
            }
        }];
    }
}

- (void)commentButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    [BlurCommentView commentshowSuccess:^(NSString *text) {
        if ([text isEqualToString:@""]) {
            [HTToastUtils showToastViewWithMessage:@"评论内容为空." ForView:self.view forTimeInterval:vMessageShowDuration];
        } else {
            [[EHNewsCommentAddService clientInstance] addCommentWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsID:self.newsInfoModel.id comment:text block:^(HTBaseModel *data, NSError *error) {
                
                if ([[data status] integerValue] == RequestSuccess) {
                    [HTToastUtils showToastViewWithMessage:@"发布评论成功." ForView:self.view forTimeInterval:vMessageShowDuration];
                    
                    [[EHNewsCommentService clientInstance] requestNewsCommentWithNewsID:self.newsInfoModel.id start:@"0" size:@"1000" block:^(__weak id data, NSError *error) {
                        NSLog(@"%@", data);
                        
                        self.commentModel = data;
                        [self updateCommentTableview];
                    }];
                } else {
                    [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
                }
            }];
        }
    }];
}

- (void)recommentNewsButtonClicked:(UIButton *)button
{
    EHNewsDetailViewController *detail = [EHNewsDetailViewController new];
    
    detail.newsID = [[self.newsListModel.result objectAtIndex:button.tag] id];
    
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)shareButtonClicked:(UIButton *)button
{
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    UIImage *image = [UIImage imageNamed:@"share-icon"];
    
    [shareParams SSDKSetupShareParamsByText:self.newsInfoModel.title
                                     images:@[image]
                                        url:[NSURL URLWithString:self.newsInfoModel.sns_url]
                                      title:self.newsInfoModel.title
                                       type:SSDKContentTypeAuto];
    
    [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",self.newsInfoModel.title, self.newsInfoModel.sns_url]
                                               title:self.newsInfoModel.title
                                               image:image
                                                 url:[NSURL URLWithString:self.newsInfoModel.sns_url]
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

#pragma UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self addNetworkDoneCounter];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
   [self addNetworkDoneCounter];
}

- (void)updateCommentTableview
{
    self.noCommentLabel.hidden = YES;
    self.commentTableView.hidden = NO;
    
    if (self.commentModel.result && [self.commentModel.result count] > 0) {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + 65);
        
        [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(65 * [self.commentModel.result count]));
        }];
        
        [self.commentTableView reloadData];
    }
}

- (void)addNetworkDoneCounter
{
    self.networkDoneCounter++;
    
    if (self.networkDoneCounter >= vMaxNetworkDoneCounter) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        [self updateUIElements];
        
        // 更新收藏按钮状态
        if ([self.newsInfoModel.is_enshrine isEqual:ident_yes]) {
            self.enshirineButton.selected = YES;
        } else {
            self.enshirineButton.selected = NO;
        }
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height - 100 + 65 * [self.commentModel.result count]);
        
        [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(65 * [self.commentModel.result count]));
        }];
        [self.webView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.scrollView);
            make.height.equalTo(@(self.webView.scrollView.contentSize.height));
            make.top.equalTo(self.topObj).with.offset(5);
        }];
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height + self.webView.scrollView.contentSize.height);
        
        NSLog(@"self.view:%@", self.view);
        NSLog(@"scrollView:%@", self.scrollView);
        NSLog(@"webView:%@",self.webView);
        NSLog(@"self.topLayoutGuide length:%f", [self.topLayoutGuide length]);
    }
}

#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentModel.result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsCommentModel *model = [self.commentModel.result objectAtIndex:indexPath.row];
    
    EHNewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsCommentTableViewCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.timeLabel.text = [StringUtils getDateWithFormatter:@"MM-dd HH:mm" andTimeStamp:[NSString stringWithFormat:@"%@", model.createdate]];
    cell.nicknameLabel.text = (model.nickname && ![model.nickname isEqualToString:@""]) ? model.nickname : @"匿名网友";
    [cell.userPhotoView setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"P-2-user"]];
    
    cell.commentLabel.text = model.comment;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
