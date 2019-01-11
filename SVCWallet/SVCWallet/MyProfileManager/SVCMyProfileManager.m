//
//  SVCMyProfileManager.m
//  SVCWallet
//
//  Created by SVC on 2018/3/7.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCMyProfileManager.h"

@implementation SVCMyProfileManager


/**
 * 方法描述：获取当前登录客户端的用户账号
 * 创建人：
 * 创建时间：2018-03-07
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *) getUsername
{
    NSString * userName = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_USERNAME];
    userName = [NSString stringWithFormat:@"%@",userName];
    if (nil == userName)
    {
//        userName = @"";
    }
    
    return userName;
}

/**
 * 方法描述：获取当前登录客户端的用户账户余额
 * 创建人：
 * 创建时间：2018-03-07
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *) getAccountBalance
{
    NSString * accountBalance = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ACCOUNTMONEY];
    accountBalance = [NSString stringWithFormat:@"%@",accountBalance];
    if (nil == accountBalance)
    {
        accountBalance = @"0.00";
    }
    
    return accountBalance;
}

@end
