//
//  HRCreteLocationController.m
//  HRER
//
//  Created by quke on 16/7/20.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRCreteLocationController.h"
#import "SearchInPutView.h"
#import "HRLocationManager.h"
#import "HRCreateCategoryCell.h"
#import "HRCretePoiCell.h"
#import "HRPoiNoFoundTipsView.h"
#import "HRLocationMapController.h"
#import "HRUPloadImageView.h"
#import "FindCityViewController.h"
#import "RefreshTableView.h"
#import "HRLocationManager.h"
#import "HRNavigationTool.h"

@interface HRCreteLocationController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HRCreateCategoryCell,FindCityViewControllerDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)UIButton * rightButton;

/**
 *  CityInfo
 */
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)double lat;
@property(nonatomic,assign)double lng;
@property(nonatomic,assign)NSInteger countyId;

/**
 *  搜索框
 */
@property (nonatomic, strong) SearchInPutView *inputView;


@property(nonatomic,assign)NSInteger categortIndex;

@end

@implementation HRCreteLocationController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavController setNavigationBarHidden:YES];
    [self.rightButton setTitle:self.cityName.length ? self.cityName : @"北京" forState:UIControlStateNormal];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quaryData) name:LOGIN_IN object:nil];
    self.cityId = [[HRLocationManager  sharedInstance] curCityId];
    self.cityName = [[HRLocationManager  sharedInstance] cityName];
    self.lat = [[[HRLocationManager  sharedInstance] curLocation] coordinate].latitude;
    self.lng = [[[HRLocationManager  sharedInstance] curLocation] coordinate].longitude;
    self.countyId = 11;
    self.categortIndex = 0;
    [self initUI];
    [self quaryData];
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

- (void)initUI
{
    [self initNavBar];
    [self initContentView];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"选择位置";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 86, 26, 66, 33)];
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(onRignthButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.rightButton];
    
    UIImageView * imageDwon = [[UIImageView alloc] initWithFrame:CGRectMake(self.rightButton.right - 2, 0, 9, 9)];
    imageDwon.image = [UIImage imageNamed:@"home_head_down"];
    imageDwon.centerY = self.rightButton.centerY;
    [self.view addSubview:imageDwon];
    
}

- (void)initContentView
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.inputView;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    HRPoiNoFoundTipsView* tipsView = [[HRPoiNoFoundTipsView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, [HRPoiNoFoundTipsView heightForView])];
    [tipsView addTarget:self action:@selector(onNoFoundTipsDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:tipsView];
    self.tableView.tableFooterView = view;
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    BOOL isUseGoogle = (self.countyId != 11);

//    暂时写死
//    isUseGoogle = YES;
    
    WS(weakSelf);
    
    [NetWorkEntity quaryPoiListWith:isUseGoogle
                            keyWord:self.inputView.textFiled.text
                            poiType:self.categortIndex + 1
                           countyId:self.countyId
                                lat:self.lat  loc:self.lng success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    
                                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                    [weakSelf.tableView.refreshHeader endRefreshing];
                                    if(!isUseGoogle){
                                        NSArray * poiS = [responseObject objectForKey:@"pois"];
                                        weakSelf.dataArray = [weakSelf analysisPoiModelFromArray:poiS];
                                    }else{
                                        NSArray * poiS = [responseObject objectForKey:@"results"];
                                        weakSelf.dataArray = [weakSelf analysisGooglePoiModelFromArray:poiS];
                                    }
                                    [weakSelf.tableView reloadData];
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    weakSelf.dataArray = nil;
                                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                                    [weakSelf.tableView reloadData];
                                    [weakSelf.tableView.refreshHeader endRefreshing];
                                }];
    
}

- (NSArray *)analysisPoiModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRCretePOIInfo * model = [HRCretePOIInfo yy_modelWithJSON:dic];
        if (model) {
            NSArray * locArray = [[model location] componentsSeparatedByString:@","];
            if (locArray.count == 2) {
                CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:[[locArray lastObject] floatValue] longitude:[[locArray firstObject] floatValue]];
                model.distance = [HRNavigationTool distancenumberBetwenOriGps:[[HRLocationManager sharedInstance] curLocation].coordinate desGps:desLocaiton.coordinate];
                
            }
            [mArray addObject:model];
        }
    }
    return [self sortArray:mArray];
}


- (NSArray *)analysisGooglePoiModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRGooglPoiInfo * model = [HRGooglPoiInfo yy_modelWithJSON:dic];
        if (model) {
            NSDictionary * geometry = [dic objectForKey:@"geometry"];
            NSDictionary * loc = [geometry objectForKey:@"location"];
            model.location = [NSString stringWithFormat:@"%@,%@",[loc objectForKey:@"lng"],[loc objectForKey:@"lat"]];
            
            NSArray * locArray = [[model location] componentsSeparatedByString:@","];
            if (locArray.count == 2) {
                CLLocation * desLocaiton = [[CLLocation alloc] initWithLatitude:[[locArray lastObject] floatValue] longitude:[[locArray firstObject] floatValue]];
                model.distance = [HRNavigationTool distancenumberBetwenOriGps:[[HRLocationManager sharedInstance] curLocation].coordinate desGps:desLocaiton.coordinate];
                
            }
            
            [mArray addObject:model];
        }
    }
    return [self sortArray:mArray];
}

