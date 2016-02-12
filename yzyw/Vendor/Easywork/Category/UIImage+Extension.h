//
//  UIImage+Extension.h
//  MyVillage
//
//  Created by 金学利 on 3/15/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

+ (UIImage *)ew_fixOrientation:(UIImage *)srcImg;

- (UIImage *)ew_scaleToSize:(CGSize)size;

+ (UIImage *)ew_imageWithContentOfFile:(NSString *)fileName;

+ (UIImage *)ew_imageWithColor:(UIColor *)color;

@end
