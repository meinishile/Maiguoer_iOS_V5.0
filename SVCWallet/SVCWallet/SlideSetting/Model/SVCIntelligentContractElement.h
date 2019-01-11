//
//  SVCIntelligentContractElement.h
//  SVCWallet
//
//  Created by SVC on 2018/4/26.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SVCIntelligentContractElement : NSObject


/** 合约id */
@property (nonatomic,copy) NSString *contractId;
/** 合约总量 */
@property (nonatomic,copy) NSString *total;
/** 是否完成     完成 1  下次执行时间 0 */
@property (nonatomic,copy) NSString *isDone;
/** 合约已完成数量 */
@property (nonatomic,copy) NSString *done;
/** 合约待完成数量 */
@property (nonatomic,copy) NSString *beDone;
/** 相关时间   完成时间 isDone 等于1     下次执行时间 isDone 等于0 */
@property (nonatomic,copy) NSString *relatedDate;
/** 合约数额 */
@property (nonatomic,copy) NSString *grant;
/** 合约添加时间 */
@property (nonatomic,copy) NSString *datetime;

@end
