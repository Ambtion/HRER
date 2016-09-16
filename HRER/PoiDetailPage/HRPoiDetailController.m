//
//  HRPoiDetailController.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiDetailController.h"
#import "HRPoiDetailPhotosCell.h"
#import "HRPoiLocInfoCell.h"
#import "HRPoiCreateInfoCell.h"
#import "HRRecomendCell.h"
#import "HRNavMapController.h"
#import "HRPhotoBrowser.h"
#import "HRUserHomeController.h"
#import "RDRGrowingTextView.h"
#import "RefreshTableView.h"
#import "HcdActionSheet.h"

static CGFloat const MaxToolbarHeight = 200.0f;

@interface HRPoiDetailController()<UITableViewDelegate,
                                    UITableViewDataSource,
                                    SDPhotoBrowserDelegate,
                                    HRPoiDetailPhotosCellDelegat,
                                    HRRecomendCellDelegate,
                                    HRPoiCreateInfoCellDelegate,UITextViewDelegate>
{
    UIToolbar *_toolbar;

}

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSString * poiId;

@property(nonatomic,strong)HRPoiDetailPhotosCell * photoesCell;

@property(nonatomic,strong)RDRGrowingTextView * textView;

@property(nonatomic,strong)HRPOIInfo * poiInfo;
@property(nonatomic,strong)NSArray * recomendList;

//评论
@property(nonatomic,assign)CGFloat offsetY;
@property(nonatomic,strong)NSString * cmt_id; //要回复的评论
@end

