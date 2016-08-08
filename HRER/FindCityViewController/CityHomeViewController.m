//
//  CityHomeViewController.m
//  HRER
//
//  Created by kequ on 16/7/18.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "CityHomeViewController.h"
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

@interface CityHomeViewController()<UITableViewDelegate,UITableViewDataSource,HomeHeadViewDelegate,HRHerePoisSetCellDelegate,HRHerePoiCellDelegate>

@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,assign)NSInteger cityID;

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,assign)NSUInteger catergoryIndex;

@property(nonatomic,strong)HRCatergoryInfo * catergoryInfo;
@property(nonatomic,strong)NSArray * nearyBySource;
@property(nonatomic,strong)NSArray * userPoiSource;
@property(nonatomic,strong)NSArray * editPoiSource;
@property(nonatomic,strong)NSArray * userPoiSetsSource;
@property(nonatomic,strong)NSArray * editPoiSetsSource;

@end

@implementation CityHomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.myNavController setNavigationBarHidden:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.myNavController setNavigationBarHidden:NO];
}

- (instancetype)initWithCityId:(NSInteger )cityId cityName:(NSString *)cityName
{
    self = [super init];
    if (self) {
        self.cityID = cityId;
        self.cityName = cityName;
    }
    return self;
}

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
    
    self.catergoryIndex = 0;
    [self initUI];
    [self quaryData];
}

- (void)initUI
{
    UIView * view  = [UIView new];
    [self.view addSubview:view];
    
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self initRefreshView];
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
    
    __block NSInteger toutalNetCount = 4 + ([[LoginStateManager getInstance] userLoginInfo] ? 2 : 0);

    void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        [self netErrorWithTableView:self.tableView];
    };
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //获取类别数目
    [NetWorkEntity quaryCityTypeCount:self.cityID success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    
    //获取附件条目
    [NetWorkEntity quartCityNearByWithCityId:self.cityID catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

    
    //编辑创建的POI集合
    [NetWorkEntity quaryEditCretePoiListWithCityId:self.cityID catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * poiSets = [responseObject objectForKey:@"response"];
            self.editPoiSetsSource = [self analysisPoiSetsModelFromArray:poiSets];
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
    
    //编辑创建的单个POI
    [NetWorkEntity quaryEditCretePoiListWithCityId:self.cityID catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * poiList = [responseObject objectForKey:@"response"];
            self.editPoiSource = [self analysisPoiModelFromArray:poiList];
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
    
    //个人创建POI集合
    if([[LoginStateManager getInstance] userLoginInfo]){
        [NetWorkEntity quaryFreindsCretePoiSetListWithCityId:self.cityID catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                NSArray * poiSets = [responseObject objectForKey:@"response"];
                self.userPoiSource = [self analysisPoiModelFromArray:poiSets];
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
        [self.tableView reloadData];
        [self.tableView.refreshHeader endRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }


    [NetWorkEntity quaryFreindsCretePoiListWithCityId:self.cityID catergory:self.catergoryIndex + 1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * poiList = [responseObject objectForKey:@"response"];
            self.userPoiSetsSource = [self analysisPoiSetsModelFromArray:poiList];
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


#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // HeadView
    // 附件的POI集合
    // 我和朋友创建的单个POI
    // 我和朋友的POI集合
    // 编辑创建的单个POI
    // 编辑推荐的POI集合
    
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.nearyBySource.count;
            break;
        case 2:
            return self.userPoiSource.count;
            break;
        case 3:
            return self.userPoiSetsSource.count;
            break;
        case 4:
            return self.editPoiSource.count;
            break;
        case 5:
            return self.editPoiSetsSource.count;
        default:
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
        case 3:
        case 5:
            return [HRHerePoisSetCell heightForCell];
        case 2:
        case 4:
            return [HRHerePoiCell heightForCell];
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
                cell.titleLabel.text = self.cityName;
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonDidClick:)];
                [cell.titleLabel setUserInteractionEnabled:YES];
                [cell.titleLabel addGestureRecognizer:tap];
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
            //附近
            NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
            HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            
            [cell setData:self.nearyBySource[indexPath.row]];
            return cell;
        }
            break;
            
        case 2:
        {
            //我和朋友创建的POI
            NSString * identify = NSStringFromClass([HRHerePoiCell class]);
            HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            [cell setData:self.userPoiSource[indexPath.row]];
            return cell;
            
        }
            break;
            
        case 3:
        {
            NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
            HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            
            [cell setData:self.userPoiSetsSource[indexPath.row]];
            return cell;
        }
            break;
        case 4:
        {
            NSString * identify = NSStringFromClass([HRHerePoiCell class]);
            HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            [cell setData:self.editPoiSource[indexPath.row]];
//            [cell setLocaitonStr:self.cityName];
            return cell;
        }
            break;
            
        case 5:
        {
            NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
            HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
                cell.delegate = self;
            }
            
            [cell setData:self.editPoiSetsSource[indexPath.row]];
            return cell;
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

- (void)herePoiCellDidClick:(HRHerePoiCell *)cell
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:cell.data.poi_id] animated:YES];
}

- (void)herePoisSetCellDidClick:(HRHerePoisSetCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    KPoiSetsCreteType tpye = KPoiSetsCreteNearBy;
    if (indexPath.section == 1) {
        //附近
        tpye = KPoiSetsCreteNearBy;
    }
    
    if(indexPath.section == 3){
        //朋友
        tpye = KPoiSetsCreteUser;
    }
    
    if(indexPath.section == 5){
        tpye = KPoiSetsCreteHere;
        //编辑
    }
    HRPoiSetsController * poiSetController = [[HRPoiSetsController alloc] initWithPoiSetCreteType:tpye creteId:cell.data.creatorId creteUserName:cell.data.creatorName category:self.catergoryIndex];
    [self.myNavController pushViewController:poiSetController animated:YES];
}

- (void)herePoisSetCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1 || indexPath.section == 3 ) {
        //附近  //编辑
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.data.creator_id];
    [self.myNavController pushViewController:userHomeController animated:YES];
    
}

- (void)herePoiCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1 || indexPath.section == 3 ) {
        //附近  //编辑
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.data.creator_id];
    [self.myNavController pushViewController:userHomeController animated:YES];
}
#pragma mark - Login
- (void)userLoginChnage:(id)sender
{
    [self quaryData];
}

- (void)backButtonDidClick:(id)sender
{
    [self.myNavController popViewControllerAnimated:YES];
}

@end