//
//  EHNewsCommentTableViewCell.h
//  EduHeader
//
//  Created by Hao King on 15/10/22.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHBaseTableViewCell.h"

@interface EHNewsCommentTableViewCell : EHBaseTableViewCell

@property (nonatomic, weak)UILabel *nicknameLabel;
@property (nonatomic, weak)UILabel *timeLabel;
@property (nonatomic, weak)UILabel *commentLabel;
@property (nonatomic, weak)UIImageView *userPhotoView;

@end
