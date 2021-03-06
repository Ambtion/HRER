//
//  HRUserHomeMapView.m
//  HRER
//
//  Created by quke on 16/7/19.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeMapView.h"
#import "HRMapView.h"
#import <MapKit/MapKit.h>
#import "HRLocationManager.h"
#import "HRPinAnnomationView.h"
#import "HRPoiCardView.h"
#import "HRAnomation.h"
#import "HereDataModel.h"
#import "HRUserHomeMapHeadView.h"

#define kHRMapMAOLEVEL        (0.1f)


@interface HRUserHomeMapView()<MKMapViewDelegate,UIScrollViewDelegate,HRUserHomeMapHeadViewDelegate>

@property(nonatomic,strong)MKMapView * mapView;

@property(nonatomic,strong)HRUserHomeMapHeadView * headView;

@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * anotionDataArray;

@property(nonatomic,strong)UIView * renderView;
@end

@implementation HRUserHomeMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self initNavBar];
//    self.renderView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.width, self.height - 20)];
//    [self addSubview:self.headView];
    [self initMapView];
}

- (void)initNavBar
{
    
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self addSubview:barView];
    
    UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.text = @"这里护照";
    [barView addSubview:titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(userHomeHeadViewDidClickSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:backButton];
}


#pragma mark - MapView

- (void)initMapView
{
    self.backgroundColor = [UIColor whiteColor];
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64)];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    
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

#pragma mark - Data |UI
- (void)setHeadUserInfo:(HRUserHomeInfo *)homeInfo dataSource:(NSArray *)dataSource
{
    [self.headView setDataSource:homeInfo];
    [self refreshUIWithData:dataSource];
}
- (void)refreshUIWithData:(NSArray *)array
{
    if (!array.count) {
        return;
    }
    self.dataArray = array;
    [self refreshMapPinViews];
    
//    if(array.count == 1){
//        [self ceneterMapViewOnSeleteIndexAnomaiton:0];
//    }else{
//        [self setMapViewSeleteIndexAnomaiton:0];
//    }
}

#pragma mark Map
- (void)refreshMapPinViews
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(39.904209 , 116.407394);
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < self.dataArray.count; i++) {
        HRPOIInfo * poiInfo = self.dataArray[i];
        
        coord = CLLocationCoordinate2DMake(poiInfo.lat , poiInfo.lng);
        HRAnomation * anomation =  [[HRAnomation alloc] initWithCoordinates:coord title:poiInfo.title subTitle:poiInfo.intro];
        anomation.index = i;
        anomation.extData = poiInfo;
        [array addObject:anomation];
    }
    self.anotionDataArray = array;
    [self.mapView addAnnotations:array];
    [self.mapView showAnnotations:array animated:YES];
}

#pragma mark - 联动效果
//- (void)ceneterMapViewOnSeleteIndexAnomaiton:(NSInteger)index
//{
//    if (index >= 0 && index < [self.mapView annotations].count) {
//        
//        HRAnomation * anomation = (HRAnomation *)[self.mapView annotations][index];
//        //设置图区范围
//        MKCoordinateSpan span;
//        span.latitudeDelta = kHRMapMAOLEVEL;
//        span.longitudeDelta = kHRMapMAOLEVEL;
//        MKCoordinateRegion region;
//        
//        CLLocationCoordinate2D coord = anomation.coordinate;
//        region.center = coord;
//        region.span = span;
//        [self.mapView setRegion:region animated:YES];
//    }
//}

- (void)setMapViewSeleteIndexAnomaiton:(NSInteger)index
{
    
    if (index >= 0 && index < self.anotionDataArray.count) {
        
        @try {
            HRAnomation * anomation = self.anotionDataArray[index];
            [self.mapView selectAnnotation:anomation animated:NO];
            //设置图区范围
            
            MKCoordinateSpan span;
            span.latitudeDelta = self.mapView.region.span.latitudeDelta;
            span.longitudeDelta = self.mapView.region.span.longitudeDelta;
            MKCoordinateRegion region;
            
            CLLocationCoordinate2D coord = anomation.coordinate;
            region.center = coord;
            region.span = span;
            
            
            [self.mapView setRegion:region animated:YES];

        } @catch (NSException *exception) {
            
        } @finally {
            
        }
        
    }
    
}

#pragma mark - Total
- (void)setSeltedAtIndex:(NSInteger)index
{
    [self.headView setSeltedAtIndex:index];
}

#pragma mark HEADView
- (HRUserHomeMapHeadView *)headView
{
    if (!_headView) {
        _headView = [[HRUserHomeMapHeadView alloc] initWithFrame:CGRectMake(0, 0, self.width, [HRUserHomeMapHeadView heightForView])];
        _headView.delegate = self;
        [_headView setDataSource:nil];
    }
    return _headView;
}

#pragma mark - Action
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MKUserLocation class]]) {
        // 点击当前位置
        
    } else if ([view.annotation isKindOfClass:[HRAnomation class]]) {
        //联动
        HRAnomation * anomaiton = (HRAnomation *)view.annotation;
        //        [self scrollViewToPage:anomaiton.index];
        if ([_delegate respondsToSelector:@selector(userHomeMapView:DidClickCellWithSource:)]) {
            [_delegate userHomeMapView:self DidClickCellWithSource:anomaiton.extData];
        }
    }
}


- (void)userHomeHeadView:(HRUserHomeMapHeadView *)headView DidClickCateAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(userHomeMapView:DidCategoryAtIndex:)]) {
        [_delegate userHomeMapView:self DidCategoryAtIndex:index];
    }
}

- (void)userHomeHeadViewDidCancelSeletedButton:(HRUserHomeMapHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidCancelSeletedButton:)]) {
        [_delegate userHomeMapViewDidCancelSeletedButton:self];
    }
}

- (void)userHomeHeadViewDidClickSwitchButton:(HRUserHomeMapHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickSwitchButton:)]) {
        [_delegate userHomeMapViewDidClickSwitchButton:self];
    }
}

- (void)userHomeHeadView:(HRUserHomeMapHeadView *)headView DidClickRightButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickRightButton:)]) {
        [_delegate userHomeMapViewDidClickRightButton:self];
    }
}

- (void)userHomeHeadViewDidClickDetail:(HRUserHomeMapHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickDetailButton:)]) {
        [_delegate userHomeMapViewDidClickDetailButton:self];
    }
}
@end
