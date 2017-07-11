//
//  JXPlayView.h
//  TableViewPlayer
//
//  Created by apple on 2017/7/10.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class JXPlayView;


@protocol JXPlayViewDelegate <NSObject>

- (void)playViewClick:(JXPlayView *)playView;

@end

@interface JXPlayView : UIView

@property (weak, nonatomic)id<JXPlayViewDelegate> delegate;

- (void)setUpPlayer:(AVPlayer *)player;


@end
