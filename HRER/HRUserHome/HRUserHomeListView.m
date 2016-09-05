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
#import "NetWorkEntity.h"

@interface HRUserHomeListView()<UITableViewDelegate,UITableViewDataSource,HRUserHomeHeadViewDelegate,SWTableViewCellDelegate>

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)UIButton * backButton;


@property(nonatomic,strong)HRUserHomeHeadView * headView;

@property(nonatomic,strong)NSMutableArray * sectionFlag;
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
    self.backgroundColor = [UIColor whiteColor];
    [self initTableView];
    [self initRefreshView];
}

- (void)initTableView
{
    [self addSubview:[UIView new]];
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headView;
    [self addSubview:self.tableView];
    
    
    UINavigationController * nav = (UINavigationController *)[[[UIApplication sharedApplication] delegate] window].rootViewController;
    if([nav viewControllers].count > 1){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 80)];
        self.tableView.tableFooterView = view;
    }
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
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _dataSource.count; i++) {
        [array addObject:@(YES)];
    }
    self.sectionFlag = array;
    [self.tableView reloadData];
}

- (void)setSeltedAtIndex:(NSInteger)index
{
    [self.headView setSeltedAtIndex:index];
}

- (void)setHeadUserInfo:(HRUserHomeInfo *)homeInfo dataSource:(NSArray *)dataSource
{
    [self.headView setDataSource:homeInfo];
    self.dataSource = dataSource;
    
}

#pragma mark - TableDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

#pragma mark - HeadView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [HRUserTimeLineHeadView heightForView];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    HRHomePoiInfo * poiInfo = self.dataSource[section];
    
    HRUserTimeLineHeadView * lineHeadView = [[HRUserTimeLineHeadView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, [HRUserTimeLineHeadView heightForView])];
    lineHeadView.tag = section;
    [lineHeadView setDataSource:poiInfo];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(segTap:)];
    [lineHeadView addGestureRecognizer:tap];
    return lineHeadView;
}

- (void)segTap:(UITapGestureRecognizer *)tap
{
    UIView * view = tap.view;
    BOOL value = [self.sectionFlag[view.tag] boolValue];
    [self.sectionFlag replaceObjectAtIndex:view.tag withObject:@(!value)];
    [[self tableView] reloadSections:[NSIndexSet indexSetWithIndex:view.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark - Cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRUserHomeCell heightForView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HRHomePoiInfo * poiInfo = self.dataSource[section];
    BOOL flag = [self.sectionFlag[section] boolValue];
    return flag ? [self totalPoiInCity:poiInfo] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRUserHomeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRUserHomeCell"];
    if (!cell) {
        cell = [[HRUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRUserHomeCell"];
        cell.rightUtilityButtons = [self rightButtons];
        cell.leftUtilityButtons = nil;
        cell.delegate = self;
        
    }
    HRHomePoiInfo * cityList = self.dataSource[indexPath.section];
    HRPOIInfo * poiInfo = [self poiInTotalCityInCity:cityList ListAtIndex:indexPath.row];
    [cell setDataSource:poiInfo];
    [cell setCellStation:[self poiStationInTotalCityInCity:cityList ListAtIndex:indexPath.row]];
    return cell;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];
    
    return rightUtilityButtons;
}

-(void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"确定删除POI？" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [cell hideUtilityButtonsAnimated:YES];
    }];
    
    UIAlertAction * ensureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [MBProgressHUD showHUDAddedTo:weakSelf animated:YES];
        [NetWorkEntity deletePoiWithPoiId:[(HRUserHomeCell *)cell dataSource].poi_id success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                [weakSelf showTotasViewWithMes:@"删除成功"];
                [[[weakSelf tableView] refreshHeader] beginRefreshing];
            }else{
                [weakSelf showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf animated:YES];
            [weakSelf showTotasViewWithMes:@"网络异常,稍后重试"];
        }];
       
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:ensureAction];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:alertController animated:YES completion:^{
        
    }];
}


- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

#pragma mark -
- (NSInteger)totalPoiInCity:(HRHomePoiInfo *)cityInfo
{
    NSInteger count = 0;
    for (HRMouthPoiList * mouthList in cityInfo.cityPoiList) {
        count += mouthList.timePoiList.count;
    }
    return count;
}

- (HRPOIInfo *)poiInTotalCityInCity:(HRHomePoiInfo *)cityInfo ListAtIndex:(NSInteger)index
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (HRMouthPoiList * mouthList in cityInfo.cityPoiList) {
        [array addObjectsFromArray:mouthList.timePoiList];
    }
    if (index >=0 && index < array.count) {
        return [array objectAtIndex:index];
    }
    return nil;
}

- (KCellStation)poiStationInTotalCityInCity:(HRHomePoiInfo *)cityInfo ListAtIndex:(NSInteger)index
{
    
    for (HRMouthPoiList * mouthList in cityInfo.cityPoiList) {
        if(index < mouthList.timePoiList.count){
            if (index == 0) {
                if (mouthList.timePoiList.count == 1) {
                    return KCellstationFull;
                }else{
                    return KCellstationTop;
                }
            }else if (index == mouthList.timePoiList.count - 1){
                return KCellstationBottom;
            }else{
                return KCellstationMiddle;
            }
        }else{
            index -= mouthList.timePoiList.count;
        }
    }
    return KCellstationMiddle;
}

#pragma mark HEADView
- (HRUserHomeHeadView *)headView
{
    if (!_headView) {
        _headView = [[HRUserHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, [HRUserHomeHeadView heightForView])];
        _headView.delegate = self;
    }
    return _headView;
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HRUserHomeCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([_delegate respondsToSelector:@selector(userHomeListView:DidClickCellWithSource:)]) {
        [_delegate userHomeListView:self DidClickCellWithSource:cell.dataSource];
    }
}

- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickCateAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(userHomeListView:DidCategoryAtIndex:)]) {
        [_delegate userHomeListView:self DidCategoryAtIndex:index];
    }
}

- (void)userHomeHeadViewDidCancelSeletedButton:(HRUserHomeHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeHeadViewDidCancelSeletedButton:)]) {
        [_delegate userHomeListViewDidCalcelSeleted:self];
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

- (void)userHomeHeadViewDidClickDetail:(HRUserHomeHeadView *)headView
{
    if([_delegate respondsToSelector:@selector(userHomeListViewDidDetailButton:)]){
        [_delegate userHomeListViewDidDetailButton:self];
    }
}
@end
