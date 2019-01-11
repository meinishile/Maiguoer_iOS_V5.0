//
//  SVCTwoLevelPwdConfirmViewController.h
//  SVCWallet
//
//  Created by SVC on 2018/4/12.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseViewController.h"

/**
 * 类描述：确认PIN密码主界面
 * 创建人：
 * 创建时间：2018-04-12
 * 修改人：
 * 修改时间：
 * 版本号：V1.1
 *
 */

@interface SVCTwoLevelPwdConfirmViewController : SVCBaseViewController

@property (nonatomic,strong) NSString *  keyString;

@property (nonatomic,strong)NSString * indexString;

@property (nonatomic) BOOL isModifyPINFlag;// 是否是修改PIN YES 是  NO 否

@property (nonatomic,copy) NSString *oldPINPwd;// 旧的PIN密码

@end
