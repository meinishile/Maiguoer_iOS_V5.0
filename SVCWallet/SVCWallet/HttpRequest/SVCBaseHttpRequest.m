//
//  SVCBaseHttpRequest.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCBaseHttpRequest.h"
#import "SVCSystemInfoTool.h"

@interface SVCBaseHttpRequest ()<UIAlertViewDelegate>
{
    NSString *newVersionUrl;
}
@end

@implementation SVCBaseHttpRequest


- (instancetype)init
{
    self = [super init];
    if (self) {
        
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.svcwallet.com/"]];//其创建的时候，默认使用了json解析器192.168.1.239
//        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.239/"]];//其创建的时候，默认使用了json解析器192.168.1.239
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        //        manager.requestSerializer= [AFHTTPRequestSerializer serializer];
        //        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        managerOfHttps = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"https://api.svcwallet.com/"]];//其创建的时候，默认使用了json解析器
//        managerOfHttps = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://192.168.1.244/"]];//其创建的时候，默认使用了json解析器192.168.1.239
        managerOfHttps.responseSerializer = [AFJSONResponseSerializer serializer];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        managerOnAsyncBlock = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.svcwallet.com/"]];//其创建的时候，默认使用了json解析器
        managerOnAsyncBlock.responseSerializer = [AFJSONResponseSerializer serializer];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
        managerOfHttpsOnAsyncBlock = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@"http://api.svcwallet.com/"]];//其创建的时候，默认使用了json解析器
        managerOfHttpsOnAsyncBlock.responseSerializer = [AFJSONResponseSerializer serializer];
        //        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        
    }
    return self;
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
- (NSMutableDictionary *) addCommonParametersWithParameters:(NSDictionary *) originalParameters withUserInfoType:(SVCDegestAuthUserInfoType) userInfoType withUserInfoStr:(NSString *) userInfoStr withActionStr:(NSString *)actionStr
{
    NSMutableDictionary * finalParameters = [NSMutableDictionary dictionaryWithDictionary:originalParameters];
    //客户端类型以及版本号
    [finalParameters setObject:[SVCSystemInfoTool getClientVersion] forKey:HTTP_FIELD_CLIENT_VERSION];
    [finalParameters setObject:SVC_CLIENT_TYPE_IOS forKey:HTTP_FIELD_CLIENT_TYPE];
    
    //添加网络类型。//0.    其他 1.    wifi 2.    2G //3.    3G4.    4G
    NSString * network_type_in_SVC = [[NSUserDefaults standardUserDefaults] stringForKey:SVC_CLIENT_NETWORK_TYPE];
    [finalParameters setObject:network_type_in_SVC forKey:HTTP_FIELD_REQUEST_NETWORK_TYPE];
    
    //添加语言类型。当前的语言版本，默认0
    NSString *langStr = @"0";
    if ([currentLanguage isEqualToString:@"en"])
    {
        langStr = @"1";
    }
    else
    {
        langStr = @"0";
    }
    [finalParameters setObject:langStr forKey:HTTP_FIELD_REQUEST_LANGUAGE_TYPE];
    
    // 唯一标识tokenId
    NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_USER_TOKEN_ID];
    if ([tokenId isEqualToString:@""] || tokenId == NULL || tokenId == nil)
    {
        tokenId = @"";
    }
    
    // 客户端生成的唯一id uuid
    NSString *uuidStr = [SVCSystemInfoTool createUUID];
    
    //设置摘要认证相关字段
    NSString * signStr = @"";//摘要认证字符串
    NSString * timestamp = @"";//生成摘要认证字符串的时间戳
    if (SVCDegestAuthUserInfoType_SelfUsername == userInfoType) {
        [SVCStringTools getHTTPInterfaceSignutureAndTimestampByUserInfoStr:userInfoStr withVersion:[SVCSystemInfoTool getClientVersion] withClientType:SVC_CLIENT_TYPE_IOS withNetwork:network_type_in_SVC withLang:langStr withToken:tokenId withUUid:uuidStr withAction:actionStr withTimestamp:&timestamp withSignStr:&signStr];
    }else{
        if (nil == userInfoStr || userInfoStr.length == 0) {
            userInfoStr = @"";//[SVCMyProfileManager getUserId];//默认取用户id
        }
        [SVCStringTools getHTTPInterfaceSignutureAndTimestampByUserInfoStr:userInfoStr withVersion:[SVCSystemInfoTool getClientVersion] withClientType:SVC_CLIENT_TYPE_IOS withNetwork:network_type_in_SVC withLang:langStr withToken:tokenId withUUid:uuidStr withAction:actionStr withTimestamp:&timestamp withSignStr:&signStr];
    }
    
    // 时间戳
    [finalParameters setObject:timestamp forKey:HTTP_FIELD_REQUEST_TIMESTAMP_STR];
    // MD5加密签名sign
    [finalParameters setObject:signStr forKey:HTTP_FIELD_REQUEST_SIGN_STR];
    // 客户端生成的唯一id
    [finalParameters setObject:uuidStr forKey:HTTP_FIELD_REQUEST_UUID_STR];
    
    return finalParameters;
}

