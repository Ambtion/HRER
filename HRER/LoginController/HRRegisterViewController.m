//
//  HRReigsterViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRegisterViewController.h"
#import "HRRegisterDealViewController.h"
#import "HRInPutView.h"
#import "LoginStateManager.h"

@interface HRRegisterViewController()

@property(nonatomic,strong)UIImageView * bgView;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)HRInPutView * phoneNumber;
@property(nonatomic,strong)UIButton * codeButton;

@property(nonatomic,strong)HRInPutView * phoneCode;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSUInteger timeCount;

@property(nonatomic,strong)HRInPutView * passWord;
@property(nonatomic,strong)HRInPutView * nick;

@property(nonatomic,strong)UIButton * dealSeletButton;

@end

@implementation HRRegisterViewController


#pragma mark - ViewLifeStyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cusTomNavBar];
}

- (void)cusTomNavBar
{
    self.title = @"注册";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI
{
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.image = [UIImage imageNamed:@"bj"];
    [self.view addSubview:self.bgView];
    
    [[self bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.right.equalTo(self.view);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = RGB_Color(0xbd, 0xb7, 0xb9);
    self.titleLabel.font = [UIFont systemFontOfSize:13.f];
    self.titleLabel.text = @"使用手机号注册快速找到通讯录朋友";
    [self.view addSubview:self.titleLabel];
    
    
    self.phoneNumber = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"+86"];
    self.phoneNumber.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view  addSubview:self.phoneNumber];
    
    
    self.codeButton = [[UIButton alloc] init];
    
    [self.codeButton setTitle:@"验证码" forState:UIControlStateNormal];
    [[self.codeButton titleLabel] setFont:[UIFont systemFontOfSize:12.f]];
    [self.codeButton setBackgroundImage:[UIImage imageNamed:@"code_fasong"] forState:UIControlStateNormal];
    [self.codeButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.codeButton];
    
    self.phoneCode = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"发送验证码"];
    self.phoneCode.textField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneCode];
    
    self.passWord = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"密码 密码不少于6位"];
    [self.view addSubview:self.passWord];
    
    self.nick = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"昵称"];
    [self.view addSubview:self.nick];
    
    //注册
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [[registerButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [registerButton setTitleColor:RGB_Color(0xf9, 0xda, 0xd5) forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Login-box"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Login-box_click"] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(registerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    //同意协议
    self.dealSeletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.dealSeletButton setImage:[UIImage imageNamed:@"deal_agree"] forState:UIControlStateSelected];
    [self.dealSeletButton setImage:[UIImage imageNamed:@"check_box_no_select"] forState:UIControlStateNormal];
    [self.dealSeletButton setSelected:YES];
    [self.dealSeletButton addTarget:self action:@selector(dealSeletButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dealSeletButton];
    
    //协议
    UIButton * dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dealButton setTitle:@"我已阅读并同意 这里协议" forState:UIControlStateNormal];
    [[dealButton titleLabel] setFont:[UIFont systemFontOfSize:10.f]];
    [dealButton setTitleColor:RGB_Color(0xf9, 0xda, 0xd5) forState:UIControlStateNormal];
    [dealButton addTarget:self action:@selector(dealButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dealButton];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(66 + 10);
        make.height.equalTo(@(15));
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(42.f));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneNumber);
        make.right.equalTo(self.phoneNumber).offset(-5);
        make.height.equalTo(@(30));
        make.width.equalTo(@(60.f));
    }];

    
    [self.phoneCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(10);

    }];
    
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.phoneCode.mas_bottom).offset(10);
    }];
    
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.passWord.mas_bottom).offset(10);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.nick.mas_bottom).offset(20);
    }];
    
    [dealButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(registerButton.mas_bottom).offset(50);
        make.centerX.equalTo(self.view).offset(12);
    }];


    [self.dealSeletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(dealButton.mas_left).offset(-5);
        make.centerY.equalTo(dealButton);

    }];
}


