//
//  HRPoiSetsController.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsController.h"
#import "HRPoiSetsMapView.h"
#import "HRPoiSetsListView.h"

@interface HRPoiSetsController()

@property(nonatomic,strong)HRPoiSetsMapView * poisetsMapView;

@property(nonatomic,strong)NSArray * dataSource;

@end

@implementation HRPoiSetsController

- (instancetype)initWithDataSource:(NSArray *)dataSource
{
    self = [super init];
    if (self) {
        self.dataSource = dataSource;
    }
    return self;
}


#pragma mark - ViewLife
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}



- (void)initUI
{
    self.poisetsMapView = [[HRPoiSetsMapView alloc] initWithFrame:self.view.bounds];
    [self.poisetsMapView refreshUIWithData:nil];
    [self.view addSubview:self.poisetsMapView];
    
}

@end
