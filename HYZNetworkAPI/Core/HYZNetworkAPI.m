//
//  HYZRequestManager.m
//  HYZRequestManager
//
//  Created by hyz on 2022/6/16.
//

#import "HYZNetworkAPI.h"
@interface HYZNetworkAPI ()
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *requestRecord;
@property (nonatomic, strong) NSLock *requestRecordLock;
@end

@implementation HYZNetworkAPI

+ (instancetype)shareAPI {
    static dispatch_once_t onceToken;
    static HYZNetworkAPI *share;
    dispatch_once(&onceToken, ^{
        if (share == nil) {
            share = [[HYZNetworkAPI alloc]init];
        }
    });
    return share;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [AFHTTPSessionManager manager];
        self.requestRecord = [NSMutableDictionary dictionary];
        self.requestRecordLock = [[NSLock alloc]init];
    }
    return self;
}

+ (void)initWithErrorHandle:(id <HYZNetworkAPIErrorProtocol>)ErrorHandle config:(id <HYZNetworkAPIConfigProtocol>)config {
    HYZNetworkAPI *networkAPI = [HYZNetworkAPI shareAPI];
    networkAPI.errorDelegate = ErrorHandle;
    networkAPI.configDelegate = config;
}

+ (HYZRequest *)requestWithUrl:(NSString *)url param:(NSDictionary *)param method:(HYZRequestMethod)method success:(HYZRequestCompletionBlock)success failure:(HYZRequestCompletionBlock)failure {
    
    HYZNetworkAPI *networkAPI = [HYZNetworkAPI shareAPI];
    
    //设置RequestSerializer
    [networkAPI setRequestSerializerWithConfig:nil];
    //设置ResponseSerializer
    [networkAPI setResponseSerializerWithConfig:nil];
    
    //构建相应的request
    HYZRequest *request = [[HYZRequest alloc]init];
    request.successCompletionBlock = success;
    request.failureCompletionBlock = failure;
    
    //获取完整的请求URL
    url = [networkAPI getRequestIntactUrlWithConfig:nil originalUrl:url];
    
    //赋值给request留打印log用的
    request.httpRequestUrl = url;
    //赋值给request留打印log用的
    request.httpRequestHeaders = networkAPI.sessionManager.requestSerializer.HTTPRequestHeaders;
    
    NSURLSessionTask *task;
    if (method == HYZRequestMethodGET) {
        task = [networkAPI.sessionManager GET:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [networkAPI handlerSuccessWithTask:task responseObject:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [networkAPI handlerFailureWithTask:task error:error];
        }];
    } else {
        task = [networkAPI.sessionManager POST:url parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [networkAPI handlerSuccessWithTask:task responseObject:responseObject];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [networkAPI handlerFailureWithTask:task error:error];
        }];
    }
    
    //设置requestTask并加入到记录中
    request.requestTask = task;
    [networkAPI.requestRecordLock lock];
    [networkAPI.requestRecord setValue:request forKey:@(task.taskIdentifier).stringValue];
    //    NSLog(@"requestRecord setValue%@",[NSThread currentThread]);
    [networkAPI.requestRecordLock unlock];
    return request;
    
}

- (void)setRequestSerializerWithConfig:(id<HYZNetworkAPIConfigProtocol>)config {
    
    id<HYZNetworkAPIConfigProtocol>finalConfig;
    
    if (config == nil) {
        finalConfig = self.configDelegate;
    } else {
        finalConfig = config;
    }
    
    AFJSONRequestSerializer *jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    
    if (finalConfig && [finalConfig respondsToSelector:@selector(timeInterval)]) {
        jsonRequestSerializer.timeoutInterval = [finalConfig timeoutInterval];
    }
    
    //设置headers
    if (finalConfig && [finalConfig respondsToSelector:@selector(requestHeaders)]) {
        
        NSDictionary *headers = [finalConfig requestHeaders];
        
        for (NSString *headerField in headers.keyEnumerator) {
            [jsonRequestSerializer setValue:headers[headerField] forHTTPHeaderField:headerField];
        }
        
    }
    
    self.sessionManager.requestSerializer = jsonRequestSerializer;
}

- (void)setResponseSerializerWithConfig:(id<HYZNetworkAPIConfigProtocol>)config {
    
    id<HYZNetworkAPIConfigProtocol>finalConfig;
    
    if (config == nil) {
        finalConfig = self.configDelegate;
    } else {
        finalConfig = config;
    }
    
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
}

