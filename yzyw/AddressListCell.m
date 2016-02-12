//
//  ShoppingCell.m
//  Garden
//
//  Created by nmg on 16/2/2.
//  Copyright (c) 2016 nmg. All rights reserved.
//

#import "AddressListCell.h"

#import "UIImageView+MJWebCache.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface AddressListCell ()

@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *mobile;
@property (nonatomic, strong) UILabel *address;

//@property (nonatomic, strong) UIButton *default_addr;
//@property (nonatomic, strong) UIButton *edit_addr;
//@property (nonatomic, strong) UIButton *delete_addr;

@end

@implementation AddressListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = WHITE_COLOR;
        [self addSubview:self.name];
        [self addSubview:self.mobile];
        [self addSubview:self.address];
    }
    return self;
}


//- (void)configAddrCell:(NSIndexPath *)indexPath data:(NSMutableArray *)data
- (void)configAddrCell:(NSDictionary *)data
{
        self.name.text = data[@"name"];
        self.mobile.text = data[@"mobile"];
        DBLog(@"%@", data[@"address"]);
        self.address.text = [NSString stringWithFormat:@"%@%@",data[@"region"],data[@"address"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.name.frame = CGRectMake(15, 15, 50, 20);
    self.mobile.frame = CGRectMake(self.name.right+20, 15, 150, 20);
    self.address.frame = CGRectMake(15, self.name.bottom+15, SCREEN_WIDTH, 20);
//    self.default_addr.frame = CGRectMake(15, 10, 18,18);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



#pragma mark - getter & setter
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


- (UILabel *)mobile
{
    if (!_mobile) {
        _mobile = [[UILabel alloc] initWithFrame:CGRectZero];
        _mobile.font = FONT(16);
//        _mobile.textColor = RGB_COLOR(50, 189, 111);
        _mobile.backgroundColor = CLEAR_COLOR;
    }
    
    return _mobile;
    
}

- (UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] initWithFrame:CGRectZero];
        _address.font = FONT(14);
        _address.textColor = GRAY_COLOR;
        _address.backgroundColor = CLEAR_COLOR;
    }
    
    return _address;
    
}

//- (UIButton *)default_addr
//{
//    if (!_default_addr) {
//        _default_addr = [UIButton buttonWithType:UIButtonTypeCustom];
////        _default_addr.frame = CGRectMake(15, 10, 18,18);
//        _default_addr.layer.cornerRadius = 9;
//        _default_addr.clipsToBounds = YES;
//        _default_addr.layer.borderColor=[UIColor colorWithRed:204.0f/255.0f
//                                                green:204.0f/255.0f
//                                                blue:204.0f/255.0f
//                                                alpha:1.0f].CGColor;
//        _default_addr.layer.borderWidth=1.0f;
//    }
//    return _default_addr;
//}
@end
