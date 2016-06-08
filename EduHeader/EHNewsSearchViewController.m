//
//  EHNewsSearchViewController.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsSearchViewController.h"
#import "EHNewsQueryService.h"

#import "EHWebViewController.h"
#import "EHNewsDetailViewController.h"
#import "SVPullToRefresh.h"

#import "EHNewsBigPicTableViewCell.h"
#import "EHNewsThreePicTableViewCell.h"
#import "EHNewsNoPicTableViewCell.h"
#import "EHNewsRightPicTableViewCell.h"
#import "EHNewsPhotoTableViewCell.h"

#import "EHGlobalSingleton.h"

static NSString *cellReuseIdentifierForEHNewsBigPicTableViewCell = @"EHNewsBigPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsThreePicTableViewCell = @"EHNewsThreePicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsNoPicTableViewCell = @"EHNewsNoPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsRightPicTableViewCell = @"EHNewsRightPicTableViewCellIdentifier";
static NSString *cellReuseIdentifierForEHNewsPhotoTableViewCell = @"EHNewsPhotoTableViewCellIdentifier";

@interface EHNewsSearchViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, EHNewsPhotoTableViewCellDatasource>

@property (nonatomic, weak)UISearchBar *searchBar;
@property (nonatomic, weak)UITableView *tableView;
@property (nonatomic, assign)NSInteger page;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *data2Arr;
@property (nonatomic, strong)UIImageView *loadingImageView;

@property (nonatomic, weak)UIView *noResultView;
@property (nonatomic, weak)UILabel *sorryLabel;
@property (nonatomic, weak)UITableView *noResultTableView;

@end

@implementation EHNewsSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.page = 0;
    
    [self initSubViews];
    
    [self initNoResultView];
}

