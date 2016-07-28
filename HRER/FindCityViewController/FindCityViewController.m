//
//  FindCityViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "FindCityViewController.h"
#import "RefreshTableView.h"
#import "SearchInPutView.h"
#import "JSonKit.h"
#import "HRCityCell.h"
#import "HRLocationCurCityCell.h"
#import "HRLocationManager.h"
#import "HRHotCityCell.h"
#import "CityHomeViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"


@interface FindCityViewController()<UITableViewDelegate,UITableViewDataSource,UISearchDisplayDelegate,UISearchBarDelegate,HRHotCityCellDelegate>
@property(nonatomic,strong)UIView * navBarView;
@end

@implementation FindCityViewController

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

#pragma mark - Init
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(244, 246, 245, 1);
    [self initNavBar];
    [self loadDataSource];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [barView setUserInteractionEnabled:YES];
    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    label.text = @"发现城市";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton setHidden:[self.myNavController viewControllers].count == 1 ? YES : NO];
    
    self.navBarView = barView;
}

- (void)loadDataSource
{
    NSString * path = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"txt"];
    NSData * date = [[NSData alloc] initWithContentsOfFile:path];
    self.dataSource = [date objectFromJSONData];
    
    NSMutableArray * titleArray = [NSMutableArray arrayWithCapacity:0];
    [titleArray addObject:UITableViewIndexSearch];
    [titleArray addObject:@"#"];
    for (NSDictionary * dic in self.dataSource) {
        [titleArray addObject:[dic objectForKey:@"section"]];
    }
    [titleArray addObject:@"#"];
    self.sectionIndexTitles = titleArray;
}

#pragma mark - Action
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && tableView != self.searchDisplayController.searchResultsTableView) {
        if(indexPath.row == 0){
            return [HRLocationCurCityCell heightForCell];
        }else{
            return [HRHotCityCell heightForCell];
        }
    }
    return 44.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //定位城市
    if (indexPath.section == 0 && tableView != self.searchDisplayController.searchResultsTableView) {
        
        if (indexPath.row == 0) {
            HRLocationCurCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRLocationCurCityCell"];
            if (!cell) {
                cell = [[HRLocationCurCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRLocationCurCityCell"];
            }
            cell.cityLabel.text = [[HRLocationManager sharedInstance] cityName];
            return cell;
 
        }else{
            HRHotCityCell * hotCell = [tableView dequeueReusableCellWithIdentifier:@"HRHotCityCell"];
            if (!hotCell) {
                hotCell = [[HRHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRHotCityCell"];
                hotCell.delegate = self;
            }
            hotCell.hotArray = self.hotSource;
            return hotCell;
        }
    }
    
    //热们城市
    
    HRCityCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRCityCell"];
    if (!cell) {
        cell = [[HRCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRCityCell"];
    }
    
    NSDictionary * cityInfo = nil;
    
    // 判断是否是搜索tableView
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // 获取联系人数组
        cityInfo = self.filteredDataSource[indexPath.row];
        
     }else{
        
        NSDictionary * dic = [self.dataSource objectAtIndex:indexPath.section - 1];
        NSArray * listArray = [dic objectForKey:@"list"];
        cityInfo = [listArray objectAtIndex:indexPath.row];
         
    }
    
    NSInteger rowcount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    if (rowcount == 1) {
        [cell setCellType:CellPositionFull];
    }else{
        if (indexPath.row == 0) {
            [cell setCellType:CellPositionTop];
        }else if(indexPath.row == rowcount - 1){
            [cell setCellType:CellPositionBottom];
        }else{
            [cell setCellType:CellPositionMiddle];
        }
    }
    cell.cityInfo = cityInfo;
    return cell;
}

#pragma mark - 
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    [self hidenBar];
}

- (void) searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    [self showNavBar];
}

- (void)showNavBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.navBarView setAlpha:1];
        self.tableView.frame = CGRectMake(0, 64, self.view.width, self.view.height - 64);
    }];
}

- (void)hidenBar
{
    [UIView animateWithDuration:0.3 animations:^{
        [self.navBarView setAlpha:0];
        self.tableView.frame = CGRectMake(0, 20, self.view.width, self.view.height - 20);
    }];
}


#pragma mark - Action
- (void)backButtonDidClick:(UIButton *)button
{
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)hotCityCellDidSeletedHotCity:(NSDictionary *)cityInfo
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && tableView != self.searchDisplayController.searchResultsTableView) {
        //当前城市
        if ([_delegate respondsToSelector:@selector(findCityViewControllerDidCurCity)]) {
            [_delegate findCityViewControllerDidCurCity];
        }else{
            NSString * cityName = [[HRLocationManager sharedInstance] cityName];
            NSInteger cityId = [[HRLocationManager sharedInstance] curCityId];
            [self.myNavController pushViewController:[[CityHomeViewController alloc] initWithCityId:cityId cityName:cityName] animated:YES];
        }
    }
    
    NSDictionary * cityInfo = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cityInfo = self.filteredDataSource[indexPath.row];
    }else{
        NSDictionary * dic = [self.dataSource objectAtIndex:indexPath.section - 1];
        NSArray * listArray = [dic objectForKey:@"list"];
        cityInfo = [listArray objectAtIndex:indexPath.row];
    }
    
    if([_delegate respondsToSelector:@selector(findCityViewControllerDidSeltedCityInfo:)]){
        [_delegate findCityViewControllerDidSeltedCityInfo:cityInfo];
    }else{
        NSString * cityName = [cityInfo objectForKey:@"city_name"];
        NSInteger cityId = [[cityInfo objectForKey:@"id"] integerValue];
        [self.myNavController pushViewController:[[CityHomeViewController alloc] initWithCityId:cityId cityName:cityName] animated:YES];
    }
    
}
@end
