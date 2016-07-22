//
//  FindCityViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "FindCityViewController.h"
#import "RefreshTableView.h"
#import "SearchInPutView.h"

@interface FindCityViewController()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate>

@end

@implementation FindCityViewController

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

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initNavBar];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"发现城市";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton setHidden:[self.myNavController viewControllers].count == 1 ? YES : NO];
}

#pragma mark - Action
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
}


#pragma mark - Action
- (void)backButtonDidClick:(UIButton *)button
{
    [self.myNavController popViewControllerAnimated:YES];
}

@end