@implementation HRPoiDetailController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithPoiId:(NSString *)poiId
{
    if (self = [super init]) {
        self.poiId = poiId;
        //注册键盘通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
#pragma mark - ViewLife
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self quartData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark  init
- (void)initUI
{
    [self initContentView];
    [self initNavBar];
}

- (void)initNavBar
{
    UIImageView * barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    barView.image = [UIImage imageNamed:@"nav_bg"];
    [self.view addSubview:barView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    self.titleLabel.text = @"";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    [barView addSubview:self.titleLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(onBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    [backButton setHidden:[self.myNavController viewControllers].count == 1 ? YES : NO];
    
    UIButton * shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 33 - 12, 26, 33, 33)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [shareButton addTarget:self action:@selector(onShareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];    
}

- (void)initContentView
{
    
    UIView * view = [UIView new];
    [self.view addSubview:view];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, self.view.width, self.view.height + 20) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
//    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
//    self.tableView.tableFooterView = view;
//    [self initRefreshView];
    
}

#pragma mark - Data
//- (void)initRefreshView
//{
//    self.tableView.refreshFooter.scrollView = nil;
//    self.tableView.refreshHeader.scrollView = nil;
////    WS(ws);
////    self.tableView.refreshHeader.beginRefreshingBlock = ^(){
////        [ws quartData];
////    };
//}

- (void)quartData
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WS(ws);
    void (^ failure)(AFHTTPRequestOperation *, NSError *) = ^(AFHTTPRequestOperation *operation, NSError *error){
        [ws netErrorWithTableView:nil];
    };
    
    [NetWorkEntity quaryPoiDetailInfoWithPoiId:self.poiId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            NSDictionary * response = [responseObject objectForKey:@"response"];
            NSDictionary * poiInfo = [response objectForKey:@"poi_detail"];
            ws.poiInfo = [HRPOIInfo yy_modelWithJSON:poiInfo];
            ws.titleLabel.text = ws.poiInfo.city_name;
            ws.recomendList = [ws analysisPoiModelFromArray:[response objectForKey:@"comments"]];
            [ws.tableView reloadData];
//            [[ws.tableView refreshHeader] endRefreshing];
        }else{
            [ws dealErrorResponseWithTableView:nil info:responseObject];
        }
    } failure:failure];
}

- (NSArray *)analysisPoiModelFromArray:(NSArray *)array
{
    if (![array isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray * mArray = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary * dic  in array) {
        HRRecomend * model = [HRRecomend yy_modelWithJSON:dic];
        if (model) {
            [mArray addObject:model];
        }
    }
    return mArray;
}


#pragma delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
            
        case 0:
        case 1:
        case 2:
            //图片
            //POI地理信息
            //POI用户描述
            return 1;
            break;
        case 3:
            //POI评论
            return self.recomendList.count ? self.recomendList.count + 2 : 0;
            break;
        default:
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            //图片
            return [HRPoiDetailPhotosCell heightForCell];
            break;
        case 1:
            //POI地理信息
            return [HRPoiLocInfoCell heightForCell];
            break;
        case 2:
            //POI用户描述
            return [HRPoiCreateInfoCell cellHeithForData:self.poiInfo];
            break;
        case 3:
            //POI评论
            if (indexPath.row == 0) {
                return 10.f;
            }else{
                if (indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1) {
                    return 6.f;
                }
            }
            return [HRRecomendCell heigthForCellWithData:self.recomendList[indexPath.row - 1]];
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            //图片
        {
            self.photoesCell = [tableView dequeueReusableCellWithIdentifier:@"HRPoiDetailPhotosCell"];
            if (!self.photoesCell) {
                self.photoesCell = [[HRPoiDetailPhotosCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPoiDetailPhotosCell"];
                self.photoesCell.delegate = self;
                
            }
            [self.photoesCell setDataImages:self.poiInfo.photos];
            return self.photoesCell;
        }
            break;
        case 1:
            //POI地理信息
        {
            
            HRPoiLocInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRPoiLocInfoCell"];
            if (!cell) {
                cell = [[HRPoiLocInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPoiLocInfoCell"];
                
            }
            [cell setDataSource:self.poiInfo];
            return cell;
        }
            break;
        case 2:
            //POI用户描述
        {
            HRPoiCreateInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRPoiCreateInfoCell"];
            if (!cell) {
                cell = [[HRPoiCreateInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRPoiCreateInfoCell"];
                cell.delegate = self;
            }
            [cell setDataSource:self.poiInfo];
            return cell;
        }
            break;
        case 3:
        {
            
            if (indexPath.row == 0) {
                
                UITableViewCell * topCell = [tableView dequeueReusableCellWithIdentifier:@"TopCell"];
                if (!topCell) {
                    topCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopCell"];
                    [topCell setUserInteractionEnabled:NO];
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Comment_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50)]];
                    imageView.frame = CGRectMake(10, 0,tableView.width - 20, 10);
                    [topCell.contentView addSubview:imageView];
                }
                return topCell;
                
            }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] -1){
                UITableViewCell * bottomCell = [tableView dequeueReusableCellWithIdentifier:@"BottomCell"];
                if (!bottomCell) {
                    bottomCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BottomCell"];
                    [bottomCell setUserInteractionEnabled:NO];
                    UIImageView * imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Comment_bg_2"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 50, 0, 50)]];
                    imageView.frame = CGRectMake(10, 0,tableView.width - 20, 6);
                    [bottomCell.contentView addSubview:imageView];
                }
                return bottomCell;
            }
            
            HRRecomendCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRRecomendCell"];
            if (!cell) {
                cell = [[HRRecomendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRRecomendCell"];
                cell.delegate = self;
            }
            [cell setDataSource:self.recomendList[indexPath.row - 1]];
            [cell.lineView setHidden:indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 2];
            return cell;
        }
            //POI评论
            
            break;
        default:
            break;
    }
    return [UITableViewCell new];
}

#pragma mark - Action
- (void)onBackButtonClick:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onShareButtonClick:(UIButton *)button
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {}
            break;
        case 1:
            //POI地理信息
        {
            HRNavMapController * navMap = [[HRNavMapController alloc] initWithPoiInfo:@[self.poiInfo] barTitle:self.poiInfo.city_name];
            [self.navigationController  pushViewController:navMap animated:YES];
        }
            break;
        case 2:
        {
        }
            break;
        case 3:
        {
        }
            break;
        default:
            break;
    }
}

- (void)poiDetailPhotosCellDidClickPhoto:(HRPoiDetailPhotosCell *)cell
{
    HRPhotoBrowser *browser = [[HRPhotoBrowser alloc] init];
    browser.currentImageIndex = [self.photoesCell seletedIndex];
    browser.sourceImagesContainerView = self.photoesCell;
    browser.imageCount = self.photoesCell.photosView.dataArray.count;
    browser.delegate = self;
    [browser show];

}

- (BOOL)photoBrowser:(HRPhotoBrowser *)browser loadingImage:(HRImageScaleView *)hrImageView withIndexPath:(NSInteger)index
{
    HRPotoInfo * photoInfo = [self.photoesCell.photosView.dataArray objectAtIndex:index];
    
    [hrImageView.imageView sd_setImageWithURL:[NSURL URLWithString:photoInfo.url] placeholderImage:[UIImage imageNamed:@"not_loaded"]];
    if (photoInfo.width && photoInfo.height ) {
        
        CGFloat scale = self.view.width / photoInfo.width;
        hrImageView.imageView.frame = CGRectMake(0, 0, self.view.width, photoInfo.height * scale);
    }
    hrImageView.imageView.centerY = self.view.height/2.f;
    return YES;
}


#pragma nark WantTogo
- (void)poiUserInfoCell:(HRPoiCreateInfoCell *)cell DidClickWantTogo:(UIButton *)button
{
    if (![[LoginStateManager getInstance] userLoginInfo]) {
        //未登录
        [HRLoginManager showLoginView];
        return;
    }
    
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntity quaryWantTogoPoidetailWithPoiId:self.poiInfo.poi_id wantTogo:!button.isSelected success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            ws.poiInfo.intend = !ws.poiInfo.intend;
            [button setSelected:ws.poiInfo.intend];
            [self showTotasViewWithMes:@"操作成功"];
        }else{
            [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        [ws showTotasViewWithMes:@"网络异常,稍后重试"];

    }];
}

