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
#import "HRPoiDetailController.h"
#import "LoginStateManager.h"
#import "HRSettingViewController.h"
#import "LoginStateManager.h"
#import "DHSmartScreenshot.h"
#import "HcdActionSheet.h"
#import "HRWebCatShare.h"
#import "HRQQManager.h"

@interface HRUserHomeController()<HRUserHomeListViewDelegate,HRUserHomeMapViewDelegate>

@property(nonatomic,strong)NSString * userId;

@property(nonatomic,strong)UIButton * backButton;

@property(nonatomic,strong)HRUserHomeListView * listView;
@property(nonatomic,strong)HRUserHomeMapView * mapView;

@property(nonatomic,strong)HRUserHomeInfo * homeUserInfo;
@property(nonatomic,strong)NSArray * poiList;

@property(nonatomic,assign)NSInteger caterIndex;

@end

@implementation HRUserHomeController

- (instancetype)initWithUserID:(NSString *)userId
{
    self = [super init];
    if (self) {
        
        self.userId = userId;
        self.caterIndex = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:LOGIN_IN object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:@"HomeNeedRefresh" object:nil];

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
    [self.backButton setHidden:[self.myNavController viewControllers].count == 1 ? YES : NO];
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
    
    [self initUI];
    [self quaryDataWithTableView:nil];
}

- (void)showLoginPage
{
    //未登录弹出登录
    if (![[LoginStateManager getInstance] userLoginInfo]) {
        if (![[self.navigationController topViewController] isKindOfClass:[HRLoginViewController class]]) {
            [HRLoginManager showLoginViewWithNavgation:self.myNavController];
        }
    }else{
        if ([[self.myNavController topViewController] isKindOfClass:[HRLoginViewController class]]) {
            [self.myNavController popViewControllerAnimated:NO];
        }
    }
    
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
    self.listView.delegate = self;
    [self.listView setSeltedAtIndex:self.caterIndex];
    [self.view addSubview:self.listView];
}

- (void)initMapView
{
    self.mapView = [[HRUserHomeMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)switchView
{
//    if (self.listView.dataSource.count == 0) {
//        return;
//    }
    
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = @"cube";/*立方体 */
    animation.subtype = kCATransitionFromRight;
    
    NSUInteger map = [[self.view subviews] indexOfObject:self.mapView];
    NSUInteger list = [[self.view subviews] indexOfObject:self.listView];
    
    [self.view exchangeSubviewAtIndex:map withSubviewAtIndex:list];
    [self.view.layer addAnimation:animation forKey:@"switch"];
    
}

- (void)refreshData
{
    [self.listView setHeadUserInfo:self.homeUserInfo dataSource:self.poiList];
    [self.listView setSeltedAtIndex:self.caterIndex];
    
    self.mapView.delegate = nil;
    [self.mapView setHeadUserInfo:self.homeUserInfo dataSource:[self totalPoiListFromDataSource:self.poiList]];
    [self.mapView setSeltedAtIndex:self.caterIndex];
    self.mapView.delegate = self;
}


- (NSArray *)totalPoiListFromDataSource:(NSArray *)dataSource
{
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:0];
    for (HRHomePoiInfo * cityList in self.poiList) {
        for (HRMouthPoiList * mouthList in cityList.cityPoiList) {
            [array addObjectsFromArray:mouthList.timePoiList];
        }
    }
    return array;
}
- (void)initNavBar
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [self.backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
}

#pragma mark - Data
- (void)quaryDataWithTableView:(RefreshTableView *)tableView
{
    __block NSInteger toutalNetCount = 2;
    
    if(![MBProgressHUD HUDForView:self.view]){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    WS(ws);
    void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        [ws netErrorWithTableView:tableView];
    };
    
    [NetWorkEntity quaryUserInfoWithUserId:self.userId
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * response  = [responseObject objectForKey:@"response"];
            HRUserHomeInfo * userHomeInfo = [HRUserHomeInfo yy_modelWithJSON:response];
            if(userHomeInfo){
                ws.homeUserInfo = userHomeInfo;
                [ws refreshData];
                [tableView.refreshHeader endRefreshing];
                
                toutalNetCount --;
                if (toutalNetCount == 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }else{
                [ws  dealErrorResponseWithTableView:tableView info:responseObject];
            }
        }else{
            [ws dealErrorResponseWithTableView:tableView info:responseObject];
        }

        
    } failure:failure];
 
    
    [NetWorkEntity quaryUserHomePoiListWithUserId:self.userId
                                        catergory:self.caterIndex + 1
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * response  = [responseObject objectForKey:@"response"];
            ws.poiList  = [ws analysisPoiListModelFromArray:[response objectForKey:@"city_list"]];
            [ws refreshData];
            [tableView.refreshHeader endRefreshing];
            
            toutalNetCount --;
            if (toutalNetCount == 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            [ws dealErrorResponseWithTableView:tableView info:responseObject];
        }
        
    } failure:failure];
}

