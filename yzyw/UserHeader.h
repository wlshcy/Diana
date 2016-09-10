//
//  UserHeader.h
//  Garden
//
//  Created by 金学利 on 8/7/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserHeaderDelegate <NSObject>

- (void)login;

@end

@interface UserHeader : UIView

@property (nonatomic, assign) id<UserHeaderDelegate>delegate;
- (void)configUserHeader:(id)data;

@end