- (void)dealButtonClick:(id)sender
{
    [self.navigationController pushViewController:[[HRRegisterDealViewController alloc] init] animated:YES];
}

- (void)dealSeletButtonDidClick:(UIButton *)button
{
    [button setSelected:!button.isSelected];
}

#pragma mark - Touch
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}


- (void)reduceTime:(NSTimer *)codeTimer
{
    self.timeCount--;
    if (self.timeCount == 0) {
        [self.codeButton setTitle:@"验证码" forState:UIControlStateNormal];
        UIButton *info = codeTimer.userInfo;
        info.enabled = YES;
        self.codeButton.userInteractionEnabled = YES;
        [self.timer invalidate];
    } else {
        NSString *str = [NSString stringWithFormat:@"%lus", self.timeCount];
        [self.codeButton setTitle:str forState:UIControlStateNormal];
        self.codeButton.userInteractionEnabled = NO;
    }
}

#pragma mark - CommonMethod
- (HRInPutView *)createTextFileWithFont:(UIFont *)font placeholderPlaceText:(NSString *)text
{
    
    HRInPutView * textInput = [[HRInPutView alloc] init];
    
    textInput.textField.font = font;
    textInput.textField.borderStyle = UITextBorderStyleNone;
    
    NSMutableAttributedString * muAt = [[NSMutableAttributedString alloc]initWithString:text];
    [muAt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]  range:NSMakeRange(0, text.length)];
    [muAt addAttribute:NSForegroundColorAttributeName value:RGB_Color(0x5b, 0x5b, 0x5b) range:NSMakeRange(0, text.length)];
    [textInput.textField setAttributedPlaceholder:muAt];
    return textInput;
}

#pragma mark - Action
- (void)getValidCode:(UIButton *)sender
{
    if (!self.phoneNumber.textField.text.length)
    {
        [self showTotasViewWithMes:@"请输入手机号码"];
        return;
        
    }else if (self.phoneNumber.textField.text.length <11)
    {
        [self showTotasViewWithMes:@"请输入正确的手机号码"];
        return;
    }
    
    [self.timer invalidate];
    self.timer = nil;
    self.timeCount = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceTime:) userInfo:sender repeats:YES];
    
    [NetWorkEntity sendVerCodeWithPhoneNumber:self.phoneNumber.textField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [self showTotasViewWithMes:@"发送成功"];
        }else{
            [self showTotasViewWithMes:@"方式失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
    }];
}

- (void)registerButtonDidClick:(id)sender
{
    
    if (!self.phoneNumber.textField.text.length)
    {
        [self showTotasViewWithMes:@"请输入手机号码"];
        return;
        
    }
    if (!self.phoneCode.textField.text.length) {
        [self showTotasViewWithMes:@"请输入验证码"];
        return;
    }
    
    if (!self.passWord.textField.text.length) {
        [self showTotasViewWithMes:@"请输入密码"];
        return;
    }
    
    if (self.passWord.textField.text.length < 6) {
        [self showTotasViewWithMes:@"密码不能小于6位"];
        return;
    }
    
    if (!self.nick.textField.text.length) {
        [self showTotasViewWithMes:@"昵称不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [NetWorkEntity regisWithPhotoNumber:self.phoneNumber.textField.text password:self.passWord.textField.text nickName:self.nick.textField.text verCode:self.phoneCode.textField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
  
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            
            NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
            
            HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
            if(userInfo){
                [[LoginStateManager getInstance] LoginWithUserLoginInfo:userInfo];
                [self showTotasViewWithMes:@"注册成功"];
                
                if ([self.myNavController presentedViewController]) {
                    [self.myNavController dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                }else{
                    [self.myNavController popToRootViewControllerAnimated:YES];
                }
            }else{
                [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
            }
        }else{
            [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTotasViewWithMes:@"网络异常，注册失败"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}


@end
