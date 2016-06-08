//
//  HTBaseService.h
//  HT
//
//  Created by HaoKing on 14-2-11.
//  Copyright (c) 2013年 EduHeader. All rights reserved.
//

#import "HTBaseService.h"
#import "HTStringUtils.h"
#import "HTBaseModel.h"
#import "HTAppUtil.h"
#import "HTDeviceInfo.h"

static NSString *baseURL = @"http://123.57.191.41:8080/FocusAPI";
static NSString *appid = @"focus";
static NSString *appsecrect = @"focus1qazxsw2api";

@interface HTBaseService()

@end

@implementation HTBaseService

- (id)init
{
    self = [self initWithBaseURL:[NSURL URLWithString:baseURL]];
    if (self) {
        // do nothing...
    }
    return self;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self) {
        [self setUpDefaultHeader];
        
        self.timeoutInterval = 10;
        
        self.parameterEncoding = HTFormURLParameterEncoding;
    }
    
    return self;
}

+ (instancetype)clientInstance
{
    return [self clientWithBaseURL:[NSURL URLWithString:baseURL]];
}

- (HTBaseModel *)errorOfJsonStructure
{
    return [[HTBaseModel alloc] initWithDictionary:@{@"info" : @"连接失败，请查看网络连接！",
                                                     @"status" : @"400404"}];
}

#pragma mark -
#pragma mark Private Methods
#pragma mark 拼装，设置Header信息
- (void)setUpDefaultHeader
{
    [self setDefaultHeader:@"appid" value:appid];
}

#pragma mark -

#pragma mark 提供取消请求方法
- (void)cancelService
{
    [self cancelAllHTTPOperationsWithMethod:self.method path:self.urlPath];
}

#pragma mark 重写get请求，当请求失败时，从缓存获得数据，并返回成功Block。
- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *operation, id model))success failure:(void (^)(HTHTTPRequestOperation *operation, NSError *err))failure
{
    // 保存请求方式和请求路径，方便取消操作使用.
    self.method = @"GET";
    self.urlPath = path;
    
    // 修改AFNetworking的逻辑，当网络不可连接时，判断是否存在缓存。如果存在将不执行failureBlock，转发到successBlock中。
    void (^onFailure)(HTHTTPRequestOperation *, id) = [self setupOnFailureBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    
    void (^onSuccess)(HTHTTPRequestOperation *, id) = [self setupOnSuccessBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    
    // 发送get请求
    [self getPath:path parameters:parameters success:onSuccess failure:onFailure];
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(HTHTTPRequestOperation *operation, id model))success failure:(void (^)(HTHTTPRequestOperation *operation, NSError *err))failure
{
    void (^onSuccess)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        success(operation, responseObject);
        
          };
    
    void (^onFailure)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        failure(operation, responseObject);
    };
    
    // 根据传入param，设置header信息中的签名值
    [self calculateSign:parameters];
    [super getPath:path parameters:parameters success:onSuccess failure:onFailure];
    
}

#pragma mark 重写post请求，设置不使用缓存
- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters modelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *operation, id model))success failure:(void (^)(HTHTTPRequestOperation *operation, id model))failure
{
    void (^onSuccess)(HTHTTPRequestOperation *, id) = [self setupOnSuccessBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    void (^onFailure)(HTHTTPRequestOperation *, id) = [self setupOnFailureBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    
    [self postPath:path parameters:parameters success:onSuccess failure:onFailure];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(HTHTTPRequestOperation *operation, id model))success failure:(void (^)(HTHTTPRequestOperation *operation, id model))failure
{
    
    // 保存请求方式和请求路径，方便取消操作使用.
    self.method = @"POST";
    self.urlPath = path;
    
    void (^onSuccess)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        success(operation, responseObject);
    };
    
    void (^onFailure)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        failure(operation, responseObject);
    };
    
    // 根据传入param，设置header信息中的签名值
   [self calculateSign:parameters];
    
    NSMutableURLRequest *request = [self requestWithMethod:@"POST" path:path parameters:parameters];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
	HTHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:onSuccess failure:onFailure];
    [self enqueueHTTPRequestOperation:operation];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
      modelClass:(Class)modelClass
   keyPathInJson:(NSString *)keyPath
constructingBodyWithBlock:(void (^)(id <HTMultipartFormData> formData))block
         success:(void (^)(HTHTTPRequestOperation *operation, id model))success
         failure:(void (^)(HTHTTPRequestOperation *operation, id model))failure
{
    void (^onSuccess)(HTHTTPRequestOperation *, id) = [self setupOnSuccessBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    void (^onFailure)(HTHTTPRequestOperation *, id) = [self setupOnFailureBlockFroModelClass:modelClass keyPathInJson:keyPath success:success failure:failure];
    
    [self POST:path parameters:parameters constructingBodyWithBlock:block success:onSuccess failure:onFailure];
}

- (void)POST:(NSString *)path
  parameters:(NSDictionary *)parameters
constructingBodyWithBlock:(void (^)(id <HTMultipartFormData> formData))block
     success:(void (^)(HTHTTPRequestOperation *operation, id responseObject))success
     failure:(void (^)(HTHTTPRequestOperation *operation, NSError *error))failure
{
    // 保存请求方式和请求路径，方便取消操作使用.
    self.method = @"POST";
    self.urlPath = path;
    
    void (^onSuccess)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        success(operation, responseObject);
    };
    
    void (^onFailure)(HTHTTPRequestOperation *, id) = ^(HTHTTPRequestOperation *operation, id responseObject){
        failure(operation, responseObject);
    };
    
    // 根据传入param，设置header信息中的签名值
    [self calculateSign:parameters];
    
    NSMutableURLRequest *request = [self multipartFormRequestWithMethod:@"POST" path:path parameters:parameters constructingBodyWithBlock:block];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    HTHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:onSuccess failure:onFailure];
    [self enqueueHTTPRequestOperation:operation];

}

