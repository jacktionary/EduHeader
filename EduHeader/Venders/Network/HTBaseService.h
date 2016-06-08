//
//  HTBaseService.h
//  HT
//
//  Created by HaoKing on 14-2-11.
//  Copyright (c) 2013年 EduHeader. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTNetworking.h"
#import "HTBaseModel.h"

#define kNetworkErrorcode @"400404"

@class HTBaseModel;

typedef void (^ServiceCallBackBlock)(__weak id data, NSError *error);

@interface HTBaseService : HTHTTPClient

@property (nonatomic, strong)NSString *method;
@property (nonatomic, strong)NSString *urlPath;

/////////////////////////////////////////////////////
//                                                 //
//                  网络请求                        //
//                                                //
////////////////////////////////////////////////////

/*
 * 取消网络请求
 * @return 无。
 */
- (void)cancelService;

/*
 * 生成service实例
 * @return 生成的service实例。
 */
+ (instancetype)clientInstance;

/*
 * 发送get网络请求。
 * 支持根据keypath自动生成model实例，支持生成array model实例。
 * 在没有网络和服务器无法连接时，自动使用缓存数据。
 * @param path 请求path
 * @param parameters 请求参数
 * @param modelClass 返回model的class类型
 * @param keyPath 所取数据在json返回对象中的keyPath
 * eg
    {
        "code":
        0,
        "data":[{
            "pages":"0"
        }],
        "msg":
        "success"
    }
 * 上面的json，如果keyPath为@"data.pages"，则会取到pages的结点
 *
 * @param success 成功的回调Block
 * @param failure 失败的回调Block
 * @return 生成的service实例。*/
- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *op, id model))success failure:(void (^)(HTHTTPRequestOperation *op, NSError *e))failure;
/*
 * 发送post网络请求。
 * 支持根据keypath自动生成model实例，支持生成array model实例。
 * post请求，设定不支持缓存。
 * @param path 请求path
 * @param parameters 请求参数
 * @param modelClass 返回model的class类型
 * @param keyPath 所取数据在json返回对象中的keyPath
 * eg
    {
        "code":0,
        "data":[{
            "pages":"0"
        }],
        "msg":"success"
    }
 * 上面的json，如果keyPath为@"data.pages"，则会取到pages的结点
 *
 * @param success 成功的回调Block
 * @param failure 失败的回调Block
 * @return 生成的service实例。
 */
- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(HTHTTPRequestOperation *op, id model))success failure:(void (^)(HTHTTPRequestOperation *op, id model))failure;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *operation, id model))success failure:(void (^)(HTHTTPRequestOperation *operation, id model))failure;

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      modelClass:(Class)modelClass
   keyPathInJson:(NSString *)keyPath
constructingBodyWithBlock:(void (^)(id <HTMultipartFormData> formData))block
         success:(void (^)(HTHTTPRequestOperation *operation, id model))success
         failure:(void (^)(HTHTTPRequestOperation *operation, id model))failure;

- (void)POST:(NSString *)path
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <HTMultipartFormData> formData))block
     success:(void (^)(HTHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(HTHTTPRequestOperation *operation, NSError *error))failure;

- (NSError *)errorOfJsonStructure;

@end
