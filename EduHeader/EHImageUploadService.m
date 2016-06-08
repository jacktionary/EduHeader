//
//  EHImageUploadService.m
//  EduHeader
//
//  Created by HaoKing on 15/10/15.
//  Copyright © 2015年 EduHeader. All rights reserved.
//

#import "EHImageUploadService.h"

@implementation EHImageUploadService

- (void)uploadImageWithFilePath:(NSString *)filePath fileName:(NSString *)fileName block:(ServiceCallBackBlock)block
{
    [self POST:@"image/upload"
    parameters:@{}
constructingBodyWithBlock:^(id<HTMultipartFormData> formData) {
    /**
     *  appendPartWithFileURL   //  指定上传的文件
     *  name                    //  指定在服务器中获取对应文件或文本时的key
     *  fileName                //  指定上传文件的原始文件名
     *  mimeType                //  指定商家文件的MIME类型
     */
    NSError *error;
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"image" fileName:fileName mimeType:[[fileName pathExtension] isEqualToString:@"png"] ? @"image/png" : @"image/jpg" error:&error];
}
       success:^(HTHTTPRequestOperation *operation, id responseObject) {
           block([[EHImageUploadModel alloc] initWithDictionary:[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil]], operation.error);
       }
       failure:^(HTHTTPRequestOperation *operation, NSError *error) {
           block([self errorOfJsonStructure], error);
       }];
}

@end
