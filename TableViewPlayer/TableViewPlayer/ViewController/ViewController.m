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
#import "JXPlayerView.h"



static NSString *playUrl = @"http://baobab.cdn.wandoujia.com/14468618701471.mp4";

static NSString *cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>



@property (strong, nonatomic)JXPlayerView *playView;

@end



@implementation ViewController

- (JXPlayerView *)playView
{
    if (_playView == nil) {
        _playView = [[JXPlayerView alloc] initWithFrame:CGRectZero];
    }
    return _playView;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.showsVerticalScrollIndicator = NO;

    
    [self.view addSubview:tableView];
    
}


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
    JXPlayerViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self addPlayLayerWithView:cell.centerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}


#pragma mark - 视频列表
- (void)addPlayLayerWithView:(UIView *)ownPlayView{
    
    [self.playView removeFromSuperview];
    
    self.playView.urlStr = playUrl;
    
    self.playView.frame = ownPlayView.bounds;
    
    [ownPlayView addSubview:self.playView];
}



- (NSURL *)playUrl {
    return [NSURL URLWithString:playUrl];
}



@end
