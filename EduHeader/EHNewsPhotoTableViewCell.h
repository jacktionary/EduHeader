//
//  EHNewsPhotoTableViewCell.h
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHBaseTableViewCell.h"
#import "EHNewsInfoModel.h"
#import "EHNewsListModel.h"

@protocol EHNewsPhotoTableViewCellDatasource <NSObject>

- (UIView *)mainView;
- (UINavigationController *)mainNavigationController;

@end

@interface EHNewsPhotoTableViewCell : EHBaseTableViewCell

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *sourceLabel;
@property (nonatomic, weak)UILabel *commentLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UIImageView *img1View;

@property (nonatomic, weak)UILabel *topLabel;
@property (nonatomic, weak)UILabel *treadLabel;
@property (nonatomic, weak)UILabel *commentDownLabel;

@property (nonatomic, weak)EHNewsListModel *newsInfoModel;

@property (nonatomic, weak)id<EHNewsPhotoTableViewCellDatasource> dataSource;

@end
