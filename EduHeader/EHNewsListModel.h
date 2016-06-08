//
//  EHNewsListModel.h
//  EduHeader
//
//  Created by Hao King on 15/9/12.
//  Copyright (c) 2015年 EduHeader. All rights reserved.
//

#import "HTBaseModel.h"

@interface EHNewsListRootModel : HTBaseModel

@property (nonatomic, strong)NSArray *result;
@property (nonatomic, strong)NSString *result2;

@end

@interface EHNewsListResult2Model : HTBaseModel



@end

@interface EHNewsListModel : HTBaseModel
//Integer id;//'新闻ID',
@property (nonatomic, strong)NSString *id;
//Integer typeid;//'分类ID',
@property (nonatomic, strong)NSString *typeid;
//Integer news_type;//'新闻类型\n0=新闻；\n1=广告；\n2=图片；\n3=外链；',
@property (nonatomic, strong)NSString *news_type;
//Integer img_type;//'图片类型\n0=无图；\n1=小图；\n2=大图；\n3=三图；',
@property (nonatomic, strong)NSString *img_type;
//String title;//'新闻标题',
@property (nonatomic, strong)NSString *title;
//String titile_img1;//'标题图片1',
@property (nonatomic, strong)NSString *title_img1;
//String titile_img2;//'标题图片2',
@property (nonatomic, strong)NSString *title_img2;
//String titile_img3;//'标题图片3',
@property (nonatomic, strong)NSString *title_img3;
//String content_html;//'新闻内容（HTML）',
@property (nonatomic, strong)NSString *content_html;
//String content_url;//'新闻内容（URL）',
@property (nonatomic, strong)NSString *content_url;

@property (nonatomic, strong)NSString *sns_url;
//Integer top;//'顶',
@property (nonatomic, strong)NSNumber *top;
//Integer tread;//'踩',
@property (nonatomic, strong)NSNumber *tread;
//String source;//'新闻来源',
@property (nonatomic, strong)NSString *source;
//String comment_count;//'评论数',
@property (nonatomic, strong)NSString *comment_count;
//String release_time;//'新闻时间',
@property (nonatomic, strong)NSString *release_time;
//String source_url;//'来源URL',
@property (nonatomic, strong)NSString *source_url;
//String source_url;//'是否顶过',
@property (nonatomic, strong)NSString *is_top;
//String source_url;//'是否踩过',
@property (nonatomic, strong)NSString *is_tread;
//String source_url;//'是否收藏过',
@property (nonatomic, strong)NSString *is_enshrine;
//Date createdate;//'创建时间',
@property (nonatomic, strong)NSString *createdate;

@end
