//
//  HYZNetworkAPIConfigProtocol.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import <Foundation/Foundation.h>
#import "AFSecurityPolicy.h"
NS_ASSUME_NONNULL_BEGIN

@protocol HYZNetworkAPIConfigProtocol <NSObject>
@optional
/// 设置URL共有部分
- (NSString *)baseUrl;
/// 设置共有header
- (NSDictionary *)requestHeaders;
/// 设置超时时间
- (NSTimeInterval)timeoutInterval;
/// 设置安全策略
- (AFSecurityPolicy *)securityPolicy;

@end

NS_ASSUME_NONNULL_END
