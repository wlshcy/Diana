//
//  ZoneListViewController.h
//  Lynp
//
//  Created by nmg on 16/2/6.
//  Copyright © 2016年 nmg. All rights reserved.
//

#ifndef ZoneListViewController_h
#define ZoneListViewController_h

#import <UIKit/UIKit.h>

@class ZoneListViewController;
@protocol PassingValueDelegate <NSObject>

@optional
    -(void)viewController:(ZoneListViewController *)viewController didPassingValueWithInfo:(id)info;
@end


@interface ZoneListViewController : UIViewController <UIPickerViewDelegate ,UIPickerViewDataSource>

@property (nonatomic ,strong) UIPickerView *cityPicker;
@property (nonatomic ,strong) UILabel *cityLabel;

@property (nonatomic, assign) id<PassingValueDelegate> delegate;

@end


#endif /* ZoneListViewController_h */
