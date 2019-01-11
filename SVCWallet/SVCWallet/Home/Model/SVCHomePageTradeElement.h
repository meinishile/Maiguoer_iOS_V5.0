//
//  SVCHomePageTradeElement.h
//  SVCWallet
//
//  Created by SVC on 2018/3/8.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCHomePageTradeElement : NSObject

/** 日志id */
@property (nonatomic,copy) NSString *tradeId;
/** 用户余额 */
@property (nonatomic,copy) NSString *balance;
/** 发送账号 */
@property (nonatomic,copy) NSString *fromusername;
/** 发送地址 */
@property (nonatomic,copy) NSString *fromaddress;
/** 接收账号 */
@property (nonatomic,copy) NSString *tousername;
/** 接收地址 */
@property (nonatomic,copy) NSString *toaddress;
/** 变更方式  1 : 接收 0 : 发送 */
@property (nonatomic,copy) NSString *changeType;
/** 变更额度 */
@property (nonatomic,copy) NSString *changeAmount;
/** 变更手续费 */
@property (nonatomic,copy) NSString *changeFee;
/** 变更合计 */
@property (nonatomic,copy) NSString *changeTotal;
/** 交易时间 */
@property (nonatomic,copy) NSString *datetime;
/** 备注 */
@property (nonatomic,copy) NSString *noteInfo;

@end
