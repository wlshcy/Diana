
#import "ItemSectionHeader.h"

@interface ItemSectionHeader ()
@end

@implementation ItemSectionHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.line];
        [self addSubview:self.titleLabel];

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 30);
    self.line.frame = CGRectMake((SCREEN_WIDTH-(110+40+82*2)/2.0)/2.0, 15, (110+40+82*2)/2.0, 1);
    self.titleLabel.frame = CGRectMake(self.line.left+41, 0, self.line.width-82, 30);
}

#pragma mark -Getter
- (UIView *)line
{
    if (!_line) {
        _line = [UIView new];
        _line.backgroundColor = RGB_COLOR(206, 206, 206);
        _line.hidden = YES;
    }
    return _line;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(16);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = RGB_COLOR(245, 245, 245);
    }
    return _titleLabel;
}

@end
