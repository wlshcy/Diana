//
//  EWButton.m
//  Garden
//
//  Created by 金学利 on 8/12/15.
//  Copyright (c) 2015 Kingxl. All rights reserved.
//

#import "EWButton.h"

@implementation EWButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1.0);
    //设置颜色
    CGContextSetRGBStrokeColor(context,242/255.0, 242/255.0, 242/255.0, 1.0);
    //开始绘制
    CGContextBeginPath(context);
    //画笔移动到点(31,170)
    CGContextMoveToPoint(context,0, 0);
    //下一点
    CGContextAddLineToPoint(context,self.width, 0);
    //绘制完成
    CGContextStrokePath(context);
}


@end
