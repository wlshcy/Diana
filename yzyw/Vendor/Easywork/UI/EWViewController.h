//
//  EWViewController.h
//  Garden
//
//  Created by 金学利 on 8/5/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EWViewController : UIViewController

//Loading
- (void)showLoading;
- (void)showLoadingWithTitle:(NSString *)title;
- (void)hideLoading;

//Status
- (void)showSuccessStatusWithTitle:(NSString *)title;
- (void)showErrorStatusWithTitle:(NSString *)title;
- (void)showFailureStatusWithTitle:(NSString *)title;

@end