- (void)initSubViews
{
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    
    [self.view addSubview:searchBar];
    
    searchBar.delegate = self;
    searchBar.showsCancelButton = YES;
    searchBar.barTintColor = UIColorFromRGB(0xebebed);
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:UIColorFromRGB(0x3dc6fb)];
    searchBar.placeholder = @"搜索";
    
    self.searchBar = searchBar;
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(20);
        make.width.equalTo(self.view);
        make.left.equalTo(self.view);
    }];
    
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [self.tableView registerClass:[EHNewsBigPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsBigPicTableViewCell];
    [self.tableView registerClass:[EHNewsNoPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsNoPicTableViewCell];
    [self.tableView registerClass:[EHNewsRightPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsRightPicTableViewCell];
    [self.tableView registerClass:[EHNewsThreePicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsThreePicTableViewCell];
    [self.tableView registerClass:[EHNewsPhotoTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsPhotoTableViewCell];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchBar.mas_bottom);
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

- (void)initNoResultView
{
    UIView *noResultView = [UIView new];
    
    [self.view addSubview:noResultView];
    
    self.noResultView = noResultView;
    
    [self.noResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.bottom.and.left.and.right.equalTo(self.view);
    }];
    
    // 抱歉
    UILabel *sorryLabel = [UILabel new];
    
    [self.noResultView addSubview:sorryLabel];
    
    sorryLabel.textAlignment = NSTextAlignmentCenter;
    
    [sorryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noResultView).with.offset(25);
        make.left.equalTo(self.noResultView);
        make.width.equalTo(self.noResultView);
    }];
    
    self.sorryLabel = sorryLabel;
    
    // grayline
    UIView *grayLine = [UIView new];
    
    grayLine.backgroundColor = UIColorFromRGB(0xcdcdcd);
    grayLine.alpha = 0.5;
    
    [self.noResultView addSubview:grayLine];
    
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sorryLabel.mas_bottom).with.offset(25);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.equalTo(@1);
    }];
    
    // 您可能感兴趣
    UILabel *interestLabel = [UILabel new];
    interestLabel.text = @"您可能感兴趣";
    
    [self.noResultView addSubview:interestLabel];
    
    [interestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(grayLine.mas_bottom).with.offset(12);
        make.left.equalTo(self.view).with.offset(8);
    }];
    
    //
    UITableView *tableView = [[UITableView alloc] init];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [self.noResultView addSubview:tableView];
    
    self.noResultTableView = tableView;
    
    [tableView registerClass:[EHNewsBigPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsBigPicTableViewCell];
    [tableView registerClass:[EHNewsNoPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsNoPicTableViewCell];
    [tableView registerClass:[EHNewsRightPicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsRightPicTableViewCell];
    [tableView registerClass:[EHNewsThreePicTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsThreePicTableViewCell];
    [tableView registerClass:[EHNewsPhotoTableViewCell class] forCellReuseIdentifier:cellReuseIdentifierForEHNewsPhotoTableViewCell];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(interestLabel.mas_bottom);
        make.bottom.and.left.and.right.equalTo(self.view);
    }];
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.noResultView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        self.page += 1;
        
        NSString *lastRequestTimeStamp = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@", vFirstMostNewsIDForTheLastRequest]];
        
        [self requestNewsListWithTitle:self.searchBar.text timeStamp:lastRequestTimeStamp pageNo:self.page];
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    self.page = 0;
    
    [HTToastUtils showLoadingAnimationForView:self.view message:vLoadingMessage];
    [self requestNewsListWithTitle:searchBar.text timeStamp:nil pageNo:self.page];
}

- (void)requestNewsListWithTitle:(NSString *)title timeStamp:(NSString *)timeStamp pageNo:(NSInteger)page
{
    [[EHNewsQueryService clientInstance] queryWithTitle:title city:[EHGlobalSingleton sharedInstance].gpsCity createdate:timeStamp start:[NSString stringWithFormat:@"%ld", (long)self.page * vPageSize] size:@"10" block:^(EHNewsQueryListRootModel *data, NSError *error) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HTToastUtils hideAllLoadingAnimationForView:self.view];
            if (!timeStamp) {
                [self.tableView.pullToRefreshView stopAnimating];
            } else {
                [self.tableView.infiniteScrollingView stopAnimating];
            }
            
            if ([[data status] integerValue] == RequestSuccess) {
                
                if ([self.loadingImageView superview]) {
                    [self.loadingImageView removeFromSuperview];
                }
                
                if ([data.result count] == 0) {
                    if ([self.dataArr count] > 0) {
                        [HTToastUtils showToastViewWithMessage:@"没有更多新闻了." ForView:self.view forTimeInterval:vMessageShowDuration];
                        return;
                    }
                    
                    self.tableView.hidden = YES;
                    self.noResultView.hidden = NO;
                    
                    self.sorryLabel.text = [NSString stringWithFormat:@"抱歉，为搜索到“%@”相关文章", self.searchBar.text];
                    
                    if ([data.result2 count] == 0) {
                        return;
                    }
                    self.data2Arr = [NSMutableArray array];

                    [self.data2Arr addObjectsFromArray:data.result2];
                    
                    [self.noResultTableView reloadData];
                    
                    return;
                } else {
                    self.tableView.hidden = NO;
                    self.noResultView.hidden = YES;
                }
                
                if (!timeStamp) {
                    self.dataArr = [NSMutableArray array];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:
                     [self timeStamp] forKey:[NSString stringWithFormat:@"%@", vFirstMostNewsIDForTheLastRequest]];
                }
                
                [self.dataArr addObjectsFromArray:data.result];
                
                [self.tableView reloadData];
            } else {
                [HTToastUtils showToastViewWithMessage:[data info] ForView:self.view forTimeInterval:vMessageShowDuration];
            }
        });
    }];
}

- (NSString *)timeStamp {
    NSString *result = [NSString stringWithFormat:@"%ld",(long)([[NSDate date] timeIntervalSince1970] * 1000)];
    
    return result;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [self.dataArr removeAllObjects];
    [self.data2Arr removeAllObjects];
    
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.tableView) {
        return [self.dataArr count];
    } else if (tableView == self.noResultTableView) {
        return [self.data2Arr count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArr = nil;
    
    if (tableView == self.tableView) {
        dataArr = self.dataArr;
    } else if (tableView == self.noResultTableView) {
        dataArr = self.data2Arr;
    }
    
    EHNewsListModel *model = [dataArr objectAtIndex:indexPath.row];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *dataArr = nil;
    
    if (tableView == self.tableView) {
        dataArr = self.dataArr;
    } else if (tableView == self.noResultTableView) {
        dataArr = self.data2Arr;
    }
    
    EHNewsListModel *model = [dataArr objectAtIndex:indexPath.row];
    
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
    
    NSArray *dataArr = nil;
    
    if (tableView == self.tableView) {
        dataArr = self.dataArr;
    } else if (tableView == self.noResultTableView) {
        dataArr = self.data2Arr;
    }
    
    EHNewsListModel *model = [dataArr objectAtIndex:indexPath.row];
    
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

@end
