//
//  JXPlayerViewCell.h
//  TableViewPlayer
//
//  Created by apple on 2017/6/23.
//  Copyright © 2017年 Kang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class JXPlayerViewCell;


@protocol JXPlayerViewCellDelegate <NSObject>

- (void)playWithCell:(JXPlayerViewCell *)cell withIndexPath:(NSIndexPath *)indexPath;

@end


@interface JXPlayerViewCell : UITableViewCell


@property (strong, nonatomic,readonly)UIView *centerView;

@property (weak, nonatomic)id<JXPlayerViewCellDelegate> delegate;

@property (strong, nonatomic)NSIndexPath *indexPath ;

- (void)setUpView;

@end
