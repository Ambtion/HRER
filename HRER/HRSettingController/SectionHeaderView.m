//linxs
#import "SectionHeaderView.h"

@implementation EmptyHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@implementation FillHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
//        self.backgroundColor = RGBA(180, 180, 180, 0.8);//RGBA(153, 153, 153, 1);
//        
//        m_titleLabel = [[UILabel alloc] init];
//        m_titleLabel.font = NORMAL_SUBTITLE_FONT;
//        m_titleLabel.textColor = SECTION_TEXT_COLOR;
//        m_titleLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:m_titleLabel];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    self.backgroundColor = RGBA(180, 180, 180, 0.8);//RGBA(153, 153, 153, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0f].CGColor);
//    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGFloat lineWidth = 1.0f;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f)
    {
        lineWidth = 1.0f;
    }
    
    CGContextSetLineWidth(context, lineWidth);
    
	CGFloat minx = CGRectGetMinX(rect);
	CGFloat maxx = CGRectGetMaxX(rect);
	CGFloat miny = CGRectGetMinY(rect);
    
    //top line
    CGContextMoveToPoint(context, minx, miny); 
    CGContextAddLineToPoint(context, maxx, miny);
    
    CGContextStrokePath(context);
}

-(void)setTitle:(NSString*)title
{
    m_titleLabel.text = title;
    [m_titleLabel sizeToFit];
    
    CGRect _frame = m_titleLabel.frame;
    _frame.origin.x = 10.0f;
    _frame.origin.y = floorf((self.frame.size.height-_frame.size.height)/2);
    m_titleLabel.frame = _frame;
}

- (void)dealloc 
{
    m_titleLabel = nil;
}
@end
