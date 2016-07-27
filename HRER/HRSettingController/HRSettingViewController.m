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

#define TRIPHELPSYSCONFIGCELLHEIGTH (50.f)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface HRSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)NSArray * dataSource;
@end

@implementation HRSettingViewController

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
    [self initUI];
    [self loadData];

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
    
    if([self.myNavController viewControllers].count > 1){
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        self.tableView.tableFooterView = view;
    }
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
        [cell.porView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"man"]];
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
                default:
                    rightLabel.text = @"";
                    break;
            }
        }else{
            switch (indexPath.row) {
                case 0:
                    rightLabel.text = @"";
                    break;
                case 1:
                    
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
    
    //获得编辑过的图片
//    UIImage * editImage = [editingInfo objectForKey: @"UIImagePickerControllerEditedImage"];

    
    [[self myNavController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
//    UIImage * editImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self myNavController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}



@end


