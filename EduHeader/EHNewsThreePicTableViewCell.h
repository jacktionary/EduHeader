//
//  EHNewsThreePicTableViewCell.h
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHBaseTableViewCell.h"

@interface EHNewsThreePicTableViewCell : EHBaseTableViewCell

@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, weak)UILabel *sourceLabel;
@property (nonatomic, weak)UILabel *commentLabel;
@property (nonatomic, weak)UILabel *recommendLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UIImageView *img1View;
@property (nonatomic, weak)UIImageView *img2View;
@property (nonatomic, weak)UIImageView *img3View;

@end
