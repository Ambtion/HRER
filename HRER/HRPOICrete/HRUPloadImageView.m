//
//  HRUPloadImageView.m
//  HRER
//
//  Created by quke on 16/7/21.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "HRUPloadImageView.h"
#import "iCarousel.h"
#import "NetWorkEntity.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#define MAXSEARCHCOUNT (100)

@interface HRUPloadImageView()<iCarouselDelegate,iCarouselDataSource,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,copy)UPloadCallBack callBack;

@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)iCarousel * icarousel;
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)UIButton * uploadImageButton;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * locIconImageView;
@property(nonatomic,strong)UILabel * addressLabel;

@property(nonatomic,strong)UITextView * textDesView;
@property(nonatomic,strong)UILabel * placeLabel;

@property(nonatomic,strong)UIView * lineView;

@property(nonatomic,strong)UIImageView * priceIcon;
@property(nonatomic,strong)UITextField * priceTextField;
@property(nonatomic,strong)UILabel * countUnitLabel;

@property(nonatomic,strong)UIButton * uploadbutton;

@property(nonatomic,strong)NSMutableArray * photosArray;



//Data
@property(nonatomic,strong)NSString * location;
@property(nonatomic,assign)NSInteger cityId;
@property(nonatomic,assign)NSInteger poiType;
@end


@implementation HRUPloadImageView

+ (void)showInView:(UIView *)view
      withPoiTitle:(NSString *)title
            cityId:(NSInteger)cityId
           address:(NSString *)addRess
               loc:(NSString *)loc
      categoryType:(NSInteger)poiType
          callBack:(UPloadCallBack) callBack
{
    for (UIView * oneSubview in view.subviews) {
        if ([oneSubview isKindOfClass:self]) {
            return;
        }
    }

    HRUPloadImageView * uploadView = [[HRUPloadImageView alloc] initWithFrame:view.bounds];
    uploadView.callBack = callBack;
    uploadView.titleLabel.text = title;
    uploadView.addressLabel.text = addRess;
    
    uploadView.cityId = cityId;
    uploadView.location = loc;
    uploadView.poiType = poiType;
    
    [uploadView showInView:view completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self initContentView];
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    }
    return self;
}

