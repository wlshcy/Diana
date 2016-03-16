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
@property (nonatomic, strong) UIView *lineView1;
@property (nonatomic, strong) UIView *lineView2;
//@property (nonatomic, strong) UIImageView *photo;

//@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic ,strong) UILabel *freqLabel;
@property (nonatomic ,strong) UILabel *weightLabel;
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
//        [self addSubview:self.lineView1];
        [self addSubview:self.lineView2];
//        [self.backView addSubview:self.photo];
//        [self.backView addSubview:self.typeView];
        [self.backView addSubview:self.nameLabel];
        [self.backView addSubview:self.freqLabel];
        [self.backView addSubview:self.weightLabel];
        [self.backView addSubview:self.numberLabel];
        [self.backView addSubview:self.priceLabel];
        //        [self.backView addSubview:self.oriPriceLabel];
        
    }
    return self;
}

- (void)configComboListCell:data
{
    DBLog(@"%@", data[@"name"]);
    self.nameLabel.text = data[@"name"];
    self.freqLabel.text = [NSString stringWithFormat:@"一周配送%@次", data[@"freq"]];
    self.weightLabel.text = [NSString stringWithFormat:@"%@斤/次", data[@"weight"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@人份",data[@"num"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",data[@"price"]];
    
    
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
    
    self.backView.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 160);
    self.nameLabel.frame = CGRectMake(0,20,self.backView.width, 15);
//    self.lineView1.frame = CGRectMake(10, self.nameLabel.bottom+10, self.backView.width, 1);

    self.freqLabel.frame = CGRectMake(0,self.nameLabel.bottom+10, self.backView.width, 15);
    self.weightLabel.frame = CGRectMake(0,self.freqLabel.bottom+10, self.backView.width, 15);
    self.numberLabel.frame = CGRectMake(0, self.weightLabel.bottom+10, self.backView.width, 15);
    self.lineView2.frame = CGRectMake(10, self.numberLabel.bottom+10, self.backView.width, 1);
    self.priceLabel.frame = CGRectMake(0,self.lineView2.bottom+10, self.backView.width, 15);
//    self.photo.frame = CGRectMake(self.backView.width-PHOTO_WIDTH-7, 7, PHOTO_WIDTH, PHOTO_HEIGHT);
//    
//    self.typeView.frame = CGRectMake(20, 20, 4, 15);
//    self.nameLabel.frame = CGRectMake(self.typeView.right+10, 20, 150, 15);
//    self.desLabel.frame = CGRectMake(20, self.nameLabel.bottom+15, 160, 12);
//    
//    
//    self.numberLabel.frame = CGRectMake(20, self.desLabel.bottom+10, 150, 12);
//    self.priceLabel.frame = CGRectMake(20, self.numberLabel.bottom+10, 200, 14);
    
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

- (UIView *)lineView1
{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView1.backgroundColor = TABLE_COLOR;
    }
    return _lineView1;
}

- (UIView *)lineView2
{
    if (!_lineView2) {
        _lineView2 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView2.backgroundColor = TABLE_COLOR;
    }
    return _lineView2;
}

//- (UIImageView *)photo
//{
//    if (!_photo) {
//        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
//        //        _photo.backgroundColor = GRAY_COLOR;
//    }
//    return _photo;
//}

//- (UIImageView *)typeView
//{
//    if (!_typeView) {
//        _typeView = [[UIImageView alloc] initWithFrame:CGRectZero];
//    }
//    return _typeView;
//}


- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT(15);
        _nameLabel.backgroundColor = CLEAR_COLOR;
        _nameLabel.textColor = BLACK_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UILabel *)freqLabel
{
    if (!_freqLabel) {
        _freqLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _freqLabel.font = FONT(14);
        _freqLabel.backgroundColor = CLEAR_COLOR;
        _freqLabel.textColor = GRAY_COLOR;
        _freqLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _freqLabel;
}

- (UILabel *)weightLabel
{
    if (!_weightLabel) {
        _weightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _weightLabel.font = FONT(14);
        _weightLabel.backgroundColor = CLEAR_COLOR;
        _weightLabel.textColor = GRAY_COLOR;
        _weightLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _weightLabel;
}



- (UILabel *)numberLabel
{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLabel.font = FONT(14);
        _numberLabel.backgroundColor = CLEAR_COLOR;
        _numberLabel.textColor = GRAY_COLOR;
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = FONT(18);
        _priceLabel.backgroundColor = CLEAR_COLOR;
        _priceLabel.textColor = RGB_COLOR(50,189, 111);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
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