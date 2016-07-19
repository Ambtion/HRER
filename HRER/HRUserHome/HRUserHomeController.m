//
//  HRUserHomeController.m
//  HRER
//
//  Created by kequ on 16/7/17.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRUserHomeController.h"
#import "HRUserHomeListView.h"
#import "HRUserHomeMapView.h"

#import "LoginStateManager.h"

@interface HRUserHomeController()

@property(nonatomic,strong)NSString * userId;
@property(nonatomic,assign)KUserHomeControllerState state;

@property(nonatomic,strong)UIButton * backButton;

@property(nonatomic,strong)HRUserHomeListView * listView;
@property(nonatomic,strong)HRUserHomeMapView * mapView;

@end

@implementation HRUserHomeController

- (instancetype)initWithUserID:(NSString *)userId  controllerState:(KUserHomeControllerState)state
{
    self = [super init];
    if (self) {
        
        self.state = state;
        self.userId = userId;   
    }
    
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.myNavController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:LOGIN_IN object:nil];
    
    [self initUI];
}

#pragma mark - initUI
- (void)initUI
{
    [self initMapView];
    [self initListView];
    [self initNavBar];
}

- (void)initListView
{
    self.listView = [[HRUserHomeListView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.listView];
}

- (void)initMapView
{
    self.mapView = [[HRUserHomeMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.mapView];
}

- (void)switchView
{
//    if (self.listView.dataSource.count == 0) {
//        return;
//    }
    
//    [self.mapView refreshUIWithData:self.poisetsListView.dataSource];
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";/*立方体 */
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger map = [[self.view subviews] indexOfObject:self.mapView];
    NSUInteger list = [[self.view subviews] indexOfObject:self.listView];
    
    [self.view exchangeSubviewAtIndex:map withSubviewAtIndex:list];
    [self.view.layer addAnimation:animation forKey:@"switch"];
    
}

- (void)initNavBar
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [self.backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    [self.backButton setHidden:self.state == KUserHomeControllerStateRoot];
}

#pragma mark - Data
- (void)quaryData
{
    //用户主页，并且未登录，要求登录
    if (![[LoginStateManager getInstance] userLoginInfo] && self.state == KUserHomeControllerStateRoot) {
        [HRLoginManager showLoginView];
        return;
    }
    [self.listView quaryDataWithVisitUserid:self.userId];
}

- (void)loginSucess:(id)sucess
{
    if (self.state == KUserHomeControllerStateRoot) {
        self.userId = [[[LoginStateManager getInstance] userLoginInfo] user_id];
    }
    [self quaryData];
}

#pragma mark - Action
- (void)backButtonDidClick:(id)sender
{
    [self.myNavController popViewControllerAnimated:YES];
}
@end
