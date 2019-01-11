//
//  SVCHomePageCell.h
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVCHomePageTradeElement;

/**
 * 类描述：首页单元格
 * 创建人：
 * 创建时间：2018-03-02
 * 版本号：V1.0
 *
 */

@interface SVCHomePageCell : UITableViewCell


/** 底部 */
@property (nonatomic,strong) UIView *buttomView;

/** 发送或接收图标 */
@property (nonatomic,strong) UIImageView *typeImageView;
/** 时间 */
@property (nonatomic,strong) UILabel *dateLabel;
/** 发送或接收地址 */
@property (nonatomic,strong) UILabel *addressLabel;
/** 备注 */
@property (nonatomic,strong) UILabel *noteLabel;
/** 数量 */
@property (nonatomic,strong) UILabel *numberLabel;
/** 手续费 */
@property (nonatomic,strong) UILabel *poundageLabel;
/** 合计 */
@property (nonatomic,strong) UILabel *combinedLabel;
/** 目标模型 */
@property (nonatomic,strong) SVCHomePageTradeElement *targetHomePageTradeElement;

@end
