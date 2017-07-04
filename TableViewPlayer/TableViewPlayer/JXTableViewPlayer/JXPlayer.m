//
//  JXPlayer.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "JXPlayer.h"



@interface JXPlayer ()

@property (strong, nonatomic)AVPlayer *player;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation JXPlayer

static JXPlayer *_shareInstance;

+ (instancetype)shareInstance{
    if (!_shareInstance) {
        _shareInstance = [[self alloc] init];
    }
    return _shareInstance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    if (!_shareInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _shareInstance = [super allocWithZone:zone];
        });
    }
    return _shareInstance;
}

- (AVPlayer *)playWithUrl:(NSURL *)url {
    
    //1.资源的请求
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    
    //2.资源的组织
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //3.资源的播放
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    return self.player;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        
        if ([keyPath isEqualToString:@"status"]) {
            AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] integerValue];
            if (status == AVPlayerItemStatusReadyToPlay) {
                [self.player play];
            }else{
                NSLog(@"状态未知");
            }
        }
        
    });
    
}



@end
