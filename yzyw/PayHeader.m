//
//  PayHeader.m
//  Garden
//
//  Created by 金学利 on 8/10/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "PayHeader.h"

@interface PayHeader ()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *line;
@end

@implementation PayHeader


- (instancetype)initWithFrame:(CGRect)frame data:(float)data
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = WHITE_COLOR;
        [self addSubview:self.photo];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.line];
        
        self.priceLabel.text = [NSString stringWithFormat:@"￥%0.2f",data];
    
    }
    return self;
}




#pragma mark -Getter
- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-140)/2.0, 17, 140, 132)];
        _photo.image = [UIImage imageNamed:@"weizhang"];
    }
    return _photo;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.photo.bottom+23, SCREEN_WIDTH, 20)];
        _titleLabel.text = @"请支付金额";
        _titleLabel.font = FONT(14);
        _titleLabel.textColor = RGB_COLOR(103, 103, 103);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom+14, SCREEN_WIDTH, 20)];
        _priceLabel.textColor = RGB_COLOR(255, 144, 0);
        _priceLabel.font = FONT(16);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _priceLabel;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-0.6, SCREEN_WIDTH, 0.6)];
        _line.backgroundColor = LIGHTGRAY_COLOR;
    }
    return _line;
}

@end