-(void)initContentView
{
    self.contentView.frame = CGRectMake(0, 0, 300, 470.f);
    self.contentView.center = CGPointMake(self.width/2.f, self.height/2.f);
    self.contentView.image = [[UIImage imageNamed:@"card_ba"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    
    self.icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(12, 15, self.contentView.width - 24 - 20, 150.f)];
    self.icarousel.type = iCarouselTypeInvertedTimeMachine;
    self.icarousel.delegate = self;
    self.icarousel.pagingEnabled = YES;
    self.icarousel.dataSource = self;
    self.icarousel.bounces = NO;
    [self.icarousel reloadData];
    [self.contentView addSubview:self.icarousel];
    
    self.uploadImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadImageButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
    [self.uploadImageButton addTarget:self action:@selector(uploadImagedidClic:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.uploadImageButton];
    
    [self.uploadImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.icarousel.mas_right).offset(-9);
        make.bottom.equalTo(self.icarousel.mas_bottom).offset(-9);
    }];
    
    self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width - 40, 0, 40, 40)];
    [self.cancelButton addTarget:self action:@selector(cancanButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.font = [UIFont systemFontOfSize:18.f];
    self.titleLabel.textColor = RGB_Color(0xd4, 0xd4, 0xd4);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.icarousel.mas_bottom).offset(18.f);
    }];
    
    
    self.locIconImageView = [[UIImageView alloc] init];
    self.locIconImageView.image = [UIImage imageNamed:@"location"];
    [self.contentView addSubview:self.locIconImageView];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = [UIFont systemFontOfSize:12.f];
    self.addressLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    [self.contentView addSubview:self.addressLabel];
    
    [self.locIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressLabel.mas_left).offset(-6);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.f);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.locIconImageView.mas_right).offset(6);
        make.centerX.equalTo(self.contentView);
        make.centerY.equalTo(self.locIconImageView);
    }];
    
    
    UIView * bgView = [[UIView alloc] init];
    bgView.layer.cornerRadius = 4.f;
    bgView.layer.borderColor = [RGB_Color(0xd9, 0xd9, 0xd9) CGColor];
    bgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12.f);
        make.right.equalTo(self).offset(-12.f);
        make.top.equalTo(self.addressLabel.mas_bottom).offset(22.f);
        make.height.equalTo(@(142.f));
    }];
    
    self.textDesView = [[UITextView alloc] init];
    self.textDesView.delegate = self;
    self.textDesView.font =[UIFont systemFontOfSize:14];
    self.textDesView.textColor = RGB_Color(0xd4, 0xd4, 0xd4);
    self.textDesView.returnKeyType = UIReturnKeyNext;//返回键的类型
    self.textDesView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    [self.contentView addSubview:self.textDesView];

    [self.textDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(11.f);
        make.right.equalTo(bgView).offset(-11);
        make.top.equalTo(bgView).offset(11);
        make.height.equalTo(@(78));
    }];
    
    self.placeLabel = [[UILabel alloc] init];
    self.placeLabel.font = [UIFont systemFontOfSize:14.f];
    self.placeLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    self.placeLabel.text = @"给朋友们种草吧~";
    [self.contentView addSubview:self.placeLabel];
    
    [self.placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textDesView).offset(4);
        make.top.equalTo(self.textDesView).offset(8);
    }];
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xe5, 0xe5, 0xe5);
    [self.contentView addSubview:self.lineView];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView);
        make.right.equalTo(bgView);
        make.height.equalTo(@(0.5));
        make.top.equalTo(self.textDesView.mas_bottom).offset(11);
    }];
    
    
    UIView * priceBgView = [[UIView alloc] init];
    priceBgView.backgroundColor = [UIColor whiteColor];
    priceBgView.layer.cornerRadius = 15.f;
    priceBgView.layer.borderColor = [RGB_Color(0xe5, 0xe5, 0xe5) CGColor];
    priceBgView.layer.borderWidth = 0.5;
    [self.contentView addSubview:priceBgView];
    
    //价格Iocn
    self.priceIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"price"]];
    [priceBgView addSubview:self.priceIcon];
    
    //价格输入
    
    self.priceTextField = [[UITextField alloc] init];
    self.priceTextField.returnKeyType = UIReturnKeyNext;
    self.priceTextField.delegate =  self;
    self.priceTextField.textAlignment = NSTextAlignmentCenter;
    self.priceTextField.font = [UIFont systemFontOfSize:13.f];
    self.priceTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.priceTextField.textColor = RGB_Color(0x4d, 0x4d, 0x4d);
    self.priceTextField.text = @"0";
    [priceBgView addSubview:self.priceTextField];
    
    self.countUnitLabel = [[UILabel alloc] init];
    self.countUnitLabel.textAlignment = NSTextAlignmentLeft;
    self.countUnitLabel.textColor = RGB_Color(51, 51, 51);
    self.countUnitLabel.backgroundColor = [UIColor clearColor];
    self.countUnitLabel.font = [UIFont systemFontOfSize:12];
    self.countUnitLabel.text = @"￥";
    [self.contentView addSubview:self.countUnitLabel];
    [priceBgView addSubview:self.countUnitLabel];
    
    
    [priceBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(11.f);
        make.height.equalTo(@(30.f));
        make.width.equalTo(@(69 + 20.f));
        make.centerY.equalTo(bgView.mas_bottom).offset(-21);
    }];
    
    [self.priceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(priceBgView).offset(5);
        make.centerY.equalTo(priceBgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.priceTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceIcon.mas_right).offset(5);
        make.right.equalTo(self.countUnitLabel.mas_left).offset(-5);
        make.centerY.equalTo(priceBgView);
    }];
    
    [self.countUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceBgView);
        make.right.equalTo(priceBgView).offset(-5);
        make.width.equalTo(@(15));
    }];
    
    self.uploadbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.uploadbutton setBackgroundImage:[UIImage imageNamed:@"button_bg"] forState:UIControlStateNormal];
    [self.uploadbutton setTitle:@"加入我的美食地图" forState:UIControlStateNormal];
    [self.uploadbutton titleLabel].font = [UIFont systemFontOfSize:14.f];
    [self.uploadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.uploadbutton addTarget:self action:@selector(uploadButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.uploadbutton];
    
    [self.uploadbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-10.f);
        make.centerX.equalTo(self);
        make.width.equalTo(@(175));
        make.height.equalTo(@(53));
    }];
}

