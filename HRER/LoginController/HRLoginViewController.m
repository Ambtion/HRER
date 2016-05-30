//
//  HRLoginViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLoginViewController.h"
#import "RFSegmentView.h"
#import "HRRegisterView.h"
#import "HRLoginView.h"

@interface HRLoginViewController()

@property(nonatomic,strong)RFSegmentView * segControll;
@property(nonatomic,strong)UIScrollView * scrollView;
@end

@implementation HRLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.segControll = [[RFSegmentView alloc] initWithFrame:CGRectMake(0, 0, 200, 44) items:@[@"注册",@"登录"]];
    [self.view addSubview:self.segControll];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.segControll.bottom, self.view.width, self.view.height - self.segControll.bottom)];
    self.scrollView.scrollEnabled = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = NO;
    [self.view addSubview:self.scrollView];
    
    
    
}
@end


