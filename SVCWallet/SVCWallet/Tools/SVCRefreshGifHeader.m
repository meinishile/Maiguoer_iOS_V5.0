//
//  SVCRefreshGifHeader.m
//  SVCWallet
//
//  Created by SVC on 2018/3/8.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCRefreshGifHeader.h"

@implementation SVCRefreshGifHeader

-(void) prepare {
    
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%02ld", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_%02ld", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    // 设置文字
    
    [self setTitle:@"松开立即刷新" forState:MJRefreshStateIdle];
    
    [self setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    
    [self setTitle:@"紧急加载中" forState:MJRefreshStateRefreshing];
    
    self.stateLabel.font = [UIFont systemFontOfSize:14];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
    
}

@end
