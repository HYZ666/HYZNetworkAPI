//
//  ViewController.m
//  HYZNetworkAPI
//
//  Created by hyz on 2022/7/6.
//

#import "ViewController.h"
#import "HYZNetworkAPI.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [HYZNetworkAPI requestWithUrl:@"success" param:nil method:HYZRequestMethodGET success:^(__kindof HYZRequest * _Nonnull request) {
        NSLog(@"任务1成功");
    } failure:^(__kindof HYZRequest * _Nonnull request) {
        NSLog(@"任务1失败");
    }];
}


@end
