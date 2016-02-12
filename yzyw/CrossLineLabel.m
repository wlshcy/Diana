//
//  CrossLineLabel.m
//  Lynp
//
//  Created by nmg on 16/1/16.
//  Copyright © 2016年 nmg. All rights reserved.
//

#import "CrossLineLabel.h"

@implementation CrossLineLabel

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.textColor setStroke];
    CGFloat y = rect.size.height * 0.5;
    CGContextMoveToPoint(context, 0, y);
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    CGContextAddLineToPoint(context, size.width,y);
    CGContextStrokePath(context);
}

@end