//
//  MSStarView.m
//  MeiShi
//
//  Created by PeterLee on 2017/3/6.
//  Copyright © 2017年 PeterLee. All rights reserved.
//

#import "MSStarView.h"

@interface MSStarView()

@end

@implementation MSStarView

- (instancetype)initWithStarNum:(NSInteger)num {
    self = [super init];
    if (self) {
        _num = num;
    }
    return self;
}

- (void)setNum:(NSInteger)num {
    _num = num;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    if (_num) {
        CGFloat height = self.bounds.size.height;
        CGContextRef context = UIGraphicsGetCurrentContext();
        for (NSInteger i=1; i<=self.num; i++) {
            //确定中心点
            CGPoint centerPoint=CGPointMake(10+(i-1)*25, height/2);
            //确定半径
            CGFloat radius=7.0;
            //五角星五点数组
            CGPoint points[5];
            points[0]=CGPointMake(centerPoint.x,centerPoint.y-radius);
            //五角星每个点之间点夹角，采用弧度计算。没两个点进行连线就可以画出五角星
            //点与点之间点夹角为2*M_PI/5.0，
            CGFloat angle=4*M_PI/5.0;
            for (int i=1; i<5; i++) {
                CGFloat x=centerPoint.x-sinf(i*angle)*radius;
                CGFloat y=centerPoint.y-cosf(i*angle)*radius;
                points[i]=CGPointMake(x, y);
            }
            //上色
            [kRGBColor(255, 180, 0) set];
            CGContextMoveToPoint(context, points[0].x,points[0].y);
            for (int i=1; i<5; i++) {
                CGContextAddLineToPoint(context, points[i].x,points[i].y);
            }
        }
        CGContextDrawPath(context, kCGPathFillStroke);
        //回复上下文
        //CGContextRestoreGState(context);
    }
}


- (void)drawMultiStar:(CGContextRef) context starCount:(int)count {
    //确定中心点
    CGPoint centerPoint=CGPointMake(0, 0);
    //确定半径
    CGFloat radius=5.0;
    //五角星五点数组
    CGPoint points[5];
    points[0]=CGPointMake(centerPoint.x,centerPoint.y-radius);
    //五角星每个点之间点夹角，采用弧度计算。没两个点进行连线就可以画出五角星
    //点与点之间点夹角为2*M_PI/5.0，
    CGFloat angle=4*M_PI/5.0;
    for (int i=1; i<5; i++) {
        CGFloat x=centerPoint.x-sinf(i*angle)*radius;
        CGFloat y=centerPoint.y-cosf(i*angle)*radius;
        points[i]=CGPointMake(x, y);
    }
    
    for (int i=0; i<count; i++) {
        //保存上下文
        CGContextSaveGState(context);
        int randomX=arc4random_uniform(320);
        int randomY=arc4random_uniform(480);
        //随机移动画布位置
        CGContextTranslateCTM(context, randomX,randomY);
        //随机旋转画布
        //CGFloat roate=arc4random_uniform(90)*M_PI/180.0;
        //CGContextRotateCTM(context, roate);
        //随机缩放画布
        //float scale=arc4random_uniform(5)/10.0+0.2;
        //CGContextScaleCTM(context, scale, scale);
        [kRGBColor(255, 180, 0) set];
        CGContextMoveToPoint(context, points[0].x,points[0].y);
        for (int i=1; i<5; i++) {
            CGContextAddLineToPoint(context, points[i].x,points[i].y);
        }
        CGContextDrawPath(context, kCGPathFillStroke);
        //回复上下文
        CGContextRestoreGState(context);
    }
}

@end
