//
//  VegHeader.h
//  Lynp
//
//  Created by nmg on 1/11/16.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VegHeaderDelegate <NSObject>

- (void)didSelectItemAtIndex:(NSInteger)index;

@end

@interface VegHeader : UIView

@property (nonatomic, strong) UIButton *allCaiBtn;
@property (nonatomic, strong) UIButton *myCaiBtn;
@property (nonatomic, assign) id<VegHeaderDelegate>delegate;

- (void)configVegHeader:(NSMutableArray *)data;

- (void)stopTimer;

@end
