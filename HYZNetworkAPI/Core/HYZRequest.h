//
//  HYZRequest.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import "HYZNetWorkConst.h"
NS_ASSUME_NONNULL_BEGIN
@class HYZRequest;

typedef void(^HYZRequestCompletionBlock)(__kindof HYZRequest *request);

@interface HYZRequest : NSObject

@property (nonatomic, copy, nullable) HYZRequestCompletionBlock successCompletionBlock;

@property (nonatomic, copy, nullable) HYZRequestCompletionBlock failureCompletionBlock;

@property (nonatomic, copy) NSURLSessionTask *requestTask;

@property (nonatomic, copy) NSError *error;

@property (nonatomic ) id reseponseData;

@property (nonatomic, copy) NSString *httpRequestUrl;

@property (nonatomic, copy) NSDictionary *httpRequestHeaders;


@end

NS_ASSUME_NONNULL_END
