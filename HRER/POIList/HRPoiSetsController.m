//
//  HRPoiSetsController.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsController.h"
#import "HRPoiSetsMapView.h"
#import "HRPoiSetsListView.h"
#import "HRUserHomeController.h"
#import "HRPoiDetailController.h"

@interface HRPoiSetsController()<HRPoiSetsMapViewDelegate,HRPoiSetsListViewDelegate>

@property(nonatomic,strong)HRPoiSetsMapView * poisetsMapView;
@property(nonatomic,strong)HRPoiSetsListView * poisetsListView;

@property(nonatomic,assign)KPoiSetsCreteType creteType;
@property(nonatomic,assign)NSInteger categoryType;
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,assign)NSInteger poiNumber;
@property(nonatomic,strong)NSString * poiTitle;
@end

@implementation HRPoiSetsController


- (instancetype)initWithPoiSetCreteType:(KPoiSetsCreteType)creteType
                                creteId:(NSString *)userID
                                city_Id:(NSInteger)cityId
                               cityName:(NSString *)cityName
                              poiNumber:(NSInteger)poiNumber
                                poiName:(NSString *)poiTitle
                          creteUserName:(NSString *)creteUserName
                               category:(NSInteger)categoryType

{
    self = [super init];
    if (self) {
        self.userId = userID;
        self.userName = creteUserName;
        self.creteType = creteType;
        self.categoryType = categoryType;
        self.cityId = cityId;
        self.cityName = cityName;
        self.poiNumber = poiNumber;
        self.poiTitle = poiTitle;
    }
    return self;
}


#pragma mark - ViewLife
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xebebeb);
    [self initUI];
    [self.poisetsListView quaryData];
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

- (void)initUI
{
    [self initMapView];
    [self initPoiListView];
}

#pragma mark - MapView

- (void)initMapView
{
    self.poisetsMapView = [[HRPoiSetsMapView alloc] initWithFrame:self.view.bounds];
    self.poisetsMapView.delegate = self;
    [self.view addSubview:self.poisetsMapView];
}

- (void)poiSetsMapViewdidClickBackButton:(HRPoiSetsMapView *)view
{
    [[self myNavController] popViewControllerAnimated:YES];
}

- (void)poiSetsMapViewdidClickListButton:(HRPoiSetsMapView *)view
{
    [self switchView];
}

- (void)poiSetsMapView:(HRPoiSetsMapView *)view didClickCarViewAtIndex:(NSInteger)index
{
    
    if ([view seletedPoiInfo]) {
        [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:[view seletedPoiInfo].poi_id] animated:YES];

    }
}

- (void)switchView
{
    if (self.poisetsListView.dataSource.count == 0) {
        return;
    }
    
    [self.poisetsMapView refreshUIWithData:self.poisetsListView.dataSource];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";/*立方体 */
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger map = [[self.view subviews] indexOfObject:self.poisetsMapView];
    NSUInteger list = [[self.view subviews] indexOfObject:self.poisetsListView];

    [self.view exchangeSubviewAtIndex:map withSubviewAtIndex:list];
    [self.view.layer addAnimation:animation forKey:@"switch"];
    

}
#pragma mark - PoiListView
- (void)initPoiListView
{
    self.poisetsListView = [[HRPoiSetsListView alloc] initWithFrame:self.view.bounds PoiSetCreteType:self.creteType creteId:self.userId city_Id:self.cityId cityName:self.cityName poiTitle:self.poiTitle creteUserName:self.userName category:self.categoryType];
    self.poisetsListView.poiListNumber = self.poiNumber;
    self.poisetsListView.delegate = self;
    [self.poisetsListView.tableView.refreshHeader beginRefreshing];
    [self.view addSubview:self.poisetsListView];
}

- (void)poiSetsListViewdidClickBackButton:(HRPoiSetsListView *)view
{
    [[self myNavController] popViewControllerAnimated:YES];
}

- (void)poiSetsListViewdidClickListButton:(HRPoiSetsListView *)view
{
    [self switchView];
}

- (void)poiSetsMapViewdidClickDetailView:(HRPoiSetsMapView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if(!poiInfo.poi_id.length){
        [self showTotasViewWithMes:@"POI数据格式错误，POI Id是空"];
        return;
    }
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:poiInfo.poi_id] animated:YES];

}

- (void)poiSetsListViewdidClickDetailView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if(!poiInfo.poi_id.length){
        [self showTotasViewWithMes:@"POI数据格式错误，POI Id是空"];
        return;
    }
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:poiInfo.poi_id] animated:YES];
}

-(void)poiSetsMapViewdidClickPortView:(HRPoiSetsMapView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if (self.creteType != KPoiSetsCreteUser) {
        return;
    }
    if(!poiInfo.creator_id.length){
        [self showTotasViewWithMes:@"POI数据格式错误，用户ID是空"];
        return;
    }

    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:poiInfo.creator_id ];
    [self.myNavController pushViewController:userHomeController animated:YES];

}
- (void)poiSetsListViewdidClickPortView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if (self.creteType != KPoiSetsCreteUser) {
        return;
    }
    if(!poiInfo.creator_id.length){
        [self showTotasViewWithMes:@"POI数据格式错误，用户ID是空"];
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:poiInfo.creator_id];
    [self.myNavController pushViewController:userHomeController animated:YES];
}
@end
