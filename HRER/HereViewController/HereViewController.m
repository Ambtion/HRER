//
//  HereViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HereViewController.h"
#import "RefreshTableView.h"



@interface HereViewController()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation HereViewController

#pragma mark - ViewLife
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self initUI];
}

//- (void)initUI
//{
//    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStylePlain];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
//    [self.view addSubview:self.tableView];
//    
//    [self initRefreshView];
//}
//
//- (void)initRefreshView
//{
////    WS(ws);
//    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
//        
//    };
//    
//    self.tableView.refreshFooter.beginRefreshingBlock = ^(){
//    
//    };
//}
//
//#pragma mark - TableViewDelegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 40;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return [HRHerePoiCell heightForCell];
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSString * identify = NSStringFromClass([HRHerePoiCell class]);
//    HRHerePoiCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
//    if (!cell) {
//        cell = [[HRHerePoiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
//    }
//    return cell;
//}
@end
