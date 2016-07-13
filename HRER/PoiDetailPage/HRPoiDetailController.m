//
//  HRPoiDetailController.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiDetailController.h"
#import "HRPoiDetailPhotosCell.h"
#import "HRPoiLocInfoCell.h"

@interface HRPoiDetailController()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UITableView * tableView;

@end

@implementation HRPoiDetailController


#pragma mark - ViewLife
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark  init
- (void)initUI
{
    [self initContentView];
    [self initNavBar];

}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    self.titleLabel.text = @"北京";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [barView addSubview:self.titleLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton * shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 33 - 12, 26, 33, 33)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [shareButton addTarget:self action:@selector(onShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
}

- (void)initContentView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = RGB_Color(236, 236, 236);
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    self.tableView.tableFooterView = view;
    
}



#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case 0:
        case 1:
        case 2:
            //图片
            //POI地理信息
            //POI用户描述
            return 1;
            break;
        case 3:
            //POI评论
            return 1;
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
            //图片
            return [HRPoiDetailPhotosCell heightForCell];
            break;
        case 1:
            //POI地理信息
            return [HRPoiLocInfoCell heightForCell];
            break;
        case 2:
            //POI用户描述
            break;
        case 3:
            //POI评论
            
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            //图片
        {
            HRPoiDetailPhotosCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRPoiDetailPhotosCell"];
            if (!cell) {
                cell = [[HRPoiDetailPhotosCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPoiDetailPhotosCell"];
                
            }
            [cell setDataImages:nil];
            return cell;
        }
            break;
        case 1:
            //POI地理信息
        {
            
            HRPoiLocInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRPoiLocInfoCell"];
            if (!cell) {
                cell = [[HRPoiLocInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPoiLocInfoCell"];
                
            }
            [cell setDataSource:nil];
            return cell;
        }
            break;
        case 2:
            //POI用户描述
        {
        
        }
            break;
        case 3:
            //POI评论
            
            break;
        default:
            break;
    }
    return [UITableViewCell new];
}


#pragma mark - Action
- (void)onBackButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onShareButtonClick:(UIButton *)button
{
    
}
@end
