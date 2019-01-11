//
//  SVCHomePageHttpRequest.h
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseHttpRequest.h"

@protocol SVCHomePageHttpRequestDelegate <NSObject>

@optional

#pragma mark - 注册登录相关接口回调

// 注册-检测用户名接口回调
- (void) detectionRegistereUsernameWithResultBody:(NSDictionary *)resultBody;
- (void) detectionRegistereUsernameFailed;
// 注册接口回调
- (void) registereUsernameWithResultBody:(NSDictionary *)resultBody;
- (void) registereUsernameFailed;
// 登录接口回调
- (void) loginWithResultBody:(NSDictionary *)resultBody;
- (void) loginFailed;
// 登出接口回调
- (void) logoutWithResultBody:(NSDictionary *)resultBody;
- (void) logoutFailed;

#pragma mark - 首页相关接口回调

//交易日志获取接口回调
- (void) loadHomePageTransactionLogWithResultBody:(NSDictionary *)resultBody;
- (void) loadHomePageTransactionLogFailed;
// 交易发送日志获取接口回调
- (void) loadHomePageTransactionSendLogWithResultBody:(NSDictionary *)resultBody;
- (void) loadHomePageTransactionSendLogFailed;
// 交易接收日志获取接口回调
- (void) loadHomePageTransactionReceiveLogWithResultBody:(NSDictionary *)resultBody;
- (void) loadHomePageTransactionReceiveLogFailed;
// 发送接口回调
- (void) applySendInfoWithResultBody:(NSDictionary *)resultBody;
- (void) applySendInfoFailed;
// 修改密码接口回调
- (void) modifyPasswordWithResultBody:(NSDictionary *)resultBody;
- (void) modifyPasswordFailed;

#pragma mark - PIN密码相关接口回调

// 设置PIN接口回调
- (void) settingPINWithResultBody:(NSDictionary *)resultBody;
- (void) settingPINFailed;
// 修改PIN密码接口回调
- (void) modifyPINWithResultBody:(NSDictionary *)resultBody;
- (void) modifyPINFailed;
// 验证PIN密码接口回调
- (void) validationPINWithResultBody:(NSDictionary *)resultBody;
- (void) validationPINFailed;

#pragma mark - 智能合约相关接口回调

// 智能合约获取接口回调
- (void) loadIntelligentContractListInfoWithResultBody:(NSDictionary *)resultBody;
- (void) loadIntelligentContractListInfoFailed;

@end

@interface SVCHomePageHttpRequest : SVCBaseHttpRequest

@property (nonatomic,weak) id<SVCHomePageHttpRequestDelegate>delegate;


#pragma mark - 注册登录相关接口

/**
 * 方法描述：注册-检测用户名接口
 * 创建人：
 * 创建时间：2018-03-05
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) detectionRegistereUsernameWithUsernam:(NSString *)username;

/**
 * 方法描述：注册接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) registereUsernameWithUsername:(NSString *)username withPassword:(NSString *)password;

/**
 * 方法描述：登录接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loginWithUsername:(NSString *)username withPassword:(NSString *)password;

/**
 * 方法描述：登出接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) logout;

#pragma mark - 首页相关接口

/**
 * 方法描述：交易日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionLogWithLastId:(NSString *)lastid;

/**
 * 方法描述：交易发送日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionSendLogWithLastId:(NSString *)lastid;

/**
 * 方法描述：交易接收日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionReceiveLogWithLastId:(NSString *)lastid;


/**
 * 方法描述：发送接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) applySendInfoWithToAddress:(NSString *)toaddress withAmount:(NSString *)amount withComment:(NSString *)comment;


/**
 * 方法描述：修改密码接口
 * 创建人：
 * 创建时间：2018-03-09
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) modifyPasswordWithUserName:(NSString *)username withOldPassword:(NSString *)oldpassword withNewPassword:(NSString *)newpassword;



#pragma mark - PIN密码相关接口

/**
 * 方法描述：设置PIN接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) settingPINWithUsername:(NSString *)username withSecpwd:(NSString *)secpwd;


/**
 * 方法描述：修改PIN密码接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) modifyPINWithUsername:(NSString *)username withOldsecpwd:(NSString *)oldsecpwd withNewsecpwd:(NSString *)newsecpwd;


/**
 * 方法描述：验证PIN密码接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) validationPINWithUsername:(NSString *)username withSecpwd:(NSString *)secpwd;


#pragma mark - 智能合约相关接口

/**
 * 方法描述：智能合约获取接口
 * 创建人：
 * 创建时间：2018-04-27
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadIntelligentContractListInfoWithLastId:(NSString *)lastid;







@end
