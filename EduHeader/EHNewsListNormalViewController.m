//
//  EHNewsListNormalViewController.m
//  EduHeader
//
//  Created by Hao King on 15/9/10.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "EHNewsListNormalViewController.h"

#import "EHWebViewController.h"
#import "EHNewsDetailViewController.h"
#import "SVPullToRefresh.h"
#import "EHNewsListService.h"

#import "EHNewsBigPicTableViewCell.h"
#import "EHNewsThreePicTableViewCell.h"
#import "EHNewsNoPicTableViewCell.h"
#import "EHNewsRightPicTableViewCell.h"
#import "EHNewsPhotoTableViewCell.h"
#import "EHNewsSearchViewController.h"
#import "EHGlobalSingleton.h"
#import "EHNewsRefreshPopView.h"

static NSString *cellReuseIdentifierForEHNewsBigPicTableViewCell = @"EHNewsBigPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsThreePicTableViewCell = @"EHNewsThreePicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsNoPicTableViewCell = @"EHNewsNoPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsRightPicTableViewCell = @"EHNewsRightPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsPhotoTableViewCell = @"EHNewsPhotoTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsSearchBarTableViewCell = @"EHNewsSearchBarTableViewCellIdentifier";

@interface EHNewsListNormalViewController()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, EHNewsPhotoTableViewCellDatasource>

@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)UIImageView *loadingImageView;

@property (nonatomic, weak)EHNewsListModel *photoCellModel;

@end

@implementation EHNewsListNormalViewController

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
        make.edges.equalTo(self.view);
    }];
    
    [self.tableView addPullToRefreshWithActionHandler:^{
        self.page = 0;
        
        NSString *one_newsid = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@%@", vFirstMostNewsIDForTheLastRequest, self.menuID]];
        
        NSString *action = vPullRequestAction_Refresh;
        
        if (!one_newsid) {
            action = vPullRequestAction_FirstTimeOpen;
        }
        
        [self requestNewsListForMenuID:self.menuID one_newsid:one_newsid action:action pageNo:self.page];
    }];
    
    [self.tableView registerClass:[EHNewsBigPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsBigPicTableViewCell];
    [self.tableView registerClass:[EHNewsNoPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsNoPicTableViewCell];
    [self.tableView registerClass:[EHNewsRightPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsRightPicTableViewCell];
    [self.tableView registerClass:[EHNewsThreePicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsThreePicTableViewCell];
    [self.tableView registerClass:[EHNewsPhotoTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsPhotoTableViewCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsSearchBarTableViewCell];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIImageView *loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"P-4-ico-loading"]];
    
    [self.view addSubview:loadingImageView];
    self.loadingImageView = loadingImageView;
    
    [self.loadingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
        make.centerY.equalTo(self.tableView).with.offset(-40);
    }];
}

- (NSString *)timeStamp {
    NSString *result = [NSString stringWithFormat:@"%d",(int)([[NSDate date] timeIntervalSince1970] * 1000)];
    
    return result;
}

- (void)requestNewsListForMenuID:(NSString *)menuID one_newsid:(NSString *)one_newsid action:(NSString *)action pageNo:(NSInteger)pageNo
{
    [[EHNewsListService clientInstance]
     requestNewsListWithTypeID:menuID
     UID:[[[EHGlobalSingleton sharedInstance] userInfo] uid]
     one_newsid:one_newsid
     action:action
     start:[NSString stringWithFormat:@"%ld", pageNo * vPageSize]
     size:[NSString stringWithFormat:@"%ld", (long)vPageSize]
     block:^(EHNewsListRootModel *data, NSError *error) {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [HTToastUtils hideAllLoadingAnimationForView:self.view];
             if ([action isEqualToString:vPullRequestAction_Refresh] || [action isEqualToString:vPullRequestAction_FirstTimeOpen]) {
                 [self.tableView.pullToRefreshView stopAnimating];
             } else {
                 [self.tableView.infiniteScrollingView stopAnimating];
             }
             
             if ([[data status] integerValue] == RequestSuccess) {
                 
                 if ([self.loadingImageView superview]) {
                     [self.loadingImageView removeFromSuperview];
                 }
                 
                 if ([data.result count] == 0) {
                     [HTToastUtils showToastViewWithMessage:@"没有更多新闻了." ForView:self.view forTimeInterval:vMessageShowDuration];
                     return;
                 }
                 
                 if ([action isEqualToString:vPullRequestAction_Refresh] || [action isEqualToString:vPullRequestAction_FirstTimeOpen]) {
                     self.dataArr = [NSMutableArray array];
                     
                     [[NSUserDefaults standardUserDefaults] setObject:
                      [data.result[0] id] forKey:[NSString stringWithFormat:@"%@%@", vFirstMostNewsIDForTheLastRequest, self.menuID]];
                     
                     // 提示view+animation
                     EHNewsRefreshPopView *alertView = [EHNewsRefreshPopView sharedInstance];
                     
                     [self.view addSubview:alertView];
                     
                     [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                         make.top.equalTo(self.view).with.offset(0);
                         make.width.equalTo(self.view);
                         make.left.equalTo(self.view);
                         make.height.equalTo(@40);
                     }];
                     
                     alertView.messageLabel.text = [NSString stringWithFormat:@"今日教育更新了 %@ 篇文章", data.result2];
                     
                     [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                         alertView.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         if (finished) {
                             [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                                 alertView.alpha = 0.0;
                             } completion:^(BOOL finished) {
                                 [alertView removeFromSuperview];
                             }];
                         }
                     }];
                 }
                 
                 [self.dataArr addObjectsFromArray:data.result];
                 
                 [self.tableView reloadData];
                 
                 if (self.type == EHNewsListType_SearchBar) {
                     if ([action isEqualToString:vPullRequestAction_Refresh] || [action isEqualToString:vPullRequestAction_FirstTimeOpen]) {
                         [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
                         
                         UIView *alertView = [[UIView alloc] init];
                         alertView.backgroundColor = UIColorFromRGB(0xfba042);
                         
                         [self.view addSubview:alertView];
                         
                         [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.top.equalTo(self.view).with.offset(0);
                             make.width.equalTo(self.view);
                             make.left.equalTo(self.view);
                             make.height.equalTo(@40);
                         }];
                         
                         alertView.alpha = 0.0;
                         
                         UILabel *alertMessage = [[UILabel alloc] init];
                         
                         alertMessage.textColor = [UIColor whiteColor];
                         alertMessage.text = [NSString stringWithFormat:@"今日教育更新了 %@ 篇文章", data.result2];
                         alertMessage.font = [UIFont systemFontOfSize:16];
                         
                         [alertView addSubview:alertMessage];
                         
                         [alertMessage mas_makeConstraints:^(MASConstraintMaker *make) {
                             make.center.equalTo(alertView);
                         }];
                         
                         [UIView animateWithDuration:0.5 delay:0.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                             alertView.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             if (finished) {
                                 [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionLayoutSubviews animations:^{
                                     alertView.alpha = 0.0;
                                 } completion:^(BOOL finished) {
                                     [alertView removeFromSuperview];
                                 }];
                             }
                         }];
                     }
                 }
                 
             } else {
                 [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
             }
         });
     }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        self.page += 1;
        [self requestNewsListForMenuID:self.menuID one_newsid:nil action:vPullRequestAction_LoadMore pageNo:self.page];
    }];
}

