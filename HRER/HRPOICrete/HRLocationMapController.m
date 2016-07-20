//
//  HRLocationMapController.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLocationMapController.h"

@interface HRLocationMapController ()

@end

@implementation HRLocationMapController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myNavController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI
{
    [self initNavBar];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"选择位置";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 66, 26, 66, 33)];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(onRignthButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:rightButton];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

#pragma mark Action
- (void)onBackButtonDidClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onRignthButtonDidClick:(UIButton *)button
{
    
}

@end