//
//  FindCityViewController.h
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRBaseTableViewController.h"

@interface HRBaseSearchTableViewController : HRBaseTableViewController

/**
 *  搜索结果数据源
 */
@property (nonatomic, strong) NSMutableArray *filteredDataSource;

/**
 *  TableView右边的IndexTitles数据源
 */
@property (nonatomic, strong) NSArray *sectionIndexTitles;

/**
 *  判断TableView是否为搜索控制器的TableView
 *
 *  @param tableView 被判断的目标TableView对象
 *
 *  @return 返回是否为预想结果
 */
- (BOOL)enableForSearchTableView:(UITableView *)tableView;

/**
 *  获取搜索框的文本
 *
 *  @return 返回文本对象
 */
- (NSString *)getSearchBarText;

@end
