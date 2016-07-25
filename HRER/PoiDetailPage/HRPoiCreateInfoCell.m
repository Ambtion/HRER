//
//  HRPoiCreateInfoCell.m
//  HRER
//
//  Created by kequ on 16/7/13.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRPoiCreateInfoCell.h"
#import "HRPoiUserInfo.h"
#import "HRPoiUserInfoBottomView.h"

@interface HRPoiCreateInfoCell()<HRPoiUserInfoBottomViewDelegate>

@property(nonatomic,strong)HRPoiUserInfo * userInfo;
@property(nonatomic,strong)UILabel * desLabel;
@property(nonatomic,strong)HRPoiUserInfoBottomView * bottomView;

@end

static NSString * str = @"驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错，驴肉火烧味道不错";

static NSInteger boundsOffset = 12.f;

@implementation HRPoiCreateInfoCell

+ (CGFloat)cellHeithForData:(id)data
{
    CGFloat heigth = [HRPoiUserInfo heightForView];
    CGSize size = [self sizeWithText:str font:[UIFont systemFontOfSize:15.f] maxSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - boundsOffset * 2, 10000)];
    heigth += size.height;
    heigth += 18.f;
    heigth += [HRPoiUserInfoBottomView heightForView];
    return heigth;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    self.userInfo = [[HRPoiUserInfo alloc] init];
    [self.contentView addSubview:self.userInfo];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.textColor = RGB_Color(0x60, 0x60, 0x60);
    self.desLabel.numberOfLines = 0;
    self.desLabel.font = [UIFont systemFontOfSize:13.f];
    [self.contentView addSubview:self.desLabel];
    
    self.bottomView = [[HRPoiUserInfoBottomView alloc] init];
    self.bottomView.delegate = self;
    [self.contentView addSubview:self.bottomView];
    
    [self.userInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@([HRPoiUserInfo heightForView]));
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userInfo).offset(12.f);
        make.right.equalTo(self.userInfo).offset(-12.f);
        make.top.equalTo(self.userInfo.mas_bottom);

    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.desLabel.mas_bottom).offset(18.f);
        make.height.equalTo(@([HRPoiUserInfoBottomView heightForView]));
    }];
}

- (void)setDataSource:(id)dataSource
{
    [self.userInfo setDtata:nil];
    self.desLabel.text = str;
    [self.bottomView setData:nil];
}

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}


#pragma mark - Action
- (void)poiUserInfoBottomViewDidClickRecomend:(HRPoiUserInfoBottomView *)vew
{
    if ([_delegate respondsToSelector:@selector(poiUserInfoCellDidClickRecomend:)]) {
        [_delegate poiUserInfoCellDidClickRecomend:self];
    }
}

- (void)poiUserInfoBottomViewDidClickWantTogo:(HRPoiUserInfoBottomView *)vew
{
    if ([_delegate respondsToSelector:@selector(poiUserInfoCellDidClickWantTogo:)]) {
        [_delegate poiUserInfoCellDidClickWantTogo:self];
    }
}

@end