#pragma mark - 
#pragma mark Private Methods

- (void (^)(HTHTTPRequestOperation *operation, id responseObject))setupOnSuccessBlockFroModelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *, id))success failure:(void (^)(HTHTTPRequestOperation *, NSError *))failure
{
    return ^(HTHTTPRequestOperation *operation, id responseObject){
        
        NSError *jsonParseError;
        
        // 数据容错处理增加，兼容json请求莫名其妙返回空串的问题
        NSDictionary *jsonDict = nil;
        
        // 返回data非空情况下，才解析为字典
        if (responseObject) {
            jsonDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonParseError];
        }
        
        if (jsonParseError) {
            failure(operation, [self errorOfJsonStructure]);
            return;
        }
        
        id modelObj = [self convertToModel:modelClass fromJSONObject:jsonDict forKeyPath:keyPath];
        
        success(operation, modelObj);
    };
}

- (void (^)(HTHTTPRequestOperation *operation, id responseObject))setupOnFailureBlockFroModelClass:(Class)modelClass keyPathInJson:(NSString *)keyPath success:(void (^)(HTHTTPRequestOperation *, id))success failure:(void (^)(HTHTTPRequestOperation *, NSError *))failure
{
    return ^(HTHTTPRequestOperation *operation, NSError *error){
        
        // 此处为与服务器商定的结果，不适用于所有HTTP请求返回
        // 服务器会将所有业务逻辑的HTTP statusCode修改为400
        // 所以此处判断，如果statusCode为400，则统一处理
        if (operation.response.statusCode == 400) {
            
            if (operation.responseData) {
                NSError *jsonParseError;
                NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableLeaves error:&jsonParseError];
                
                if (jsonParseError) {
                    failure(operation, [self errorOfJsonStructure]);
                    return;
                }
                
                id modelObj = [self convertToModel:modelClass fromJSONObject:jsonDict forKeyPath:keyPath];
                
                // 返回failure Block操作
                failure(operation, modelObj);
            } else {
                failure(operation, [self errorOfJsonStructure]);
            }
        }
        // 其他statusCode为网络错误
        else {
            failure(operation, [self errorOfJsonStructure]);
        }
    };
}
#pragma mark - JSONDictToModel
- (id)convertToModel:(Class)modelClass fromJSONObject:(id)jsonObj forKeyPath:(NSString *)keyPath
{
    if (keyPath && ![keyPath isEqualToString:@""]) {
        id keyPAthData = [jsonObj valueForKeyPath:keyPath];
        if (keyPAthData) {
            
            return [self convertToModel:modelClass fromJSONObject:jsonObj];
        } else {
            return [self errorOfJsonStructure];
        }
    } else {
        return [self convertToModel:modelClass fromJSONObject:jsonObj];
    }
}

- (id)convertToModel:(Class)modelClass fromJSONObject:(id)jsonObj
{
    // 对应keypath为Array类型
    if ([jsonObj isKindOfClass:[NSArray class]]) {
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] initWithCapacity:[(NSArray *)jsonObj count]];
        
        for (NSDictionary *dict in jsonObj) {
            id model = [[modelClass alloc] initWithDictionary:dict];
            
            [dataArray addObject:model];
        }
        
        return dataArray;
        // 对应keypath为Dictionary类型
    } else {
        id model = [[modelClass alloc] initWithDictionary:jsonObj];
        
        return model;
    }
}

#pragma mark - 签名算法

- (void)calculateSign:(NSDictionary *)paramDict
{
    NSString *data = [NSString string];;
    
    if (paramDict) {
        NSMutableArray *sortedStringArray = [NSMutableArray array];
        
        NSArray *dictKeys = [paramDict allKeys];
        
        NSArray *sortedKeysArr = [dictKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString *dictKey in sortedKeysArr) {
            [sortedStringArray addObject:[NSString stringWithFormat:@"%@=%@", dictKey, [paramDict objectForKey:dictKey]]];
        }
        
        data = [sortedStringArray componentsJoinedByString:@"&"];
    }
    
    NSString *signInfoString = [NSString stringWithFormat:@"%@%@%@",
                                data,
                                appid,
                                appsecrect];
    
    NSLog(@"string before md5：%@", signInfoString);
    
    NSString * signMD5String =[[StringUtils getMD5:signInfoString] substringWithRange:NSMakeRange(8, 16)];
    
    NSLog(@"sign：%@", signMD5String);
    
    [self setDefaultHeader:@"sign" value:signMD5String];
}

@end