#pragma mark -
- (BOOL)canBecomeFirstResponder
{
    return YES;
}
- (UIView *)inputAccessoryView
{
    if (_toolbar) {
        return _toolbar;
    }
    
    _toolbar = [UIToolbar new];
    
    RDRGrowingTextView *textView = [RDRGrowingTextView new];
    textView.font = [UIFont systemFontOfSize:14.0f];
//    textView.textColor = [UIColor blackColor];
    textView.textContainerInset = UIEdgeInsetsMake(4.0f, 3.0f, 3.0f, 3.0f);
    textView.layer.cornerRadius = 4.0f;
    textView.layer.borderColor = [UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:205.0f/255.0f alpha:1.0f].CGColor;
    textView.layer.borderWidth = 1.0f;
    textView.layer.masksToBounds = YES;
    textView.enablesReturnKeyAutomatically = YES;
    textView.returnKeyType = UIReturnKeySend;
    textView.delegate = self;
    [_toolbar addSubview:textView];
    
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    _toolbar.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[textView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    [_toolbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[textView]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
    [textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [textView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [_toolbar setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    
    [_toolbar addConstraint:[NSLayoutConstraint constraintWithItem:_toolbar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:MaxToolbarHeight]];
    
    self.textView = textView;
    [_toolbar setHidden:YES];
    
    return _toolbar;
}



#pragma mark 键盘出现和消失
#pragma mark keyBoard show/hide
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGRect boundsRect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (boundsRect.size.height == _toolbar.height) {
        return;
    }
    
    
    NSValue *keyboardBoundsValue = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardBounds;
    [keyboardBoundsValue getValue:&keyboardBounds];
    
    if (self.tableView.contentInset.bottom == 0) {
        self.offsetY =  self.tableView.contentOffset.y;
    }
    
    UIEdgeInsets e = UIEdgeInsetsMake(0, 0, keyboardBounds.size.height, 0);
    [[self tableView] setScrollIndicatorInsets:e];
    [[self tableView] setContentInset:e];
    [self.tableView setContentOffset:CGPointMake(0,
                                                 self.tableView.contentSize.height + self.tableView.contentInset.bottom - self.tableView.height)];
    [_toolbar setHidden:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGRect boundsRect = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (boundsRect.size.height == _toolbar.height) {
        return;
    }
    UIEdgeInsets e = UIEdgeInsetsMake(0, 0, 0, 0);
    [[self tableView] setScrollIndicatorInsets:e];
    [[self tableView] setContentInset:e];

    [self.tableView setContentOffset:CGPointMake(0,self.offsetY)];
    [_toolbar setHidden:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [self recomendTocmToRec:self.cmt_id];
        self.textView.text = nil;
        self.cmt_id = nil;
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - Recomend
- (void)poiUserInfoCellDidClickRecomend:(HRPoiCreateInfoCell *)cell
{
    
    if (![[LoginStateManager getInstance] userLoginInfo]) {
        //未登录
        [HRLoginManager showLoginView];
        return;
    }

    self.cmt_id = nil;
    [self.textView setPlaceText:@"评论"];
    [self.textView becomeFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.isDragging)
        [self.textView resignFirstResponder];
    
    //通过滑动的便宜距离重新给图片设置大小
    CGFloat yOffset = scrollView.contentOffset.y;
    if(yOffset < 0)
    {
        CGFloat heigth = [HRPoiDetailPhotosCell heightForCell] - yOffset;
        CGFloat scale = heigth / [HRPoiDetailPhotosCell heightForCell];
        self.photoesCell.frame = CGRectMake(0, yOffset, self.tableView.width * scale, [HRPoiDetailPhotosCell heightForCell] * scale);
        self.photoesCell.centerX = self.tableView.width/2.f;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

- (void)recomendCellDidClickUserButton:(HRRecomendCell *)cell withUserid:(NSString *)userid
{
    [self.textView resignFirstResponder];
    if (!userid.length) {
        return;
    }
    HRUserHomeController * userHomeController = [[HRUserHomeController alloc] initWithUserID:userid];
    [self.myNavController pushViewController:userHomeController animated:YES];
}

- (void)recomendCellDidClickRecomendButton:(HRRecomendCell *)cell
{
   
    
    [self.textView resignFirstResponder];
    if([cell.dataSource.user_id isEqualToString:[[LoginStateManager getInstance] userLoginInfo].user_id] ||
       [cell.dataSource.reply_id isEqualToString:[[LoginStateManager getInstance] userLoginInfo].user_id]){
        //删除个人评论或者个人的回复
        [self  deleteRecoemdWithCmtId:cell.dataSource.cmnt_id];
//    }else if (cell.dataSource.reply_id.length) {
//        
//        self.cmt_id = cell.dataSource.cmnt_id;
//        //回复回复了评论的某人的评论
//        [self.textView setPlaceText:[NSString stringWithFormat:@"回复%@:",cell.dataSource.reply_name]];
//        [self.textView becomeFirstResponder];
//    }else{
    }else{
     
        //回复某条评论
        self.cmt_id = cell.dataSource.cmnt_id;
        [self.textView setPlaceText:[NSString stringWithFormat:@"回复%@:",cell.dataSource.user_name]];
        [self.textView becomeFirstResponder];
    }
}

- (void)recomendTocmToRec:(NSString *)recId
{
    
    WS(ws);

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [NetWorkEntity recomendPoiWithPoiId:self.poiInfo.poi_id cmtToRec:recId content:[self.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [ws showTotasViewWithMes:@"评论成功"];
            [ws quartData];
        }else{
            [ws showTotasViewWithMes:@"评论失败"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:ws.view animated:YES];
        [ws showTotasViewWithMes:@"网络异常,稍后重试"];

    }];
}


#pragma mark - 删除评论
- (void)deleteRecoemdWithCmtId:(NSString *)cmtId
{
    
    for (UIView * view in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([view isKindOfClass:[HcdActionSheet class]]) {
            return;
        }
    }
    
    HcdActionSheet *sheet = [[HcdActionSheet alloc] initWithCancelStr:@"取消"
                                                    otherButtonTitles:@[@"删除"]
                                                          attachTitle:@"删除我的评论"];
    
    sheet.selectButtonAtIndex = ^(NSInteger index) {
        if (index == 1) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [NetWorkEntity deleteRecomendWithCmtId:cmtId success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                    [self showTotasViewWithMes:@"删除成功"];
                    [self quartData];
                }else{
                    [self showTotasViewWithMes:@"删除失败"];
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self showTotasViewWithMes:@"网络异常,稍后重试"];
            }];

        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:sheet];
    [sheet showHcdActionSheet];
}
@end
