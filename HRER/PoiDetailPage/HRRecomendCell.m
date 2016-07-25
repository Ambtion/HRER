//
//  HRRecomendCell.m
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

@interface UILabel(SubStirngRect)

@end
@implementation UILabel(SubStirngRect)

- (CGRect)boundingRectForCharacterRange:(NSRange)range
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:[self attributedText]];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:[self bounds].size];
    textContainer.lineFragmentPadding = 0;
    [layoutManager addTextContainer:textContainer];
    
    NSRange glyphRange;
    
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

@end


#import "HRRecomendCell.h"

@interface HRRecomendCell()
@property(nonatomic,strong)UIImageView * porImageView;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UILabel * desLabel;
@property(nonatomic,strong)UIButton * userButton;
@property(nonatomic,strong)UIButton * recomendButton;
@end

@implementation HRRecomendCell

static NSString * str = @"小李回复:他说斯蒂芬妮闪电废是打发是打发是电风扇的f,斯蒂芬妮闪电废是打发,斯蒂芬妮闪电废是打发,斯蒂芬妮闪电废是打发";

+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


+ (CGFloat)heigthForCellWithData:(id)dataSource
{
    CGFloat height = 44;
    CGSize size = [self sizeWithText:str font:[UIFont systemFontOfSize:14.f] maxSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width - 75 - 20.f, 10000)];
    return MAX(size.height + height, 60);
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
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = RGB_Color(0xf2, 0xf2, 0xf2);
    [self.contentView addSubview:self.bgView];
    
    self.porImageView = [[UIImageView alloc] init];
    self.porImageView.layer.cornerRadius = 20.f;
    [self.contentView addSubview:self.porImageView];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.textColor = RGB_Color(0x4d,0x4d , 0x4d);
    self.desLabel.numberOfLines = 0;
    self.desLabel.font = [UIFont systemFontOfSize:14.f];
    [self.desLabel setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.desLabel];
    
    
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = RGB_Color(0xe8, 0xe8, 0xe8);
    [self.contentView addSubview:self.lineView];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10.f);
        make.right.equalTo(self).offset(-10);
        make.height.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.porImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(25.f);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        
    }];
    
    self.recomendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.recomendButton addTarget:self action:@selector(onRecomendDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.recomendButton.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:self.recomendButton];
    
    [self.recomendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(self.desLabel);
        make.left.top.equalTo(self.desLabel);
    }];

    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.porImageView.mas_right).offset(10.f);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.desLabel);
        make.right.equalTo(self.bgView);
        make.bottom.equalTo(self);
        make.height.equalTo(@(0.5));
    }];
    
    self.userButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.userButton addTarget:self action:@selector(onUserButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    self.userButton.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
    [self.desLabel addSubview:self.userButton];
    
    
}

- (void)setDataSrouce:(id)dataSource
{
    [self.porImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"man"]];
    NSMutableAttributedString * attS = [[NSMutableAttributedString alloc] initWithString:str];
    [attS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    self.desLabel.attributedText = attS;
    
    CGRect rect  = [[self desLabel] boundingRectForCharacterRange:NSMakeRange(0, 5)];
//    rect = [self.contentView convertRect:rect fromView:self.desLabel];
    self.userButton.frame = rect;
}

#pragma mark -
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{}


#pragma mark Action
- (void)onRecomendDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recomendCellDidClickRecomendButton:)]) {
        [_delegate recomendCellDidClickRecomendButton:self];
    }
}

- (void)onUserButtonDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recomendCellDidClickUserButton:)]) {
        [_delegate recomendCellDidClickUserButton:self];
    }
}

@end
