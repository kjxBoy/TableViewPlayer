//
//  JXPlayer.h
//  TableViewPlayer
//
//  Created by apple on 2017/6/20.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface JXPlayer : NSObject

+ (instancetype)shareInstance;

- (AVPlayer *)playWithUrl:(NSURL *)url;

@end
