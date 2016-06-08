//
//  EHNewsBigPicTableViewCell.m
//  EduHeader
//
//  Created by HaoKing on 9/7/15.
//  Copyright (c) 2015 EduHeader. All rights reserved.
//

#import "EHNewsBigPicTableViewCell.h"

@implementation EHNewsBigPicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // title
        UILabel *titleLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:titleLabel];
        
        self.titleLabel = titleLabel;
        
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize_title];
        self.titleLabel.textColor = UIColorFromRGB(0x343434);
        self.titleLabel.numberOfLines = numberOfLines;
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(15);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(self.contentView).with.offset(-30);
        }];
        
        // img1View
        UIImageView *img1View = [[UIImageView alloc] init];
        
        [self.contentView addSubview:img1View];
        
        self.img1View = img1View;
        
        [self.img1View mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).with.offset(60);
            make.left.equalTo(self.contentView).with.offset(15);
            make.width.equalTo(@290);
            make.height.equalTo(@119);
        }];
        
        // source
        UILabel *sourceLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:sourceLabel];
        
        self.sourceLabel = sourceLabel;
        
        self.sourceLabel.font = [UIFont systemFontOfSize:10];
        self.sourceLabel.textColor = [UIColor lightGrayColor];
        self.sourceLabel.numberOfLines = 1;
        
        [self.sourceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.img1View.mas_bottom).with.offset(5);
            make.left.equalTo(self.contentView).with.offset(15);
        }];
        
        // commentLabel
        UILabel *commentLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:commentLabel];
        
        self.commentLabel = commentLabel;
        
        self.commentLabel.font = [UIFont systemFontOfSize:10];
        self.commentLabel.textColor = [UIColor lightGrayColor];
        self.commentLabel.numberOfLines = 1;
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.img1View.mas_bottom).with.offset(5);
            make.left.equalTo(self.sourceLabel.mas_right).with.offset(15);
        }];
        
        // timeLabel
        UILabel *timeLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        self.timeLabel.font = [UIFont systemFontOfSize:10];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.numberOfLines = 1;
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.img1View.mas_bottom).with.offset(5);
            make.right.equalTo(self.contentView).with.offset(-15);
        }];
        
        // 推广Label
        UILabel *recommendLabel = [[UILabel alloc] init];
        
        [self.contentView addSubview:recommendLabel];
        
        self.recommendLabel = recommendLabel;
        
        self.recommendLabel.text = @"推广";
        self.recommendLabel.font = [UIFont systemFontOfSize:10];
        self.recommendLabel.textColor = [UIColor whiteColor];
        self.recommendLabel.backgroundColor = UIColorFromRGB(0x3dc6fb);
        self.recommendLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.recommendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.right.equalTo(timeLabel.mas_left).with.offset(-10);
            make.width.equalTo(@30);
        }];
        
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
@end
