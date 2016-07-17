//
//  HRUserHomeController.m
//  HRER
//
//  Created by kequ on 16/7/17.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeController.h"
#import "RefreshTableView.h"
#import "HereDataModel.h"

@interface HRUserHomeController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)RefreshTableView * tableView;

@end

@implementation HRUserHomeController

#pragma mark - ViewLife
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isNeedRefresh){
        [self.tableView.refreshHeader beginRefreshing];
    }
    self.isNeedRefresh = NO;
}

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isNeedRefresh = YES;
    [self initUI];
    
    [self.tableView.refreshHeader beginRefreshing];
}

- (void)initUI
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self initRefreshView];
}

- (void)initRefreshView
{
    self.tableView.refreshFooter.scrollView = nil;
    
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        
    };
}

@end
