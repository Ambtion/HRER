//
//  HRFinPassViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRFinPassViewController.h"
#import "HRInPutView.h"

@interface HRFinPassViewController()

@property(nonatomic,strong)UIImageView * bgView;

@property(nonatomic,strong)HRInPutView * phoneNumber;
@property(nonatomic,strong)UIButton * codeButton;
@property(nonatomic,strong)HRInPutView * phoneCode;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSUInteger timeCount;

@property(nonatomic,strong)HRInPutView * passWord;

@end

@implementation HRFinPassViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self customNavBar];
}

- (void)customNavBar
{
    self.title = @"找回密码";
    
}


#pragma mark - InitUI
- (void)initUI
{
    
    
    self.bgView = [[UIImageView alloc] init];
    self.bgView.image = [UIImage imageNamed:@"bj"];
    [self.view addSubview:self.bgView];
    
    [[self bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.view);
        make.top.right.equalTo(self.view);
    }];
    
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
    
    self.passWord = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"新密码"];
    [self.view addSubview:self.passWord];
    
    //注册
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"重设密码" forState:UIControlStateNormal];
    [[registerButton titleLabel] setFont:[UIFont systemFontOfSize:14.f]];
    [registerButton setTitleColor:RGB_Color(0xf9, 0xda, 0xd5) forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Login-box"] forState:UIControlStateNormal];
    [registerButton setBackgroundImage:[UIImage imageNamed:@"Login-box_click"] forState:UIControlStateHighlighted];
    [registerButton addTarget:self action:@selector(resetMima:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];

    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(10.f);
        make.right.equalTo(self.view).offset(-10.f);
        make.height.equalTo(@(42.f));
        make.top.equalTo(@(64 + 50));
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

    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.phoneNumber);
        make.top.equalTo(self.passWord.mas_bottom).offset(20);
    }];
    
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

- (void)getValidCode:(UIButton *)sender
{
    if ([self.phoneNumber.textField.text isEqualToString:@""])
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
- (void)resetMima:(id)sender
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [NetWorkEntity resetPassNumber:self.phoneNumber.textField.text  verCode:self.phoneCode.textField.text password:self.passWord.textField.text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
            [self showTotasViewWithMes:@"重置成功"];
            [self.myNavController popViewControllerAnimated:YES];
        }else{
            [self showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTotasViewWithMes:@"网络异常,稍后重试"];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}
@end
