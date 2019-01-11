//
//  SVCBaseHttpRequest.h
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSInteger, SVCDegestAuthUserInfoType) {
    SVCDegestAuthUserInfoType_SelfUsername          = 1,
    SVCDegestAuthUserInfoType_Other     = 2,
};

@interface SVCBaseHttpRequest : NSObject
{
@protected
AFHTTPSessionManager *manager;//非加密传输

AFHTTPSessionManager *managerOfHttps;//加密传输

AFHTTPSessionManager *managerOnAsyncBlock;//非加密传输，回调异步处理。当在回调中使用DB操作时才使用

AFHTTPSessionManager *managerOfHttpsOnAsyncBlock;//加密传输，回调异步处理。当在回调中使用DB操作时才使用 
}


/**
 * 方法描述：增加通用请求参数。
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 userInfoType为SVCDegestAuthUserInfoType_Uid时，不用传递uid。 用户登录后发起的请求一般使用该类型
 userInfoType为其他类型时，需要传递userInfoStr。用于没有uid的场景下发起的请求。比如注册，或者获取验证码等
 * 返回参数说明：
 */
- (NSMutableDictionary *) addCommonParametersWithParameters:(NSDictionary *) originalParameters withUserInfoType:(SVCDegestAuthUserInfoType) userInfoType withUserInfoStr:(NSString *) userInfoStr withActionStr:(NSString *)actionStr;

/**
 * 方法描述：进行通用错误处理以及提示处理。只进行除了应用错误以外的其他提示。应用提示由具体的业务逻辑实现。
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

- (void) doCommonProcessingWithResponse:(NSDictionary *) responseDictionary;


@end
