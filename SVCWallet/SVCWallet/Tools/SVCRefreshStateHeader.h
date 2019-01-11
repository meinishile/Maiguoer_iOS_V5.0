//
//  SVCRefreshStateHeader.h
//  SVCWallet
//
//  Created by SVC on 2018/3/9.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "MJRefreshStateHeader.h"


@interface SVCRefreshStateHeader : MJRefreshStateHeader

@property (weak, nonatomic, readonly) UIImageView *arrowView;
/** 菊花的样式 */
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@end
