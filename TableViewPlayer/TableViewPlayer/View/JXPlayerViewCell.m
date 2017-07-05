//
//  JXPlayerViewCell.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXPlayerViewCell.h"
#import "UIView+Frame.h"


#define scaleW 0.95
#define scaleH 0.6

@interface JXPlayerViewCell ()

@end

@implementation JXPlayerViewCell

- (UIView *)centerView
{
    if (!_centerView) {
        
        _centerView = [[UIView alloc] initWithFrame:self.bounds];
        
        _centerView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        _centerView.width = self.width * scaleW;
        
        _centerView.height = self.height * scaleH;
        
        _centerView.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        
        _centerView.backgroundColor = [UIColor orangeColor];
        
        _centerView.clipsToBounds = YES;
        
        _centerView.layer.cornerRadius = 5;
    }
    return _centerView;
}


- (void)setUpView{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self addSubview:self.centerView];
    
}


@end
