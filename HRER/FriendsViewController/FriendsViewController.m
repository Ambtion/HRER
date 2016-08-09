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
#import "SearchInPutView.h"
#import "HereDataModel.h"
#import "HRWebCatShare.h"
#import "HRQQManager.h"
#import "HRUserHomeController.h"

@interface FriendsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,BMOldFriendCellDelegate>

@property(nonatomic,strong)RefreshTableView * tableView;
@property(nonatomic,strong)NSArray * dataArray;

/**
 *  搜索框
 */
@property (nonatomic, strong) SearchInPutView *inputView;

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
    self.tableView.tableHeaderView = self.inputView;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    self.tableView.tableFooterView  = [self footView];
    
    [self initRefreshView];
    
}

- (void)showLoginPage
{
    //未登录弹出登录
    if (![[LoginStateManager getInstance] userLoginInfo] &&
        ![[self.navigationController topViewController] isKindOfClass:[HRLoginViewController class]]) {
        [HRLoginManager showLoginViewWithNavgation:self.myNavController];
        return;
    }
}

- (void)initRefreshView
{
    self.tableView.refreshFooter.scrollView = nil;
    
    WS(ws);
    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
        [ws quaryData];
    };
}

- (void)quaryData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(weakSelf);
    
    [NetWorkEntity quaryFriendsListWithFillter:self.inputView.textFiled.text  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSArray * list = [[responseObject objectForKey:@"response"] objectForKey:@"dataList"];
            NSMutableArray * listArray = [NSMutableArray arrayWithCapacity:0];
            if([list isKindOfClass:[NSArray class]]){
                for (int i = 0 ; i < list.count; i++) {
                    NSDictionary * dic = list[i];
                    HRFriendsInfo * friends = [HRFriendsInfo  yy_modelWithJSON:dic];
                    if (friends) {
                        [listArray addObject:friends];
                    }
                }
            }
            weakSelf.dataArray = listArray;
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.refreshHeader endRefreshing];
        }else{
            [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.inputView.textFiled resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.inputView.textFiled resignFirstResponder];
}

#pragma mark - SearchBar
- (SearchInPutView *)inputView
{
    if (!_inputView) {
        _inputView = [[SearchInPutView alloc] initWithFrame:CGRectMake(0, 0, 200, 55)];
        NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:@" 查找朋友/找到老朋友输入朋友昵称或这里护照号"];
        
        UIFont * font1 = [UIFont systemFontOfSize:14.f];
        UIColor * color1 = RGB_Color(0x59, 0x59, 0x59);
        UIFont * font2 = [UIFont systemFontOfSize:12.f];
        UIColor * color2 = RGB_Color(0xb9, 0xb9, 0xb9);
        
        CGFloat length = 11;
        [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, length)];
        [str addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, length)];
        
        [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(length, str.length - length)];
        [str addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(length, str.length - length)];
        _inputView.textFiled.attributedPlaceholder = str;
        [_inputView.textButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _inputView.textFiled.delegate = self;
    }
    return _inputView;
}

- (void)searchButtonClick:(UIButton *)button
{
    [self.inputView textBecomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self quaryData];
    return [[self inputView] textResignFirstResponder];
}


#pragma mark -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //新朋友
    //老朋友
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 2) {
        return 40.f;
    }
    return 0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 || section == 2) {
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
    return [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 2;
    }
    if (section == 3) {
        return self.dataArray.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        return [BMNewFriendsCell heighForCell];
    }
    if (indexPath.section == 3) {
        return [BMOldFriendCell heighForCell];
    }
    return 0.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1) {
        
        NSString * identify = NSStringFromClass([BMNewFriendsCell class]);
        
        BMNewFriendsCell * newCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!newCell) {
            
            newCell = [[BMNewFriendsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            if (indexPath.row == 0) {
                newCell.maintitle.text = @"微信朋友";
                newCell.subTitle.text =  @"去微信邀请朋友>";
            }else{
                newCell.maintitle.text = @"QQ朋友";
                newCell.subTitle.text =  @"去QQ邀请朋友>";
            }
        }
//        [newCell.lineView setHidden:indexPath.row != 1];
        
        return newCell;
        
    }else if (indexPath.section == 3) {
        
        NSString * identify = NSStringFromClass([BMOldFriendCell class]);
        
        BMOldFriendCell * oldCell = [tableView dequeueReusableCellWithIdentifier:identify];
        
        if (!oldCell) {
            
            oldCell = [[BMOldFriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            oldCell.delegate = self;
        }
        [oldCell setDataModel:self.dataArray[indexPath.row]];
        return oldCell;

    }
    
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)oldFriendCell:(BMOldFriendCell *)cell didClickFavButton:(UIButton *)button
{
    BOOL tofavState = NO;
    switch (cell.dataModel.isFollow) {
        case 0:
            //未关注
        {
            tofavState  = YES;
        }
            break;
            //关注
            break;
        case 1:
        case 2:
        {
            tofavState  = NO;
        }
            //相互关注
            break;
        default:
            break;
    }
    
    WS(weakSelf);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntity favFriends:cell.dataModel.uid isFav:tofavState success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            if(tofavState){
                [self showTotasViewWithMes:@"关注成功"];
            }else{
                [self showTotasViewWithMes:@"取消关注成功"];
            }
            [weakSelf quaryData];
        }else{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            [self shareToQQ];
        }else{
            [self shareToWeb];
        }
    }else{
        HRFriendsInfo * info = [self.dataArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:[[HRUserHomeController alloc] initWithUserID:info.uid] animated:YES];
    }
}

- (void)shareToQQ
{
    [[HRQQManager shareInstance] shareNewsWithImage:[UIImage imageNamed:@"add"] title:@"这里" Des:@"这里不错" link:@"http://www.baidu.com" WithCallBack:^(QQBaseResp *response) {
    }];
}

- (void)shareToWeb
{
    [HRWebCatShare sendWeixinWebContentTitle:@"这里" description:@"这里不错"  thumbImage:[UIImage imageNamed:@"add"] webpageURL:@"http://www.baidu.com" scene:WXSceneSession withcallBack:^(BaseResp *resp) {
        
    }];
}

@end

