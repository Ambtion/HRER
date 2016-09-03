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
@property(nonatomic,strong)HRUIButton * replyButton;
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
//    self.userButton.highColor = RGB_Color(0xe1, 0xe1, 0xe1);
    [self.userButton addTarget:self action:@selector(onUserButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.userButton];
    
    
    self.replyButton = [HRUIButton buttonWithType:UIButtonTypeCustom];
//    self.replyButton.highColor = RGB_Color(0xe1, 0xe1, 0xe1);
    [self.replyButton addTarget:self action:@selector(onReplayButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.replyButton];

//    self.recomendButton.backgroundColor = [UIColor redColor];
//    self.userButton.backgroundColor = [UIColor greenColor];
//    self.replyButton.backgroundColor = [UIColor greenColor];
    
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
    
    [self.porImageView sd_setImageWithURL:[NSURL URLWithString:dataSource.portrait] placeholderImage:[UIImage imageNamed:@"man"]];
    NSString * str = [NSString stringWithFormat:@"%@",dataSource.content];
    if (dataSource.reply_name.length) {
        str = [NSString stringWithFormat:@"%@回复%@:%@",dataSource.user_name,dataSource.reply_name,str];
    }else{
        
        [self.replyButton setHidden:NO];
        str = [NSString stringWithFormat:@"%@:%@",dataSource.user_name,str];
        
    }
    
//    e5ecf5
    NSMutableAttributedString * attS = [[NSMutableAttributedString alloc] initWithString:str];
    
    NSRange userRang = NSMakeRange(0, 0);
    if (_dataSource.user_name.length) {
        userRang = [str rangeOfString:_dataSource.user_name];
    }
    
    [attS addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9dafc9) range:userRang];
    

    if (dataSource.reply_name.length) {
        NSRange replayRang = [str rangeOfString:dataSource.reply_name];
        [attS addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x9dafc9) range:replayRang];
    }

    self.desLabel.attributedText = attS;
    
    CGRect userRect  = [[self desLabel] boundingRectForCharacterRange:userRang];
    [self.userButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.centerY.equalTo(self.desLabel);
        make.width.equalTo(@(userRect.size.width + 5));
    }];

    if (dataSource.reply_name.length) {
        NSRange replayRang = [str rangeOfString:dataSource.reply_name];
        CGRect replyRect  = [[self desLabel] boundingRectForCharacterRange:replayRang];
        [self.replyButton setHidden:NO];
        [self.replyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.desLabel.mas_left).offset(replyRect.origin.x + 10);
            make.centerY.equalTo(self.desLabel);
            make.width.equalTo(@(replyRect.size.width + 5));
        }];
        
    }else{
        [self.replyButton setHidden:YES];
    }

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
    if ([_delegate respondsToSelector:@selector(recomendCellDidClickUserButton: withUserid:)]) {
        [_delegate recomendCellDidClickUserButton:self withUserid:self.dataSource.user_id];
    }
}

- (void)onReplayButtonDidClick:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(recomendCellDidClickUserButton: withUserid:)]) {
        [_delegate recomendCellDidClickUserButton:self withUserid:self.dataSource.reply_id];
    }

}

@end
