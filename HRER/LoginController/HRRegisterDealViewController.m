//
//  HRRigisterDealViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRegisterDealViewController.h"

@implementation HRRegisterDealViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"这里协议";
    
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    [self.view addSubview:backButton];

    
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64)];
    UIImageView * imageview = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.view.width - 20, 6980/2.f + 10)];
    imageview.image = [UIImage imageNamed:@"serviceitem.png"];
    imageview.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:imageview];
    [scrollView setContentSize:CGSizeMake(imageview.bounds.size.width, imageview.bounds.size.height + 20)];
    [self.view addSubview:scrollView];
}

- (void)buttonDidClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
