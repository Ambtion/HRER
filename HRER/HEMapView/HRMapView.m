//
//  HRMapView.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRMapView.h"
#import <MapKit/MapKit.h>
#import "HRLocationManager.h"
#import "HRPinAnnomationView.h"


#define MAOLEVEL        (0.05f)


@interface HRMapView()<MKMapViewDelegate>

@property(nonatomic,strong)MKMapView * mapView;

@end

@implementation HRMapView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initMapView];
    }
    return self;
}

- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.showsUserLocation = YES;
    self.mapView.delegate = self;
    [self addSubview:self.mapView];
    
    
    //设置图区范围
    MKCoordinateSpan span;
    span.latitudeDelta = MAOLEVEL;
    span.longitudeDelta =MAOLEVEL;
    MKCoordinateRegion region;
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(39.904209 , 116.407394);
    region.center = coord;
    region.span = span;
    [self.mapView setRegion:region animated:YES];
    
}

#pragma mark - 大头针
- (void)showPinViews:(NSArray *)pinViews
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

@end