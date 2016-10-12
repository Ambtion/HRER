//
//  HRSettingNickController.m
//  HRER
//
//  Created by kequ on 16/7/27.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRSettingNickController.h"
#import "HRInPutView.h"
#import "EmojiUnit.h"

@interface HRSettingNickController()

@property(nonatomic,strong)HRInPutView * nickText;

@end

@implementation HRSettingNickController

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
    self.view.backgroundColor =  RGB_Color(0xec, 0xec, 0xec);
    [self initUI];
    
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
    
    UILabel * titelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.width, 44)];
    titelLabel.textAlignment = NSTextAlignmentCenter;
    titelLabel.textColor = [UIColor whiteColor];
    titelLabel.text = @"修改昵称";
    [barView addSubview:titelLabel];
    
    UIButton * backButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 26, 33, 33)];
    [backButton setImage:[UIImage imageNamed:@"list_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    
    UIButton * donebutton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 17 - 33, 26, 33, 33)];
    [donebutton setTitle:@"保存" forState:UIControlStateNormal];
    donebutton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [donebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [donebutton addTarget:self action:@selector(doneButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:donebutton];
}

- (void)initContentView
{
    self.nickText = [self createTextFileWithFont:[UIFont systemFontOfSize:14] placeholderPlaceText:@"输入昵称"];
    [self.view  addSubview:self.nickText];
    
    [self.nickText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(49.f));
        make.top.equalTo(@(64 + 15));
    }];
}

- (HRInPutView *)createTextFileWithFont:(UIFont *)font placeholderPlaceText:(NSString *)text
{
    
    HRInPutView * textInput = [[HRInPutView alloc] init];
    
    textInput.textField.font = font;
    textInput.textField.borderStyle = UITextBorderStyleNone;
    textInput.textField.keyboardType = UIKeyboardTypeDefault;
    NSMutableAttributedString * muAt = [[NSMutableAttributedString alloc]initWithString:text];
    [muAt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.f]  range:NSMakeRange(0, text.length)];
    [muAt addAttribute:NSForegroundColorAttributeName value:RGB_Color(0x5b, 0x5b, 0x5b) range:NSMakeRange(0, text.length)];
    [textInput.textField setAttributedPlaceholder:muAt];
    return textInput;
}

- (void)setNickName:(NSString *)nickName
{
    self.nickText.textField.placeholder = nickName;
}

#pragma mark - Touch
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
#pragma mark - 
- (void)buttonDidClick:(UIButton *)button
{
    [self.myNavController popViewControllerAnimated:YES];
}

- (void)doneButtonDidClick:(UIButton *)button
{
    if (!self.nickText.textField.text.length) {
        [self showTotasViewWithMes:@"请输入要修改昵称"];
        return;
    }
    
//    if([EmojiUnit stringContainsEmoji:self.nickText.textField.text]){
//        return [self showTotasViewWithMes:@"昵称不支持表情"];
//    }
    
    WS(ws);

    if(![MBProgressHUD HUDForView:self.view])
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [NetWorkEntity updateUserName:[self.nickText.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] password:nil image:nil bindweixin:-1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [ws showTotasViewWithMes:@"修改成功"];
            NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
            HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
            [[LoginStateManager getInstance] updateUserInfo:userInfo];
            [ws.navigationController popViewControllerAnimated:YES];
            
        }else{
            [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];

}
@end
