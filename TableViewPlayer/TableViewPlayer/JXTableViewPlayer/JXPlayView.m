//
//  JXPlayView.m
//  TableViewPlayer
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXPlayView.h"
#import <AVFoundation/AVFoundation.h>

@interface JXPlayView ()

@end

@implementation JXPlayView

- (instancetype)init
{
    self = [super init];
    if (self) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
        
        [self addGestureRecognizer:tap];
    }
    return self;
}

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (void)click
{
    if ([self.delegate respondsToSelector:@selector(playViewClick:)]) {
        [self.delegate playViewClick:self];
    }
}

- (void)setUpPlayer:(AVPlayer *)player
{
    ((AVPlayerLayer *)self.layer).player = player;
    
    self.backgroundColor = [UIColor blackColor];
}


@end
