//
//  SVCStringTools.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCStringTools.h"

#import <CommonCrypto/CommonDigest.h>

#import "SVCSystemInfoTool.h"

@implementation SVCStringTools


#pragma mark - 摘要算法

+ (NSString *)md5:(NSString *) str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



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

+ (void) getHTTPInterfaceSignutureAndTimestampByUserInfoStr:(NSString *) username withVersion:(NSString *)version withClientType:(NSString *)clientType withNetwork:(NSString *)network withLang:(NSString *)lang withToken:(NSString *)token withUUid:(NSString *)uuid withAction:(NSString *)aciton withTimestamp:(NSString **)timestamp withSignStr:(NSString **) signStr
{
    //获取当前的时间戳
    NSDate * currentDate = [NSDate date];
    double timeStampValue = [currentDate timeIntervalSince1970];
    
    NSString *tmpTimeStampString = [NSString stringWithFormat:@"%.0f",timeStampValue];
    
    //生成内层的待摘要字符串。clientType=1&lang=0&network=1&timestamp=1&uid=1&version=4.0.0 + token=ddsadssd + uuid=123456985 + action=(请求地址，去掉域名)
    NSString * innerStrForMD5Processing = [NSString stringWithFormat:@"clientType=%@&lang=%@&network=%@&timestamp=%@&username=%@&version=%@token=%@uuid=%@action=%@",SVC_CLIENT_TYPE_IOS,lang,network,tmpTimeStampString,username, [SVCSystemInfoTool getClientVersion],token,uuid,aciton];
    
    //生成外层的摘要字符串。md5(clientType=1&lang=0&network=1&timestamp=1&username=1&version=1.0.0 + token=ddsadssd + uuid=123456985 + action=(请求地址，去掉域名))
    NSString * outterMD5ProcessingResultStr = [self md5:innerStrForMD5Processing];
    *signStr = outterMD5ProcessingResultStr;
    *timestamp = tmpTimeStampString;
}

@end
