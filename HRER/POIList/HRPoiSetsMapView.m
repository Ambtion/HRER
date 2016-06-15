//
//  HRPoiSetsMapView.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsMapView.h"
#import "HRMapView.h"

@interface HRPoiSetsMapView()
@property(nonatomic,strong)HRMapView * mapView;
@property(nonatomic,strong)UIScrollView * scrollView;
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
    self.mapView = [[HRMapView alloc] initWithFrame:self.bounds];
    [self addSubview:self.mapView];
}

#pragma mark Data |UI
- (void)refreshUIWithData:(NSArray *)array
{
    [self.mapView showPinViews:array];
}
@end
