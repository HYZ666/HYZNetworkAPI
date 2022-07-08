//
//  HYZNetworkAPIConfig.m
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import "HYZNetworkAPIConfig.h"

@implementation HYZNetworkAPIConfig

- (NSString *)baseUrl {
    return @"http://rap2api.taobao.org/app/mock/293984/api/";
}

- (NSTimeInterval)timeoutInterval {
    return 20;
}

- (NSDictionary *)requestHeaders {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    [dic setValue:@"test" forKey:@"test"];
    return dic;
}

@end
