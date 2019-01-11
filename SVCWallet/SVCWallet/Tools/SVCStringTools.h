//
//  SVCStringTools.h
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCStringTools : NSObject


#pragma mark - 摘要算法

/**
 * 方法描述：md5加密函数
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

+ (NSString *)md5:(NSString *) str;



/**
 * 方法描述：获取本次HTTP接口调用的签名字段 。用户标识字段为具体功能传入值。全部加密
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 action: (请求地址，去掉域名)
 timestamp: 时间戳字符串。
 sign: 签名摘要字符串。摘要生成规则：sign = md5(clientType + lang + network + timestamp + username + version + token + uuid + action)
 * 返回参数说明：
 */

+ (void) getHTTPInterfaceSignutureAndTimestampByUserInfoStr:(NSString *) username withVersion:(NSString *)version withClientType:(NSString *)clientType withNetwork:(NSString *)network withLang:(NSString *)lang withToken:(NSString *)token withUUid:(NSString *)uuid withAction:(NSString *)aciton withTimestamp:(NSString **)timestamp withSignStr:(NSString **) signStr;

@end
