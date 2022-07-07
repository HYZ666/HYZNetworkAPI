//
//  HYZResponse.h
//  HYZRequestManager
//
//  Created by hyz on 2022/6/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HYZResponse : NSObject
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *messageArgs;
@property (nonatomic,) id result;
@property (nonatomic, assign) NSInteger success;

@end

NS_ASSUME_NONNULL_END
