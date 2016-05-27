//
//  MyViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "MyViewController.h"
#import "HRCycleScrollView.h"


@interface MyViewController()<HRCycleScrollViewDelegate,HRCycleScrollViewDataSource>
@property(nonatomic,strong)HRCycleScrollView *hrScro;
@end
@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.hrScro = [[HRCycleScrollView alloc] initWithFrame:self.view.bounds];
    self.hrScro.delegate = self;
    self.hrScro.dataSource = self;
    [self.view addSubview:self.hrScro];
    
    [self.hrScro reloadData];
}

- (NSInteger)hrCycleScrollViewNumberofPage:(HRCycleScrollView *)scrollView
{
    return 4;
}


- (HRImageScaleView *)hrCycleScrollView:(HRCycleScrollView *)cycleScrollView pageAtIndex:(NSInteger)index
{
    HRImageScaleView * view = [[HRImageScaleView alloc] initWithFrame:cycleScrollView.bounds];
    view.backgroundColor = [UIColor clearColor];
    view.imageView.image = [UIImage imageNamed:@"btn_card"];
    return view;
}


@end
