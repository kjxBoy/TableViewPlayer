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
#import "JXPlayView.h"

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

static NSString *playUrl = @"http://flv2.bn.netease.com/videolib3/1707/10/mKkoJ3091/SD/mKkoJ3091-mobile.mp4";

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,JXPlayerViewCellDelegate,JXPlayViewDelegate>

@property (strong, nonatomic)NSIndexPath *indexPath ;

@property (strong, nonatomic) AVPlayerItem *playerItem;

@property (strong, nonatomic)AVPlayer *player;

@property (assign, nonatomic,getter=isRemove)BOOL remove;

@property (strong, nonatomic)UIView *smallShowView;

@property (weak, nonatomic)UITableView * tableView;

@property (strong, nonatomic)JXPlayView *playView;

@property (assign, nonatomic)CGRect oldFrame;

@end



@implementation ViewController


- (JXPlayView *)playView
{
    if (_playView == nil) {
        _playView = [[JXPlayView alloc] init];
        _playView.delegate = self;
    }
    return _playView;
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
    [self.playView removeFromSuperview];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.playView.frame = self.smallShowView.bounds;
    } completion:^(BOOL finished) {

        [self.smallShowView addSubview:self.playView];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.smallShowView.jx_X = screenWidth * 0.5;
        }];
    }];
}

- (void)cellShowWithCell:(JXPlayerViewCell *)cell andScrollView:(UIScrollView *)scrollView
{
    [self.playView removeFromSuperview];
    
    self.smallShowView.jx_X = screenWidth;
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        self.playView.frame = [self cellFrame:cell];
        
        
    } completion:^(BOOL finished) {
        
        [scrollView addSubview:self.playView];
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
    [self.playView removeFromSuperview];
    
    self.playView.frame = [self cellFrame:cell];
    
    self.smallShowView.jx_X = screenWidth;
    
    [scrollView addSubview:self.playView];
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
                self.indexPath = nil;
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
    if (self.indexPath && indexPath.row == self.indexPath.row)   return;
    
    if (self.smallShowView.jx_X < screenWidth - 10) {
        
        self.smallShowView.jx_X = screenWidth;
        
        [self.playView removeFromSuperview];
    }
    
    self.indexPath = indexPath;
    
    if (!_remove) {
        [self removePlayObserver];
    }
    
    [self resetPlayerWithPlayUrl:self.playUrl];
    
    self.playView.frame = [self cellFrame:cell];
    
    [self.playView setUpPlayer:self.player];
    
    [self.tableView addSubview:self.playView];

}

#pragma mark - JXPlayViewDelegate
- (void)playViewClick:(JXPlayView *)playView
{
    [playView removeFromSuperview];
    
    //cell屏 & 小屏
    if (playView.width < screenWidth - 10) {
        
        self.oldFrame = playView.frame;
        
        [self.view addSubview:playView];
        
        playView.frame = [UIScreen mainScreen].bounds;
        
        return;
    }
    
    //全屏
    playView.frame = self.oldFrame;
    
    if (self.smallShowView.jx_X == screenWidth) {
        [self.tableView addSubview:playView];
    }else{
        [self.smallShowView addSubview:playView];
    }
    
}

#pragma mark - 其他
- (void)smallShowViewClick:(UITapGestureRecognizer *)tapGesture
{
    [self.tableView scrollToRowAtIndexPath:self.indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}


@end
