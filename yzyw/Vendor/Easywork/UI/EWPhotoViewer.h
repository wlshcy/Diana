//
//  EWPhotoViewer.h
//  Easywork
//
//  Created by Jin on 15-1-14.
//  Copyright (c) 2015年 kingxl. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SelectBlock)(BOOL selected);

@interface EWPhotoViewer : NSObject

+(instancetype)instance;

- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL isShow:(BOOL)isShow block:(SelectBlock)block;

- (void)showImages:(NSArray *)images index:(NSInteger)index block:(SelectBlock)block;

- (void)showImage:(UIImage *)image imageURL:(NSString *)imageURL title:(NSString *)title;
@end
