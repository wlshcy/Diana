//
//  VegCell.m
//  Lynp
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import "VegCell.h"
#import <UIImageView+AFNetworking.h>
#import "VegModel.h"
#import "CrossLineLabel.h"


@interface VegCell ()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *size;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) CrossLineLabel *mprice;
@end

@implementation VegCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = WHITE_COLOR;
        self.clipsToBounds = YES;
        
        [self addSubview:self.photo];
        [self addSubview:self.name];
        [self addSubview:self.size];
        [self addSubview:self.price];
        [self addSubview:self.mprice];
    }
    return self;
}


- (void)configVegCell:data
{
    
    [self.photo sd_setImageWithURL:[NSURL URLWithString:data[@"photo"]] placeholderImage:[UIImage imageNamed:@"home_rec"]];
    self.name.text = data[@"name"];
    self.size.text = [NSString stringWithFormat:@"%@g/份",data[@"size"]];
    self.price.text = [NSString stringWithFormat:@"¥%0.2f",[data[@"price"] floatValue]];
    self.mprice.text = [NSString stringWithFormat:@"¥%0.2f",[data[@"mprice"] floatValue]];

}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.photo.frame = CGRectScaleXY(0, 0, 290/2.0, 232/2.0);
    self.name.frame = CGRectScaleXY(10, self.photo.bottom+10, self.width-20, 12);
    self.size.frame = CGRectScaleXY(10, self.name.bottom+10, 50, 10);
    self.price.frame = CGRectScaleXY(10,self.size.bottom+10, 50, 10);
    self.mprice.frame = CGRectScaleXY(self.price.right+5, self.size.bottom+10, 50, 10);
    
//    if (SCREEN_WIDTH >= 320) {
//        self.countLabel.top = self.countLabel.top-4;
//        self.perlabel.top = self.perlabel.top-4;
//        self.priceLabel.top = self.priceLabel.top-10;
//    }
}



#pragma mark - Getter
- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [UIImageView new];
    }
    return _photo;
}

//- (UILabel *)miaosha
//{
//    if (!_miaosha) {
//        _miaosha = [UILabel new];
//        _miaosha.textColor = WHITE_COLOR;
//        _miaosha.backgroundColor = RGB_COLOR(241, 123, 82);
//        _miaosha.layer.cornerRadius = 17/2.0;
//        _miaosha.clipsToBounds = YES;
//        _miaosha.text = @"秒杀";
//        _miaosha.font = FONT(10);
//        _miaosha.textAlignment = NSTextAlignmentCenter;
//        _miaosha.hidden = YES;
//    }
//    return _miaosha;
//}

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

- (UILabel *)mprice
{
    if (!_mprice) {
        _mprice = [CrossLineLabel new];
        _mprice.font = FONT(15);
        _mprice.textColor = RGB_COLOR(154, 154, 154);
    }
    return _mprice;
}

@end
