//
//  SVCGlobalDefine.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#ifndef SVCGlobalDefine_h
#define SVCGlobalDefine_h


/** @brief 登录状态变更的通知 */
#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"


#define SVC_CLIENT_TYPE_ANDROID @"0" //android客户端
#define SVC_CLIENT_TYPE_IOS @"1" //ios客户端



#define HTTP_FIELD_CLIENT_TYPE @"clientType"
#define HTTP_FIELD_CLIENT_VERSION @"version"
#define HTTP_FIELD_REQUEST_SIGN_STR @"sign"//added at 2018-03-05
#define HTTP_FIELD_REQUEST_TIMESTAMP_STR @"timestamp"//added at 2018-03-05
#define HTTP_FIELD_REQUEST_NETWORK_TYPE @"network"//added at 2018-03-05
#define HTTP_FIELD_REQUEST_LANGUAGE_TYPE @"lang"//added at 2018-03-05
#define HTTP_FIELD_REQUEST_UUID_STR @"uuid"//added at 2018-03-05

#define HTTP_FIELD_RESULT_CODE @"code"//服务器处理结果 //added at 2018-03-05
#define HTTP_FIELD_RESULT_MESSAGE @"msg"//服务器处理信息反馈 //added at 2018-03-05
#define HTTP_FIELD_RESULT_TOKEN_ID @"token"//服务器返回的tokenId //added at 2018-03-05

#define SVC_CLIENT_NETWORK_TYPE @"client_network_type"//客户端的网络状态//added  at 2018-03-05  //0.其他 1.wifi  2.2G  3.3G   4.4G

#define SVC_LOGIN_USER_TOKEN_ID @"login_user_tokenId" //当前登录系统的用户从服务器获取到的最新TokenId, base64编码的令牌，用于sso


#define SVC_CLIENT_VERSION_BEFORE_UPGRADE @"client_version_before_upgrade"//客户端升级前的版本号。在进行升级安装时刚开始为升级前的版本号，随后变为升级后的版本号

#endif /* SVCGlobalDefine_h */
