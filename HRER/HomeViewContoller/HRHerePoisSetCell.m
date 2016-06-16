//
//  HRHerePoisSetCell.m
//  HRER
//
//  Created by quke on 16/6/12.
//  Copyright © 2016年 linjunhou. All rights reserved.
//

#import "HRHerePoisSetCell.h"
#import "HRPoidSetsCardView.h"

@interface HRHerePoisSetCell()

@property(nonatomic,strong)HRPoidSetsCardView * cardView;

@end

#define  KPoiSetSpacing (10.f)

@implementation HRHerePoisSetCell


+ (CGFloat)heightForCell
{
    return KPoiSetSpacing + [HRPoidSetsCardView heightForCardView];
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
    self.cardView = [[HRPoidSetsCardView alloc] init];
    [self.contentView addSubview:self.cardView];
    
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self).offset(-KPoiSetSpacing);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{

}

@end
