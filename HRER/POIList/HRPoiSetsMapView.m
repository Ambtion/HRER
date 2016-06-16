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

#define kPoiMapMAOLEVEL        (0.05f)


@interface HRPoiSetsMapView()<MKMapViewDelegate>

@property(nonatomic,strong)MKMapView * mapView;
@property(nonatomic,strong)UIScrollView * scrollView;
@property(nonatomic,strong)NSArray * dataArray;
@property(nonatomic,assign)NSInteger seletedIndex;
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
    
}



#pragma mark - MapView
- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    
    //设置图区范围
    MKCoordinateSpan span;
    span.latitudeDelta = kPoiMapMAOLEVEL;
    span.longitudeDelta = kPoiMapMAOLEVEL;
    MKCoordinateRegion region;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(39.904209 , 116.407394);
    region.center = coord;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
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
    if(annotationView.isSelected){
        annotationView.image = [UIImage imageNamed:@"find"];
    }else{
        annotationView.image = [UIImage imageNamed:@"location"];
    }
    
    annotationView.opaque = NO;
    annotationView.draggable = YES;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self resetAllPinViewToUnseletd];
    view.image = [UIImage imageNamed:@"find"];
    
}

- (void)resetAllPinViewToUnseletd
{
    for (HRAnomation * annomation in self.mapView.annotations) {
        HRPinAnnomationView * annotationView = (HRPinAnnomationView *)[self.mapView viewForAnnotation:annomation];
        annotationView.image = [UIImage imageNamed:@"location"];
    }
}

#pragma mark - ScrollView
- (void)initScrollView
{
//    self.scrollView = [[UIScrollView alloc] initWithFrame:<#(CGRect)#>]
}



#pragma mark Data |UI
- (void)refreshUIWithData:(NSArray *)array
{
    self.dataArray = array;
    [self refreshMapPinViews];
    
}


- (void)refreshMapPinViews
{
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(39.904209 , 116.407394);
    NSMutableArray * array  = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < 5; i++) {
        coord = CLLocationCoordinate2DMake(39.904209 + 0.1 * i , 116.407394);
        HRAnomation * anomation =  [[HRAnomation alloc] initWithCoordinates:coord title:@"1" subTitle:@""];
        [array addObject:anomation];
    }
    [self.mapView addAnnotations:array];
}

- (void)resetSeletIndex
{
    if (self.seletedIndex >= 0 && self.seletedIndex < self.dataArray.count) {
        [self.mapView selectAnnotation:self.dataArray[self.seletedIndex] animated:YES];
    }

}
@end
