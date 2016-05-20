//
//  HRMapView.m
//  HRER
//
//  Created by quke on 16/5/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRMapView.h"
#import <MapKit/MapKit.h>
#import "HELocationManager.h"

@interface HRMapView()
@property(nonatomic,strong)MKMapView * mapView;
@end

@implementation HRMapView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self initMapView];
        [self addLocaitonButton];
        
    }
    return self;
}

- (void)initMapView
{
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    self.mapView.mapType = MKMapTypeStandard;
    [self addSubview:self.mapView];
    
    [[HELocationManager sharedInstance] startLocaiton];
}

- (void)addLocaitonButton
{
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    button.backgroundColor = [UIColor redColor];
    
}

- (void)showLocaiton
{
    
}



@end