- (NSArray *)sortArray:(NSArray *)array
{
    NSComparator cmptr = ^(HRGooglPoiInfo * obj1, HRGooglPoiInfo * obj2){
        if ([obj1 distance] > [obj2 distance]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 distance] < [obj2 distance]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    
    return [array sortedArrayUsingComparator:cmptr];
}

#pragma mark - SearchBar
- (SearchInPutView *)inputView
{
    if (!_inputView) {
        _inputView = [[SearchInPutView alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
        _inputView.textFiled.placeholder = @"搜索想推荐地点";
        [_inputView.textButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _inputView.textFiled.delegate = self;
    }
    return _inputView;
}

- (void)searchButtonClick:(UIButton *)button
{
    [self.inputView textBecomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self quaryData];
    return [[self inputView] textResignFirstResponder];
}


#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return self.dataArray.count;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return [HRCreateCategoryCell heightForCell];
            break;
        case 1:
            return [HRCretePoiCell heightforCell];
            break;
        default:
            break;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        HRCreateCategoryCell * cateCell = [tableView dequeueReusableCellWithIdentifier:@"HRCreateCategoryCell"];
        if (!cateCell) {
            cateCell = [[HRCreateCategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HRCreateCategoryCell"];
            cateCell.delegate = self;
        }
        [cateCell setSeletedAtIndex:self.categortIndex];
        return cateCell;
    }
    if (indexPath.section == 1) {
        HRCretePoiCell * poiCell = [tableView dequeueReusableCellWithIdentifier:@"HRCretePoiCell"];
        if (!poiCell) {
            poiCell = [[HRCretePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRCretePoiCell"];
        }
        UIImage * image =  [self imageForType:self.categortIndex];
        poiCell.portraitImage.image = image;
        poiCell.data = self.dataArray[indexPath.row];
        return poiCell;
    }
    
    return [UITableViewCell new];
}

- (UIImage *)imageForType:(NSInteger)type
{
    switch (type) {
        case 0:
            return [UIImage imageNamed:@"food_select"];
            break;
        case 1:
            return [UIImage imageNamed:@"look_select"];
        case 2:
            return [UIImage imageNamed:@"shopping_select"];
        case 3:
            return [UIImage imageNamed:@"hotel_select"];
        default:
            break;
    }
    return [UIImage imageNamed:@"not_loaded"];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    HRCretePOIInfo * creteInfo = self.dataArray[indexPath.row];
    [HRUPloadImageView showInView:[self.myNavController view] withPoiTitle:creteInfo.title cityId:self.cityId address:creteInfo.subTitle loc:creteInfo.location categoryType:self.categortIndex + 1 callBack:^(BOOL isSucesss) {
    }];
}

- (void)onRignthButtonDidClick:(UIButton *)button
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    FindCityViewController * controller = [[FindCityViewController alloc] init];
    controller.delegate = self;
    [self.myNavController pushViewController:controller animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)findCityViewControllerDidCurCity
{
    self.cityName = [[HRLocationManager sharedInstance] cityName];
    self.cityId = [[HRLocationManager sharedInstance] curCityId];
    self.lat = [[HRLocationManager sharedInstance] curLocation].coordinate.latitude;
    self.lng = [[HRLocationManager sharedInstance] curLocation].coordinate.longitude;
    self.countyId = 11;
    [self.rightButton setTitle:self.cityName.length ? self.cityName : @"北京" forState:UIControlStateNormal];
    [self quaryData];
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)findCityViewControllerDidSeltedCityInfo:(NSDictionary *)cityInfo
{
/*
    beentocounts = 16;
    "city_name" = "\U963f\U5df4\U574e";
    "country_id" = 208;
    "en_name" = Abakan;
    id = 7092;
    latitude = "53.715557";
    livedcounts = 0;
    longitude = "91.429169";
    pingyin = abakan;
    plantocounts = 6;
    status = 1;
*/
    
    if ([cityInfo objectForKey:@"city_id"]) {
        self.cityId = [[cityInfo objectForKey:@"city_id"] integerValue];
    }else{
        self.countyId = [[cityInfo objectForKey:@"id"] intValue];
    }
    self.cityName = [cityInfo objectForKey:@"city_name"];
    self.lat = [[cityInfo objectForKey:@"latitude"] floatValue];
    self.lng = [[cityInfo objectForKey:@"longitude"] floatValue];
    if ([cityInfo objectForKey:@"country_id"]) {
        self.countyId = [[cityInfo objectForKey:@"country_id"] intValue];
    }else{
        self.countyId = [[cityInfo objectForKey:@"ctry_id"] intValue];
    }
    [self.rightButton setTitle:self.cityName.length ? self.cityName : @"北京" forState:UIControlStateNormal];
    [self quaryData];
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)createCategoryCellDidSeletedIndex:(NSInteger)index
{
    self.categortIndex = index;
    [self quaryData];
}

- (void)createCategoryCellDidCancelSeletedIndex
{
    self.categortIndex = -1;
    [self quaryData];
}

#pragma mark MapPoi
- (void)onNoFoundTipsDidClick:(id)sender
{
    HRLocationMapController * controller =  [[HRLocationMapController alloc] init];
    if (self.lat == [[[HRLocationManager  sharedInstance] curLocation] coordinate].latitude &&
        self.lng == [[[HRLocationManager  sharedInstance] curLocation] coordinate].longitude) {
        controller.lat = -1;
        controller.lng = -1;
    }else{
        controller.lat = self.lat;
        controller.lng = self.lng;

    }
    controller.cityName = self.cityName;
    controller.cityId = self.cityId;
    [self.myNavController pushViewController:controller animated:YES];

}

@end
