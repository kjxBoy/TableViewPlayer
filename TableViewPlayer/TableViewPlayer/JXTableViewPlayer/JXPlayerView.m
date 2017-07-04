//
//  JXPlayerView.m
//  TableViewPlayer
//
//  Created by apple on 2017/7/4.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "JXPlayer.h"

@implementation JXPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (NSURL *)url{
    return [NSURL URLWithString:self.urlStr];
}


- (void)setUrlStr:(NSString *)urlStr
{
    _urlStr = urlStr;
    
    AVPlayer *player = [[JXPlayer shareInstance] playWithUrl:self.url];
    
    ((AVPlayerLayer *)self.layer).videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    ((AVPlayerLayer *)self.layer).player = player;
    
}



@end