/**
 * 方法描述：进行通用错误处理以及提示处理。只进行除了应用错误以外的其他提示。应用提示由具体的业务逻辑实现。
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */

- (void) doCommonProcessingWithResponse:(NSDictionary *) responseDictionary
{
    //错误码字符串 version2
    NSString * resultCodeStr = [[responseDictionary objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    
    //获取服务器处理信息反馈
    NSString * resultMessage = [responseDictionary objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    
    //处理登录状态令牌tokenId
    NSString * tokenId = [responseDictionary objectForKey:HTTP_FIELD_RESULT_TOKEN_ID];
    if (nil != tokenId  && ![tokenId isEqualToString:@""] && tokenId.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:tokenId forKey:SVC_LOGIN_USER_TOKEN_ID];
    }
    
    if ([resultCodeStr isEqualToString:@"101"])// 有版本更新
    {
//        NSDictionary *dataDic = [responseDictionary objectForKey:@"data"];
        // 客户端的最新下载地址
        newVersionUrl = [responseDictionary objectForKey:@"url"];
        // 最新版本号
//        NSString *newVersionNo = [dataDic objectForKey:@"version"];
        // 升级版本内容
//        NSString *content = [dataDic objectForKey:@"content"];
//        // 升级更新方式  0 自主更新  1 提示更新 2 强制更新
//        NSString *upgrade= [[dataDic objectForKey:@"upgrade"] stringValue];
        
//        UIAlertView *appStoreAlertView = [[UIAlertView alloc] initWithTitle:@"升级提示" message:content delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
//        [appStoreAlertView show];
        
        
        // 定义一个变量存放当前屏幕显示的viewcontroller
        UIViewController *result = nil;
        
        // 得到当前应用程序的主要窗口
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        
        // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
        if (window.windowLevel != UIWindowLevelNormal)
        {
            // 获取应用程序所有的窗口
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows)
            {
                // 找到程序的默认窗口（正在显示的窗口）
                if (tmpWin.windowLevel == UIWindowLevelNormal)
                {
                    // 将关键窗口赋值为默认窗口
                    window = tmpWin;
                    break;
                }
            }
        }
        
        // 获取窗口的当前显示视图
        UIView *frontView = [[window subviews] objectAtIndex:0];
        
        // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
        id nextResponder = [frontView nextResponder];
        
        // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            result = nextResponder;
        } else {
            result = window.rootViewController;
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"upgrade.prompt") message:resultMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle: Localized(@"cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVCSystemInfoTool exitApplication];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle: Localized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (newVersionUrl)
            {
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:newVersionUrl]];
                [SVCSystemInfoTool exitApplication];
            }
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        
        [result presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else if ([resultCodeStr isEqualToString:@"110"])// 异常退出重新登录
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
//        [defaults setObject:@"" forKey:SVC_LOGIN_USERNAME];// 存储当前用户账号
        [defaults setObject:@"" forKey:SVC_LOGIN_ADDRESS];// 存储当前用户地址
        [defaults setObject:@"0" forKey:SVC_LOGIN_STATUS];//当前登录系统的用户登录状态。0 未登录  1 已登录
        [defaults setObject:@"" forKey:SVC_LOGIN_USER_TOKEN_ID];
        [defaults setObject:@"0" forKey:SVC_LOGIN_ACCOUNTMONEY];
        [defaults synchronize];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else if ([resultCodeStr isEqualToString:@"120"])// 系统维护中
    {
        // 定义一个变量存放当前屏幕显示的viewcontroller
        UIViewController *result = nil;
        
        // 得到当前应用程序的主要窗口
        UIWindow * window = [[UIApplication sharedApplication] keyWindow];
        
        // windowLevel是在 Z轴 方向上的窗口位置，默认值为UIWindowLevelNormal
        if (window.windowLevel != UIWindowLevelNormal)
        {
            // 获取应用程序所有的窗口
            NSArray *windows = [[UIApplication sharedApplication] windows];
            for(UIWindow * tmpWin in windows)
            {
                // 找到程序的默认窗口（正在显示的窗口）
                if (tmpWin.windowLevel == UIWindowLevelNormal)
                {
                    // 将关键窗口赋值为默认窗口
                    window = tmpWin;
                    break;
                }
            }
        }
        
        // 获取窗口的当前显示视图
        UIView *frontView = [[window subviews] objectAtIndex:0];
        
        // 获取视图的下一个响应者，UIView视图调用这个方法的返回值为UIViewController或它的父视图
        id nextResponder = [frontView nextResponder];
        
        // 判断显示视图的下一个响应者是否为一个UIViewController的类对象
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            result = nextResponder;
        } else {
            result = window.rootViewController;
        }
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"system.maintenance") message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle: Localized(@"sure") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [SVCSystemInfoTool exitApplication];
        }];
        
        [alert addAction:action1];
        
        [result presentViewController:alert animated:YES completion:^{
            
        }];
    }
    else if ([resultCodeStr isEqualToString:@"201"])// 签名错误
    {
        
    }
    else
    {
        
    }
}

@end
