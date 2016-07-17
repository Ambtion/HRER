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
@property(nonatomic,strong)NSString * userName;

@end

@implementation HRPoiSetsController


- (instancetype)initWithPoiSetCreteType:(KPoiSetsCreteType)creteType
                                creteId:(NSString *)userID
                          creteUserName:(NSString *)creteUserName
                               category:(NSInteger)categoryType
{
    self = [super init];
    if (self) {
        self.userId = userID;
        self.userName = creteUserName;
        self.creteType = creteType;
        self.categoryType = categoryType;
    }
    return self;
}


#pragma mark - ViewLife
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
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
    [self.poisetsMapView refreshUIWithData:nil];
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
    
}

- (void)switchView
{
    if (self.poisetsListView.dataSource.count == 0) {
        return;
    }
    
    [self.poisetsMapView refreshUIWithData:self.poisetsListView.dataSource];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
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
    self.poisetsListView = [[HRPoiSetsListView alloc] initWithFrame:self.view.bounds PoiSetCreteType:self.creteType creteId:self.userId creteUserName:self.userName category:self.categoryType];
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
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:poiInfo.poi_id] animated:YES];

}

- (void)poiSetsListViewdidClickDetailView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:poiInfo.poi_id] animated:YES];
}

-(void)poiSetsMapViewdidClickPortView:(HRPoiSetsMapView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if (self.creteType != KPoiSetsCreteUser) {
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:poiInfo.creator_id];
    [self.myNavController pushViewController:userHomeController animated:YES];

}
- (void)poiSetsListViewdidClickPortView:(HRPoiSetsListView *)view withDataSource:(HRPOIInfo *)poiInfo
{
    if (self.creteType != KPoiSetsCreteUser) {
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:poiInfo.creator_id];
    [self.myNavController pushViewController:userHomeController animated:YES];
}
@end
