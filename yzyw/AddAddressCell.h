//
//  AddAddressCell.h
//  Garden
//
//  Created by 金学利 on 9/12/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAddressCell : UITableViewCell

@property (nonatomic, strong) UITextField *textField;

- (void)configCell:(NSIndexPath *)indexPath;
@end
