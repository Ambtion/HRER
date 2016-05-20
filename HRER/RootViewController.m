//
//  RootViewController.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "RootViewController.h"
#import "HRMapView.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    HRMapView * view = [[HRMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:view];
}


@end

