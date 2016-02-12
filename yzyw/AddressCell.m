//
//  AddressCell.m
//  Garden
//
//  Created by 金学利 on 8/26/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "AddressCell.h"

@implementation AddressCell

- (void)awakeFromNib {
    // Initialization code
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.detailTextLabel.frame = CGRectMake(self.textLabel.left, self.textLabel.bottom+6, self.detailTextLabel.width, self.detailTextLabel.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