- (NSString *)getRequestIntactUrlWithConfig:(id<HYZNetworkAPIConfigProtocol>)config originalUrl:(NSString *)originalUrl {
    NSMutableString *url = [NSMutableString string];
    
    id<HYZNetworkAPIConfigProtocol>finalConfig;
    
    if (config == nil) {
        finalConfig = self.configDelegate;
    } else {
        finalConfig = config;
    }
    
    if (finalConfig && [finalConfig respondsToSelector:@selector(baseUrl)]) {
        NSString *baseUrl = [finalConfig baseUrl];
        if (baseUrl != nil && baseUrl.length > 0) {
            [url appendString:baseUrl];
        }
    }
    
    [url appendString:originalUrl];
    
    return url;
}

- (void)handlerSuccessWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject {
    
    [self.requestRecordLock lock];
    
    HYZRequest *request = [self.requestRecord valueForKey:@(task.taskIdentifier).stringValue];
    
    request.reseponseData = responseObject;
    
    [self.requestRecordLock unlock];
    
    
    //    NSLog(@"requestRecord valueForKey%@",[NSThread currentThread]);
    
    if (self.errorDelegate) {
        
        if ([self.errorDelegate respondsToSelector:@selector(isEffectiveSeverRequestWithResponseObject:)]) {
            
            //判断是否为有效的网络请求
            BOOL isEffectiveRequest = [self.errorDelegate isEffectiveSeverRequestWithResponseObject:responseObject];
            
            //业务认为是无效网络请求走错误处理
            if (!isEffectiveRequest) {
                
                NSError *error;
                
                if ([self.errorDelegate respondsToSelector:@selector(errorHandleWithResponseObject:)]) {
                    //如果不是有效的网络请求，进行相应的处理，封装Error
                    error = [self.errorDelegate errorHandleWithResponseObject:responseObject];
                }
                
                //业务处理也属于接口调用失败所以调用最终的错误处理方法。
                [self handlerFailureWithTask:task error:error];
                
                return;
            }
        }
        
    }
    
    //请求成功后处理
    request.successCompletionBlock(request);
    
    if (self.debugLog) {
        
        NSString *headerJsonString;
        
        NSString *responseDataJsonString;
        
        if (request.httpRequestHeaders != nil) {
            NSData *headerData = [NSJSONSerialization dataWithJSONObject:request.httpRequestHeaders options:NSJSONWritingPrettyPrinted error:nil];
            
            headerJsonString = [[NSString alloc]initWithData:headerData encoding:NSUTF8StringEncoding];
        }
        
        if (request.reseponseData != nil) {
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:request.reseponseData options:NSJSONWritingPrettyPrinted error:nil];
            
            responseDataJsonString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        }
        
        NSLog(@"\n[HYZNetworkAPI url]:%@\n[HYZNetworkAPI headers]:%@\n[HYZNetworkAPI response]:%@",request.httpRequestUrl,headerJsonString,responseDataJsonString);
        
    }
    
    [self.requestRecordLock lock];
    
    //        NSLog(@"requestRecord removeObjectForKey%@",[NSThread currentThread]);
    
    [self.requestRecord removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    [self.requestRecordLock unlock];
    
    
    
    
}

- (void)handlerFailureWithTask:(NSURLSessionDataTask *)task error:(NSError *)error {
    
    [self.requestRecordLock lock];
    
    HYZRequest *request = [self.requestRecord valueForKey:@(task.taskIdentifier).stringValue];
    
    [self.requestRecordLock unlock];
    
    
    //    NSLog(@"requestRecord valueForKey%@",[NSThread currentThread]);
    
    request.error = error;
    
    request.failureCompletionBlock(request);
    
    if (self.debugLog) {
        
        NSString *headerJsonString;
        
        NSString *responseDataJsonString;
        
        if (request.httpRequestHeaders != nil) {
            NSData *headerData = [NSJSONSerialization dataWithJSONObject:request.httpRequestHeaders options:NSJSONWritingPrettyPrinted error:nil];
            
            headerJsonString = [[NSString alloc]initWithData:headerData encoding:NSUTF8StringEncoding];
        }
        
        if (request.reseponseData != nil) {
            NSData *responseData = [NSJSONSerialization dataWithJSONObject:request.reseponseData options:NSJSONWritingPrettyPrinted error:nil];
            
            responseDataJsonString = [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding];
        }
        
        NSLog(@"\n[HYZNetworkAPI url]:%@\n[HYZNetworkAPI headers]:%@\n[HYZNetworkAPI response]:%@,\n[HYZNetworkAPI error]:%@",request.httpRequestUrl,headerJsonString,responseDataJsonString,request.error);
    }
    
    //    NSLog(@"requestRecord removeObjectForKey%@",[NSThread currentThread]);
    
    [self.requestRecordLock lock];
    
    [self.requestRecord removeObjectForKey:@(task.taskIdentifier).stringValue];
    
    [self.requestRecordLock unlock];
    
}

+ (void)cancelRequest:(HYZRequest *)request {
    
    [request.requestTask cancel];
    
}

@end
