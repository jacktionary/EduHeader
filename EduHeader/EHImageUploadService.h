//
//  EHImageUploadService.h
//  EduHeader
//
//  Created by HaoKing on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "EHImageUploadModel.h"

@interface EHImageUploadService : HTBaseService

- (void)uploadImageWithFilePath:(NSString *)filePath fileName:(NSString *)fileName block:(ServiceCallBackBlock)block;

@end
