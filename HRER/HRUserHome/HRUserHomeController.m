//
//  HRUserHomeController.m
//  HRER
//
//  Created by kequ on 16/7/17.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeController.h"
#import "HRUserHomeListView.h"
#import "HRUserHomeMapView.h"
#import "HRPoiDetailController.h"
#import "LoginStateManager.h"
#import "HRSettingViewController.h"


//Test
#import "PoiRecomendListController.h"

@interface HRUserHomeController()<HRUserHomeListViewDelegate,HRUserHomeMapViewDelegate>

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)UIButton * backButton;

@property(nonatomic,strong)HRUserHomeListView * listView;
@property(nonatomic,strong)HRUserHomeMapView * mapView;
@property(nonatomic,strong)id dataSorece;
@property(nonatomic,assign)NSInteger caterIndex;
@end

@implementation HRUserHomeController

- (instancetype)initWithUserID:(NSString *)userId
{
    self = [super init];
    if (self) {
        
        self.userId = userId;
        self.caterIndex = 0;
        
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:LOGIN_IN object:nil];
    
    [self initUI];
}

- (void)showLoginPage
{
    //未登录弹出登录
    if (![[LoginStateManager getInstance] userLoginInfo] && [self.myNavController viewControllers].count == 1) {
        [HRLoginManager showLoginViewWithNavgation:self.myNavController];
        return;
    }
}

#pragma mark - initUI
- (void)initUI
{
    [self initMapView];
    [self initListView];
    [self initNavBar];
}

- (void)initListView
{
    self.listView = [[HRUserHomeListView alloc] initWithFrame:self.view.bounds];
    self.listView.delegate = self;
    [self.listView setSeltedAtIndex:self.caterIndex];
    [self.view addSubview:self.listView];
}

- (void)initMapView
{
    self.mapView = [[HRUserHomeMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)switchView
{
//    if (self.listView.dataSource.count == 0) {
//        return;
//    }
    
    [self.mapView refreshUIWithData:self.dataSorece];
    [self.listView setDataSource:self.dataSorece];
    [self.mapView setSeltedAtIndex:self.caterIndex];
    [self.listView setSeltedAtIndex:self.caterIndex];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";/*立方体 */
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger map = [[self.view subviews] indexOfObject:self.mapView];
    NSUInteger list = [[self.view subviews] indexOfObject:self.listView];
    
    [self.view exchangeSubviewAtIndex:map withSubviewAtIndex:list];
    [self.view.layer addAnimation:animation forKey:@"switch"];
    
}

- (void)initNavBar
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [self.backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    [self.backButton setHidden:[self.myNavController viewControllers].count == 1 ? YES : NO];
}

#pragma mark - Data
- (void)quaryDataWithTableView:(RefreshTableView *)tableView
{
    //用户主页，并且未登录，要求登录
    if (![[LoginStateManager getInstance] userLoginInfo] && [self isRootController]) {
        [HRLoginManager showLoginView];
        return;
    }
}

- (void)loginSucess:(id)sucess
{
    if ([self isRootController]) {
        self.userId = [[[LoginStateManager getInstance] userLoginInfo] user_id];
    }
    [self quaryDataWithTableView:nil];
}

- (BOOL)isRootController
{
    return [self.myNavController viewControllers].count == 1;
}

#pragma mark - Action
- (void)backButtonDidClick:(id)sender
{
    [self.myNavController popViewControllerAnimated:YES];
}

#pragma mark Refresh Loading
- (void)userHomeListView:(HRUserHomeListView *)listView DidNeedRefreshData:(RefreshTableView *)refreshTableView
{
    [self quaryDataWithTableView:refreshTableView];
}

#pragma mark PoiDetail
- (void)userHomeListView:(HRUserHomeListView *)listView DidClickCellWithSource:(id)dataSource
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:nil] animated:YES];
}
- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidClickCellWithSource:(id)dataSource
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:nil] animated:YES];
}

#pragma mark  SwitchView
- (void)userHomeListViewDidClickSwitchButton:(HRUserHomeListView *)listView
{
    [self switchView];
}

- (void)userHomeMapViewDidClickSwitchButton:(HRUserHomeMapView *)mapView
{
    [self switchView];
}

#pragma mark RightButton
- (void)userHomeListViewDidClickRightButton:(HRUserHomeListView *)listView
{
    [self.myNavController pushViewController:[[PoiRecomendListController alloc] init] animated:YES];
}
-(void)userHomeMapViewDidClickRightButton:(HRUserHomeMapView *)mapView
{

}

#pragma mark - Detail
- (void)userHomeMapViewDidClickDetailButton:(HRUserHomeMapView *)mapView
{
    if([self.userId isEqualToString:[[LoginStateManager getInstance] userLoginInfo].user_id] &&
       [self.myNavController viewControllers].count == 1){
        [self.myNavController pushViewController:[[HRSettingViewController alloc] init] animated:YES];
    }
}
- (void)userHomeListViewDidDetailButton:(HRUserHomeListView *)listView
{
    [self.myNavController pushViewController:[[HRSettingViewController alloc] init] animated:YES];
}

#pragma mar CategoryIndex
- (void)userHomeListView:(HRUserHomeListView *)listView DidCategoryAtIndex:(NSInteger)index
{
    if (self.caterIndex == index) {
        return;
    }
    self.caterIndex = index;
    [self quaryDataWithTableView:nil];
}
- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidCategoryAtIndex:(NSInteger)index
{
    if (self.caterIndex == index) {
        return;
    }
    self.caterIndex = index;
    [self quaryDataWithTableView:nil];
}
@end
