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
#import "HRWebCatLogin.h"
#import "HRBindPhoneController.h"
#import "HRAddressBookManager.h"
#import "HRQQManager.h"

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
    self.userName.font = [UIFont systemFontOfSize:14.f];
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
    
    self.password = [[UITextField alloc] initWithFrame:CGRectMake(18 + 10, 39, 205, 49)];
    self.password.font = [UIFont systemFontOfSize:14];
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
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [[loginButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login-box"] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login-box_click"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(loginButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    
    //找回密码
    UIButton * forgetPas = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPas setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [forgetPas setTitle:@"忘记密码" forState:UIControlStateNormal];
    [[forgetPas titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [forgetPas addTarget:self action:@selector(findPassButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPas];
    
    //找回密码
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"快速注册" forState:UIControlStateNormal];
    [[registerButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [registerButton addTarget:self action:@selector(registerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

        
    UIImageView * imageLabel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_line"]];
    [self.view addSubview:imageLabel];
    
    
    //微信登陆
    UIButton * webLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [webLogin setImage:[UIImage imageNamed:@"WeChat"] forState:UIControlStateNormal];
    [webLogin setImage:[UIImage imageNamed:@"WeChat_click"] forState:UIControlStateHighlighted];
    [webLogin addTarget:self action:@selector(webCatLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webLogin];
    
    
    
    //QQ登陆
    UIButton * qqLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqLogin setImage:[UIImage imageNamed:@"WeChat"] forState:UIControlStateNormal];
    [qqLogin setImage:[UIImage imageNamed:@"WeChat_click"] forState:UIControlStateHighlighted];
    [qqLogin addTarget:self action:@selector(qqLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqLogin];

    
    UILabel * webLoginTitl = [[UILabel alloc] init];
    webLoginTitl.textColor = RGB_Color(0xcf, 0xc7, 0xc2);
//    webLoginTitl.text = @"微信登录";
    webLoginTitl.font = [UIFont systemFontOfSize:14.f];
    webLoginTitl.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:webLoginTitl];
    
    
    [[self bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.right.equalTo(self.view);
    }];
    
    //登录
    [self.userNamebgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(49.f));
        make.top.equalTo(self.view).offset(22.f+44+20);
    }];
    
    [self.userNameIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNamebgView.mas_left).offset(20.f);
        make.width.height.equalTo(@(30.f));
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
        
        make.left.width.height.equalTo(self.userNamebgView);
        make.top.equalTo(self.userNamebgView.mas_bottom).offset(14);
    }];
    
    [self.passIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.userNameIcon);
        make.centerY.equalTo(self.passbgView);
    }];
    
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passIcon.mas_right).offset(12.f);
        make.right.equalTo(self.passbgView.mas_right).offset(-12.f);
        make.top.equalTo(self.passbgView);
        make.bottom.equalTo(self.passbgView);
    }];
    
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.password.mas_bottom).offset(20.f);
        make.size.left.equalTo(self.userNamebgView);
    }];
    
    
    [forgetPas mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loginButton).offset(-2);
        make.height.equalTo(@(30));
        make.top.equalTo(loginButton.mas_bottom).offset(7);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(loginButton).offset(2);
        make.top.height.equalTo(forgetPas);
    }];
    
    [webLoginTitl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-80);
        make.centerX.equalTo(self.view);
    }];

    CGFloat offset = self.view.width  * 0.15;
    
    [webLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(webLoginTitl.mas_top).offset(-8);
        make.centerX.equalTo(self.view).offset(-offset);
    }];

    [qqLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(webLoginTitl.mas_top).offset(-8);
        make.centerX.equalTo(self.view).offset(offset);
    }];
    
    [imageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(webLogin.mas_top).offset(-50.f);
        make.centerX.equalTo(self.view);
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
    if(self.navigationController.presentingViewController)
        self.navigationItem.leftBarButtonItems = [self createBackButtonWithTarget:self seletor:@selector(backButtonDidClick:)];
    else
        self.navigationItem.leftBarButtonItems = nil;
    
}