- (NSArray *)analysisPoiListModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRHomePoiInfo * model = [HRHomePoiInfo yy_modelWithJSON:dic];
        if (model) {
            [mArray addObject:model];
        }
    }
    return mArray;
}

- (void)loginSucess:(id)sucess
{
    if ([self isRootController]) {
        self.userId = [[[LoginStateManager getInstance] userLoginInfo] user_id];
    }
    [self quaryDataWithTableView:nil];
}

- (BOOL)isRootController
{
    return ([self.myNavController viewControllers].count == 1) ||
            ([self.myNavController viewControllers].count == 2 && [[self.myNavController topViewController] isKindOfClass:[HRLoginViewController class]]);
}

#pragma mark - Action
- (void)backButtonDidClick:(id)sender
{
    [self.myNavController popViewControllerAnimated:YES];
}

#pragma mark Refresh Loading
- (void)userHomeListView:(HRUserHomeListView *)listView DidNeedRefreshData:(RefreshTableView *)refreshTableView
{
    [self quaryDataWithTableView:refreshTableView];
}

#pragma mark PoiDetail
- (void)userHomeListView:(HRUserHomeListView *)listView DidClickCellWithSource:(HRPOIInfo *)dataSource
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:dataSource.poi_id] animated:YES];
}
- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidClickCellWithSource:(HRPOIInfo *)dataSource
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:dataSource.poi_id] animated:YES];
}

#pragma mark  SwitchView
- (void)userHomeListViewDidClickSwitchButton:(HRUserHomeListView *)listView
{
    [self switchView];
}

- (void)userHomeMapViewDidClickSwitchButton:(HRUserHomeMapView *)mapView
{
    [self switchView];
}

#pragma mark RightButton
- (void)userHomeListViewDidClickRightButton:(HRUserHomeListView *)listView
{
    if ([[LoginStateManager getInstance] userLoginInfo] &&
        [[LoginStateManager getInstance] userLoginInfo].user_id &&
        [[[LoginStateManager getInstance] userLoginInfo].user_id isEqualToString:self.userId]) {
        //进入的是个人主页
        [self shareHomePage];
    }else{
        
        if (![[LoginStateManager getInstance] userLoginInfo]) {
            [HRLoginManager showLoginView];
            return;
        }
        //关注
        WS(weakSelf);
        
        if(![MBProgressHUD HUDForView:self.view])
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [NetWorkEntity favFriends:self.homeUserInfo.user_id isFav:!self.homeUserInfo.is_focus success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                if(!weakSelf.homeUserInfo.is_focus){
                    [self showTotasViewWithMes:@"关注成功"];
                }else{
                    [self showTotasViewWithMes:@"取消关注成功"];
                }
                [weakSelf quaryDataWithTableView:nil];
            }else{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [self showTotasViewWithMes:@"网络异常,稍后重试"];
        }];

    }
}

-(void)userHomeMapViewDidClickRightButton:(HRUserHomeMapView *)mapView
{
    [self shareHomePage];
}

