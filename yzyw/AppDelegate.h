//
//  AppDelegate.h
//  
//
//  Created by nmg on 16/2/2.
//  Copyright (c) 2015 nmg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, strong) UITabBarController *tabBarController;


- (void)changeToMainPage;
-(void) updateCartTabBadge;


@end
