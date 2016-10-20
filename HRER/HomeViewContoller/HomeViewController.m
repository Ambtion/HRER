//
//  HomeViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HomeViewController.h"
#import "RefreshTableView.h"
#import "HomeHeadView.h"
#import "HRHerePoiCell.h"
#import "HRHerePoisSetCell.h"
#import "HRHereBannerCell.h"
#import "HRPoiSetsController.h"
#import "HRPoiDetailController.h"
#import "NetWorkEntity.h"
#import "HRLocationManager.h"
#import "HereDataModel.h"
#import "LoginStateManager.h"
#import "HRUserHomeController.h"
#import "BMGuideMaskView.h"
#import "PoiRecomendListController.h"
#import "HRRecomendNotificationView.h"


@interface HomeViewController()<UITableViewDelegate,UITableViewDataSource,HomeHeadViewDelegate,HRHerePoisSetCellDelegate,HRHerePoiCellDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)HRRecomendNotificationView * notificationCell;

@property(nonatomic,assign)NSUInteger catergoryIndex;

@property(nonatomic,strong)HRCatergoryInfo * catergoryInfo;
@property(nonatomic,strong)NSArray * nearyBySource;
@property(nonatomic,strong)NSArray * userPoiSource;
@property(nonatomic,strong)NSArray * mixPoiSource;
@property(nonatomic,assign)BOOL hasRecomend;
@end

@implementation HomeViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ViewLife
#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginChnage:) name:LOGIN_IN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginChnage:) name:LOGIN_OUT object:nil];
    self.catergoryIndex = -1;
    self.hasRecomend = NO;
    [self initUI];
    [self quaryData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.clipsToBounds = YES;
    [self refreshComment];
}

- (void)initUI
{
    UIView * view = [UIView new];
    [self.view addSubview:view];
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, [[UIScreen mainScreen] bounds].size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self initRefreshView];
    self.tableView.tableFooterView  = [self footView];
    self.tableView.backgroundColor = UIColorFromRGB(0xebebeb);

    [self initDebugButton];

}


- (HRRecomendNotificationView *)notificationCell
{
    if (!_notificationCell) {
        _notificationCell = [[HRRecomendNotificationView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRRecomendNotificationView"];
        [_notificationCell.action addTarget:self action:@selector(recomendButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _notificationCell;
}

- (void)initDebugButton
{
#ifdef DEBUG
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.height /2.f - 25, 50, 50)];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(debugButtonDidclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
#endif
}

- (void)initRefreshView
{
    self.tableView.refreshFooter.scrollView = nil;
    
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        [ws quaryData];
    };
}

- (void)quaryData
{
    
    __block NSInteger toutalNetCount = 2 + ([[LoginStateManager getInstance] userLoginInfo] ? 2 : 0);
    
    if(![MBProgressHUD HUDForView:self.view])
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        [self netErrorWithTableView:self.tableView];
    };
    
    //获取类别数目
    [NetWorkEntity quaryCityTypeCount:-1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * response  = [responseObject objectForKey:@"response"];
            HRCatergoryInfo * categoryInfo = [HRCatergoryInfo yy_modelWithJSON:response];
            if(categoryInfo){
                self.catergoryInfo = categoryInfo;
                [self.tableView reloadData];
                [self.tableView.refreshHeader endRefreshing];
                
                toutalNetCount --;
                if (toutalNetCount == 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }else{
                [self dealErrorResponseWithTableView:self.tableView info:responseObject];
            }
        }else{
            [self dealErrorResponseWithTableView:self.tableView info:responseObject];
        }
    } failure:failure];
    
    
    
    // 编辑创建的POI集合  | 编辑创建的单个POI  | 个人创建POI集合
    [NetWorkEntity quaryAllMixedPoiListWithCityId:-1 catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * poiSets = [responseObject objectForKey:@"response"];
            self.mixPoiSource = [self analysisPoiMixModelFromArray:poiSets];
            [self.tableView reloadData];
            [self.tableView.refreshHeader endRefreshing];
            
            toutalNetCount --;
            if (toutalNetCount == 0) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }else{
            [self dealErrorResponseWithTableView:self.tableView info:responseObject];
        }

    } failure:failure];
    
    
    if([[LoginStateManager getInstance] userLoginInfo]){
        
        //获取附件条目
        [NetWorkEntity quartCityNearByWithCityId:-1 catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                NSArray * poiSets = [responseObject objectForKey:@"response"];
                self.nearyBySource = [self analysisPoiSetsModelFromArray:poiSets];
                [self.tableView reloadData];
                [self.tableView.refreshHeader endRefreshing];
                
                toutalNetCount --;
                if (toutalNetCount == 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
                
            }else{
                [self dealErrorResponseWithTableView:self.tableView info:responseObject];
            }
            
        } failure:failure];

        
        //个人单个POI
        [NetWorkEntity quaryFreindsCretePoiListWithCityId:-1 catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                NSArray * poiList = [responseObject objectForKey:@"response"];
                self.userPoiSource = [self analysisPoiModelFromArray:poiList];
                [self.tableView reloadData];
                [self.tableView.refreshHeader endRefreshing];
                
                toutalNetCount --;
                if (toutalNetCount == 0) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }else{
                [self dealErrorResponseWithTableView:self.tableView info:responseObject];
            }
            
        } failure:failure];

        
        
    }else{
        self.userPoiSource = nil;
        self.nearyBySource = nil;
    }
    
    [self refreshComment];
    [self refreshTip];
    
}

