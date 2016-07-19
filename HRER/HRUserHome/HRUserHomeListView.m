//
//  HRUserHomeListView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeListView.h"
#import "RefreshTableView.h"
#import "HRUserHomeHeadView.h"
#import "HRUserTimeLineHeadView.h"

@interface HRUserHomeListView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)UIButton * backButton;

@property(nonatomic,strong)RefreshTableView * tableView;

@property(nonatomic,strong)HRUserHomeHeadView * headView;


@end

@implementation HRUserHomeListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        [self initUI];
    }
    return self;
}

#pragma mark - InitUI
- (void)initUI
{
    [self initTableView];
    [self initRefreshView];
}

- (void)initTableView
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.headView =  [[HRUserHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, [HRUserHomeHeadView heightForView])];
    [self.headView setDataSource:nil];
    self.tableView.tableHeaderView = self.headView;
    [self addSubview:self.tableView];
}

- (void)initRefreshView
{
    self.tableView.refreshFooter.scrollView = nil;
    
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        
    };
}

-(void)quaryDataWithVisitUserid:(NSString *)userId
{
    
}

#pragma mark - TableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


#pragma mark - HeadView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [HRUserTimeLineHeadView heightForView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HRUserTimeLineHeadView * lineHeadView = [[HRUserTimeLineHeadView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [HRUserTimeLineHeadView heightForView])];
    [lineHeadView setDataSource:nil];
    return lineHeadView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}
@end
