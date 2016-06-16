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

#define kPoiMapMAOLEVEL        (0.1f)


@interface HRPoiSetsMapView()<MKMapViewDelegate,UIScrollViewDelegate>

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


#pragma mark - 大头针
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[HRAnomation class]] == NO)
    {
        return nil;
    }
    
    if([mapView isEqual:self.mapView] == NO)
    {
        return nil;
    }
    
    HRAnomation * senderAnnotation = (HRAnomation *)annotation;
    HRPinAnnomationView * annotationView = (HRPinAnnomationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotation.title];
    if(annotationView == nil)
    {
        annotationView = [[HRPinAnnomationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:annotation.title];
        [annotationView setCanShowCallout:YES];
    }
        
    annotationView.anomationData = senderAnnotation;
    annotationView.opaque = YES;
    annotationView.draggable = YES;
    return annotationView;
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
    array = @[@"1",@"3",@"3",@"4",@"5"];
    self.dataArray = array;
    [self refreshMapPinViews];
    [self refreshScrollViews];
    [self setMapViewSeleteIndexAnomaiton:0];
}

#pragma mark ScrollView
- (void)refreshScrollViews
{
    CGFloat offset = 0.f;
    for (int i = 0; i < self.dataArray.count; i++) {
        HRPoiCardView * poiCardView = [[HRPoiCardView alloc] initWithFrame:CGRectMake(offset + self.width * i, 0, self.scrollView.width - offset * 2, self.scrollView.height)];
        poiCardView.tag = i;
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
        
        coord = CLLocationCoordinate2DMake(39.904209 + 0.1 * i , 116.407394);
        HRAnomation * anomation =  [[HRAnomation alloc] initWithCoordinates:coord title:[NSString stringWithFormat:@"%d",i] subTitle:@""];
        anomation.index = i;
        [array addObject:anomation];
    }
    self.anotionDataArray = array;
    [self.mapView addAnnotations:array];
}


#pragma mark - 联动效果
#pragma mark Map
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view isKindOfClass:[HRPinAnnomationView class]]) {
        NSArray * anomations = [self.mapView selectedAnnotations];
        HRAnomation * anomaiton = [anomations lastObject];
        [self scrollViewToPage:anomaiton.index];
    }
}


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

@end