- (void)refreshComment
{
    [NetWorkEntity hasRecomentSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * dic = [responseObject objectForKey:@"response"];
            if ([[dic objectForKey:@"count"] boolValue]) {
                self.hasRecomend = YES;
                [self.tableView reloadData];
            }else{
                self.hasRecomend = NO;
                [self.tableView reloadData];
            }
        }else{
            self.hasRecomend = NO;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.hasRecomend = NO;
        [self.tableView reloadData];
    }];

}

- (void)refreshTip
{
    [NetWorkEntity quaryNewFriendTipsSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * response = [responseObject objectForKey:@"response"];
            if ([[response objectForKey:@"newFriend"] boolValue]) {
                [self showMessCountInTabBar:0];
            }else{
                [self hiddenMessCountInTabBar];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (NSArray *)analysisPoiSetsModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRPOISetInfo * model = [HRPOISetInfo yy_modelWithJSON:dic];
        if (model) {
            [mArray addObject:model];
        }
    }
    return mArray;
}

- (NSArray *)analysisPoiModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRPOIInfo * model = [HRPOIInfo yy_modelWithJSON:dic];
        if (model) {
            [mArray addObject:model];
        }
    }
    return mArray;
}

- (NSArray *)analysisPoiMixModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        if ([dic isKindOfClass:[NSDictionary class]]) {
            if([dic objectForKey:@"poi_id"]){
                HRPOIInfo * model = [HRPOIInfo yy_modelWithJSON:dic];
                if (model) {
                    [mArray addObject:model];
                }
            }else{
                HRPOISetInfo * model = [HRPOISetInfo yy_modelWithJSON:dic];
                if (model) {
                    [mArray addObject:model];
                }
            }
        }
    }
    return mArray;
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // HeadView
    // 附件的POI集合
    // 我和朋友创建的单个POI
    // 我和朋友的POI集合 | 编辑创建的单个POI | 编辑推荐的POI集合
    
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.hasRecomend ? 1 : 0;
        case 2:
            return self.nearyBySource.count;
            break;
        case 3:
            return self.userPoiSource.count;
            break;
        case 4:
            return self.mixPoiSource.count;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [HomeHeadView heightForHeadCell];
        case 1:
            return [HRRecomendNotificationView heightForCell];
        case 2:
            return [HRHerePoisSetCell heightForCell];
        case 3:
            return [HRHerePoiCell heightForCell];
        case 4:
        {
            id poiSoure = self.mixPoiSource[indexPath.row];
            if ([poiSoure isKindOfClass:[HRPOIInfo class]]) {
                return [HRHerePoiCell heightForCell];
            }else{
                return [HRHerePoisSetCell heightForCell];
            }
        }
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.section) {
        case 0:
        {
            NSString * identify = NSStringFromClass([HomeHeadView class]);
            HomeHeadView * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HomeHeadView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.bgImageView.image = [UIImage imageNamed:@"poi_head_bg"];
                cell.mainLabel.text = @"ZHELI";
                cell.titleLabel.text = @"这里";
                cell.delegate = self;
            }
            NSInteger totalCount = self.catergoryInfo.food + self.catergoryInfo.tour + self.catergoryInfo.shop + self.catergoryInfo.hotel;
            cell.totalCountLabel.text =  [NSString stringWithFormat:@"%ld",totalCount];
            [cell setButtonSeletedAtIndex:self.catergoryIndex];
            if(self.catergoryInfo){
                [cell setcatergortCount:@[@(self.catergoryInfo.food),@(self.catergoryInfo.tour),@(self.catergoryInfo.shop),@(self.catergoryInfo.hotel)]];
            }
            
            return cell;
        }
            break;
        case 1:
        {
            return self.notificationCell;
        }
        case 2:
        {
            //附近
            NSString * identify = @"NearByCell";
            HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            
            [cell setData:self.nearyBySource[indexPath.row]];
            return cell;
        }
            break;
            
        case 3:
        {
            //我和朋友创建的七天以内的POI
            NSString * identify = NSStringFromClass([HRHerePoiCell class]);
            HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            HRPOIInfo * poiInfo = self.userPoiSource[indexPath.row];
            [cell setData:poiInfo];
            if (poiInfo.city_id != [[HRLocationManager sharedInstance] curCityId]) {
                [cell setLocaitonStr:poiInfo.city_name];
            }else{
                [cell setData:poiInfo];
            }
            
            return cell;

        }
            break;
            
        case 4:
        {
            id poiSoure = self.mixPoiSource[indexPath.row];
            if ([poiSoure isKindOfClass:[HRPOIInfo class]]) {
                
                NSString * identify = NSStringFromClass([HRHerePoiCell class]);
                HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.delegate = self;
                }
                HRPOIInfo * poiInfo = poiSoure;
                [cell setData:poiInfo];
                if (poiInfo.city_id != [[HRLocationManager sharedInstance] curCityId]) {
                    [cell setLocaitonStr:poiInfo.city_name];
                }else{
                    [cell setData:poiInfo];
                }
                return cell;
 
            }else{
                
                NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
                HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
                if (!cell) {
                    cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                    cell.delegate = self;
                }
                HRPOISetInfo * poiInfo = poiSoure;
                [cell setData:poiSoure];                
                [cell setLocaitonStr:poiInfo.city_name];
                BOOL isShowMask = poiInfo.poi_type == 17;
                [cell setUserInteractionEnabled:!isShowMask];
                [cell showMask:isShowMask];
                return cell;
            }

        }
            break;
        default:
            break;
    }
    return [UITableViewCell new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.myNavController setNavigationBarHidden:scrollView.contentOffset.y > 0 animated:NO];
}

