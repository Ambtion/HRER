//
//  RootViewController.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "RootViewController.h"
#import "HRQQManager.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[HRQQManager shareInstance] loginWithLoginCallBack:^(BOOL isSucess, BOOL isCanceled) {
        
    }];
}


@end

