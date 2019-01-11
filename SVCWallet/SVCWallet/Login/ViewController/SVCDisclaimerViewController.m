//
//  SVCDisclaimerViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCDisclaimerViewController.h"

#import "SVCHomePageViewController.h"

@interface SVCDisclaimerViewController ()<SVCHomePageHttpRequestDelegate>
{
    SVCHomePageHttpRequest *homePagePageHttpRequest;// 网络请求
}
@end

@implementation SVCDisclaimerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SVCV1B7Color;
    homePagePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePagePageHttpRequest.delegate = self;
    
    // Do any additional setup after loading the view.
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, SVC_ScreenWidth-40, 18)];
    titleLabel.text = Localized(@"use.notice.disclaimer");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:titleLabel];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = Localized(@"terms.content");
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:contentLabel];
    CGSize maxSize = CGSizeMake(SVC_ScreenWidth - 45, MAXFLOAT);
    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    contentLabel.frame = CGRectMake(20, 102, SVC_ScreenWidth-45, size.height);
    
    //同意按钮
    UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, SVC_ScreenHeight-50-64, SVC_ScreenWidth, 50)];
    agreeBtn.layer.cornerRadius = 4.0;
    agreeBtn.layer.masksToBounds = YES;
    [agreeBtn setTitle:Localized(@"haveRead.and.agreed") forState:UIControlStateNormal];
    [agreeBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    agreeBtn.backgroundColor = SVCV1B5Color;
    [agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreeBtn];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setNavigationBarWithColor:SVCV1B7Color];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

#pragma mark - 注册接口回调
-(void)registereUsernameWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SVC_LOGIN_USER_TOKEN_ID];
        [homePagePageHttpRequest loginWithUsername:self.acountNameStr withPassword:self.registerPwdStr];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)registereUsernameFailed
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:Localized(@"networkError")];
}


#pragma mark - 登录接口回调
-(void)loginWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        NSDictionary *dataDic = [resultBody objectForKey:@"data"];
        NSDictionary *userInfoDic = [dataDic objectForKey:@"userInfo"];
        userInfoDic = [NSDictionary changeType:userInfoDic];
        
        NSString * username = [NSString stringWithFormat:@"%@",userInfoDic[@"username"]];
        NSString * walletAddress = [NSString stringWithFormat:@"%@",userInfoDic[@"address"]];
        NSString * balance = [NSString stringWithFormat:@"%@",userInfoDic[@"balance"]];
        NSString * hasSecpwd = [NSString stringWithFormat:@"%@",userInfoDic[@"hasSecpwd"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:username forKey:SVC_LOGIN_USERNAME];// 存储当前用户账号
        [defaults setObject:walletAddress forKey:SVC_LOGIN_ADDRESS];// 存储当前用户地址
        [defaults setObject:@"1" forKey:SVC_LOGIN_STATUS];//当前登录系统的用户登录状态。0 未登录  1 已登录
        [defaults setObject:balance forKey:SVC_LOGIN_ACCOUNTMONEY];// 存储当前用户账户余额
        [defaults setObject:hasSecpwd forKey:SVC_PIN_SETTING_STATUS];// 存储当前用户PIN密码设置状态 1 已设置   0 未设置
        [defaults synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)loginFailed
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:Localized(@"networkError")];
}

-(void)agreeBtnClick
{
    [homePagePageHttpRequest registereUsernameWithUsername:self.acountNameStr withPassword:self.registerPwdStr];
//    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
}

@end
