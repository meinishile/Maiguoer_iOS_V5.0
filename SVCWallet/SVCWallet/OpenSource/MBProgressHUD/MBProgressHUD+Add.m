//
//  MBProgressHUD+Add.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+Add.h"

#import "UIImage+EMGIF.h"

@implementation MBProgressHUD (Add)

/**
 * 方法描述：显示成功信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 * 方法描述：显示错误信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 * 方法描述：显示功能未实现的提示信息。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */

+ (void)showUnImplemented:(NSString *)unImplemented
{
    [self showUnImplemented:unImplemented toView:nil];
}

/**
 * 方法描述：显示正在操作的进度。纯不能超过15个汉字，否则会显示不全。纯英文不能超过26个字符
 * 创建人：
 * 创建时间：
 * 传参说明：
 * 返回参数说明：
 */
+ (void)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

#pragma mark - 能指定显示目标的方法  noted by wangxin

+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication] keyWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.detailsLabelText = text;
    // 设置图片
    
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.5];
}


+ (void)showError:(NSString *)error toView:(UIView *)view{
   
    [self show:error icon:@"hint_icon_error" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"hint_icon_success" view:view];
}


+ (void)showUnImplemented:(NSString *)unImplemented toView:(UIView *)view
{
    [self show:unImplemented icon:@"hint_icon_expect" view:view];
}


+ (void)showMessage:(NSString *)message toView:(UIView *)view {
    
    [self show:message icon:@"hint_icon_success" view:view];
}

+ (void)showLoading {
    
    UIWindow *view = [[UIApplication sharedApplication] keyWindow];
    
    UIView *bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = Rgba(0, 0, 0, 0.4);
    bgView.tag = 1000000;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidLodingView)];
    bgView.userInteractionEnabled = YES;
    [bgView addGestureRecognizer:tap];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
    imageView.centerX = SVC_ScreenWidth/2.0;
    imageView.centerY = SVC_ScreenHeight/2.0;
    NSString *langusgeStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"];
    if ([langusgeStr isEqualToString:@""] || langusgeStr == NULL || langusgeStr == nil)
    {
        langusgeStr = @"";
    }
    
    if ([langusgeStr isEqualToString:@"zh-Hans"])
    {
        imageView.image = [UIImage sd_animatedGIFNamed:@"loding"];
    }
    else
    {
        imageView.image = [UIImage sd_animatedGIFNamed:@"loding_English"];
    }
    
    [bgView addSubview:imageView];
    
    [view addSubview:bgView];
}

+(void)hidLodingView {

    UIWindow *view = [[UIApplication sharedApplication] keyWindow];
    UIView *bgView = [view viewWithTag:1000000];
    [bgView removeFromSuperview];
    bgView = nil;
    
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}


@end
