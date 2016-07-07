//
//  HRRigisterDealViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRegisterDealViewController.h"

@implementation HRRegisterDealViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 5700/2.f)];
    imageview.image = [UIImage imageNamed:@"serviceitem.png"];
    imageview.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:imageview];
    [scrollView setContentSize:imageview.bounds.size];
    [self.view addSubview:scrollView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"这里协议";
}

@end
