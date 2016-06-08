//
//  EHNewsCommentTableViewCell.m
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHNewsCommentTableViewCell.h"

@implementation EHNewsCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // photo
        UIImageView *photoImg = [UIImageView new];
        
        [self.contentView addSubview:photoImg];
        
        self.userPhotoView = photoImg;
        self.userPhotoView.layer.cornerRadius = 20;
        
        [self.userPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).with.offset(10);
            make.top.equalTo(self.contentView).with.offset(15);
            make.width.and.height.equalTo(@40);
        }];
        
        self.userPhotoView.layer.cornerRadius = 20;
        self.userPhotoView.clipsToBounds = YES;
        
        // nickname
        UILabel *nicknameLabel = [UILabel new];
        
        nicknameLabel.textColor = UIColorFromRGB(0xa2a1a1);
        nicknameLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:nicknameLabel];
        
        self.nicknameLabel = nicknameLabel;
        
        [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userPhotoView.mas_right).with.offset(6);
            make.top.equalTo(self.userPhotoView);
        }];
        
        // time
        UILabel *timeLabel = [UILabel new];
        
        timeLabel.textColor = UIColorFromRGB(0xa2a1a1);
        timeLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).with.offset(-10);
            make.top.equalTo(nicknameLabel);
        }];
        
        // comment
        UILabel *commentLabel = [UILabel new];
        
        commentLabel.textColor = [UIColor blackColor];
        commentLabel.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:commentLabel];
        
        self.commentLabel = commentLabel;
        
        [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userPhotoView.mas_right).with.offset(6);
            make.bottom.equalTo(self.userPhotoView);
        }];
    }
    
    return self;
}

@end