#pragma mark - Action
- (void)homeHeadView:(HomeHeadView *)view DidSeletedIndex:(NSInteger)index
{
    self.catergoryIndex = index;
    [self quaryData];
}

- (void)homeHeadViewDidCancelSeleted:(HomeHeadView *)view
{
    self.catergoryIndex = -1;
    [self quaryData];
}

- (void)herePoiCellDidClick:(HRHerePoiCell *)cell
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:cell.data.poi_id] animated:YES];
}

- (void)herePoisSetCellDidClick:(HRHerePoisSetCell *)cell
{
    
    if (cell.data.poi_type == 18) {
        //引导页面
        [[self myTabBarcontroller] setSelectedIndex:2];
        
        if ([[[(UINavigationController *) [[self myTabBarcontroller]  selectedViewController] viewControllers] firstObject] respondsToSelector:@selector(showLoginPage)]) {
            [[[(UINavigationController *) [[self myTabBarcontroller]  selectedViewController] viewControllers] firstObject] performSelector:@selector(showLoginPage)];
        }

        return;
    }
    
    if (cell.data.poi_type == 16) {
        //引导页面
        [[self myTabBarcontroller] setSelectedIndex:3];
        if ([[[(UINavigationController *) [[self myTabBarcontroller]  selectedViewController] viewControllers] firstObject] respondsToSelector:@selector(showLoginPage)]) {
            [[[(UINavigationController *) [[self myTabBarcontroller]  selectedViewController] viewControllers] firstObject] performSelector:@selector(showLoginPage)];
        }

        return;
    }

    if(cell.data.poi_type == 15) return;
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    KPoiSetsCreteType tpye = KPoiSetsCreteNearBy;
    if (indexPath.section == 2) {
        //附近
        tpye = KPoiSetsCreteNearBy;
    }
    
    if(indexPath.section == 3){
        //我和朋友创建的七天以内的POI
        tpye = KPoiSetsCreteUser;
    }
    
    if(indexPath.section == 4){
        if ([cell.data.creator_id isEqualToString:@"0"]) {
            //编辑
            tpye = KPoiSetsCreteHere;
        }else{
            tpye = KPoiSetsCreteUser;
        }
    }
    
    HRPoiSetsController * poiSetController = [[HRPoiSetsController alloc] initWithPoiSetCreteType:tpye creteId:cell.data.creator_id city_Id:cell.data.city_id cityName:cell.data.city_name poiNumber:cell.data.poi_num poiName:cell.data.title creteUserName:cell.data.creator_name  category:cell.data.type];
    [self.myNavController pushViewController:poiSetController animated:YES];

}

