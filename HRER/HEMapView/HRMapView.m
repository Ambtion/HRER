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
    
    [self showPinViewWithLocation:coord title:@"" subTitle:@""];
}

#pragma mark - 大头针
- (void)showPinViewWithLocation:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)title subTitle:(NSString *)subTitle
{
    HRAnomation * anomation =  [[HRAnomation alloc] initWithCoordinates:paramCoordinates title:title subTitle:subTitle];
    [self.mapView addAnnotation:anomation];
    [self.mapView selectAnnotation:anomation animated:YES];
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
    MKPinAnnotationView * annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pingView"];
    
    if(annotationView == nil)
    {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:senderAnnotation reuseIdentifier:@"pingView"];
        [annotationView setCanShowCallout:YES];
    }

    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annotationView.rightCalloutAccessoryView = button;
    
    annotationView.opaque = NO;
    annotationView.animatesDrop = YES;
    annotationView.draggable = YES;
    annotationView.selected = YES;

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

@end