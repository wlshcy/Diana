//
//  OrderCell.m
//  Garden
//
//  Created by 金学利 on 8/8/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "OrderCell.h"

@interface OrderCell ()
@property (nonatomic, strong) UILabel *createdLabel;
@property (nonatomic, strong) UILabel *total;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation OrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.topView];
        [self addSubview:self.bottomView];
        [self addSubview:self.createdLabel];
        [self addSubview:self.total];
    }
    return self;
}


- (void)configOrderCell
{
//    self.titleLabel.text =[NSString stringWithFormat:@"第%@次选品",@(data.times)];
//    self.dateLabel.text =[data sentDate];
//    self.typeLabel.text = data.title; //@"套餐A";
//    self.statusLabel.text = [data orderStatus];//@"为配送";
//    self.statusLabel.backgroundColor = [data orderStatusColor];
//    
//    
//    if (data.status == 0 || data.status == 1) {
//        self.statusLabel.userInteractionEnabled = YES;
//    }else{
//        self.statusLabel.userInteractionEnabled = NO;
//    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 40, SCREEN_WIDTH, 1);
    self.bottomView.frame = CGRectMake(0, 120, SCREEN_WIDTH, 1);
    self.createdLabel.frame = CGRectMake(10,0,100,40);
    self.total.frame = CGRectMake(10, 120, 100, 40);
//    self.titleLabel.frame = CGRectMake(20, 23, 150, 14);
//    self.dateLabel.frame = CGRectMake(20, self.titleLabel.bottom+7, 150, 12);
//    self.typeLabel.frame = CGRectMake(20, self.dateLabel.bottom+7, 100, 20);
//    self.statusLabel.frame = CGRectMake(SCREEN_WIDTH-43-54, (self.height-23)/2.0, 54, 23);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma mark - Getter
- (UILabel *)createdLabel
{
    if (!_createdLabel) {
        _createdLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _createdLabel.font = FONT(15);
        _createdLabel.text = @"下单时间";
        _createdLabel.textColor = RGB_COLOR(68, 68, 68);
    }
    return _createdLabel;
}

- (UILabel *)total
{
    if (!_total) {
        _total = [[UILabel alloc] initWithFrame:CGRectZero];
        _total.font = FONT(15);
        _total.text = @"共计";
        _total.textColor = RGB_COLOR(68, 68, 68);
    }
    return _total;
}


- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLabel.font = FONT(10);
        _typeLabel.textColor = RGB_COLOR(68, 68, 68);
        _typeLabel.layer.borderColor = RGB_COLOR(68, 68, 68).CGColor;
        _typeLabel.layer.borderWidth = 0.6;
        _typeLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _typeLabel;
}


- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLabel.font = FONT(12);
        _statusLabel.textColor = WHITE_COLOR;//RGB_COLOR(68, 68, 68);
        _statusLabel.backgroundColor = RGB_COLOR(148, 214, 192);
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.layer.cornerRadius = 4;
        _statusLabel.clipsToBounds = YES;
    
    }
    return _statusLabel;
}

- (UIView *) topView
{
    if (!_topView){
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = RGB_COLOR(242, 242, 242);
        
    }
    return _topView;
}

- (UIView *) bottomView
{
    if (!_bottomView){
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = RGB_COLOR(242, 242, 242);
        
    }
    return _bottomView;
}

@end
