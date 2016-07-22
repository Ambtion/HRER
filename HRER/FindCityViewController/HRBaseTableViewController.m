//
//  HRBaseTableViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRBaseTableViewController.h"

@interface HRBaseTableViewController ()

/**
 *  判断tableView是否支持iOS7的api方法
 *
 *  @return 返回预想结果
 */
- (BOOL)validateSeparatorInset;

@end

@implementation HRBaseTableViewController

#pragma mark - Publish Method

- (void)configuraTableViewNormalSeparatorInset {
    if ([self validateSeparatorInset]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)configuraSectionIndexBackgroundColorWithTableView:(UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
}

- (void)loadDataSource {
    // subClasse
}

#pragma mark - Propertys

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect tableViewFrame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
        _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:self.tableViewStyle];
        _tableView.delegate = self;
        _tableView.dataSource = self;        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _tableView.tableFooterView = view;

    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _dataSource;
}

#pragma mark - Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

#pragma mark - TableView Helper Method

- (BOOL)validateSeparatorInset {
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        return YES;
    }
    return NO;
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


@end
