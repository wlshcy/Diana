//
//  ShoppingCell.h
//  Garden
//
//  Created by 金学利 on 9/8/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCell : UITableViewCell

@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;

- (void)configCellData:(NSDictionary *)data;


@end
