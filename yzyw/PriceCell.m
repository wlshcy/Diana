//
//  PriceCell.m
//  Garden
//
//  Created by 金学利 on 9/14/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "PriceCell.h"

@implementation PriceCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.textLabel.textColor = BLACK_COLOR;//RGB_COLOR(242, 96, 63);
        self.detailTextLabel.textColor = RGB_COLOR(242, 96, 63);
        self.textLabel.font = FONT(14);
        self.detailTextLabel.font = FONT(23);
        
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 30, SCREEN_WIDTH, 14);
    self.detailTextLabel.frame = CGRectMake(0, self.textLabel.bottom + 14, SCREEN_WIDTH, 23);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
