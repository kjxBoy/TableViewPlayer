//
//  UIView+Frame.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)jx_X
{
    return self.frame.origin.x;
}

- (CGFloat)jx_Y
{
    return self.frame.origin.y;
}

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}


- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)pointX{
    CGPoint point = self.center;
    point.x = pointX;
    self.center = point;
}

- (void)setCenterY:(CGFloat)pointY{
    CGPoint point = self.center;
    point.y = pointY;
    self.center = point;
}


- (void)setJx_X:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setJx_Y:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
