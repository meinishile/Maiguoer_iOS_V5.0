//
//  SVCDisclaimerViewController.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseViewController.h"

/**
 * 类描述：免责声明主界面
 * 创建人：
 * 创建时间：2018-03-01
 * 版本号：V1.0
 *
 */

@interface SVCDisclaimerViewController : SVCBaseViewController
/** 账号名 */
@property (nonatomic,copy) NSString *acountNameStr;
/** 注册密码 */
@property (nonatomic,copy) NSString *registerPwdStr;

@end