#pragma mark - Login
- (void)loginButtonClicked:(id)sender
{
    
    if (!self.userName.text.length)
    {
        [self showTotasViewWithMes:@"请输入手机号码"];
        return;
        
    }
    
    if (!self.password.text.length) {
        [self showTotasViewWithMes:@"请输入密码"];
        return;
    }
    
    WS(ws);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetWorkEntity loginWithUserName:self.userName.text password:self.password.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            
            NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
            
            HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
            if(userInfo){
                [[LoginStateManager getInstance] LoginWithUserLoginInfo:userInfo];
                [ws showTotasViewWithMes:@"登录成功"];
                
                //访问通讯录
                [HRAddressBookManager readAllPersonAddressWithCallBack:^(NSArray *resultList, ABAuthorizationStatus status) {
                    
                    if (resultList.count && [[LoginStateManager getInstance] userLoginInfo]) {
                        //用户登录方法
                        [NetWorkEntity sendPhotoNumberWithPhotoNumber:resultList success:^(AFHTTPRequestOperation *operation, id responseObject) {
                            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                NSDictionary * response = [responseObject objectForKey:@"response"];
                                if ([[response objectForKey:@"newFriend"] boolValue]) {
                                    [self showMessCountInTabBar:0];
                                }else{
                                    [self hiddenMessCountInTabBar];
                                }
                            }

                        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            
                        }];
                    }
                }];
                
                if ([ws.myNavController presentingViewController]) {
                    [ws.myNavController dismissViewControllerAnimated:YES completion:^{
                    }];
                    
                }else{
                    [ws.myNavController popViewControllerAnimated:YES];
                }
            }else{
                
                [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"   "]];
            }
        }else{
            [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [ws showTotasViewWithMes:@"网络异常,稍后重试"];
    }];
}

- (void)webCatLogin:(id)sender
{
    
    WS(ws);
    [HRWebCatLogin sendAuthRequestcallBack:^(BaseResp *resp) {
         
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (![(SendAuthResp *)resp code] ) {
            [self showTotasViewWithMes:@"登录失败"];
            return ;
        }
        [NetWorkEntity loginWithWebCatAccess_token:[(SendAuthResp *)resp code] success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
    
                NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
                HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
                if(userInfo){
                    if (userInfo.phone.length) {
                        
                        [[LoginStateManager getInstance] LoginWithUserLoginInfo:userInfo];

                        //访问通讯录
                        [HRAddressBookManager readAllPersonAddressWithCallBack:^(NSArray *resultList, ABAuthorizationStatus status) {
                            
                            if (resultList.count && [[LoginStateManager getInstance] userLoginInfo]) {
                                //用户登录方法
                                [NetWorkEntity sendPhotoNumberWithPhotoNumber:resultList success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                        NSDictionary * response = [responseObject objectForKey:@"response"];
                                        if ([[response objectForKey:@"newFriend"] boolValue]) {
                                            [self showMessCountInTabBar:0];
                                        }else{
                                            [self hiddenMessCountInTabBar];
                                        }
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                }];
                            }
                        }];
                        
                        if(self.navigationController.presentingViewController){
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                            
                            }];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        
                        
                    }else{
                        HRBindPhoneController * binC = [[HRBindPhoneController alloc] init];
                        binC.bindToken = userInfo.token;
                        [self.navigationController  pushViewController:binC animated:YES];
                        binC.navigationItem.leftBarButtonItems = nil;
                    }
                    
                }else{
                    [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                }
            }else{
                [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                
            }

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showTotasViewWithMes:@"网络异常,稍后重试"];

        }];
    }];
}

- (void)qqLogin:(UIButton *)button
{
    WS(ws);

    [[HRQQManager shareInstance] loginWithLoginCallBack:^(TencentOAuth *oauth, BOOL isCanceled) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (!oauth) {
            [self showTotasViewWithMes:@"登录失败"];
            return ;
        }
        [NetWorkEntity loginWithqqAccess_token:oauth.accessToken success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:ws.view animated:YES];
            if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                
                NSDictionary * userInfoDic  = [responseObject objectForKey:@"response"];
                HRUserLoginInfo * userInfo = [HRUserLoginInfo yy_modelWithJSON:userInfoDic];
                if(userInfo){
                    if (userInfo.phone.length) {
                        
                        [[LoginStateManager getInstance] LoginWithUserLoginInfo:userInfo];
                        
                        //访问通讯录
                        [HRAddressBookManager readAllPersonAddressWithCallBack:^(NSArray *resultList, ABAuthorizationStatus status) {
                            
                            if (resultList.count && [[LoginStateManager getInstance] userLoginInfo]) {
                                //用户登录方法
                                [NetWorkEntity sendPhotoNumberWithPhotoNumber:resultList success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                        NSDictionary * response = [responseObject objectForKey:@"response"];
                                        if ([[response objectForKey:@"newFriend"] boolValue]) {
                                            [self showMessCountInTabBar:0];
                                        }else{
                                            [self hiddenMessCountInTabBar];
                                        }
                                    }
                                    
                                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                    
                                }];
                            }
                        }];
                        
                        if(self.navigationController.presentingViewController){
                            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                        
                        
                        
                    }else{
                        HRBindPhoneController * binC = [[HRBindPhoneController alloc] init];
                        binC.bindToken = userInfo.token;
                        [self.navigationController  pushViewController:binC animated:YES];
                        binC.navigationItem.leftBarButtonItems = nil;
                    }
                    
                }else{
                    [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                }
            }else{
                [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showTotasViewWithMes:@"网络异常,稍后重试"];
            
        }];
    }];
}

@end



