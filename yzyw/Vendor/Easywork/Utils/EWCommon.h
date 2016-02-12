//
//  EWCommon.h
//  Easywork
//
//  Created by Kingxl on 5/4/14.
//  Copyright (c) 2014 Jin. All rights reserved.
//  http://kingxl.cn

#ifndef Easywork_EWCommon_h
#define Easywork_EWCommon_h

#pragma mark - Color

#define BLACK_COLOR         [UIColor blackColor]
#define DARKGRAY_COLOR      [UIColor darkGrayColor]
#define LIGHTGRAY_COLOR     [UIColor lightGrayColor]
#define WHITE_COLOR         [UIColor whiteColor]
#define GRAY_COLOR          [UIColor grayColor]
#define RED_COLOR           [UIColor redColor]
#define GREEN_COLOR         [UIColor greenColor]
#define BLUE_COLOR          [UIColor blueColor]
#define CYAN_COLOR          [UIColor cyanColor]
#define YELLOW_COLOR        [UIColor yellowColor]
#define MAGENTA_COLOR       [UIColor magentaColor]
#define ORANGE_COLOR        [UIColor orangeColor]
#define PURPLE_COLOR        [UIColor purpleColor]
#define BROWN_COLOR         [UIColor brownColor]
#define CLEAR_COLOR         [UIColor clearColor]
#define RGB_COLOR(R,G,B)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]
#define RGBA_COLOR(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0  alpha:A]


#pragma mark - font
#define FONT(A)   [UIFont systemFontOfSize:A]
#define BFONT(A)  [UIFont boldSystemFontOfSize:A]


#pragma mark - Size

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height


#pragma mark - Device

#define iPad    ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)?YES:NO
#define iPhone  ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)?YES:NO


#pragma mark - SDK Version

#define SystemVersion [[UIDevice currentDevice] systemVersion]

#pragma mark - IOS7
#define IOS7Later ([SystemVersion floatValue] >=7.0)

#define IOS8Later ([SystemVersion floatValue] >=8.0)



#endif
