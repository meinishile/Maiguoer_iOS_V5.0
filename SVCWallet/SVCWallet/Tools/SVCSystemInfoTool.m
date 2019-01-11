//
//  SVCSystemInfoTool.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCSystemInfoTool.h"

@implementation SVCSystemInfoTool


#pragma mark - 版本信息

/**
 * 方法描述：获取客户端的版本
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *) getClientVersion
{
    //通过配置文件获取版本号
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}

#pragma mark - 随机生成UUID

/**
 * 方法描述：随机生成UUID
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *)createUUID
{
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}


#pragma mark - 退出程序的处理

/**
 * 方法描述：退出应用程序(退出时需要包含动画效果)
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (void)exitApplication
{
    [UIView beginAnimations:@"exitApplication" context:nil];
    
    [UIView setAnimationDuration:0.5];
    
    [UIView setAnimationDelegate:self];
    
    // [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.view.window cache:NO];
    
    //    [UIView setAnimationTransition:UIViewAnimationCurveEaseOut forView:self.window cache:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[UIApplication sharedApplication].keyWindow cache:NO];
    
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    
    //self.view.window.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIApplication sharedApplication].keyWindow.bounds = CGRectMake(0, 0, 0, 0);
    
    [UIView commitAnimations];
}


#pragma mark - 退出程序的动画处理

+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    if ([animationID compare:@"exitApplication"] == 0) {
        exit(0);
    }
}

@end
