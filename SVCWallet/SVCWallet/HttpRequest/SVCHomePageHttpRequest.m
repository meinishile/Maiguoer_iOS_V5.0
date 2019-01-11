//
//  SVCHomePageHttpRequest.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCHomePageHttpRequest.h"

@implementation SVCHomePageHttpRequest

- (id)init
{
    self = [super init];
    
    return self;
}


#pragma mark - 注册登录相关接口

/**
 * 方法描述：注册-检测用户名接口
 * 创建人：
 * 创建时间：2018-03-05
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) detectionRegistereUsernameWithUsernam:(NSString *)username
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    NSString *actionStr = @"v1.0/register/check_username";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:username withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(detectionRegistereUsernameWithResultBody:)])
             {
                 [self.delegate detectionRegistereUsernameWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(detectionRegistereUsernameFailed)])
             {
                 [self.delegate detectionRegistereUsernameFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(detectionRegistereUsernameFailed)])
         {
             [self.delegate detectionRegistereUsernameFailed];
         }
     }];
}

/**
 * 方法描述：注册接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) registereUsernameWithUsername:(NSString *)username withPassword:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:password] forKey:@"password"];
    NSString *actionStr = @"v1.0/register";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:username withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(registereUsernameWithResultBody:)])
             {
                 [self.delegate registereUsernameWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(registereUsernameFailed)])
             {
                 [self.delegate registereUsernameFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(registereUsernameFailed)])
         {
             [self.delegate registereUsernameFailed];
         }
     }];
}

/**
 * 方法描述：登录接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loginWithUsername:(NSString *)username withPassword:(NSString *)password
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:password] forKey:@"password"];
    NSString *actionStr = @"v1.0/login";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:username withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loginWithResultBody:)])
             {
                 [self.delegate loginWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailed)])
             {
                 [self.delegate loginFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(loginFailed)])
         {
             [self.delegate loginFailed];
         }
     }];
}


/**
 * 方法描述：登出接口
 * 创建人：
 * 创建时间：2018-03-07
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) logout
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    NSString *actionStr = @"v1.0/logout";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(logoutWithResultBody:)])
             {
                 [self.delegate logoutWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(logoutFailed)])
             {
                 [self.delegate logoutFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(logoutFailed)])
         {
             [self.delegate logoutFailed];
         }
     }];
}


#pragma mark - 首页相关接口

/**
 * 方法描述：交易日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionLogWithLastId:(NSString *)lastid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    [parameters setObject:lastid forKey:@"lastid"];
    NSString *actionStr = @"v1.0/transfer/logs";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps GET:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionLogWithResultBody:)])
             {
                 [self.delegate loadHomePageTransactionLogWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionLogFailed)])
             {
                 [self.delegate loadHomePageTransactionLogFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionLogFailed)])
         {
             [self.delegate loadHomePageTransactionLogFailed];
         }
     }];
}


/**
 * 方法描述：交易发送日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionSendLogWithLastId:(NSString *)lastid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    [parameters setObject:lastid forKey:@"lastid"];
    NSString *actionStr = @"v1.0/transfer/send_logs";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps GET:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionSendLogWithResultBody:)])
             {
                 [self.delegate loadHomePageTransactionSendLogWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionSendLogFailed)])
             {
                 [self.delegate loadHomePageTransactionSendLogFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionSendLogFailed)])
         {
             [self.delegate loadHomePageTransactionSendLogFailed];
         }
     }];
}

/**
 * 方法描述：交易接收日志获取接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadHomePageTransactionReceiveLogWithLastId:(NSString *)lastid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    [parameters setObject:lastid forKey:@"lastid"];
    NSString *actionStr = @"v1.0/transfer/receive_logs";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps GET:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionReceiveLogWithResultBody:)])
             {
                 [self.delegate loadHomePageTransactionReceiveLogWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionReceiveLogFailed)])
             {
                 [self.delegate loadHomePageTransactionReceiveLogFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(loadHomePageTransactionReceiveLogFailed)])
         {
             [self.delegate loadHomePageTransactionReceiveLogFailed];
         }
     }];
}


/**
 * 方法描述：发送接口
 * 创建人：
 * 创建时间：2018-03-08
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) applySendInfoWithToAddress:(NSString *)toaddress withAmount:(NSString *)amount withComment:(NSString *)comment
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    [parameters setObject:toaddress forKey:@"toaddress"];
    [parameters setObject:amount forKey:@"amount"];
    [parameters setObject:comment forKey:@"comment"];
    NSString *actionStr = @"v1.0/transfer/send_to";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(applySendInfoWithResultBody:)])
             {
                 [self.delegate applySendInfoWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(applySendInfoFailed)])
             {
                 [self.delegate applySendInfoFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(applySendInfoFailed)])
         {
             [self.delegate applySendInfoFailed];
         }
     }];
}


/**
 * 方法描述：修改密码接口
 * 创建人：
 * 创建时间：2018-03-09
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) modifyPasswordWithUserName:(NSString *)username withOldPassword:(NSString *)oldpassword withNewPassword:(NSString *)newpassword
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:oldpassword] forKey:@"oldpassword"];
    [parameters setObject:[SVCStringTools md5:newpassword] forKey:@"newpassword"];
    NSString *actionStr = @"v1.0/user/edit_password";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPasswordWithResultBody:)])
             {
                 [self.delegate modifyPasswordWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPasswordFailed)])
             {
                 [self.delegate modifyPasswordFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPasswordFailed)])
         {
             [self.delegate modifyPasswordFailed];
         }
     }];
}


#pragma mark - PIN密码相关接口

/**
 * 方法描述：设置PIN接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) settingPINWithUsername:(NSString *)username withSecpwd:(NSString *)secpwd
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:secpwd] forKey:@"secpwd"];
    NSString *actionStr = @"v1.0/user/set_secpwd";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(settingPINWithResultBody:)])
             {
                 [self.delegate settingPINWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(settingPINFailed)])
             {
                 [self.delegate settingPINFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(settingPINFailed)])
         {
             [self.delegate settingPINFailed];
         }
     }];
}


/**
 * 方法描述：修改PIN密码接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) modifyPINWithUsername:(NSString *)username withOldsecpwd:(NSString *)oldsecpwd withNewsecpwd:(NSString *)newsecpwd
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:oldsecpwd] forKey:@"oldsecpwd"];
    [parameters setObject:[SVCStringTools md5:newsecpwd] forKey:@"newsecpwd"];
    NSString *actionStr = @"v1.0/user/edit_secpwd";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPINWithResultBody:)])
             {
                 [self.delegate modifyPINWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPINFailed)])
             {
                 [self.delegate modifyPINFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(modifyPINFailed)])
         {
             [self.delegate modifyPINFailed];
         }
     }];
}


/**
 * 方法描述：验证PIN密码接口
 * 创建人：
 * 创建时间：2018-04-16
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) validationPINWithUsername:(NSString *)username withSecpwd:(NSString *)secpwd
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:[SVCStringTools md5:secpwd] forKey:@"secpwd"];
    NSString *actionStr = @"v1.0/user/check_secpwd";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps POST:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(validationPINWithResultBody:)])
             {
                 [self.delegate validationPINWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(validationPINFailed)])
             {
                 [self.delegate validationPINFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(validationPINFailed)])
         {
             [self.delegate validationPINFailed];
         }
     }];
}


#pragma mark - 智能合约相关接口

/**
 * 方法描述：智能合约获取接口
 * 创建人：
 * 创建时间：2018-04-27
 * 传输协议 HTTP|HTTPS
 * 传参说明：
 * 返回参数说明：
 */

- (void) loadIntelligentContractListInfoWithLastId:(NSString *)lastid
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[SVCMyProfileManager getUsername] forKey:@"username"];
    [parameters setObject:lastid forKey:@"lastid"];
    NSString *actionStr = @"v1.0/contract/list";
    
    // 增加通用请求参数
    parameters = [self addCommonParametersWithParameters:parameters withUserInfoType:SVCDegestAuthUserInfoType_SelfUsername withUserInfoStr:[SVCMyProfileManager getUsername] withActionStr:actionStr];
    [managerOfHttps GET:actionStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
     {
         // 进行通用错误处理以及提示处理
         [self doCommonProcessingWithResponse:responseObject];
         
         if (responseObject)
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadIntelligentContractListInfoWithResultBody:)])
             {
                 [self.delegate loadIntelligentContractListInfoWithResultBody:responseObject];
             }
         }
         else
         {
             if (self.delegate && [self.delegate respondsToSelector:@selector(loadIntelligentContractListInfoFailed)])
             {
                 [self.delegate loadIntelligentContractListInfoFailed];
             }
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error)
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(loadIntelligentContractListInfoFailed)])
         {
             [self.delegate loadIntelligentContractListInfoFailed];
         }
     }];
}




@end
