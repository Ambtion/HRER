//
//  HRPoiSetsListView.m
//  HRER
//
//  Created by kequ on 16/6/15.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiSetsListView.h"
#import "HRHerePoiCell.h"
#import "NetWorkEntity.h"
#import "HRLocationManager.h"

@interface HRPoiSetsListView()<UITableViewDelegate,UITableViewDataSource,HRHerePoiCellDelegate>

@property(nonatomic,assign)KPoiSetsCreteType creteType;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)NSInteger categoryType;
@property(nonatomic,strong)NSString * userId;
@property(nonatomic,strong)NSString * userName;

@end

@implementation HRPoiSetsListView

- (instancetype)initWithFrame:(CGRect)frame
              PoiSetCreteType:(KPoiSetsCreteType)creteType
                      creteId:(NSString *)userID
                      city_Id:(NSInteger)cityId
                creteUserName:(NSString *)creteUserName
                     category:(NSInteger)categoryType
{
    if (self = [super initWithFrame:frame]) {
        self.userId = userID;
        self.userName = creteUserName;
        self.creteType = creteType;
        self.categoryType = categoryType;
        self.cityId = cityId;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self initNavBar];
    [self initTableView];
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
    
    WS(ws);

    [MBProgressHUD hideHUDForView:self animated:YES];
    
    void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        [ws netErrorWithTableView:ws.tableView];
    };
    
    [NetWorkEntity quaryPoiSetDetailListWithCreteType:ws.creteType cityId:ws.cityId catergory:ws.categoryType creteUserId:ws.userId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * poiList = [responseObject objectForKey:@"response"];
            ws.dataSource = [ws analysisPoiModelFromArray:poiList];
            [[ws.tableView refreshHeader] endRefreshing];
            [ws.tableView reloadData];
            [MBProgressHUD hideHUDForView:ws animated:YES];
        }else{
            [ws dealErrorResponseWithTableView:ws.tableView info:responseObject];
        }
    } failure:failure];
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

- (void)dealErrorResponseWithTableView:(RefreshTableView *)tableview info:(NSDictionary *)dic
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    [self showTotasViewWithMes:[[dic objectForKey:@"response"] objectForKey:@"errorText"]];
    [tableview.refreshHeader endRefreshing];
}

- (void)netErrorWithTableView:(RefreshTableView*)tableView
{
    [MBProgressHUD hideHUDForView:self animated:YES];
    [self showTotasViewWithMes:@"网络异常，稍后重试"];
    [tableView.refreshHeader endRefreshing];
}

#pragma mark - NavBar

- (void)initNavBar
{
    
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self addSubview:barView];
    
    self.titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.width, 44)];
    self.titelLabel.textAlignment = NSTextAlignmentCenter;
    self.titelLabel.textColor = [UIColor whiteColor];
    self.titelLabel.text = [self bartitle];
    [barView addSubview:self.titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.tag = 0;
    [self addSubview:backButton];
    
    UIButton * switchButton = [[UIButton alloc] initWithFrame:CGRectMake(self.width - 17 - 33, 26, 33, 33)];
    switchButton.tag = 1;
    [switchButton setImage:[UIImage imageNamed:@"list_map"] forState:UIControlStateNormal];
    [switchButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:switchButton];
}

- (void)buttonDidClick:(UIButton *)button
{
    if (button.tag == 0) {
        if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickBackButton:)]) {
            [_delegate poiSetsListViewdidClickBackButton:self];
        }
    }else{
        if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickListButton:)]) {
            [_delegate poiSetsListViewdidClickListButton:self];
        }
    }
}


#pragma mark - TableView

- (void)initTableView
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.width, self.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self addSubview:self.tableView];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRHerePoiCell heightForCell];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString * identify = NSStringFromClass([HRHerePoiCell class]);
    HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        cell.delegate = self;
    }
    [cell setData:self.dataSource[indexPath.row]];
    return cell;
}

- (void)herePoiCellDidClick:(HRHerePoiCell *)cell
{
    
    if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickDetailView:withDataSource:)]) {
        [_delegate poiSetsListViewdidClickDetailView:self withDataSource:cell.data];
    }
}

- (void)herePoiCellDidClickUserPortrait:(HRHerePoiCell *)cell
{
    if ([_delegate respondsToSelector:@selector(poiSetsListViewdidClickPortView: withDataSource:)]) {
        [_delegate poiSetsListViewdidClickPortView:self withDataSource:cell.data];
    }
}

#pragma mark - Title
- (NSString *)bartitle
{
    NSString * catergory = [self typeNameWithType:self.categoryType];
    NSString * str = @"";
    switch (self.creteType) {
        case KPoiSetsCreteNearBy: {
            str =  @"附近";
            break;
        }
        case KPoiSetsCreteUser: {
            str = [NSString stringWithFormat:@"%@",self.userName];
            break;
        }
        case KPoiSetsCreteHere: {
            str = @"这里";
            break;
        }
    }
    if (catergory.length) {
        str = [str stringByAppendingFormat:@" %@",catergory];
    }
    return str;
}

- (NSString *)typeNameWithType:(NSInteger)type
{
    switch (type) {
        case 1:
            return @"美食";
            break;
        case 2:
            return @"观光";
        case 3:
            return @"购物";
        case 4:
            return @"酒店";
        default:
            break;
    }
    return @"";
}

@end
