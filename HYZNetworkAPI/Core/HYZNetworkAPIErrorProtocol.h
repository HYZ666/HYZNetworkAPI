//
//  HYZNetworkAPIErrorProtocol.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HYZNetworkAPIErrorProtocol <NSObject>

///  是否是有效的网络请求
/// @param responseObject 返回数据
- (BOOL)isEffectiveSeverRequestWithResponseObject:(id)responseObject;

/// 根据返回数据返回相应的error
/// @param responseObject 返回数据
- (NSError *)errorHandleWithResponseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
