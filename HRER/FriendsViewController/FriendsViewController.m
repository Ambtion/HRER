//
//  FriendsViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "FriendsViewController.h"
#import "BMNewFriendsCell.h"
#import "BMOldFriendCell.h"
#import "RefreshTableView.h"
#import "HRWebCatShare.h"
#import "HRQQManager.h"

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

@property(nonatomic,strong)NSString * fillterString;

/**
 *  搜索框
 */
@property (nonatomic, strong) UISearchBar *aSearchBar;

/**
 *  搜索框绑定的控制器
 */
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end


@implementation FriendsViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quaryData) name:LOGIN_IN object:nil];
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
    label.text = @"朋友在这里";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [barView addSubview:label];
}

- (void)initContentView
{
    self.tableView = [[RefreshTableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.aSearchBar;
    [self.view addSubview:self.tableView];
    
}

- (void)initRefreshView
{
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        [ws quaryData];
    };

    self.tableView.refreshFooter.scrollView = nil;
}



- (void)quaryData
{
 
    //未登录弹出登录
    if (![[LoginStateManager getInstance] userLoginInfo]) {
        [HRLoginManager showLoginView];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetWorkEntiry quaryFriendsListWithToken:[[[LoginStateManager getInstance] userLoginInfo] token] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            
        }else{

        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark - SearchBar
- (UISearchBar *)aSearchBar {
    if (!_aSearchBar) {
        _aSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 44)];
        _aSearchBar.delegate = self;
        
        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:_aSearchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsDelegate = self;
        _searchController.searchResultsDataSource = self;
    }
    return _aSearchBar;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(nullable NSString *)searchString
{
    [self.tableView reloadData];
    return NO;
}
#pragma mark - 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //新朋友
    //老朋友
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40.f)];
    bgView.backgroundColor = RGB_Color(0xde, 0x7c, 0x68);
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, tableView.width - 20, bgView.height)];
    label.textColor = RGB_Color(0xfd, 0xff, 0xff);
    label.font = [UIFont systemFontOfSize:12.f];
    [bgView addSubview:label];
    if (section == 0) {
        label.text = @"新朋友";
    }else{
        label.text = @"老朋友";
    }
    return bgView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return self.dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [BMNewFriendsCell heighForCell];
    }
    if (indexPath.section == 1) {
        return [BMOldFriendCell heighForCell];
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        NSString * identify = NSStringFromClass([BMNewFriendsCell class]);
        
        BMNewFriendsCell * newCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!newCell) {
            
            newCell = [[BMNewFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            if (indexPath.row == 0) {
                newCell.maintitle.text = @"微信朋友";
                newCell.subTitle.text =  @"去微信邀请朋友>";
            }else{
                newCell.maintitle.text = @"QQ朋友";
                newCell.subTitle.text =  @"去微信邀请朋友>";
            }
        }
        
        [newCell.lineView setHidden:indexPath.row == 1];
        
        return newCell;
        
    }else if (indexPath.section == 1) {
        
        NSString * identify = NSStringFromClass([BMOldFriendCell class]);
        
        BMOldFriendCell * newCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!newCell) {
            
            newCell = [[BMOldFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        
        return newCell;

    }
    
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self shareToQQ];
        }else{
            [self shareToWeb];
        }
    }
}

- (void)shareToQQ
{
    [[HRQQManager shareInstance] shareNewsWithImage:[UIImage imageNamed:@"add"] title:@"这里" Des:@"这里不错" link:@"http://www.baidu.con" WithCallBack:^(QQBaseResp *response) {
    }];
}

- (void)shareToWeb
{
    [HRWebCatShare sendWeixinWebContentTitle:@"这里" description:@"这里不错"  thumbImage:[UIImage imageNamed:@"add"] webpageURL:@"http://www.baidu.con" scene:WXSceneSession withcallBack:^(BaseResp *resp) {
        
    }];
}

@end

