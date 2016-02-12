//
//  PacketCell.m
//  Garden
//
//  Created by 金学利 on 9/6/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "PacketCell.h"

@interface PacketCell()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *topLine;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIImageView *backLogoView;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end


@implementation PacketCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        self.backgroundColor = CLEAR_COLOR;
        [self addSubview:self.backView];
        [self.backView addSubview:self.topLine];
        [self.backView addSubview:self.backLogoView];
        [self.backView addSubview:self.priceLabel];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.subTitleLabel];
        [self.backView addSubview:self.dateLabel];
        [self.backView addSubview:self.desLabel];
        
    }
    return self;
}

- (void)configPacketCell:(CouponsData *)data price:(float)price
{
    

    if (data.type == 1) {
        self.titleLabel.text = @"宅配套餐优惠红包";
        //self.desLabel.text = @"仅用于购买宅配套餐";

    }else{
        self.titleLabel.text = @"商品优惠红包";
        //self.desLabel.text = @"仅用于农庄优选商品";

    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"有效期至 %@",[NSDate ew_formatTimeWithInterval:data.expire]];
    
    
    if (data.distype == 1) {
        //套餐优惠卷
        
        NSString *text = [NSString stringWithFormat:@"￥%@",@(data.discount/100)];
        self.priceLabel.attributedText = [text ew_focusSubstring:@"￥" color:RGB_COLOR(254, 120, 107) font:FONT(22)];

        
    }else{
        
        NSString *text = [NSString stringWithFormat:@"￥%@折",@(data.discount/10.0)];
        self.priceLabel.attributedText = [text ew_focusSubstring:@"￥" color:RGB_COLOR(254, 120, 107) font:FONT(22)];
    }
    
    
    if (data.charge == 0) {
        self.subTitleLabel.text = nil;
    }else{
        self.subTitleLabel.text = [NSString stringWithFormat:@"满%0.2f元使用",data.charge/100.00];
    }
    
    DBLog(@"-----today==%@",@([[NSDate date] timeIntervalSince1970] ));
    DBLog(@"expire=%@",@(data.expire));
    
    if ([[NSDate date] timeIntervalSince1970] > data.expire/1000.0 || data.used == 1) {
        DBLog(@"红包过期了");
        _topLine.image = nil;
        _topLine.image = [UIImage imageNamed:@"top_line_gray"];
        
        _priceLabel.textColor = RGB_COLOR(204, 204, 204);
        _titleLabel.textColor = RGB_COLOR(204, 204, 204);
        _dateLabel.textColor = RGB_COLOR(204, 204, 204);
        _desLabel.textColor = RGB_COLOR(204, 204, 204);
        _subTitleLabel.textColor = RGB_COLOR(204, 204, 204);
        _backLogoView.image = [UIImage imageNamed:@"packet_disable"];

    }else{
        _topLine.image = nil;
        _topLine.image = [UIImage imageNamed:@"packet_line"];
        
        _priceLabel.textColor = RGB_COLOR(254, 120, 107);
        _titleLabel.textColor = RGB_COLOR(87, 87, 87);
        _dateLabel.textColor = RGB_COLOR(254, 120, 107);
        _desLabel.textColor = RGB_COLOR(87, 87, 87);
        _backLogoView.image = [UIImage imageNamed:@"packet_logo"];

    }
    
    
    if (price > 0 && data.charge/100.0 > price) {
        _topLine.image = nil;
        _topLine.image = [UIImage imageNamed:@"top_line_gray"];
        
        _priceLabel.textColor = RGB_COLOR(204, 204, 204);
        _titleLabel.textColor = RGB_COLOR(204, 204, 204);
        _dateLabel.textColor = RGB_COLOR(204, 204, 204);
        _desLabel.textColor = RGB_COLOR(204, 204, 204);
        _subTitleLabel.textColor = RGB_COLOR(204, 204, 204);
        
        _backLogoView.image = [UIImage imageNamed:@"packet_disable"];
    }


}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 224/2.0);
    self.topLine.frame = CGRectMake(0, 0, self.backView.width, 8);
    self.backLogoView.frame = CGRectMake(self.backView.width-132/2.0-10, 30, 132/2.0, 144/2.0);
    self.priceLabel.frame = CGRectMake(15, 84/2.0-8, 250/2.0, 55);
    self.titleLabel.frame = CGRectMake(self.priceLabel.right+30, 70/2.0, 100, 12);
    self.subTitleLabel.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom+7, 100, 10);
    self.dateLabel.frame = CGRectMake(self.titleLabel.left, self.subTitleLabel.bottom+7, 120, 10);
    self.desLabel.frame = CGRectMake(self.titleLabel.left, self.dateLabel.bottom, 100, 30);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Getter
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = WHITE_COLOR;
        _backView.layer.cornerRadius = 3;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)topLine
{
    if (!_topLine) {
        _topLine = [UIImageView new];
        _topLine.image = [UIImage imageNamed:@"packet_line"];
    }
    return _topLine;
}

- (UIImageView *)backLogoView
{
    if (!_backLogoView) {
        _backLogoView = [UIImageView new];
        _backLogoView.image = [UIImage imageNamed:@"packet_logo"];
    }
    return _backLogoView;
}


- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [UILabel new];
        _priceLabel.textColor = RGB_COLOR(254, 120, 107);
        _priceLabel.font = FONT(54);
    }
    return _priceLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT(12);
        _titleLabel.textColor = RGB_COLOR(87, 87, 87);
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [UILabel new];
        _subTitleLabel.font = FONT(10);
        _subTitleLabel.textColor = RGB_COLOR(254, 120, 107);
    }
    return _subTitleLabel;
}


- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [UILabel new];
        _dateLabel.font = FONT(10);
        _dateLabel.textColor = RGB_COLOR(254, 120, 107);
    }
    return _dateLabel;
}

- (UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel = [UILabel new];
        _desLabel.font = FONT(10);
        _desLabel.textColor = RGB_COLOR(87, 87, 87);
        _desLabel.numberOfLines = 0;
        _desLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _desLabel;
}


@end
