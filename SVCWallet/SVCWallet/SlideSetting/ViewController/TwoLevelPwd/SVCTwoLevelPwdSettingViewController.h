//
//  SVCTwoLevelPwdSettingViewController.h
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseViewController.h"

/**
 * 类描述：设置PIN主界面
 * 创建时间：2018-04-11
 * 版本号：V1.1
 *
 */

@interface SVCTwoLevelPwdSettingViewController : SVCBaseViewController

@property (nonatomic) BOOL isModifyPINFlag;// 是否是修改PIN YES 是  NO 否

@property (nonatomic,copy) NSString *oldPINPwd;// 旧的PIN密码

@end
