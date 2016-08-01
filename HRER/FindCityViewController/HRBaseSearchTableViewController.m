//
//  HRBaseSearchTableViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#import "HRBaseSearchTableViewController.h"

@interface HRBaseSearchTableViewController () <UISearchDisplayDelegate, UISearchBarDelegate>

/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;

/**
 *  搜索框绑定的控制器
 */
@property (nonatomic) UISearchDisplayController *searchController;

/**
 *  查找搜索框目前文本是否为搜索目标文本
 *
 *  @param searchText 搜索框的文本
 *  @param scope      搜索范围
 */
- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope;

@end

@implementation HRBaseSearchTableViewController

#pragma mark - Action

- (void)voiceButtonClicked:(UIButton *)sender {
    [self.searchDisplayController setActive:YES animated:YES];
}

#pragma mark - Propertys
- (NSMutableArray *)filteredDataSource {
    if (!_filteredDataSource) {
        _filteredDataSource = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _filteredDataSource;
}

- (UISearchBar *)aSearchBar {
    if (!_aSearchBar) {
        
        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _aSearchBar.delegate = self;
        
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_aSearchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsDataSource = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _searchController.searchResultsTableView.clipsToBounds = YES;
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        _searchController.searchResultsTableView.tableFooterView = view;

        //自定义Search Bar样式
        _aSearchBar.backgroundImage = [[UIImage alloc] init];
        _aSearchBar.backgroundColor = RGBA(244, 246, 245, 1);
        
        UITextField *searchField = [_aSearchBar valueForKey:@"searchField"];
        if (searchField) {
            [searchField setBackgroundColor:[UIColor whiteColor]];
            searchField.font = [UIFont systemFontOfSize:14.f];
            searchField.placeholder = @"输入城市名字";
            searchField.textColor = RGBA(0x5b, 0x5b, 0x5b, 1);
            searchField.layer.cornerRadius = 4.0f;
            searchField.layer.borderColor = RGBA(0xcc, 0xcc, 0xcc, 1).CGColor;
            searchField.layer.borderWidth = 1;
            searchField.layer.masksToBounds = YES;
            searchField.top = 20;
        }
        
    }
    return _aSearchBar;
}

- (NSString *)getSearchBarText {
    return self.searchDisplayController.searchBar.text.lowercaseString;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configuraSectionIndexBackgroundColorWithTableView:self.tableView];
    
    self.tableView.tableHeaderView = self.aSearchBar;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView
{
    tableView.contentOffset = CGPointMake(0, -44);
    tableView.frame = CGRectMake(0, 20, self.view.width, self.view.height - 20);
    for (UIView * view in tableView.subviews) {
        if (view.height == 0.5) {
            [view setHidden:YES];
        }
        if([view isKindOfClass:NSClassFromString(@"UITableViewIndex")]){
            [view setHidden:YES];
        }
    }
}

#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope {
    
	[self.filteredDataSource removeAllObjects];
    
    for (NSDictionary *contacts in self.dataSource) {
        NSArray * list = [contacts objectForKey:@"list"];
        for (NSDictionary *  contact in list) {
            NSString *contactName = [contact valueForKey:@"city_name"];
            NSString *enName = [contact valueForKey:@"en_name"];

            NSRange nameRange = [[contactName lowercaseString] rangeOfString:[scope lowercaseString]];
            NSRange enNameResult = [[enName lowercaseString] rangeOfString:[scope lowercaseString]];
            
            if (nameRange.length || enNameResult.length) {
                [self.filteredDataSource addObject:contact];
            }
            
        }
    }
}

#pragma mark - SearchTableView Helper Method

- (BOOL)enableForSearchTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return YES;
    }
    return NO;
}

#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:self.searchDisplayController.searchBar.text];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [self.searchDisplayController.searchBar scopeButtonTitles][searchOption]];
    
    return YES;
}
#pragma mark - SearchBar Delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
}

#pragma mark - UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self enableForSearchTableView:tableView]) {
        return 1;
    }
    return self.dataSource.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return self.filteredDataSource.count;
    }
    
    if (section == 0) {
        return 2;
//        return 1 + (self.hotSource.count ? 1 : 0);
    }
    NSArray * list = [self.dataSource[section - 1] objectForKey:@"list"];
    return [list count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionIndexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (index == 0) {
        [self.tableView scrollRectToVisible:self.aSearchBar.frame animated:NO];
        return -1;
    }
    if(index == 1){
        [self.tableView setContentOffset:CGPointMake(0, 44)];
        return -1;
    }
    return index - 2;
    
}

#pragma mark - UITableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([self enableForSearchTableView:tableView]) {
        return nil;
    }
    if(section == 0) return nil;
    
    BOOL showSection = [[self.dataSource[section - 1] objectForKey:@"list"] count] != 0;
    //only show the section title if there are rows in the section
    return (showSection) ?  [self.dataSource[section - 1] objectForKey:@"section"] : nil;
    
}

@end
