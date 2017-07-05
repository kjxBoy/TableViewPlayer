//
//  ViewController.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "JXPlayerViewCell.h"



static NSString *playUrl = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)NSIndexPath *indexPath ;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic)AVPlayer *player;

@property (strong, nonatomic)AVPlayerLayer *playerLayer;

@property (assign, nonatomic,getter=isRemove)BOOL remove;

@end



@implementation ViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _remove = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:tableView];
}





#pragma mark - 视频列表

- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil) {
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:nil];
        
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;

    }
    return _playerLayer;
}



- (void)resetPlayerLayerWithFrame:(CGRect)frame withPlayUrl:(NSURL *)playUrl
{
    //重设设置self.player
    AVURLAsset *asset = [AVURLAsset assetWithURL:playUrl];
    
    //2.资源的组织
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    _remove = NO;
    
    //3.资源的播放
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];

    self.playerLayer.player = self.player;
    
    self.playerLayer.frame = frame;

}


- (NSURL *)playUrl {
    return [NSURL URLWithString:playUrl];
}

#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.playerItem removeObserver:self forKeyPath:@"status"];
        
        _remove = YES;
        
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




#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JXPlayerViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[JXPlayerViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    [cell setUpView];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_remove) {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    }
    
    JXPlayerViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //重置self.playerLayer
    [self resetPlayerLayerWithFrame:cell.centerView.bounds withPlayUrl:self.playUrl];
    
    [cell.centerView.layer addSublayer:self.playerLayer];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView.indexPathsForVisibleRows indexOfObject:indexPath] == NSNotFound)
    {
        if (self.indexPath && indexPath.row == self.indexPath.row) {
            
        }
    }
}



@end
