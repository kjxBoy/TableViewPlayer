//
//  ViewController.m
//  TableViewPlayer
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Frame.h"
#import "JXPlayerViewCell.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

static NSString *playUrl = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,JXPlayerViewCellDelegate>

@property (strong, nonatomic)NSIndexPath *indexPath ;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic)AVPlayer *player;

@property (assign, nonatomic,getter=isRemove)BOOL remove;

@property (strong, nonatomic)UIView *smallShowView;

@property (strong,nonatomic)AVPlayerLayer *playerLayer;

@property (weak, nonatomic)UITableView * tableView;

@end



@implementation ViewController

- (AVPlayerLayer *)playerLayer
{
    if (_playerLayer == nil) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:nil];
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _playerLayer;
}

- (UIView *)smallShowView
{
    if (_smallShowView == nil) {
        _smallShowView = [[UIView alloc] init];
        
        _smallShowView.frame = CGRectMake(screenWidth, screenHeight - 110, screenWidth * 0.5, 100);
        _smallShowView.backgroundColor = [UIColor clearColor];
       
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(smallShowViewClick:)];
        
        [_smallShowView addGestureRecognizer:tapGesture];
        
    }
    return _smallShowView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _remove = YES;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;

    [self.view addSubview:tableView];
    
    [self.view addSubview:self.smallShowView];
}


#pragma mark - 视频列表
- (void)cellRemove
{
    [self.playerLayer removeFromSuperlayer];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.playerLayer.frame = self.smallShowView.bounds;
    } completion:^(BOOL finished) {
        
        [self.smallShowView.layer addSublayer:self.playerLayer];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.smallShowView.jx_X = screenWidth * 0.5;
        }];
    }];
}

- (void)cellShowWithCell:(JXPlayerViewCell *)cell andScrollView:(UIScrollView *)scrollView
{
    [self.playerLayer removeFromSuperlayer];
    
    self.smallShowView.jx_X = screenWidth;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.playerLayer.frame = [self cellFrame:cell];
        
    } completion:^(BOOL finished) {
        [scrollView.layer addSublayer:self.playerLayer];
    }];
}

- (void)addPlayObserver
{
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    _remove = NO;
}

- (void)removePlayObserver
{
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    _remove = YES;
}

- (void)coverSmallPlayerViewWithCell:(JXPlayerViewCell *)cell withScrollView:(UIScrollView *)scrollView
{
    [self.playerLayer removeFromSuperlayer];
    
    self.playerLayer.frame = [self cellFrame:cell];
    
    self.smallShowView.jx_X = screenWidth;
    
    [scrollView.layer addSublayer:self.playerLayer];

}

//重设设置self.player
- (void)resetPlayerWithPlayUrl:(NSURL *)playUrl
{
    AVURLAsset *asset = [AVURLAsset assetWithURL:playUrl];
    
    //2.资源的组织
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    [self addPlayObserver];
    
    //3.资源的播放
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
}


- (NSURL *)playUrl {
    return [NSURL URLWithString:playUrl];
}


#pragma mark - 监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self removePlayObserver];
        
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
    
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableView = (UITableView *)scrollView;
    
    JXPlayerViewCell *cell = [tableView cellForRowAtIndexPath:self.indexPath];
    
    if (self.indexPath == nil)  return;
    
    if ([tableView.indexPathsForVisibleRows indexOfObject:self.indexPath] == NSNotFound) {
        
        if (self.smallShowView.jx_X == screenWidth * 0.5) return;
        
        [self cellRemove];

    }else{
        
        if (self.smallShowView.jx_X == screenWidth) return;
        
        [self cellShowWithCell:cell andScrollView:scrollView];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

- (CGRect)cellFrame:(JXPlayerViewCell *)cell
{
    CGFloat cellX = (screenWidth - cell.centerView.width) * 0.5;
    CGFloat cellY = (cell.width - cell.centerView.width) * 0.5 + cell.jx_Y ;
    return CGRectMake(cellX , cellY, cell.centerView.width, cell.centerView.height);
}

#pragma mark - JXPlayerViewCellDelegate
- (void)playWithCell:(JXPlayerViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    if (self.indexPath && indexPath.row == self.indexPath.row) return;
    
    self.indexPath = indexPath;
    
    if (self.smallShowView.jx_X < screenWidth - 10) {
        
        self.smallShowView.jx_X = screenWidth;
        [self.playerLayer removeFromSuperlayer];
        
    }
    
    if (!_remove) {
        [self removePlayObserver];
    }
    
    [self resetPlayerWithPlayUrl:self.playUrl];
    
    self.playerLayer.frame = [self cellFrame:cell];
    self.playerLayer.player = self.player;
    
    [self.tableView.layer addSublayer:self.playerLayer];

}

#pragma mark - 其他
- (void)smallShowViewClick:(UITapGestureRecognizer *)tapGesture
{
    [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


@end
