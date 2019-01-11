//
//  SVCSystemInfoTool.h
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCSystemInfoTool : NSObject

#pragma mark - 版本信息

/**
 * 方法描述：获取客户端的版本
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *) getClientVersion;

#pragma mark - 随机生成UUID

/**
 * 方法描述：随机生成UUID
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *)createUUID;


#pragma mark - 退出程序的处理

/**
 * 方法描述：退出应用程序(退出时需要包含动画效果)
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (void)exitApplication;

#pragma mark - 退出程序的动画处理

+ (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end
