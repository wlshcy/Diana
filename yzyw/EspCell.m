//
//  EspCell.m
//  Lynp
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "EspCell.h"
#import <UIImageView+AFNetworking.h>
#import "CrossLineLabel.h"


@interface EspCell ()
@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *size;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) CrossLineLabel *mprice;

@end

@implementation EspCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        
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


- (void)configEspCell:data
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
    
    
    self.photo.frame = CGRectMake(10, 10, SCREEN_WIDTH * 0.4 - 10, 100);
    self.name.frame = CGRectMake(self.photo.right+20, self.photo.top+15, 150, 20);
    self.size.frame = CGRectMake(self.photo.right+20, self.name.bottom+15, 150, 20);
    self.price.frame = CGRectMake(self.photo.right+20, self.size.bottom+15, 80, 20);
    self.mprice.frame = CGRectMake(self.price.right+5, self.size.bottom+15, 80, 20);
    
    [self.name sizeToFit];
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
        _name.font = FONT(15);
    }
    return _name;
}

- (UILabel *)size
{
    if (!_size) {
        _size = [UILabel new];
        _size.font = FONT(16);
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
