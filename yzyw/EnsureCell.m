//
//  EnsureCell.m
//  Garden
//
//  Created by nmg on 16/1/13.
//  Copyright © 2016年 Nmg. All rights reserved.
//

#import "EnsureCell.h"

#import "UIImageView+MJWebCache.h"

@interface EnsureCell ()
//@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *price;
@property (nonatomic, strong) UILabel *ride;
@property (nonatomic, strong) UILabel *count;
@end

@implementation EnsureCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WHITE_COLOR;
//        [self addSubview:self.photo];
        [self addSubview:self.name];
        [self addSubview:self.price];
        //[self addSubview:self.ride];
        [self addSubview:self.count];
        
    }
    return self;
}


- (void)populateCell:(NSDictionary *)data
{
    self.name.text = data[@"name"];
    self.price.text = [NSString stringWithFormat:@"￥%@",data[@"price"]];
    //self.ride.text = @"X";
    self.count.text = [NSString stringWithFormat:@"%@份",data[@"count"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.name.frame = CGRectMake(15, 10, SCREEN_WIDTH * 0.75, 40);
    self.price.frame = CGRectMake(self.name.right, 10, SCREEN_WIDTH * 0.2, 40);
    self.count.frame = CGRectMake(self.price.right, 10, SCREEN_WIDTH * 0.2, 40);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - getter & setter
//- (UIImageView *)photo
//{
//    if (!_photo) {
//        _photo = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _photo.userInteractionEnabled = YES;
//        
//    }
//    return _photo;
//}

- (UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        _name.font = FONT(16);
        _name.numberOfLines = 0;
        _name.backgroundColor = CLEAR_COLOR;
    }
    
    return _name;
}


- (UILabel *)price
{
    if (!_price) {
        _price = [[UILabel alloc] initWithFrame:CGRectZero];
        _price.font = FONT(16);
//        _price.textColor = RGB_COLOR(154, 154, 154);
       _price.backgroundColor = CLEAR_COLOR;
    }
    
    return _price;
    
}

- (UILabel *)ride
{
    if (!_ride) {
        _ride = [[UILabel alloc] initWithFrame:CGRectZero];
        _ride.font = FONT(14);
        _ride.backgroundColor = CLEAR_COLOR;
    }
    
    return _ride;
    
}


- (UILabel *)count
{
    if (!_count) {
        _count = [[UILabel alloc] initWithFrame:CGRectZero];
        _count.font = FONT(16);
//        _count.textAlignment = NSTextAlignmentCenter;
    }
    return _count;
}

@end