- (void)herePoisSetCellDidClickUserPortrait:(HRHerePoisSetCell *)cell
{
    
    
    if (cell.data.poi_type == 16 || cell.data.poi_type == 18 || cell.data.poi_type == 15) {
        //引导页面
        return;
    }
    
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 2) {
        //附近没有用户头像
        return;
    }else{
        
        if ([cell.data.creator_id isEqualToString:@"0"]) {
            //编辑
        }else{
            HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.data.creator_id];
            [self.myNavController pushViewController:userHomeController animated:YES];
        }
        //编辑集合 | 用户创建
    }
}

- (void)herePoiCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    
    if (indexPath.section == 2) {
        //附近没有用户头像
        return;
    }else{
        
        if ([cell.data.creator_id isEqualToString:@"0"]) {
            //编辑
        }else{
//            编辑集合 | 用户创建
            if (!cell.data.creator_id.length) {
//                [self showTotasViewWithMes:@"服务器bug,数据用户ID是空"];
                return;
            }
            
            if (cell.data.single_type == 5) {
                HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.data.xq_user_id];
                [self.myNavController pushViewController:userHomeController animated:YES];
            }else{
                HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.data.creator_id];
                [self.myNavController pushViewController:userHomeController animated:YES];
            }
          
        }
    }
}

#pragma mark - Login
- (void)userLoginChnage:(id)sender
{
    [self quaryData];
}

- (void)recomendButtonDidClick:(UIButton *)button
{
    [self.myNavController pushViewController:[[PoiRecomendListController alloc] init] animated:YES];
}

#pragma mark Debug
- (void)debugButtonDidclick:(UIButton *)button
{
    [self.myNavController pushViewController:[[PoiRecomendListController alloc] init] animated:YES];
}

@end
