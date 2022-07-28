//
//  HYZNetWorkConst.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYZNetWorkConst : NSObject

FOUNDATION_EXPORT NSString * _Nonnull const HYZRequestCodeErrorDomain;

typedef NS_ENUM(NSInteger, HYZRequestMethod) {
    HYZRequestMethodGET = 0,
    HYZRequestMethodPOST
};

typedef NS_ENUM(NSUInteger, HYZErrorType)
{
    HYZErrorWithAFNetworkError, /// 网络错误
    HYZErrorWithJsonValidateError, ///解析错误
    HYZErrorWithRequestCodeError ///业务错误
};

@end

NS_ASSUME_NONNULL_END