#pragma mark - Images
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return self.photosArray.count;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    if (!view || ![view isKindOfClass:[UIImageView class]]) {
        view = [[UIImageView alloc] initWithFrame:carousel.bounds];
    }
    [(UIImageView *)view setImage:self.photosArray[index]];
    return view;
}


- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    switch (option) {
        case iCarouselOptionTilt:
            return 0.06;
            break;
        case iCarouselOptionSpacing:
            return 0.1f;
        default:
            break;
    }
    return value;
}


- (UIViewController *)appController
{
    return [[[UIApplication sharedApplication] delegate] window].rootViewController;
}

- (NSMutableArray *)photosArray
{
    if (!_photosArray) {
        _photosArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _photosArray;
}

#pragma mark PriceCount
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    [newtxt replaceCharactersInRange:range withString:string];
    if (newtxt.length > 5) {
        return NO;
    }
  
    return YES;
}

#pragma mark 键盘出现和消失
#pragma mark keyBoard show/hide
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * dic = [notification userInfo];
    CGFloat heigth = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
//    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.bottom = self.height - heigth;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    NSDictionary * dic = [notification userInfo];
//    CGFloat duration = [[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.9 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.centerY = self.height/2.f;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark TextFied
#pragma mark 字数限制
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.placeLabel setHidden:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.placeLabel setHidden:textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    NSMutableString *newtxt = [NSMutableString stringWithString:textView.text];
    [newtxt replaceCharactersInRange:range withString:text];
    if (newtxt.length > MAXSEARCHCOUNT ) {
        newtxt = [[newtxt substringWithRange:NSMakeRange(0,MAXSEARCHCOUNT)] mutableCopy];
    }
    textView.text = newtxt;
    return ([newtxt length] <= MAXSEARCHCOUNT);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textDesView resignFirstResponder];
}

#pragma mark - Action
- (void)cancanButtonDidClick:(UIButton *)button
{
    if (self.callBack) {
        self.callBack(NO);
    }
    
    [self disAppear];
}

- (void)uploadImagedidClic:(UIButton *)button
{
    //添加图片
    UIActionSheet * action = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"相册", nil];
    [action showInView:self];
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
    [[self appController] presentViewController:imagePickerController animated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    
    //获得编辑过的图片
    UIImage * editImage = [editingInfo objectForKey: @"UIImagePickerControllerEditedImage"];
    [self.photosArray addObject:editImage];
    [self.icarousel reloadData];
    
    [[self appController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //获得编辑过的图片
    UIImage * editImage = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    [self.photosArray addObject:editImage];
    [self.icarousel reloadData];
    
    [[[[UIApplication sharedApplication] delegate] window].rootViewController dismissViewControllerAnimated:YES completion:^{
        
    }];}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[self appController] dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)uploadButtonDidClick:(UIButton *)button
{
    
    
    if (!self.photosArray.count) {
        [self showTotasViewWithMes:@"请上传至少一张图片"];
    }
    
    [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] delegate] window] animated:YES];

    NSArray * locArray = [self.location componentsSeparatedByString:@","];
    WS(ws);
    [NetWorkEntity uploadPoiWithTitle:self.titleLabel.text
                                  des:self.textDesView.text
                                 type:self.poiType
                                price:[self.priceTextField.text integerValue]
                               locDes:self.addressLabel.text cityID:self.cityId
                                  lat:[[locArray firstObject] floatValue]
                                  loc:[[locArray lastObject] floatValue]
                               images:self.photosArray  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                   [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] delegate] window] animated:YES];
                                   if ([[responseObject objectForKey:@"result"] isEqualToString:@"OK"]) {
                                       
                                       [ws showTotasViewWithMes:@"上传成功"];
                                       [ws jumpToHomePage];
                                       [ws disAppear];
                                       
                                   }else{
                                       [ws showTotasViewWithMes:[[responseObject objectForKey:@"response"] objectForKey:@"errorText"]];
                                   }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:ws animated:YES];
        [ws showTotasViewWithMes:@"网络异常,稍后重试"]; 
    }];
    
}



@end
