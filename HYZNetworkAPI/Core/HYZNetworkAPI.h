//
//  HYZRequestManager.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "HYZRequest.h"
#import "HYZNetworkAPIErrorProtocol.h"
#import "HYZNetworkAPIConfigProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface HYZNetworkAPI : NSObject
@property (nonatomic,strong) id <HYZNetworkAPIErrorProtocol>errorDelegate;
@property (nonatomic,strong) id <HYZNetworkAPIConfigProtocol>configDelegate;
@property (nonatomic,assign) BOOL debugLog;

/// 初始化并绑定错误处理和基本配置信息
/// @param ErrorHandle 错误处理遵循协议<HYZNetworkAPIErrorProtocol>
/// @param config 基本信息配置遵循协议<HYZNetworkAPIConfigProtocol>
+ (void)initWithErrorHandle:(id <HYZNetworkAPIErrorProtocol>)ErrorHandle config:(id <HYZNetworkAPIConfigProtocol>)config;

/// 获取单例对象
+ (instancetype)shareAPI;

/// 使用初始化的配置进行网络请求
/// @param url url路径
/// @param param 参数
/// @param method 方法
/// @param success 成功回调
/// @param failure 错误回调
+ (HYZRequest *)requestWithUrl:(NSString *)url param:(NSDictionary *__nullable)param method:(HYZRequestMethod)method success:(HYZRequestCompletionBlock)success failure:(HYZRequestCompletionBlock)failure;

/// 取消请求
/// @param request 请求request
+ (void)cancelRequest:(HYZRequest *)request;

@end

NS_ASSUME_NONNULL_END
