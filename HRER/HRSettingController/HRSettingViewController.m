//
//  HRSettingViewController.m
//  HRER
//
//  Created by quke on 16/7/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRSettingViewController.h"
#import "BMSystemConfigPageCell.h"
#import "LoginStateManager.h"
#import "SectionHeaderView.h"
#import "LoginStateManager.h"
#import "HRSettingUserinfoCell.h"
#import "HRSettingNickController.h"
#import "HRSetBindController.h"
#import "HRResetPassControlller.h"
#import "NetWorkEntity.h"

#define TRIPHELPSYSCONFIGCELLHEIGTH (50.f)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface HRSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataSource;
@property(nonatomic,strong)UIButton * loginOutButton;

@end

@implementation HRSettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.myNavController setNavigationBarHidden:YES];
    [self loadData];
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
    [self initUI];

}

#pragma mark Data
- (void)loadData
{
    self.dataSource = @[
                        
                        @[@"", @"昵称",@"手机号",@"密码"],
                        @[@"微信绑定",@"QQ绑定"]
                        ];
    [self.tableView reloadData];
}

#pragma mark UI
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
    
    UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.text = @"设置";
    [barView addSubview:titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
}

- (void)initContentView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.inputView;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
    self.tableView.tableFooterView = view;
    
    self.loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 20, self.tableView.width - 32, 44)];
    self.loginOutButton.layer.cornerRadius = 4.f;
    [self.loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [[self.loginOutButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [self.loginOutButton setTitleColor:RGB_Color(0xf9, 0xda, 0xd5) forState:UIControlStateNormal];
    [self.loginOutButton setBackgroundColor:RGBA(225, 68, 48, 1)];
    [self.loginOutButton titleLabel].font = [UIFont systemFontOfSize:14.f];
    [self.loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginOutButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.loginOutButton];
    
}

#pragma mark - DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataSource objectAtIndex:section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 0) {
        return [HRSettingUserinfoCell heightForCell];
    }
    return TRIPHELPSYSCONFIGCELLHEIGTH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 9;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        EmptyHeaderView *headerView = [[EmptyHeaderView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 9.f)];
        return headerView;
    }
    
    return [UIView new];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HRUserLoginInfo * loginUserInfo = [[LoginStateManager getInstance] userLoginInfo];

    if (indexPath.row == 0 && indexPath.section == 0) {
        HRSettingUserinfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HRSettingUserinfoCell"];
        if (!cell) {
            cell = [[HRSettingUserinfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HRSettingUserinfoCell"];
            [cell.uploadImageButton addTarget:self action:@selector(uploadImagedidClic:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSURL * imageUrl = nil;
        if (loginUserInfo.image.length) {
            imageUrl = [NSURL URLWithString:loginUserInfo.image];
        }
        [cell.porView sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"man"]];
        cell.passLabel.text = loginUserInfo.passport_num;
        
        return cell;
        
    }else{
        
        static NSString *defaultIdentifier = @"defaultIdentifier";
        
        BMSystemConfigPageCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
        if (!cell) {
            cell = [[BMSystemConfigPageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
        }
        
    
        cell.titleLabel.text = [self.dataSource[indexPath.section] objectAtIndex:indexPath.row];
        
        UILabel * rightLabel = cell.subTtileLabel;
        
        if (indexPath.section == 0) {
            switch (indexPath.row) {
                case 0:
                    rightLabel.text = @"";
                    break;
                case 1:
                    rightLabel.text = loginUserInfo.name;
                    break;
                case 2:
                    rightLabel.text = loginUserInfo.phone;
                    break;
                case 3:
                    rightLabel.text = @"修改";
                    break;
                default:
                    rightLabel.text = @"";
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    rightLabel.text = loginUserInfo.weixin ? @"已绑定"  : @"未绑定";
                    rightLabel.textColor = !loginUserInfo.weixin ? RGBA(0xdb, 0x42, 0x22, 1) : RGBA(0x99, 0x99, 0x99, 1);
                    break;
                case 1:
                    rightLabel.text = loginUserInfo.qq ? @"已绑定"  : @"未绑定";
                    rightLabel.textColor = !loginUserInfo.qq ? RGBA(0xdb, 0x42, 0x22, 1) : RGBA(0x99, 0x99, 0x99, 1);
                    break;
                default:
                    break;
            }
        }
        CellPositionType postion = CellPositionFull;
        if(indexPath.row == 0 || (indexPath.row == 1 && indexPath.section == 0)){
            postion = CellPositionTop;
        }else if(indexPath.row == [self tableView:tableView numberOfRowsInSection:indexPath.section] - 1){
            postion = CellPositionBottom;
        }else{
            postion = CellPositionMiddle;
        }
        
        [cell setCellType:postion];
        
        return cell;
    }
    
    return [UITableViewCell new];
    
}

#pragma mark - Action
- (void)buttonDidClick:(UIButton *)button
{
    [self.myNavController popViewControllerAnimated:YES];
}


#pragma mark - Photo
- (void)uploadImagedidClic:(UIButton *)button
{
    //添加图片
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [action showInView:self.view];
}

#pragma mark Photo
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            //相机
            [self addImmagesFormCamera:YES];
            break;
        case 1:
            //相册
            [self addImmagesFormCamera:NO];
            break;
        default:
            break;
    }
}

- (void)addImmagesFormCamera:(BOOL)isFromCamera
{
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    if (isFromCamera) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType =
            UIImagePickerControllerSourceTypeCamera;
        }
        
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            imagePickerController.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
    }
    imagePickerController.allowsEditing = YES;
    //设置委托对象
    imagePickerController.delegate = self;
    [[self myNavController] presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    [[self myNavController] dismissViewControllerAnimated:YES completion:^{
        
    }];

    //获得编辑过的图片
    UIImage * editImage = [editingInfo objectForKey: @"UIImagePickerControllerEditedImage"];
    [self uploadUserImage:editImage];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [[self myNavController] dismissViewControllerAnimated:YES completion:^{
        
    }];
    //获得编辑过的图片
    UIImage * editImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self uploadUserImage:editImage];
}

- (void)uploadUserImage:(UIImage *)image
{
    
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetWorkEntity updateUserName:nil password:nil image:image bindweixin:-1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [ws showTotasViewWithMes:@"修改成功"];
            NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
            HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
            [[LoginStateManager getInstance] updateUserInfo:userInfo];
            [ws.tableView reloadData];
            
        }else{
            [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self myNavController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark Action
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            //用户信息
            if(indexPath.row == 1){
                //昵称
                HRSettingNickController * nickViewController = [[HRSettingNickController alloc] init];
                nickViewController.nickName = [[LoginStateManager getInstance] userLoginInfo].name;
                [self.myNavController pushViewController:nickViewController animated:YES];
                
            }
            
            if(indexPath.row == 2){
                //手机号
                [self.myNavController pushViewController:[[HRSetBindController alloc] init] animated:YES];
            }
            
            if(indexPath.row == 3){
                //修改密码
                [[self myNavController] pushViewController:[[HRResetPassControlller alloc] init] animated:YES];
            }
        }
            break;
        case 1:
        {
            //绑定设置
        }
        default:
            break;
    }
}

#pragma mark - LoginOut
- (void)loginButtonClick:(UIButton *)button
{
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确定退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = 200;
    alertView.delegate = self;
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!buttonIndex) return;
    [[LoginStateManager getInstance] logout];
    [self hiddenMessCountInTabBar];
    [self.myNavController popToRootViewControllerAnimated:NO];
    [self  jumpToHomePageWithQuary:NO];
}

@end


