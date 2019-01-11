//
//  SVCSendMainViewController.h
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseViewController.h"

/**
 * 类描述：发送主界面
 * 创建人：
 * 创建时间：2018-03-02
 * 版本号：V1.0
 *
 */

@interface SVCSendMainViewController : SVCBaseViewController

@property (nonatomic,copy) NSString *targetAddress;
@property (nonatomic,copy) NSString *targetAmount;

@end
