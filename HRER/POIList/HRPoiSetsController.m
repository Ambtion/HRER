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

@interface HRPoiSetsController()<HRPoiSetsMapViewDelegate,HRPoiSetsListViewDelegate>

@property(nonatomic,strong)HRPoiSetsMapView * poisetsMapView;
@property(nonatomic,strong)HRPoiSetsListView * poisetsListView;
@property(nonatomic,strong)NSArray * dataSource;

@end

@implementation HRPoiSetsController

- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
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
    [self initPoiListView];
    [self initMapView];
    
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
    self.poisetsListView = [[HRPoiSetsListView alloc] initWithFrame:self.view.bounds];
    self.poisetsListView.delegate = self;
    [self.view addSubview:self.poisetsListView];
    [self.poisetsListView refreshUIWithData:nil];
}

- (void)poiSetsListViewdidClickBackButton:(HRPoiSetsListView *)view
{
    [[self myNavController] popViewControllerAnimated:YES];
}

- (void)poiSetsListViewdidClickListButton:(HRPoiSetsListView *)view
{
    [self switchView];
}
@end
