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

@property(nonatomic,strong)UITextField * userName;
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
    
    //账号
    self.userName = [[UITextField alloc] init];
    self.userName = [[UITextField alloc] initWithFrame:CGRectZero];
    self.userName.font = [UIFont systemFontOfSize:15];
    self.userName.textColor = [UIColor blackColor];
    self.userName.returnKeyType = UIReturnKeyNext;
    self.userName.keyboardType = UIKeyboardTypeNumberPad;
    self.userName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.userName.textColor = [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1];
    self.userName.font = [UIFont systemFontOfSize:14.f];
    [self.userName addTarget:self action:@selector(usernameDidEndOnExit) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    NSDictionary * attribuDic = @{
                                  NSFontAttributeName : [UIFont systemFontOfSize:14.f],
                                  NSForegroundColorAttributeName : [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1]
                                  };
    
    NSAttributedString * mutalStr = [[NSAttributedString alloc] initWithString:@"手机号"
                                                                    attributes:attribuDic];
    [self.userName setAttributedPlaceholder:mutalStr];
    [self.view addSubview:self.userName];
    
    //密码
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 39, 205, 35)];
    self.password.font = [UIFont systemFontOfSize:14];
    self.password.textColor = [UIColor colorWithRed:223/255.f green:229/255.f blue:224/255.f alpha:1];
    self.password.attributedPlaceholder = mutalStr;
    self.password.backgroundColor = [UIColor clearColor];
    self.password.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.password.returnKeyType = UIReturnKeyDone;
    self.password.keyboardType = UIKeyboardTypeASCIICapable;
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.autocorrectionType = UITextAutocorrectionTypeNo;
    self.password.secureTextEntry = YES;

    mutalStr = [[NSAttributedString alloc] initWithString:@"请输入您的密码"
                                               attributes:attribuDic];
    [self.password setAttributedPlaceholder:mutalStr];
    [self.view addSubview:self.password];

    
    //登录
    UIButton * loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    loginButton.layer.cornerRadius = 6.f;
    loginButton.clipsToBounds = YES;
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    //找回密码
    UIButton * forgetPas = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPas.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    forgetPas.layer.cornerRadius = 6.f;
    forgetPas.clipsToBounds = YES;
    [forgetPas setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPas setTitle:@"找回密码" forState:UIControlStateNormal];
    [forgetPas addTarget:self action:@selector(findPassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPas];
    
    self.userName.backgroundColor = [UIColor redColor];
    self.password.backgroundColor = [UIColor redColor];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(28.f);
        make.right.equalTo(self.view).offset(-28.f);
        make.top.equalTo(self.view).offset(64.f + 20);
        make.height.equalTo(@(38));
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.userName);
        make.left.equalTo(self.userName);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(38.f);
        make.width.equalTo(self.userName);
        make.left.equalTo(self.userName);
    }];
    
    [forgetPas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton);
        make.height.equalTo(loginButton);
        make.width.equalTo(@(100));
        make.top.equalTo(loginButton.mas_bottom).offset(5);
    }];
    
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
    self.title = @"这里登录";
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



