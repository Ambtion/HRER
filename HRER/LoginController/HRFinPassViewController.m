//
//  HRFinPassViewController.m
//  HRER
//
//  Created by kequ on 16/5/30.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRFinPassViewController.h"

@interface HRFinPassViewController()

@property(nonatomic,strong)UITextField * phoneNumber;
@property(nonatomic,strong)UIButton * codeButton;
@property(nonatomic,strong)UITextField * phoneCode;
@property(nonatomic,strong)NSTimer * timer;
@property(nonatomic,assign)NSUInteger timeCount;

@property(nonatomic,strong)UITextField * passWord;

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
    
    self.passWord = [self createTextFileWithFont:[UIFont systemFontOfSize:13] placeholderPlaceText:@"新密码 密码不少于6位"];
    [self.view addSubview:self.passWord];

    self.phoneNumber.backgroundColor = [UIColor redColor];
    self.passWord.backgroundColor = [UIColor redColor];
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64 + 30);
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
