//
//  MBProgressHUD+Add.h
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
//+ (void)showError:(NSString *)error toView:(UIView *)view;
//+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
//
//+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;


#pragma mark - 不指定显示目标的便捷显示方法 noted by wangxin

/**
 * 方法描述：显示成功信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+ (void)showSuccess:(NSString *)success;

/**
 * 方法描述：显示错误信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+ (void)showError:(NSString *)error;

/**
 * 方法描述：显示功能未实现的提示信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+ (void)showUnImplemented:(NSString *)unImplemented;//added by panweizhi at 2015-08-26


/**
 * 方法描述：显示正在操作的进度。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+ (void)showMessage:(NSString *)message;

/**
 * 方法描述：显示加载动画
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */

+ (void)showLoading;

/**
 * 方法描述：取消加载动画
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+(void)hidLodingView;

#pragma mark - 能指定显示目标的方法  noted by wangxin
+ (void)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showUnImplemented:(NSString *)unImplemented toView:(UIView *)view;
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;




@end