- (void)viewDidCurrentView
{
    [self.tableView triggerPullToRefresh];
}

#pragma TableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.type == EHNewsListType_SearchBar) {
        return 2;
    } else {
        return 1;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    EHNewsSearchViewController *vc = [EHNewsSearchViewController new];
    
    [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
    
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.type == EHNewsListType_SearchBar) {
        if (section == 0) {
            return 1;
        } else {
            return [self.dataArr count];
        }
    }
    
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == EHNewsListType_SearchBar) {
        if (indexPath.section == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifierForEHNewsSearchBarTableViewCell];
            
            [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            UISearchBar *searchBar = [[UISearchBar alloc] init];
            
            searchBar.delegate = self;
            searchBar.barTintColor = UIColorFromRGB(0xebebed);
            searchBar.placeholder = @"搜索";
            
            [cell.contentView addSubview:searchBar];
            [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(cell.contentView);
            }];
            
            return cell;
        }
    }
    
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

- (UINavigationController *)mainNavigationController
{
    return [SlideNavigationController sharedInstance];
}

static NSInteger cellHeight_No = 85;
static NSInteger cellHeight_Right = 110;
static NSInteger cellHeight_Big = 210;
static NSInteger cellHeight_Three = 140+15;
static NSInteger cellHeight_Photo = 250+219;
static NSInteger cellHeight_SearchBar = 40;

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EHNewsListModel *model = [self.dataArr objectAtIndex:indexPath.row];
    
    //Integer img_type;//'图片类型\n0=无图；\n1=小图；\n2=大图；\n3=三图；',
    
    CGFloat height = 0;
    if (self.type == EHNewsListType_SearchBar && indexPath.section == 0) {
        height = cellHeight_SearchBar;
    } else if ([model.news_type integerValue] == 0 || [model.news_type integerValue] == 1 || [model.news_type integerValue] == 3) {
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
            CGFloat rate = 0;
            
            if (iPhone6) {
                rate = 18;
            } else if (iPhone6Plus) {
                rate = 24;
            }
            
            height = cellHeight_Three + rate;
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
        
        [self.listViewController pushNewsDetail:vc];
    } else if  ([model.news_type integerValue] == 1 || [model.news_type integerValue] == 3) {
        // big
        EHWebViewController *vc = [EHWebViewController new];
        
        vc.urlString = model.content_html;
        
        [[SlideNavigationController sharedInstance] pushViewController:vc animated:YES];
    }
}

@end
