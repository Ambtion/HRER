//
//  HRUserHomeListView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeListView.h"
#import "HRUserHomeHeadView.h"
#import "HRUserTimeLineHeadView.h"
#import "HRUserHomeCell.h"

@interface HRUserHomeListView()<UITableViewDelegate,UITableViewDataSource,HRUserHomeHeadViewDelegate>

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
    self.tableView.tableHeaderView = self.headView;
    [self addSubview:self.tableView];
}

- (void)initRefreshView
{
    self.tableView.refreshFooter.scrollView = nil;
    
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        if ([ws.delegate respondsToSelector:@selector(userHomeListView:DidNeedRefreshData:)]) {
            [ws.delegate userHomeListView:ws DidNeedRefreshData:ws.tableView];
        }
    };
}

-(void)setDataSource:(id)dataSource
{
    _dataSource = dataSource;
    [[self tableView] reloadData];
}

- (void)setSeltedAtIndex:(NSInteger)index
{
    [self.headView setSeltedAtIndex:index];
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

#pragma mark - Cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRUserHomeCell heightForView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRUserHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRUserHomeCell"];
    if (!cell) {
        cell = [[HRUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRUserHomeCell"];
    }
    [cell setDatsSource:nil];
    NSInteger count = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (count == 1) {
        [cell setCellStation:KCellstationFull];
    }else if(indexPath.row == 0){
        [cell setCellStation:KCellstationTop];
    }else if(indexPath.row == count -1){
        [cell setCellStation:KCellstationBottom];
    }else{
        [cell setCellStation:KCellstationMiddle];
    }
    return cell;
}

#pragma mark HEADView
- (HRUserHomeHeadView *)headView
{
    if (!_headView) {
        _headView = [[HRUserHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, [HRUserHomeHeadView heightForView])];
        _headView.delegate = self;
        [_headView setDataSource:nil];
    }
    return _headView;
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRUserHomeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(userHomeListView:DidClickCellWithSource:)]) {
        [_delegate userHomeListView:self DidClickCellWithSource:cell.datsSource];
    }
}

- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickCateAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(userHomeListView:DidCategoryAtIndex:)]) {
        [_delegate userHomeListView:self DidCategoryAtIndex:index];
    }
}

- (void)userHomeHeadViewDidClickSwitchButton:(HRUserHomeHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeListViewDidClickSwitchButton:)]) {
        [_delegate userHomeListViewDidClickSwitchButton:self];
    }
}

- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickRightButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHomeListViewDidClickRightButton:)]) {
        [_delegate userHomeListViewDidClickRightButton:self];
    }
}

@end
