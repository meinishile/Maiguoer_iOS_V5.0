//
//  SVCBaseViewController.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "ViewController.h"

/**
 * 项目名称：SVCWallet
 * 类名称：SVCBaseViewController.h
 * 类描述：视图控制器的基类，封装了一些基本的通用操作，比如HUD。正在使用
 * 创建人：
 * 创建时间：2018-03-01
 * 修改人：
 * 修改时间：
 * 修改备注：
 * 版本号：V1.0
 *
 */

@interface SVCBaseViewController : ViewController

#pragma mark - 导航栏设置方法

-(void)setNavigationBarWithColor:(UIColor *)color;

@end
