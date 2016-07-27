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
#import "HRUserHomeHeadView.h"

#define kHRMapMAOLEVEL        (0.1f)


@interface HRUserHomeMapView()<MKMapViewDelegate,UIScrollViewDelegate,HRUserHomeHeadViewDelegate>

@property(nonatomic,strong)MKMapView * mapView;

@property(nonatomic,strong)HRUserHomeHeadView * headView;

@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * anotionDataArray;

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
    [self addSubview:self.headView];
    [self initMapView];
}

#pragma mark - MapView

- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, self.headView.height, self.width, self.height - self.headView.height)];
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
- (void)refreshUIWithData:(NSArray *)array
{
//    self.dataArray = array;
//    [self refreshMapPinViews];
    [self setMapViewSeleteIndexAnomaiton:0];
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
}


#pragma mark - 联动效果
- (void)setMapViewSeleteIndexAnomaiton:(NSInteger)index
{
    
    if (index >= 0 && index < self.anotionDataArray.count) {
        
        HRAnomation * anomation = self.anotionDataArray[index];
        [self.mapView selectAnnotation:anomation animated:NO];
        //设置图区范围
        MKCoordinateSpan span;
        span.latitudeDelta = kHRMapMAOLEVEL;
        span.longitudeDelta = kHRMapMAOLEVEL;
        MKCoordinateRegion region;
        
        CLLocationCoordinate2D coord = anomation.coordinate;
        region.center = coord;
        region.span = span;
        [self.mapView setRegion:region animated:YES];
    }
    
}

#pragma mark - Total
- (void)setSeltedAtIndex:(NSInteger)index
{
    [self.headView setSeltedAtIndex:index];
}

#pragma mark HEADView
- (HRUserHomeHeadView *)headView
{
    if (!_headView) {
        _headView = [[HRUserHomeHeadView alloc] initWithFrame:CGRectMake(0, 0, self.width, [HRUserHomeHeadView heightForView])];
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


- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickCateAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(userHomeMapView:DidCategoryAtIndex:)]) {
        [_delegate userHomeMapView:self DidCategoryAtIndex:index];
    }
}

- (void)userHomeHeadViewDidClickSwitchButton:(HRUserHomeHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickSwitchButton:)]) {
        [_delegate userHomeMapViewDidClickSwitchButton:self];
    }
}

- (void)userHomeHeadView:(HRUserHomeHeadView *)headView DidClickRightButton:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickRightButton:)]) {
        [_delegate userHomeMapViewDidClickRightButton:self];
    }
}

- (void)userHomeHeadViewDidClickDetail:(HRUserHomeHeadView *)headView
{
    if ([_delegate respondsToSelector:@selector(userHomeMapViewDidClickDetailButton:)]) {
        [_delegate userHomeMapViewDidClickDetailButton:self];
    }
}
@end
