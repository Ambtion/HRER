//
//  HRLoginViewController.m
//  HRER
//
//  Created by kequ on 16/5/25.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRLoginViewController.h"
#import "HRRegisterViewController.h"
#import "HRFinPassViewController.h"

@interface HRLoginViewController()
@property(nonatomic,strong)UIImageView * bgView;

@property(nonatomic,strong)UIImageView * userNamebgView;
@property(nonatomic,strong)UIImageView * userNameIcon;
@property(nonatomic,strong)UITextField * userName;


@property(nonatomic,strong)UIImageView * passbgView;
@property(nonatomic,strong)UIImageView * passIcon;
@property(nonatomic,strong)UITextField * password;

@end

@implementation HRLoginViewController

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
    
    //账号
    
    self.userNamebgView = [[UIImageView alloc] init];
    self.userNamebgView.image = [UIImage imageNamed:@"Input-box"];
    [self.view addSubview:self.userNamebgView];
    
    self.userNameIcon = [[UIImageView alloc] init];
    self.userNameIcon.image = [UIImage imageNamed:@"personal"];
    [self.view addSubview:self.userNameIcon];
    
    self.userName = [[UITextField alloc] init];
    self.userName = [[UITextField alloc] initWithFrame:CGRectZero];
    self.userName.font = [UIFont systemFontOfSize:13.f];
    self.userName.returnKeyType = UIReturnKeyNext;
    self.userName.keyboardType = UIKeyboardTypeNumberPad;
    self.userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userName.textColor = RGB_Color(86, 86, 86);
    self.userName.font = [UIFont systemFontOfSize:14.f];
    [self.userName addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSDictionary * attribuDic = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:13.f],
                                  NSForegroundColorAttributeName :RGB_Color(86, 86, 86)
                                  };
    
    NSAttributedString * mutalStr = [[NSMutableAttributedString alloc] initWithString:@"请输入您手机号"
                                                                    attributes:attribuDic];
    
    
    [self.userName setAttributedPlaceholder:mutalStr];
    [self.view addSubview:self.userName];
    
    
    
    //密码
    
    self.passbgView = [[UIImageView alloc] init];
    self.passbgView.image = [UIImage imageNamed:@"Input-box"];
    [self.view addSubview:self.passbgView];
    
    self.passIcon = [[UIImageView alloc] init];
    self.passIcon.image = [UIImage imageNamed:@"password"];
    [self.view addSubview:self.passIcon];
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 39, 205, 35)];
    self.password.font = [UIFont systemFontOfSize:13];
    self.password.textColor = RGB_Color(86, 86, 86);
    self.password.backgroundColor = [UIColor clearColor];
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password.secureTextEntry = YES;

    NSAttributedString * mutalStr2 = [[NSAttributedString alloc] initWithString:@"请输入您的密码"
                                               attributes:attribuDic];
    [self.password setAttributedPlaceholder:mutalStr2];
    [self.view addSubview:self.password];

    
    //登录
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [[loginButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login-box"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login-box_click"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    //找回密码
    UIButton * forgetPas = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPas setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPas setTitle:@"找回密码" forState:UIControlStateNormal];
    [[forgetPas titleLabel] setFont:[UIFont systemFontOfSize:12.f]];
    [forgetPas addTarget:self action:@selector(findPassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPas];
    
    
    [[self bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.right.equalTo(self.view);
    }];
    
    //登录
    [self.userNamebgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(49.f));
        make.top.equalTo(self.view).offset(105);
    }];
    
    [self.userNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNamebgView.mas_left).offset(25.f);
        make.width.height.equalTo(@(42.f));
        make.centerY.equalTo(self.userNamebgView);
    }];
    
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameIcon.mas_right).offset(12.f);
        make.right.equalTo(self.userNamebgView.mas_right).offset(-12.f);
        make.top.equalTo(self.userNamebgView);
        make.bottom.equalTo(self.userNamebgView);
    }];
    
    
    //密码
    [self.passbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(49.f));
        make.top.equalTo(self.userNamebgView.mas_bottom).offset(14);
    }];
    
    [self.passIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passbgView.mas_left).offset(25.f);
        make.width.height.equalTo(@(42.f));
        make.centerY.equalTo(self.passbgView);
    }];
    
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passIcon.mas_right).offset(12.f);
        make.right.equalTo(self.passbgView.mas_right).offset(-12.f);
        make.top.equalTo(self.passbgView);
        make.bottom.equalTo(self.passbgView);
    }];
    
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(24.f);
        make.size.equalTo(self.userNamebgView);
        make.left.equalTo(self.userNamebgView);
    }];
    
    
    [forgetPas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginButton);
        make.height.equalTo(@(30));
        make.top.equalTo(loginButton.mas_bottom).offset(0);
    }];
    
    //Line
    
}

#pragma mark - Action
- (void)backButtonDidClick:(id)sender
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)registerButtonDidClick:(id)sender
{
    [[self navigationController] pushViewController:[[HRRegisterViewController alloc] init] animated:YES];
}

- (void)usernameDidEndOnExit
{
    [self.password becomeFirstResponder];
}

- (void)loginButtonClicked:(id)sender
{
    
}

- (void)findPassButtonClick:(UIButton *)button
{
    [self.navigationController pushViewController:[[HRFinPassViewController alloc] init] animated:YES];
}

#pragma mark Touch
-(void)touchesEnded:(nonnull NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - View Appear
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self cusTomerNavBarItem];
}

- (void)cusTomerNavBarItem
{
    self.title = @"登录";
    self.navigationItem.leftBarButtonItems = [self createBackButtonWithTarget:self seletor:@selector(backButtonDidClick:)];
    
    CGRect backframe= CGRectMake(0, 0, 40, 30);
    UIButton* button= [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"注册" forState:UIControlStateNormal];
    button.frame = backframe;
    [button addTarget:self action:@selector(registerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* someBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[someBarButtonItem,[self barSpaingItem]];
    
}

@end



