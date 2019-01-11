//
//  SVCIntelligentContractCell.h
//  SVCWallet
//
//  Created by SVC on 2018/4/26.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SVCIntelligentContractElement;

/**
 * 类描述：智能合约单元格
 * 创建人：
 * 创建时间：2018-04-26
 * 修改人：
 * 修改时间：
 * 修改备注：
 * 版本号：V1.0
 *
 */

@interface SVCIntelligentContractCell : UITableViewCell

/** 合约状态图片 */
@property (nonatomic,strong) UIImageView *contractStatusImageView;
/** 合约数量 */
@property (nonatomic,strong) UILabel *contractNumLabel;
/** 已完成 */
@property (nonatomic,strong) UILabel *finishedLabel;
/** 待完成 */
@property (nonatomic,strong) UILabel *finishingLabel;
/** 合约完成状态（完成时间或下次执行时间与数额） */
@property (nonatomic,strong) UILabel *finishStatusLabel;

/** 目标模型 */
@property (nonatomic,strong) SVCIntelligentContractElement *targetIntelligentContractElement;

@end
