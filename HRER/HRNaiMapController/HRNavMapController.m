//
//  HRNavMapController.m
//  HRER
//
//  Created by quke on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRNavMapController.h"
#import "HRMapView.h"
#import <MapKit/MapKit.h>
#import "HRLocationManager.h"
#import "HRPinAnnomationView.h"
#import "HRPoiCardAddressView.h"
#import "HRAnomation.h"
#import "HereDataModel.h"
#import "HRNavigationTool.h"

#define kNavPoiMapMAOLEVEL        (0.1f)


@interface HRNavMapController ()<MKMapViewDelegate,UIScrollViewDelegate>

@property(nonatomic,strong)MKMapView * mapView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSArray * anotionDataArray;
@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)NSString * barTitle;

@end

@implementation HRNavMapController

- (instancetype)initWithPoiInfo:(NSArray *)infoList barTitle:(NSString *)barTitle;
{
    if (self = [super init]) {
        self.dataArray = infoList;
        self.barTitle = barTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self refreshUI];
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
    [self initScrollView];
    [self initNavBar];
}

#pragma mark - MapView
- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    [barView addSubview:titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    [self.view addSubview:backButton];
    
    UIButton * switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 17 - 33, 26, 33, 33)];
    switchButton.tag = 1;
    [switchButton setTitle:@"导航" forState:UIControlStateNormal];
    switchButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    [switchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:switchButton];

}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
//        HRAnomation * anomaiton = [[self.mapView selectedAnnotations] lastObject];
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(39.904209 , 116.407394);
        [HRNavigationTool actionSheetByController:self TLocaiton:coord UrlScheme:@"" appName:@"HERE"];
    }
}

#pragma mark - 大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    
    if([mapView isEqual:self.mapView] == NO)
    {
        return nil;
    }
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        // 当前位置 返回nil用系统自己的CalloutView
        return nil;
        
    }else if([annotation isKindOfClass:[HRAnomation class]]){
        
        //水滴
        HRAnomation * senderAnnotation = (HRAnomation *)annotation;
        HRPinAnnomationView * annotationView = (HRPinAnnomationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
        if(annotationView == nil)
        {
            annotationView = [[HRPinAnnomationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:annotation.title];
            [annotationView setCanShowCallout:NO];
        }
        annotationView.anomationData = senderAnnotation;
        annotationView.opaque = YES;
        annotationView.draggable = YES;
        return annotationView;
    }
    
    return nil;
}

#pragma mark Map
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        // 点击当前位置
        
    } else if ([view.annotation isKindOfClass:[HRAnomation class]]) {
        //联动
        HRAnomation * anomaiton = (HRAnomation *)view.annotation;
        [self scrollViewToPage:anomaiton.index];
    }
}

#pragma mark - ScrollView
- (void)initScrollView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.view.height - [HRPoiCardAddressView heightForCardView] - 10, self.view.width, [HRPoiCardAddressView heightForCardView])];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
}

#pragma mark - Data |UI
- (void)refreshUI
{
    [self refreshMapPinViews];
    [self refreshScrollViews];
    [self setMapViewSeleteIndexAnomaiton:0];
}

#pragma mark ScrollView
- (void)refreshScrollViews
{
    CGFloat offset = 0.f;
    for (int i = 0; i < self.dataArray.count; i++) {
        HRPoiCardAddressView * poiAddresssCardView = [[HRPoiCardAddressView alloc] initWithFrame:CGRectMake(offset + self.view.width * i, 0, self.scrollView.width - offset * 2, self.scrollView.height)];
        poiAddresssCardView.tag = i;
        [poiAddresssCardView setDataSource:self.dataArray[i]];
        [self.scrollView addSubview:poiAddresssCardView];
    }
    [self.scrollView setContentSize:CGSizeMake(self.dataArray.count * self.view.width, 0)];
}

#pragma mark Map
- (void)refreshMapPinViews
{
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.dataArray.count; i++) {
        HRPOIInfo * poiInfo = self.dataArray[i];
        
        CLLocationCoordinate2D  coord = CLLocationCoordinate2DMake(poiInfo.lat , poiInfo.lng);
        HRAnomation * anomation =  [[HRAnomation alloc] initWithCoordinates:coord title:poiInfo.title subTitle:poiInfo.intro];
        anomation.index = i;
        anomation.extData = poiInfo;
        [array addObject:anomation];
    }
    self.anotionDataArray = array;
    [self.mapView addAnnotations:array];
}


#pragma mark - 联动效果

#pragma mark ScrollView
-(void)scrollViewToPage:(NSUInteger)index
{
    if (index < self.dataArray.count) {
        [self.scrollView setContentOffset:CGPointMake(self.view.width * index, 0) animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!scrollView.isDragging) {
        return;
    }
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    [self setMapViewSeleteIndexAnomaiton:index];
}

- (void)setMapViewSeleteIndexAnomaiton:(NSInteger)index
{
    
    if (index >= 0 && index < self.anotionDataArray.count) {
        
        HRAnomation * anomation = self.anotionDataArray[index];
        [self.mapView selectAnnotation:anomation animated:NO];
        //设置图区范围
        MKCoordinateSpan span;
        span.latitudeDelta = kNavPoiMapMAOLEVEL;
        span.longitudeDelta = kNavPoiMapMAOLEVEL;
        MKCoordinateRegion region;
        
        CLLocationCoordinate2D coord = anomation.coordinate;
        region.center = coord;
        region.span = span;
        [self.mapView setRegion:region animated:YES];
    }
    
}

#pragma mark - Total
- (void)setSeletedIndexCar:(NSInteger)index
{
    [self setMapViewSeleteIndexAnomaiton:index];
}

@end
