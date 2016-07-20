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


@interface HRCreteLocationController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,HRCreateCategoryCell>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)UIButton * rightButton;
/**
 *  CityInfo
 */
@property(nonatomic,strong)NSString * cityName;
@property(nonatomic,assign)NSInteger cityId;

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
    self.categortIndex = 0;
    [self initUI];
    [self quaryData];
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
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
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
    
    [NetWorkEntity quartPoiListWithKeyWord:self.inputView.textFiled.text poiType:self.categortIndex success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
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
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRCreateCategoryCell heightForCell];
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
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (void)onRignthButtonDidClick:(UIButton *)button
{
    
}

- (void)createCategoryCellDidSeletedIndex:(NSInteger)index
{
    self.categortIndex = index;
    [self quaryData];
}

@end
