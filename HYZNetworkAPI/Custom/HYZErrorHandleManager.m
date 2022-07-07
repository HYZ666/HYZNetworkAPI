//
//  HYZErrorHandleManager.m
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import "HYZErrorHandleManager.h"
#import "HYZNetworkAPI.h"
#import "HYZResponse.h"
#import <MJExtension/MJExtension.h>

@implementation HYZErrorHandleManager

- (BOOL)isEffectiveSeverRequestWithResponseObject:(id)responseObject {
    
    HYZResponse *response = [HYZResponse mj_objectWithKeyValues:responseObject];
    if ([response.code isEqualToString:@"OK"] || [response.code isEqualToString:@"0"]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)filterErrorWithResponseObject:(id)responseObject {
    return NO;
}

- (NSError *)errorHandleWithResponseObject:(id)responseObject {
    
    HYZResponse *response = [HYZResponse mj_objectWithKeyValues:responseObject];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setValue:response.message forKey:NSLocalizedDescriptionKey];
    [userInfo setValue:response.code forKey:NSLocalizedFailureReasonErrorKey];
    
    NSError *error = [NSError errorWithDomain:HYZRequestCodeErrorDomain code:HYZErrorWithRequestCodeError userInfo:userInfo];
    
    return error;
}

@end
