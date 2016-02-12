//
//  VGUtils.h
//  Garden
//
//  Created by 金学利 on 8/12/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGUtils : NSObject

+ (BOOL)userHasLogin;
+ (BOOL)isNeedUpdate:(NSString *)ver;

+ (void)saveUserData:(NSDictionary *)data;

+ (UIViewController *)cacheControllerWithName:(NSString *)name controllers:(NSArray *)controllers;

void POSTNOTIFICATION(NSString *name,id data);

void REMOVENOTIFICATION(id sender);

NSString *STR(id data);

+ (BOOL)isWelcome;

@end