-(void)shareHomePage
{
    
    NSUInteger map = [[self.view subviews] indexOfObject:self.mapView];
    NSUInteger list = [[self.view subviews] indexOfObject:self.listView];
    
    UIImage * shareImage = nil;
    if(map > list){
        
        CGRect croppingRect = self.mapView.frame;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(croppingRect.size.width, croppingRect.size.height - 20), NO, [UIScreen mainScreen].scale);
        // Create a graphics context and translate it the view we want to crop so
        // that even in grabbing (0,0), that origin point now represents the actual
        // cropping origin desired:
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context == NULL) return ;
        
        CGContextTranslateCTM(context, -croppingRect.origin.x, -croppingRect.origin.y + 20);
        
        [self.mapView.layer renderInContext:context];
        
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

    
    }else{
//        self.listView.isShareStatue = YES;
//        [self.listView.tableView reloadData];
//        shareImage = [self.listView.tableView screenshot];
//        self.listView.isShareStatue = NO;
//        [self.listView.tableView reloadData];
        
        CGRect croppingRect = self.listView.tableView.tableHeaderView.frame;
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(croppingRect.size.width, croppingRect.size.height), NO, [UIScreen mainScreen].scale);
        // Create a graphics context and translate it the view we want to crop so
        // that even in grabbing (0,0), that origin point now represents the actual
        // cropping origin desired:
        CGContextRef context = UIGraphicsGetCurrentContext();
        if (context == NULL) return ;
        
        CGContextTranslateCTM(context, -croppingRect.origin.x, -croppingRect.origin.y);
        
        [self.listView.tableView.tableHeaderView.layer renderInContext:context];
        
        shareImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[HcdActionSheet class]]) {
            return;
        }
    }
    
    if (!shareImage) {
        return;
    }
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消"
                                                    otherButtonTitles:@[@"微信好友",@"朋友圈",@"QQ好友"]
                                                          attachTitle:nil];
    
    sheet.selectButtonAtIndex = ^(NSInteger index) {
        if (index == 1) {
            [HRWebCatShare sendWeixinWebContentTitle:@"" description:@"" thumbImage:nil image:shareImage webpageURL:nil scene:WXSceneSession withcallBack:^(BaseResp *resp) {
                
            }];
        }
        
        if (index == 2) {
            [HRWebCatShare sendWeixinWebContentTitle:@"" description:@"" thumbImage:nil image:shareImage webpageURL:nil scene:WXSceneTimeline withcallBack:^(BaseResp *resp) {
                
            }];
        }
        
        if (index == 3) {
            [[HRQQManager shareInstance] shareImageToQQWithThumbImage:nil orignalImage:shareImage title:@"" withDes:@"" WithCallBack:^(QQBaseResp *response) {
                
            }];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];

}

#pragma mark - Detail
- (void)userHomeMapViewDidClickDetailButton:(HRUserHomeMapView *)mapView
{
    if([self.userId isEqualToString:[[LoginStateManager getInstance] userLoginInfo].user_id] &&
       [self.myNavController viewControllers].count == 1){
        [self.myNavController pushViewController:[[HRSettingViewController alloc] init] animated:YES];
    }
}

- (void)userHomeListViewDidDetailButton:(HRUserHomeListView *)listView
{
    if([self.userId isEqualToString:[[LoginStateManager getInstance] userLoginInfo].user_id] &&
       [self.myNavController viewControllers].count == 1){
        [self.myNavController pushViewController:[[HRSettingViewController alloc] init] animated:YES];
    }
}

#pragma mar CategoryIndex
- (void)userHomeListView:(HRUserHomeListView *)listView DidCategoryAtIndex:(NSInteger)index
{
    if (self.caterIndex == index) {
        return;
    }
    self.caterIndex = index;
    [self quaryDataWithTableView:nil];
}

- (void)userHomeMapView:(HRUserHomeMapView *)mapView DidCategoryAtIndex:(NSInteger)index
{
    if (self.caterIndex == index) {
        return;
    }
    self.caterIndex = index;
    [self quaryDataWithTableView:nil];
}

-(void)userHomeListViewDidCalcelSeleted:(HRUserHomeListView *)listView
{
    self.caterIndex = -1;
    [self quaryDataWithTableView:nil];
}

- (void)userHomeMapViewDidCancelSeletedButton:(HRUserHomeMapView *)mapView
{
    self.caterIndex = -1;
    [self quaryDataWithTableView:nil];
}

@end
