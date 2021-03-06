//
//  RDRGrowingTextView.m
//  RDRGrowingTextView
//
//  Created by Damiaan Twelker on 04/10/15.
//  Copyright (c) 2015 Damiaan Twelker. All rights reserved.
//
//  LICENSE
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Damiaan Twelker
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "RDRGrowingTextView.h"

@interface RDRGrowingTextView()
@property(nonatomic,strong)UILabel * placeLabel;
@end

@implementation RDRGrowingTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updateLayout];
}

- (CGSize)intrinsicContentSize
{
    CGRect textRect = [self.layoutManager usedRectForTextContainer:self.textContainer];
    CGFloat height = textRect.size.height + self.textContainerInset.top + self.textContainerInset.bottom;
    return CGSizeMake(UIViewNoIntrinsicMetric, height);
}

- (void)textDidChange:(NSNotification *)notification
{
    [self.placeLabel setHidden:self.text.length];
    [self updateLayout];
}

- (void)updateLayout
{
    [self invalidateIntrinsicContentSize];
    [self scrollRangeToVisible:self.selectedRange];
}

- (UILabel *)placeLabel
{
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.font = [UIFont systemFontOfSize:14.f];
        _placeLabel.textAlignment = NSTextAlignmentLeft;
        _placeLabel.textColor = RGB_Color(0xa6, 0xa6, 0xa6);
        [self addSubview:_placeLabel];
        [_placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(8);
            make.top.height.equalTo(self);
        }];
    }
    return _placeLabel;
}

- (void)setPlaceText:(NSString *)placeText
{
    [self.placeLabel setHidden:self.text.length];
    self.placeLabel.text = placeText;
}

@end
