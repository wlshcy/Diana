//
//  ComboListCell.m
//  yzyw
//
//  Created by nmg on 16/3/14.
//  Copyright © 2016年 nmg. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ComboListCell.h"

#define PHOTO_WIDTH 366/2.0
#define PHOTO_HEIGHT 232/2.0

@interface ComboListCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *photo;

@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic ,strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *priceLabel;
//@property (nonatomic, strong) UILabel *oriPriceLabel;

@end

@implementation ComboListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CLEAR_COLOR;
        [self addSubview:self.backView];
        [self.backView addSubview:self.photo];
        [self.backView addSubview:self.typeView];
        [self.backView addSubview:self.nameLabel];
        [self.backView addSubview:self.desLabel];
        [self.backView addSubview:self.numberLabel];
        [self.backView addSubview:self.priceLabel];
        //        [self.backView addSubview:self.oriPriceLabel];
        
    }
    return self;
}

- (void)configProductCell
{
    self.nameLabel.text = @"幸福家庭周套餐";
    self.typeView.image = [UIImage imageNamed:@"shu"];
    
//    DBLog(@"----farm===%@",data.farm);
//    
//    self.desLabel.text = [data weekTimesAndWeight];
//    self.numberLabel.text = [data monthAndWeight];
//    [self.photo sd_setImageWithURL:[NSURL URLWithString:[data photo]]placeholderImage:[UIImage imageNamed:@"taocan"]];
//    self.nameLabel.text = [data name];
//    
//    self.typeView.image = [UIImage imageNamed:@"shu"];
//    
//    //self.priceLabel.text =  [data totalPrice];
//    
//    
//    NSString *priceText = [NSString stringWithFormat:@"%@  %@",[data totalPrice],[data oriPrice]];
//    
//    
//    
//    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:priceText];
//    
//    NSRange range = [priceText rangeOfString:[data oriPrice]];
//    
//    
//    [content addAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),NSStrikethroughColorAttributeName:RGB_COLOR(140, 140, 140),NSForegroundColorAttributeName:RGB_COLOR(140, 140, 140),NSFontAttributeName:FONT(14)} range:range];
//    
//    self.priceLabel.attributedText = content;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 130);
    self.photo.frame = CGRectMake(self.backView.width-PHOTO_WIDTH-7, 7, PHOTO_WIDTH, PHOTO_HEIGHT);
    
    self.typeView.frame = CGRectMake(20, 20, 4, 15);
    self.nameLabel.frame = CGRectMake(self.typeView.right+10, 20, 150, 15);
    self.desLabel.frame = CGRectMake(20, self.nameLabel.bottom+15, 160, 12);
    
    
    self.numberLabel.frame = CGRectMake(20, self.desLabel.bottom+10, 150, 12);
    self.priceLabel.frame = CGRectMake(20, self.numberLabel.bottom+10, 200, 14);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Getter

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = WHITE_COLOR;
    }
    return _backView;
}

- (UIImageView *)photo
{
    if (!_photo) {
        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
        //        _photo.backgroundColor = GRAY_COLOR;
    }
    return _photo;
}

- (UIImageView *)typeView
{
    if (!_typeView) {
        _typeView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _typeView;
}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT(15);
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = BLACK_COLOR;
    }
    return _nameLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.font = FONT(14);
        _desLabel.backgroundColor = CLEAR_COLOR;
        _desLabel.textColor = RGB_COLOR(240, 116, 72);
    }
    return _desLabel;
}


- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT(12);
        _numberLabel.backgroundColor = CLEAR_COLOR;
        _numberLabel.textColor = RGB_COLOR(154, 154, 154);
    }
    return _numberLabel;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = FONT(14);
        _priceLabel.backgroundColor = CLEAR_COLOR;
        _priceLabel.textColor = RGB_COLOR(17, 194, 88);
    }
    return _priceLabel;
}


//- (UILabel *)oriPriceLabel
//{
//    if (!_oriPriceLabel) {
//        _oriPriceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        _oriPriceLabel.font = FONT(14);
//        _oriPriceLabel.backgroundColor = CLEAR_COLOR;
//    }
//    return _oriPriceLabel;
//}



@end