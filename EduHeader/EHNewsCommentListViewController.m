//
//  EHNewsCommentListViewController.m
//  EduHeader
//
//  Created by JackCheng on 15/11/23.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsCommentListViewController.h"
#import "EHNewsListModel.h"
#import "EHNewsCommentAddService.h"
#import "HTStringUtils.h"
#import "EHNewsCommentService.h"
#import "EHNewsCommentTableViewCell.h"
#import "EHGlobalSingleton.h"
#import "EHUserLoginViewController.h"
#import "BlurCommentView.h"
#import "EHNewsCommentAddService.h"

static NSString *cellReuseIdentifierForEHNewsCommentTableViewCell = @"cellReuseIdentifierForEHNewsCommentTableViewCell";

@interface EHNewsCommentListViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UIImageView *loadingImageView;

@end

@implementation EHNewsCommentListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.page = 0;
    
    [self initSubViews];
}

- (void)initSubViews
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        make.top.equalTo(self.view).with.offset(64);
        make.bottom.equalTo(self.view).with.offset(-40);
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        self.page = 0;
        
        [self requestNewsComment];
    }];
    
    [self.tableView registerClass:[EHNewsCommentTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsCommentTableViewCell];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-ico-loading"]];
    
    [self.tableView addSubview:loadingImageView];
    self.loadingImageView = loadingImageView;
    
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).with.offset(-50);
    }];
    
    [self.tableView triggerPullToRefresh];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        if ([self.dataArr count] < 10) {
            [self.tableView.infiniteScrollingView stopAnimating];
            return;
        }
        self.page += 1;
        [self requestNewsComment];
    }];
    
    // 底部工具条
    UIView *toolBar = [[UIView alloc] init];
    
    toolBar.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    [self.view addSubview:toolBar];
    
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@50);
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

- (void)commentButtonClicked:(UIButton *)button
{
    if (![self isUserLogin]) {
        return;
    }
    
    [BlurCommentView commentshowSuccess:^(NSString *text) {
        if ([text isEqualToString:@""]) {
            [HTToastUtils showToastViewWithMessage:@"评论内容为空." ForView:self.view forTimeInterval:vMessageShowDuration];
        } else {
            [[EHNewsCommentAddService clientInstance] addCommentWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsID:self.newsID comment:text block:^(HTBaseModel *data, NSError *error) {
                
                if ([[data status] integerValue] == RequestSuccess) {
                    [HTToastUtils showToastViewWithMessage:@"发布评论成功." ForView:self.view forTimeInterval:vMessageShowDuration];
                    
                    self.page = 0;
                    [self requestNewsComment];
                } else {
                    [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
                }
            }];
        }
    }];
}

- (void)requestNewsComment
{
    [[EHNewsCommentService clientInstance] requestNewsCommentWithNewsID:self.newsID start:[NSString stringWithFormat:@"%ld", self.page] size:@"10" block:^(EHNewsCommentRootModel *data, NSError *error) {
        [HTToastUtils hideAllLoadingAnimationForView:self.view];
        
        if (self.page == 0) {
            [self.tableView.pullToRefreshView stopAnimating];
            self.dataArr = [NSMutableArray array];
        } else {
            [self.tableView.infiniteScrollingView stopAnimating];
        }
        
        if ([[data status] integerValue] == RequestSuccess) {
            
            if ([self.loadingImageView superview]) {
                [self.loadingImageView removeFromSuperview];
            }
            
            if ([data.result count] == 0) {
                [HTToastUtils showToastViewWithMessage:@"没有更多评论了." ForView:self.view forTimeInterval:vMessageShowDuration];
                return;
            }
            
            [self.dataArr addObjectsFromArray:data.result];
            
            [self.tableView reloadData];
            
        } else {
            [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
        }
    }];
}

- (void)viewDidCurrentView
{
    [self.tableView triggerPullToRefresh];
}

#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsCommentModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    EHNewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsCommentTableViewCell];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.timeLabel.text = [StringUtils getDateWithFormatter:@"MM-dd HH:mm" andTimeStamp:[NSString stringWithFormat:@"%@", model.createdate]];
    cell.nicknameLabel.text = (model.nickname && ![model.nickname isEqualToString:@""]) ? model.nickname : @"匿名网友";
    [cell.userPhotoView setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"P-2-user"]];
    
    cell.commentLabel.text = model.comment;
    
    return cell;
}

- (UIView *)mainView
{
    return self.view;
}

- (UINavigationController *)mainNavigationController
{
    return [SlideNavigationController sharedInstance];
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
