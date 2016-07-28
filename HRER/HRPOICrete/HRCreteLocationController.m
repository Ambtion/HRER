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

@interface HRCreteLocationController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HRCreateCategoryCell,FindCityViewControllerDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)UIButton * rightButton;

/**
 *  CityInfo
 */
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)CGFloat lat;
@property(nonatomic,assign)CGFloat lng;

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
    self.categortIndex = 0;
    [self initUI];
//    [self quaryData];
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
    
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 66, 26, 66, 33)];
    [self.rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(onRignthButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.view addSubview:self.rightButton];
    
}

- (void)initContentView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
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
}

- (void)quaryData
{
    
    //未登录弹出登录
    if (![[LoginStateManager getInstance] userLoginInfo]) {
        [HRLoginManager showLoginView];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(weakSelf);
    
    [NetWorkEntity quartPoiListWithKeyWord:!self.inputView.textFiled.text.length ? @"美食" : self.inputView.textFiled.text poiType:self.categortIndex lat:self.lat  loc:self.lng success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        NSArray * poiS = [responseObject objectForKey:@"pois"];
        weakSelf.dataArray = [weakSelf analysisPoiModelFromArray:poiS];
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
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
            [mArray addObject:model];
        }
    }
    return mArray;
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
        poiCell.data = self.dataArray[indexPath.row];
        return poiCell;
    }
    
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HRCretePOIInfo * creteInfo = self.dataArray[indexPath.row];
    [HRUPloadImageView showInView:[self.myNavController view] withPoiTitle:creteInfo.title address:creteInfo.subTitle loc:creteInfo.location categoryType:self.categortIndex callBack:^(BOOL isSucesss) {
    }];
}

- (void)onRignthButtonDidClick:(UIButton *)button
{
    FindCityViewController * controller = [[FindCityViewController alloc] init];
    controller.delegate = self;
    [self.myNavController pushViewController:controller animated:YES];
    
}

- (void)findCityViewControllerDidCurCity
{
    self.cityName = [[HRLocationManager sharedInstance] cityName];
    self.cityId = [[HRLocationManager sharedInstance] curCityId];
    self.lat = [[HRLocationManager sharedInstance] curLocation].coordinate.latitude;
    self.lng = [[HRLocationManager sharedInstance] curLocation].coordinate.longitude;
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
    self.cityId = [[cityInfo objectForKey:@"id"] integerValue];
    self.cityName = [cityInfo objectForKey:@"city_name"];
    self.lat = [[cityInfo objectForKey:@"latitude"] floatValue];
    self.lng = [[cityInfo objectForKey:@"longitude"] floatValue];
    [self.rightButton setTitle:self.cityName.length ? self.cityName : @"北京" forState:UIControlStateNormal];
    [self quaryData];
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)createCategoryCellDidSeletedIndex:(NSInteger)index
{
    self.categortIndex = index;
    [self quaryData];
}

#pragma mark MapPoi
- (void)onNoFoundTipsDidClick:(id)sender
{
    HRLocationMapController * controller =  [[HRLocationMapController alloc] init];
    [self.myNavController pushViewController:controller animated:YES];
}

@end
