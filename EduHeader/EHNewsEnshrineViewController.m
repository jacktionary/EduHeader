//
//  EHNewsEnshrineViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsEnshrineViewController.h"

#import "EHWebViewController.h"
#import "EHNewsDetailViewController.h"
#import "SVPullToRefresh.h"

#import "EHNewsBigPicTableViewCell.h"
#import "EHNewsThreePicTableViewCell.h"
#import "EHNewsNoPicTableViewCell.h"
#import "EHNewsRightPicTableViewCell.h"
#import "EHNewsPhotoTableViewCell.h"

#import "EHGlobalSingleton.h"
#import "EHNewsEnshrineListService.h"
#import "EHNewsEnshrineCancelService.h"

static NSString *cellReuseIdentifierForEHNewsBigPicTableViewCell = @"EHNewsBigPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsThreePicTableViewCell = @"EHNewsThreePicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsNoPicTableViewCell = @"EHNewsNoPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsRightPicTableViewCell = @"EHNewsRightPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsPhotoTableViewCell = @"EHNewsPhotoTableViewCellIdentifier";

@interface EHNewsEnshrineViewController ()<UITableViewDataSource, UITableViewDelegate, EHNewsPhotoTableViewCellDatasource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UIImageView *loadingImageView;

@property (nonatomic, weak)EHNewsListModel *photoCellModel;

@end

@implementation EHNewsEnshrineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView triggerPullToRefresh];
}

- (void)initSubViews
{
    self.title = @"我的收藏";
    
    // 修改字体tabbaritem
    UIBarButtonItem *fontBtn = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonClicked:)];
    fontBtn.tintColor = [UIColor blackColor];
    
    NSArray *actionButtonItems = @[fontBtn];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self requestNewsList];
    }];
    
    [self.tableView registerClass:[EHNewsBigPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsBigPicTableViewCell];
    [self.tableView registerClass:[EHNewsNoPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsNoPicTableViewCell];
    [self.tableView registerClass:[EHNewsRightPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsRightPicTableViewCell];
    [self.tableView registerClass:[EHNewsThreePicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsThreePicTableViewCell];
    [self.tableView registerClass:[EHNewsPhotoTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsPhotoTableViewCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(64);
        make.bottom.and.left.and.right.equalTo(self.view);
    }];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-ico-loading"]];
    
    [self.tableView addSubview:loadingImageView];
    self.loadingImageView = loadingImageView;
    
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).with.offset(-40);
    }];
}

- (void)editButtonClicked:(UIBarButtonItem *)button
{
    if ([button.title isEqualToString:@"编辑"]) {
        [button setTitle:@"完成"];
        [self.tableView setEditing:YES animated:YES];
    } else if ([button.title isEqualToString:@"完成"]) {
        [button setTitle:@"编辑"];
        [self.tableView setEditing:NO animated:YES];
    }
}

- (void)requestNewsList
{
    [[EHNewsEnshrineListService clientInstance] requestEnshrineListWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] block:^(EHNewsListRootModel *data, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HTToastUtils hideAllLoadingAnimationForView:self.view];
            [self.tableView.pullToRefreshView stopAnimating];
            
            if ([[data status] integerValue] == RequestSuccess) {
                
                if ([self.loadingImageView superview]) {
                    [self.loadingImageView removeFromSuperview];
                }
                
                if ([data.result count] == 0) {
                    [HTToastUtils showToastViewWithMessage:@"没有更多新闻了." ForView:self.view forTimeInterval:vMessageShowDuration];
                    return;
                }
                self.dataArr = [NSMutableArray array];
                
                [self.dataArr addObjectsFromArray:data.result];
                
                [self.tableView reloadData];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
            }
        });
    }];
}

