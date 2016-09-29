//
//  PoiRecomendListController.m
//  HRER
//
//  Created by quke on 16/7/26.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "PoiRecomendListController.h"
#import "PoiRecomendCell.h"
#import "HRUserHomeController.h"
#import "HRPoiDetailController.h"
#import "NetWorkEntity.h"


@interface PoiRecomendListController ()<UITableViewDataSource,UITableViewDelegate,PoiRecomendCellDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;


@end

@implementation PoiRecomendListController

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
    
    UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.text = @"评论消息";
    [barView addSubview:titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)initContentView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.inputView;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB_Color(0xec, 0xec, 0xec);
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    view.backgroundColor = [UIColor clearColor];
    UIButton * button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width,45)];
    [button setTitleColor:RGB_Color(0x79, 0x79, 0x79) forState:UIControlStateNormal];
    [button titleLabel].font = [UIFont systemFontOfSize:14.f];
    [button setTitle:@"查看之前的评论消息" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor whiteColor];
    [button addTarget:self action:@selector(onMoreRecomendClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    self.tableView.tableFooterView = view;
}

- (void)quaryData
{
    
    if(![MBProgressHUD HUDForView:self.view])
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetWorkEntity  quaryRecomendList:self.dataArray.count count:20 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * recomends = [[responseObject objectForKey:@"response"] objectForKey:@"comments"];
            NSMutableArray * source = [self analysisModelFromArray:recomends];
            if (self.dataArray.count) {
                [self.dataArray addObject:source];
            }else{
                self.dataArray = source;
            }
            [self.tableView reloadData];
        }else{
            [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
    }];
}

- (NSMutableArray *)analysisModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRRecomendDetail * model = [HRRecomendDetail yy_modelWithJSON:dic];
        if (model) {
            [mArray addObject:model];
        }
    }
    return mArray;
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [PoiRecomendCell heightForCell];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * iden =  @"PoiRecomendCell";
    PoiRecomendCell * cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[PoiRecomendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.delegate = self;
    }
    cell.dataSource = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark Action
- (void)buttonDidClick:(UIButton *)button
{
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)onMoreRecomendClick:(UIButton *)button
{
    [self quaryData];
}

- (void)poiRecomendCellDidClickPortrait:(PoiRecomendCell *)cell
{
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:cell.dataSource.user_id];
    [self.myNavController pushViewController:userHomeController animated:YES];
}

-(void)poiRecomendCellDidClickDetailPage:(PoiRecomendCell *)cell
{
    [self.myNavController pushViewController:[[HRPoiDetailController alloc] initWithPoiId:cell.dataSource.poi_id] animated:YES];

}
@end
