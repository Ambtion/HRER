//
//  FindCityViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "FindCityViewController.h"

#import "RefreshTableView.h"
#import "HomeHeadView.h"
#import "HRHerePoiCell.h"
#import "HRHerePoisSetCell.h"
#import "HRHereBannerCell.h"
#import "HRPoiSetsController.h"
#import "HRPoiDetailController.h"
#import "NetWorkEntiry.h"
#import "HRLocationManager.h"
#import "HereDataModel.h"
#import "LoginStateManager.h"

@interface FindCityViewController()<UITableViewDelegate,UITableViewDataSource,HomeHeadViewDelegate,HRHerePoisSetCellDelegate,HRHerePoiCellDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,assign)NSUInteger catergoryIndex;

@property(nonatomic,strong)HRCatergpryInfo * catergoryInfo;
@property(nonatomic,strong)NSArray * nearyBySource;
@property(nonatomic,strong)NSArray * userPoiSource;
@property(nonatomic,strong)NSArray * editPoiSource;
@property(nonatomic,strong)NSArray * userPoiSetsSource;
@property(nonatomic,strong)NSArray * editPoiSetsSource;

@end

@implementation FindCityViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - ViewLife
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(self.isNeedRefresh){
        [self.tableView.refreshHeader beginRefreshing];
    }
    self.isNeedRefresh = NO;
}
#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.catergoryIndex = 0;
    self.isNeedRefresh = YES;
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginChnage:) name:LOGIN_IN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginChnage:) name:LOGIN_OUT object:nil];
    
    [self.tableView.refreshHeader beginRefreshing];
}

- (void)initUI
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49) style:UITableViewStylePlain];
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
        
        [MBProgressHUD showHUDAddedTo:ws.view animated:YES];
        
        void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
            [ws netErrorWithTableView:ws.tableView];
        };
        
        
        //获取类别数目
        [NetWorkEntiry quaryCityTypeCount:[[HRLocationManager sharedInstance] curCityId] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                NSDictionary * response  = [responseObject objectForKey:@"response"];
                HRCatergpryInfo * categoryInfo = [HRCatergpryInfo yy_modelWithJSON:response];
                if(categoryInfo){
                    
                    ws.catergoryInfo = categoryInfo;
                    
                    //获取附件条目
                    [NetWorkEntiry quartCityNearByWithCityId:[[HRLocationManager sharedInstance] curCityId] catergory:ws.catergoryIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                            NSArray * poiSets = [responseObject objectForKey:@"response"];
                            ws.nearyBySource = [ws analysisPoiSetsModelFromArray:poiSets];
                            
                            //编辑创建的POI集合
                            [NetWorkEntiry quaryEditCretePoiListWithCityId:[[HRLocationManager sharedInstance] curCityId] catergory:ws.catergoryIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                    NSArray * poiSets = [responseObject objectForKey:@"response"];
                                    ws.editPoiSetsSource = [ws analysisPoiSetsModelFromArray:poiSets];
                                    
                                    //编辑创建的单个POI
                                    [NetWorkEntiry quaryEditCretePoiListWithCityId:[[HRLocationManager sharedInstance] curCityId] catergory:ws.catergoryIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                            NSArray * poiList = [responseObject objectForKey:@"response"];
                                            ws.editPoiSource = [ws analysisPoiModelFromArray:poiList];
                                            
                                            //个人创建POI集合
                                            if([[LoginStateManager getInstance] userLoginInfo]){
                                                [NetWorkEntiry quaryFreindsCretePoiSetListWithCityId:[[HRLocationManager sharedInstance] curCityId] catergory:ws.catergoryIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                    
                                                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                                        NSArray * poiSets = [responseObject objectForKey:@"response"];
                                                        ws.userPoiSource = [ws analysisPoiModelFromArray:poiSets];
                                                        
                                                        [NetWorkEntiry quaryFreindsCretePoiListWithCityId:[[HRLocationManager sharedInstance] curCityId] catergory:ws.catergoryIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                            
                                                            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                                                NSArray * poiList = [responseObject objectForKey:@"response"];
                                                                ws.userPoiSetsSource = [ws analysisPoiSetsModelFromArray:poiList];
                                                                [ws.tableView reloadData];
                                                                [ws.tableView.refreshHeader endRefreshing];
                                                                [MBProgressHUD hideHUDForView:ws.view animated:YES];
                                                            }else{
                                                                [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
                                                            }
                                                            
                                                        } failure:failure];
                                                        
                                                    }else{
                                                        [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
                                                    }
                                                    
                                                } failure:failure];
                                            }else{
                                                [ws.tableView reloadData];
                                                [ws.tableView.refreshHeader endRefreshing];
                                                [MBProgressHUD hideHUDForView:ws.view animated:YES];
                                            }
                                            
                                        }else{
                                            [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
                                        }
                                        
                                    } failure:failure];
                                    
                                }else{
                                    [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
                                }
                                
                            } failure:failure];
                            
                        }else{
                            [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
                        }
                        
                    } failure:failure];
                    
                }else{
                }
            }else{
                [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
            }
        } failure:failure];
        
    };
    
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
                cell.mainLabel.text =  [[HRLocationManager sharedInstance] cityName];
                cell.titleLabel.text =  [[HRLocationManager sharedInstance] subCityName];
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
    [self.tableView.refreshHeader beginRefreshing];
}

- (void)herePoiCellDidClick:(HRHerePoiCell *)cell
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] init] animated:YES];
}

- (void)herePoisSetCellDidClick:(HRHerePoisSetCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        //附近
    }
    
    if(indexPath.section == 3){
        //朋友
    }
    
    if(indexPath.section == 5){
        //编辑
    }
    [self.myNavController pushViewController:[[HRPoiSetsController alloc] initWithDataSource:nil] animated:YES];
}

- (void)herePoisSetCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1 || indexPath.section == 3 ) {
        //附近  //编辑
        return;
    }
}

- (void)herePoiCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1 || indexPath.section == 3 ) {
        //附近  //编辑
        return;
    }
}

#pragma mark - Login
- (void)userLoginChnage:(id)sender
{
    [[[self tableView] refreshHeader] beginRefreshing];
}
@end
