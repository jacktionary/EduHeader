//
//  EHNewsCommentModel.h
//  EduHeader
//
//  Created by Hao King on 15/10/9.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseModel.h"

@interface EHNewsCommentRootModel : HTBaseModel

@property (nonatomic, strong)NSArray *result;

@end

@interface EHNewsCommentModel : HTBaseModel
//"id":191,
@property (nonatomic, strong)NSString *id;
//"uid":3,
@property (nonatomic, strong)NSString *uid;
//"newsid":3,
@property (nonatomic, strong)NSString *newsid;
//"comment":"这个新闻太好了，充分反映了我党的实力，大赞！",
@property (nonatomic, strong)NSString *comment;
//"createdate":1443495450000,
@property (nonatomic, strong)NSString *createdate;
//"nickname":"昵称",
@property (nonatomic, strong)NSString *nickname;
//"photo":"https://www.baidu.com/img/bd_logo1.png"
@property (nonatomic, strong)NSString *photo;

@end
