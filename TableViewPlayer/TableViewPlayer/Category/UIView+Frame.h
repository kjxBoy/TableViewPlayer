//
//  UIView+Frame.h
//  TableViewPlayer
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (CGFloat)width;

- (CGFloat)height;

- (CGFloat)centerX;

- (CGFloat)centerY;

- (CGFloat)jx_X;

- (CGFloat)jx_Y;


- (void)setCenterX:(CGFloat)pointX;

- (void)setCenterY:(CGFloat)pointY;


- (void)setWidth:(CGFloat)width;

- (void)setHeight:(CGFloat)height;


- (void)setJx_X:(CGFloat)x;

- (void)setJx_Y:(CGFloat)y;

@end
