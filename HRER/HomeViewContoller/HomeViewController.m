//
//  HomeViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HomeViewController.h"
#import "RefreshTableView.h"
#import "HRHerePoiCell.h"
#import "HRHerePoisSetCell.h"

@interface HomeViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSMutableArray * dataSource;

@end

@implementation HomeViewController

#pragma mark - ViewLife
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
}

- (void)initUI
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
//    [self initRefreshView];
}

- (void)initRefreshView
{
    //    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        
    };
    
    self.tableView.refreshFooter.beginRefreshingBlock = ^(){
        
    };
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [HRHerePoisSetCell heightForCell];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
    HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    return cell;
}

@end
