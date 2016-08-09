//
//  HRPoiSetsMapView.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsMapView.h"
#import "HRMapView.h"
#import <MapKit/MapKit.h>
#import "HRLocationManager.h"
#import "HRPinAnnomationView.h"
#import "HRPoiCardView.h"
#import "HRAnomation.h"
#import "HereDataModel.h"

#define kPoiMapMAOLEVEL        (0.1f)


@interface HRPoiSetsMapView()<MKMapViewDelegate,UIScrollViewDelegate,HRPoiCardViewdelegate>

@property(nonatomic,strong)MKMapView * mapView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,strong)NSArray * anotionDataArray;

@end

@implementation HRPoiSetsMapView
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
    [self initMapView];
    [self initScrollView];
    [self initNavBar];
}

#pragma mark - MapView
- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    
}

- (void)initNavBar
{
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(17, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"back_map"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    [self addSubview:backButton];
    
    UIButton * switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 17 - 33, 26, 33, 33)];
    switchButton.tag = 1;
    [switchButton setImage:[UIImage imageNamed:@"back_change"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchButton];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        if ([_delegate respondsToSelector:@selector(poiSetsMapViewdidClickBackButton:)]) {
            [_delegate poiSetsMapViewdidClickBackButton:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(poiSetsMapViewdidClickListButton:)]) {
            [_delegate poiSetsMapViewdidClickListButton:self];
        }
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
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.height - [HRPoiCardView heightForCardView] - 10, self.width, [HRPoiCardView heightForCardView])];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.scrollView];
}

#pragma mark - Data |UI
- (void)refreshUIWithData:(NSArray *)array
{
    if (array.count == 0) {
        return;
    }
    self.dataArray = array;
    [self refreshMapPinViews];
    [self refreshScrollViews];
    if(array.count == 1){
        [self ceneterMapViewOnSeleteIndexAnomaiton:0];
    }else{
        [self setMapViewSeleteIndexAnomaiton:0];
    }
    
    
}

#pragma mark ScrollView
- (void)refreshScrollViews
{
    CGFloat offset = 0.f;
    for (int i = 0; i < self.dataArray.count; i++) {
        HRPoiCardView * poiCardView = [[HRPoiCardView alloc] initWithFrame:CGRectMake(offset + self.width * i, 0, self.scrollView.width - offset * 2, self.scrollView.height)];
        poiCardView.tag = i;
        poiCardView.delegate = self;
        [poiCardView setDataSource:self.dataArray[i]];
        [self.scrollView addSubview:poiCardView];
    }
    [self.scrollView setContentSize:CGSizeMake(self.dataArray.count * self.width, 0)];
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

#pragma mark ScrollView
-(void)scrollViewToPage:(NSUInteger)index
{
    if (index < self.dataArray.count) {
        [self.scrollView setContentOffset:CGPointMake(self.width * index, 0) animated:YES];
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

- (void)ceneterMapViewOnSeleteIndexAnomaiton:(NSInteger)index
{
    if (index >= 0 && index < [self.mapView annotations].count) {
        
        HRAnomation * anomation = [self.mapView annotations][index];
        //设置图区范围
        MKCoordinateSpan span;
        span.latitudeDelta = kPoiMapMAOLEVEL;
        span.longitudeDelta = kPoiMapMAOLEVEL;
        MKCoordinateRegion region;
        
        CLLocationCoordinate2D coord = anomation.coordinate;
        region.center = coord;
        region.span = span;
        [self.mapView setRegion:region animated:YES];
    }

}

- (void)setMapViewSeleteIndexAnomaiton:(NSInteger)index
{
    
    if (index >= 0 && index < self.anotionDataArray.count) {
        
        HRAnomation * anomation = self.anotionDataArray[index];
        [self.mapView selectAnnotation:anomation animated:NO];
        //设置图区范围
        MKCoordinateSpan span;
        span.latitudeDelta = kPoiMapMAOLEVEL;
        span.longitudeDelta = kPoiMapMAOLEVEL;
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

- (HRPOIInfo *)seletedPoiInfo
{
    NSArray * anomationList = [self.mapView selectedAnnotations];
    if ([anomationList count]) {
        HRAnomation * seletedAnomaiton = [anomationList firstObject];
        return seletedAnomaiton.extData;
    }
    
    return nil;
}

- (void)poiViewDidClickUserPortrait:(HRPoiCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(poiSetsMapViewdidClickPortView:withDataSource:)]) {
        [_delegate poiSetsMapViewdidClickPortView:self withDataSource:self.dataArray[poiSetsview.tag]];
    }
}

- (void)poiViewDidClick:(HRPoiCardView *)poiSetsview
{
    if ([_delegate respondsToSelector:@selector(poiSetsMapViewdidClickDetailView:withDataSource:)]) {
        [_delegate poiSetsMapViewdidClickDetailView:self withDataSource:self.dataArray[poiSetsview.tag]];
    }
}


@end
