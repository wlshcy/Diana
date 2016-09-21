#import "ItemCell.h"
#import <UIImageView+AFNetworking.h>


@interface ItemCell ()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *size;
@property (nonatomic, strong) UILabel *price;
@end

@implementation ItemCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WHITE_COLOR;
        self.clipsToBounds = YES;
        
        [self addSubview:self.photo];
        [self addSubview:self.name];
        [self addSubview:self.size];
        [self addSubview:self.price];
    }
    return self;
}


- (void)configItemCell:data
{
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:data[@"image"]] placeholderImage:[UIImage imageNamed:@"home_rec"]];
    self.name.text = data[@"name"];
    self.size.text = [NSString stringWithFormat:@"%@g",data[@"size"]];
    self.price.text = [NSString stringWithFormat:@"¥ %0.2f",[data[@"price"] floatValue]];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.photo.frame = CGRectScaleXY(0, 0, 290/2.0, 232/2.0);
    self.name.frame = CGRectScaleXY(10, self.photo.bottom+10, self.width-20, 12);
    self.size.frame = CGRectScaleXY(10, self.name.bottom+6, 50, 14);
    self.price.frame = CGRectScaleXY(10,self.size.bottom+6, 50, 10);
}



#pragma mark - Getter
- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [UIImageView new];
    }
    return _photo;
}

- (UILabel *)name
{
    if (!_name) {
        _name = [UILabel new];
        _name.font = FONT(13);
        //_titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _name;
}

- (UILabel *)size
{
    if (!_size) {
        _size = [UILabel new];
        _size.font = FONT(12);
        _size.textColor = RGB_COLOR(154, 154, 154);
    }
    return _size;
}

- (UILabel *)price
{
    if (!_price) {
        _price = [UILabel new];
        _price.font = FONT(16);
        _price.textColor = RGB_COLOR(50,189, 111);
    }
    return _price;
}
@end
