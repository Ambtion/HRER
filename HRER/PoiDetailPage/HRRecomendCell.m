//
//  HRRecomendCell.m
//  HRER
//
//  Created by kequ on 16/7/14.
//  Copyright © 2016年 linjunhou. All rights reserved.
//


@interface HRUIButton : UIButton
@property(nonatomic,strong)UIColor * highColor;
@end

@implementation HRUIButton
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = self.highColor;
    }else{
        self.backgroundColor = [UIColor clearColor];
    }
}
@end


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
@property(nonatomic,strong)HRUIButton * userButton;
@property(nonatomic,strong)HRUIButton * recomendButton;
@end

@implementation HRRecomendCell


+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}


+ (CGFloat)heigthForCellWithData:(HRRecomend *)dataSource
{
    CGFloat height = 44;
    
    NSString * str = [NSString stringWithFormat:@"%@",dataSource.content];
    if (dataSource.reply_name.length) {
        str = [NSString stringWithFormat:@"%@回复:%@",dataSource.user_name,str];
    }

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
    
    
    self.recomendButton = [HRUIButton buttonWithType:UIButtonTypeCustom];
    self.recomendButton.highColor = RGB_Color(0xd6, 0xde, 0xe9);
    [self.recomendButton addTarget:self action:@selector(onRecomendDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.recomendButton];
    
    self.userButton = [HRUIButton buttonWithType:UIButtonTypeCustom];
    self.userButton.highColor = RGB_Color(0xe1, 0xe1, 0xe1);
    [self.userButton addTarget:self action:@selector(onUserButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.userButton];
    
    self.porImageView = [[UIImageView alloc] init];
    self.porImageView.layer.cornerRadius = 20.f;
    self.porImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.porImageView];
    
    self.desLabel = [[UILabel alloc] init];
    self.desLabel.textColor = RGB_Color(0x4d,0x4d , 0x4d);
    self.desLabel.numberOfLines = 0;
    self.desLabel.font = [UIFont systemFontOfSize:14.f];
    [self.desLabel setUserInteractionEnabled:NO];
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
    
    
}

- (void)setDataSource:(HRRecomend *)dataSource
{
    
    if (_dataSource == dataSource) {
        return;
    }
    _dataSource = dataSource;
    
    [self.porImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"man"]];
    NSString * str = [NSString stringWithFormat:@"%@",dataSource.content];
    if (dataSource.reply_name.length) {
        str = [NSString stringWithFormat:@"%@回复:%@",dataSource.reply_name,str];
    }
    
    NSMutableAttributedString * attS = [[NSMutableAttributedString alloc] initWithString:str];
    NSInteger replyLenth = dataSource.reply_name.length + 2;
    
    if (dataSource.reply_name.length) {
        [self.userButton setHidden:NO];
        [attS addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, replyLenth)];
        CGRect rect  = [[self desLabel] boundingRectForCharacterRange:NSMakeRange(0, replyLenth)];
        rect.size.width += 3.f;
        [self.userButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self.desLabel);
            make.size.mas_equalTo(rect.size);
        }];
    }else{
        [self.userButton setHidden:YES];
    }
    self.desLabel.attributedText = attS;
    
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
