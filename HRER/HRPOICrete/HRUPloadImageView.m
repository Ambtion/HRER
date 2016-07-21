//
//  HRUPloadImageView.m
//  HRER
//
//  Created by quke on 16/7/21.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


#import "HRUPloadImageView.h"
#import "iCarousel.h"


@interface HRUPloadImageView()<iCarouselDelegate,iCarouselDataSource>

@property(nonatomic,copy)UPloadCallBack callBack;

@property(nonatomic,strong)UIImageView * bgImageView;

@property(nonatomic,strong)iCarousel * icarousel;
@property(nonatomic,strong)UIButton * cancelButton;
@property(nonatomic,strong)UIButton * uploadImageButton;

@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIImageView * locIconImageView;
@property(nonatomic,strong)UILabel * addressLabel;
@property(nonatomic,strong)NSString * location;

@property(nonatomic,strong)UITextView * textDesView;
@property(nonatomic,strong)UIView * lineView;


@end


@implementation HRUPloadImageView

+ (void)showInView:(UIView *)view
      withPoiTitle:(NSString *)title
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
    
    [uploadView showInView:view completion:^(BOOL finished) {
        
    }];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self){
        [self initContentView];
    }
    return self;
}

-(void)initContentView
{
    self.contentView.frame = CGRectMake(0, 0, 300, 470.f);
    self.contentView.center = CGPointMake(self.width/2.f, self.height/2.f);
    self.contentView.image = [[UIImage imageNamed:@"card_ba"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
    
    
    self.icarousel = [[iCarousel alloc] initWithFrame:CGRectMake(12, 15, self.contentView.width - 24, 150.f)];
    self.icarousel.type = iCarouselTypeInvertedTimeMachine;
    self.icarousel.delegate = self;
    self.icarousel.pagingEnabled = YES;
    self.icarousel.dataSource = self;
    self.icarousel.bounces = NO;
    [self.icarousel reloadData];
    [self.contentView addSubview:self.icarousel];
    
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
    
    
    UIView * locView = [[UIView alloc] init];
    [self.contentView addSubview:locView];
    
    self.locIconImageView = [[UIImageView alloc] init];
    self.locIconImageView.image = [UIImage imageNamed:@"location"];
    [locView addSubview:self.locIconImageView];
    
    self.addressLabel = [[UILabel alloc] init];
    self.addressLabel.font = [UIFont systemFontOfSize:12.f];
    self.addressLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
    [locView addSubview:self.addressLabel];
    
    [locView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(14.f);
        make.centerX.equalTo(self);
    }];
    
    [self.locIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locView);
        make.centerY.equalTo(self);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    
    
}

#pragma mark - Images
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 5;
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view
{
    if (!view) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
    }
    view.backgroundColor = RGB_Color(index * 0.02, 0xff, 0xff);
    return view;
}

#pragma mark - Action
- (void)cancanButtonDidClick:(UIButton *)button
{
    if (self.callBack) {
        self.callBack(NO);
    }
    
    [self disAppear];
}
@end
