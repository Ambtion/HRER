//
//  HRReigsterViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRRegisterViewController.h"
#import "HRRegisterDealViewController.h"

@interface HRRegisterViewController()
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UITextField * phoneNumber;
@property(nonatomic,strong)UIButton * codeButton;
@property(nonatomic,strong)UITextField * phoneCode;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSUInteger timeCount;

@property(nonatomic,strong)UITextField * passWord;
@property(nonatomic,strong)UITextField * nick;

@property(nonatomic,strong)UIButton * dealSeletButton;

@end

@implementation HRRegisterViewController


#pragma mark - ViewLifeStyle
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = @"使用手机号注册快速找到通讯录朋友";
    [self.view addSubview:self.titleLabel];
    
    self.phoneNumber = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"+86"];
    self.phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [self.view  addSubview:self.phoneNumber];
    
    
    self.codeButton = [[UIButton alloc] init];
    self.codeButton.backgroundColor = [UIColor greenColor];
    [self.codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.codeButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
    [[self.codeButton titleLabel] setFont:[UIFont systemFontOfSize:10.f]];
    [self.codeButton addTarget:self action:@selector(getValidCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.codeButton];
    
    
    self.phoneCode = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"发送验证码"];
    self.phoneCode.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:self.phoneCode];
    
    self.passWord = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"密码 密码不少于6位"];
    [self.view addSubview:self.passWord];
    
    self.nick = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"昵称"];
    [self.view addSubview:self.nick];
    
    
    //注册
    UIButton * registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    registerButton.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    registerButton.layer.cornerRadius = 6.f;
    registerButton.clipsToBounds = YES;
    [registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton addTarget:self action:@selector(registerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:registerButton];
    
    
    //同意协议
    self.dealSeletButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.dealSeletButton.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    self.dealSeletButton.layer.cornerRadius = 6.f;
    self.dealSeletButton.clipsToBounds = YES;
    [self.dealSeletButton setSelected:YES];
    [self.dealSeletButton addTarget:self action:@selector(dealSeletButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.dealSeletButton];
    
    
    //协议
    UIButton * dealButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dealButton.backgroundColor = [UIColor colorWithRed:84/255.f green:172/255.f blue:61/255.f alpha:1];
    dealButton.layer.cornerRadius = 6.f;
    dealButton.clipsToBounds = YES;
    [dealButton setTitle:@"这里协议" forState:UIControlStateNormal];
    [dealButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [dealButton addTarget:self action:@selector(dealButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dealButton];

    
    self.titleLabel.backgroundColor = [UIColor redColor];
    self.phoneNumber.backgroundColor = [UIColor redColor];
    self.passWord.backgroundColor = [UIColor redColor];
    self.nick.backgroundColor = [UIColor redColor];
    self.dealSeletButton.backgroundColor = [UIColor redColor];
    dealButton.backgroundColor = [UIColor greenColor];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.equalTo(self.view).offset(66 + 30);
        make.height.equalTo(@(15));
    }];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15.f);
        make.height.equalTo(@(30.f));
        make.left.equalTo(self.view);
        make.right.equalTo(self.codeButton.mas_left);
        
    }];
    
    [self.codeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneNumber);
        make.right.equalTo(self.view);
        make.width.equalTo(@(60.f));
        make.height.equalTo(self.phoneNumber);
    }];
    
    [self.passWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneNumber);
        make.left.equalTo(self.phoneNumber);
        make.top.equalTo(self.phoneNumber.mas_bottom).offset(5);
    }];
    
    [self.nick mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(self.phoneNumber);
        make.left.equalTo(self.phoneNumber);
        make.top.equalTo(self.passWord.mas_bottom).offset(5);
    }];
    
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nick.mas_bottom).offset(38.f);
        make.width.equalTo(self.nick);
        make.left.equalTo(self.nick);
    }];
    
    [self.dealSeletButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(registerButton);
        make.height.equalTo(registerButton);
        make.top.equalTo(registerButton.mas_bottom).offset(5);
    }];

    [dealButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dealSeletButton.mas_right);
        make.height.equalTo(registerButton);
        make.top.equalTo(self.dealSeletButton);
    }];
}


#pragma mark - Action
- (void)registerButtonDidClick:(id)sender
{
    
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

- (void)getValidCode:(UIButton *)sender
{
    if ([self.phoneNumber.text isEqualToString:@""])
    {
        [self showTotasViewWithMes:@"请输入手机号码"];
        return;
        
    }else if (self.phoneNumber.text.length <11)
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
        [self.codeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        [self.codeButton setTitleColor:[UIColor colorWithRed:248/255.0f green:144/255.0f blue:34/255.0f alpha:1] forState:UIControlStateNormal];
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
- (UITextField *)createTextFileWithFont:(UIFont *)font placeholderPlaceText:(NSString *)text
{
    UITextField *textField=[[UITextField alloc]init];
    textField.font = font;
    textField.borderStyle = UITextBorderStyleNone;
    
    NSMutableAttributedString * muAt = [[NSMutableAttributedString alloc]initWithString:text];
    
    [muAt addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f]  range:NSMakeRange(0, text.length)];
    [muAt addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, text.length)];
    [textField setAttributedPlaceholder:muAt];
    
    return textField;
    
}

@end
