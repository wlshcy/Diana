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
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic ,strong) UILabel *freqLabel;
@property (nonatomic ,strong) UILabel *weightLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@end

@implementation ComboListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = CLEAR_COLOR;
        [self addSubview:self.backView];
        [self addSubview:self.lineView];
        [self.backView addSubview:self.nameLabel];
        [self.backView addSubview:self.freqLabel];
        [self.backView addSubview:self.weightLabel];
        [self.backView addSubview:self.numberLabel];
        [self.backView addSubview:self.priceLabel];
    }
    return self;
}

- (void)configComboListCell:data
{
    DBLog(@"%@", data[@"price"]);
    self.nameLabel.text = data[@"name"];
    self.freqLabel.text = [NSString stringWithFormat:@"一周配送%@次", data[@"freq"]];
    self.weightLabel.text = [NSString stringWithFormat:@"%@斤/次", data[@"weight"]];
    self.numberLabel.text = [NSString stringWithFormat:@"%@人份",data[@"num"]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[data[@"price"] floatValue]];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(10, 5, SCREEN_WIDTH-20, 150);
    self.nameLabel.frame = CGRectMake(0,20,self.backView.width, 15);

    self.freqLabel.frame = CGRectMake(0,self.nameLabel.bottom+10, self.backView.width, 15);
    self.weightLabel.frame = CGRectMake(0,self.freqLabel.bottom+10, self.backView.width, 15);
    self.numberLabel.frame = CGRectMake(0, self.weightLabel.bottom+10, self.backView.width, 15);
    self.lineView.frame = CGRectMake(10, self.numberLabel.bottom+20, self.backView.width, 1);
    self.priceLabel.frame = CGRectMake(0,self.lineView.bottom, self.backView.width, 15);
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

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = TABLE_COLOR;
    }
    return _lineView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = FONT(16);
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

@end