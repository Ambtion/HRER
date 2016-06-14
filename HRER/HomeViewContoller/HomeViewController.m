//
//  HomeViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HomeViewController.h"
#import "RefreshTableView.h"
#import "HomeHeadView.h"
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
    [self initRefreshView];
}

- (void)initRefreshView
{
    
    //    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        
    };
    
    self.tableView.refreshFooter.beginRefreshingBlock = ^(){
        
    };
    
    self.tableView.refreshFooter = nil;
    self.tableView.refreshHeader = nil;
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // HeadView
    // 城市List
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 20;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return [HomeHeadView heightForHeadCell];
            break;
        case 1:
            return [HRHerePoisSetCell heightForCell];
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
                cell.titleLabel.text = @"这里";
            }
            cell.totalCountLabel.text = @"128";
            [cell setcatergortCount:@[@28,@20,@20,@50,@10]];
            return cell;
        }
            break;
        case 1:
        {
            NSString * identify = NSStringFromClass([HRHerePoisSetCell class]);
            HRHerePoisSetCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
            if (!cell) {
                cell = [[HRHerePoisSetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            }
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

@end
