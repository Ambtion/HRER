//linxs
#import <Foundation/Foundation.h>

//EmptySectionHeaderView
@interface EmptyHeaderView : UIView 
{
}
@end

@interface FillHeaderView : UIView
{
    UILabel *   m_titleLabel;
}
-(void)setTitle:(NSString*)title;

@end
