//
//  UIView+Frame.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (CGFloat)width
{
    return self.bounds.size.width;
}

- (CGFloat)height
{
    return self.bounds.size.height;
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


@end