#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArr count];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    [[EHNewsEnshrineCancelService clientInstance] cancelNewsEnshrineWithUID:[[[EHGlobalSingleton sharedInstance] userInfo] uid] newsid:model.id block:^(__weak id data, NSError *error) {
        [HTToastUtils showToastViewWithMessage:@"已取消" ForView:self.view forTimeInterval:vMessageShowDuration];
    }];
    
    [self.dataArr removeObject:model];
    
    [tableView beginUpdates];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [tableView endUpdates];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    //Integer img_type;//'图片类型\n0=无图；\n1=小图；\n2=大图；\n3=三图；',
    
    if ([model.news_type integerValue] == 0 || [model.news_type integerValue] == 1 || [model.news_type integerValue] == 3) {
        if ([model.img_type integerValue] == 0) {
            EHNewsNoPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsNoPicTableViewCell];
            
            cell.titleLabel.text = model.title;
            cell.sourceLabel.text = [NSString stringWithFormat:@"出自%@", model.source];
            cell.commentLabel.text = [NSString stringWithFormat:@"评论：%@", model.comment_count];
            cell.timeLabel.text = model.release_time;
            
            if ([model.news_type integerValue] == 1) {
                cell.recommendLabel.hidden = NO;
            } else {
                cell.recommendLabel.hidden = YES;
            }
            
            return cell;
        } else if ([model.img_type integerValue] == 1) {
            EHNewsRightPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsRightPicTableViewCell];
            
            cell.titleLabel.text = model.title;
            [cell.img1View setImageWithURL:[NSURL URLWithString:model.title_img1] placeholderImage:[UIImage imageNamed:@"P-2-Small-img"]];
            
            cell.sourceLabel.text = [NSString stringWithFormat:@"出自%@", model.source];
            cell.commentLabel.text = [NSString stringWithFormat:@"评论：%@", model.comment_count];
            cell.timeLabel.text = model.release_time;
            
            if ([model.news_type integerValue] == 1) {
                cell.recommendLabel.hidden = NO;
            } else {
                cell.recommendLabel.hidden = YES;
            }
            
            return cell;
        } else if ([model.img_type integerValue] == 2) {
            EHNewsBigPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsBigPicTableViewCell];
            
            cell.titleLabel.text = model.title;
            [cell.img1View setImageWithURL:[NSURL URLWithString:model.title_img1] placeholderImage:[UIImage imageNamed:@"P-2-Big-img"]];
            
            cell.sourceLabel.text = [NSString stringWithFormat:@"出自%@", model.source];
            cell.commentLabel.text = [NSString stringWithFormat:@"评论：%@", model.comment_count];
            cell.timeLabel.text = model.release_time;
            
            if ([model.news_type integerValue] == 1) {
                cell.recommendLabel.hidden = NO;
            } else {
                cell.recommendLabel.hidden = YES;
            }
            
            return cell;
        } else if ([model.img_type integerValue] == 3) {
            EHNewsThreePicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsThreePicTableViewCell];
            
            cell.titleLabel.text = model.title;
            
            [cell.img1View setImageWithURL:[NSURL URLWithString:model.title_img1] placeholderImage:[UIImage imageNamed:@"P-2-Small-img"]];
            [cell.img2View setImageWithURL:[NSURL URLWithString:model.title_img2] placeholderImage:[UIImage imageNamed:@"P-2-Small-img"]];
            [cell.img3View setImageWithURL:[NSURL URLWithString:model.title_img3] placeholderImage:[UIImage imageNamed:@"P-2-Small-img"]];
            
            cell.sourceLabel.text = [NSString stringWithFormat:@"出自%@", model.source];
            cell.commentLabel.text = [NSString stringWithFormat:@"评论：%@", model.comment_count];
            cell.timeLabel.text = model.release_time;
            
            if ([model.news_type integerValue] == 1) {
                cell.recommendLabel.hidden = NO;
            } else {
                cell.recommendLabel.hidden = YES;
            }
            
            return cell;
        }
    } else {
        EHNewsPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsPhotoTableViewCell];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.titleLabel.text = model.title;
        [cell.img1View setImageWithURL:[NSURL URLWithString:model.title_img1] placeholderImage:[UIImage imageNamed:@"P-2-Big-img"]];
        
        cell.sourceLabel.text = [NSString stringWithFormat:@"出自%@", model.source];
        cell.commentLabel.text = [NSString stringWithFormat:@"评论：%@", model.comment_count];
        cell.timeLabel.text = model.release_time;
        
        cell.topLabel.text = [NSString stringWithFormat:@"%@", model.top];
        cell.treadLabel.text = [NSString stringWithFormat:@"%@", model.tread];
        cell.commentDownLabel.text = [NSString stringWithFormat:@"%@", model.comment_count];
        
        cell.newsInfoModel = model;
        
        cell.dataSource = self;
        
        return cell;
    }
    
    return nil;
}

- (UIView *)mainView
{
    return self.view;
}

- (EHNewsListModel *)newsInfoModel
{
    return self.photoCellModel;
}

- (UINavigationController *)mainNavigationController
{
    return [SlideNavigationController sharedInstance];
}

static NSInteger cellHeight_No = 85;
static NSInteger cellHeight_Right = 110;
static NSInteger cellHeight_Big = 210;
static NSInteger cellHeight_Three = 140+15;
static NSInteger cellHeight_Photo = 250+219;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    //Integer img_type;//'图片类型\n0=无图；\n1=小图；\n2=大图；\n3=三图；',
    
    CGFloat height = 0;
    
    if ([model.news_type integerValue] == 0 || [model.news_type integerValue] == 1|| [model.news_type integerValue] == 3) {
        if ([model.img_type integerValue] == 0) {
            // no
            height = cellHeight_No;
        } else if ([model.img_type integerValue] == 1) {
            // right
            height = cellHeight_Right;
        } else if ([model.img_type integerValue] == 2) {
            // big
            height = cellHeight_Big;
        } else if ([model.img_type integerValue] == 3) {
            // three
            height = cellHeight_Three;
        }
    } else {
        // photo
        CGFloat rate = 0;
        if (iPhone6) {
            rate = 52;
        } else if (iPhone6Plus) {
            rate = 91;
        }
        height = cellHeight_Photo + rate;
    }
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    if ([model.news_type integerValue] == 0) {
        EHNewsDetailViewController *vc = [[EHNewsDetailViewController alloc] init];
        vc.newsID = model.id;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if  ([model.news_type integerValue] == 1 || [model.news_type integerValue] == 3) {
        // big
        EHWebViewController *vc = [EHWebViewController new];
        
        vc.urlString = model.content_url;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    if ([model.news_type integerValue] == 0 || [model.news_type integerValue] == 1|| [model.news_type integerValue] == 3) {
    } else {
        EHNewsPhotoTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        [cell.img1View mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.titleLabel);
        }];
    }
    
    return YES;
}

@end
