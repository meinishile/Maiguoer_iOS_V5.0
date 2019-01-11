//
//  SVCLoginViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCLoginViewController.h"

#import "SVCDisclaimerViewController.h"// 免责声明

#import "SVCSegButton.h"

@interface SVCLoginViewController ()<SVCHomePageHttpRequestDelegate>
{
    SVCHomePageHttpRequest *homePageRequest;// 网络请求
    
    UITextField *accountTextField;// 用户账号输入框
    UITextField *passwordTextField;// 用户登录密码输入框
    
    UITextField *accountRegisterTextField;// 账号注册输入框
    UITextField *passwordRegisterTextField;// 登录密码注册输入框
    UITextField *passwordConfirmTextField;// 登录密码确认输入框
    
    UIView *loginButtomView;// 登录账号界面
    UIView *registerButtomView;// 注册账号界面
    
    UIButton *loginBtn;// 登录按钮
    UIButton *createWalletBtn;// 创建钱包按钮
    
    UIScrollView *scrollView;
}

@property (nonatomic, strong) SVCSegButton *loginSegBtn; // 登录切换按钮
@property (nonatomic, strong) SVCSegButton *registerSegBtn; // 注册切换按钮

@end

@implementation SVCLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = SVCV1B7Color;
    
    homePageRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageRequest.delegate = self;
    
    [self initLoginView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarWithColor:[UIColor clearColor]                                                                                 ];
    [self.navigationController.navigationBar setTranslucent:YES];
}


#pragma mark - 注册-检测用户名接口回调
-(void)detectionRegistereUsernameWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
//        [homePageRequest registereUsernameWithUsername:accountRegisterTextField.text withPassword:passwordRegisterTextField.text];
        SVCDisclaimerViewController *disclaimerVc = [[SVCDisclaimerViewController alloc] init];
        disclaimerVc.acountNameStr = accountRegisterTextField.text;
        disclaimerVc.registerPwdStr = passwordRegisterTextField.text;
        UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
        temporaryBarButtonItem.title = Localized(@"login1");
        self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
        [self.navigationController pushViewController:disclaimerVc animated:NO];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)detectionRegistereUsernameFailed
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:Localized(@"networkError")];
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
        [homePageRequest loginWithUsername:accountRegisterTextField.text withPassword:passwordRegisterTextField.text];
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

#pragma mark - 创建界面
// 头部
-(void)initLoginView
{
    
    
    CGFloat loginBgHeight = (216.0f/375.0f)*SVC_ScreenWidth;
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, loginBgHeight)];
    topView.backgroundColor = SVCV1B6Color;
    [self.view addSubview:topView];
    
    UIImageView *loginBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    loginBgImageView.image = [UIImage imageNamed:@"login_bg"];
    [self.view addSubview:loginBgImageView];
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    scrollView.backgroundColor = [UIColor clearColor];
    
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self.view添加一个手势监测；
    
    [scrollView addGestureRecognizer:singleRecognizer];
    
    if (iPhone4)
    {
        [self.view addSubview:scrollView];
        scrollView.contentSize = CGSizeMake(SVC_ScreenWidth,SVC_ScreenHeight+90);
    }
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SVC_ScreenWidth-132.0)/2.0, 79, 132, 116)];
    logoImageView.image = [UIImage imageNamed:@"login_logo"];
    [scrollView addSubview:logoImageView];
    
    //切换按钮
    [self setupSwitchTitleItem];
    [self setupLoginView];
    [self setupRegisterView];
    
    if (iPhone4)
    {
        [scrollView addSubview:self.loginSegBtn];
        [scrollView addSubview:self.registerSegBtn];
        [scrollView addSubview:loginButtomView];
        [scrollView addSubview:registerButtomView];
    }
}

// 登录、注册切换按钮
-(void)setupSwitchTitleItem
{
    CGFloat loginBgHeight = 216;
    self.loginSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(0, loginBgHeight, SVC_ScreenWidth/2, 50) withTitle:Localized(@"login") withBgColor:[UIColor clearColor] withTitleColor:SVCV1T12Color withUnselectColor:Rgba(109,204,243,0.4) withLineColor:[UIColor clearColor] withFontSize:16 withItemNum:2];
    self.loginSegBtn.selected = YES;
    self.loginSegBtn.enabled = NO;
    [self.loginSegBtn addTarget:self action:@selector(loginSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginSegBtn];
    
    self.registerSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/2, loginBgHeight, SVC_ScreenWidth/2, 50) withTitle:Localized(@"register") withBgColor:[UIColor clearColor] withTitleColor:SVCV1T12Color withUnselectColor:Rgba(109,204,243,0.4) withLineColor:[UIColor clearColor] withFontSize:16 withItemNum:2];
    self.registerSegBtn.selected = NO;
    [self.registerSegBtn addTarget:self action:@selector(registerSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerSegBtn];
}

// 登录界面
-(void)setupLoginView
{
    CGFloat loginBgHeight = 262;
    CGFloat loginBgWidth = SVC_ScreenWidth-52;
    loginButtomView = [[UIView alloc] initWithFrame:CGRectMake(26, 265, loginBgWidth, loginBgHeight)];
//    loginButtomView.layer.cornerRadius = 5.0;
//    loginButtomView.layer.masksToBounds = YES;
//    loginButtomView.layer.borderColor = Rgba(255,255,255,0.08).CGColor;
//    loginButtomView.layer.borderWidth = 0.5;
//    loginButtomView.backgroundColor = Rgba(255,255,255,0.02);
    [self.view addSubview:loginButtomView];
    
    UIImageView *loginBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loginBgWidth, loginBgHeight)];
    loginBgImageView.image = [UIImage imageNamed:@"login_btnbg"];
    [loginButtomView addSubview:loginBgImageView];
    
    // 创建账号底层
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(27, 50, loginBgWidth-54, 40)];
    accountView.layer.cornerRadius = 4.0;
    accountView.layer.masksToBounds = YES;
    accountView.backgroundColor = Rgba(255,255,255,0.1);
    [loginButtomView addSubview:accountView];
    
    
    // 账号输入图标
    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 13, 14)];
    accountImageView.image = [UIImage imageNamed:@"login_account"];
    [accountView addSubview:accountImageView];
    
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    
    // 账号输入框
    accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(33, 0, loginBgWidth-54-38, 40)];
    accountTextField.textColor = [UIColor whiteColor];
    accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    accountTextField.font = [UIFont systemFontOfSize:13];
    accountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"please.enter.SVC.accounts") attributes:@{NSForegroundColorAttributeName: color}];
    [accountView addSubview:accountTextField];
    NSString *userNameStr = [SVCMyProfileManager getUsername];
    if ([userNameStr isEqualToString:@""] || userNameStr == NULL || userNameStr == nil || [userNameStr isEqualToString:@"(null)"]  || [userNameStr isEqualToString:@"null"])
    {
        userNameStr = @"";
    }
    accountTextField.text = userNameStr;
    
    
    // 创建密码底层
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(27, 100, loginBgWidth-54, 40)];
    passwordView.layer.cornerRadius = 4.0;
    passwordView.layer.masksToBounds = YES;
    passwordView.backgroundColor = Rgba(255,255,255,0.1);
    [loginButtomView addSubview:passwordView];
    
    // 密码输入图标
    UIImageView *pwdImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 13, 13, 14)];
    pwdImageView.image = [UIImage imageNamed:@"login_password"];
    [passwordView addSubview:pwdImageView];
    
    // 密码输入框
    passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(33, 0, loginBgWidth-54-38, 40)];
    passwordTextField.textColor = [UIColor whiteColor];
    passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordTextField.font = [UIFont systemFontOfSize:14];
    passwordTextField.secureTextEntry = YES;
    passwordTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"please.enter.password.SVC") attributes:@{NSForegroundColorAttributeName: color}];
    [passwordView addSubview:passwordTextField];
    
    // 登录按钮
    CGFloat btnWidth = loginBgWidth-60;
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(30, 175, btnWidth, 55);
    loginBtn.layer.cornerRadius = 1.0;
    loginBtn.layer.masksToBounds = YES;
    [loginBtn setTitle:Localized(@"login") forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [loginButtomView addSubview:loginBtn];
//    loginBtn.userInteractionEnabled = NO;
//    [loginBtn setBackgroundColor:SVCV1B5Color];
}

// 注册界面
-(void)setupRegisterView
{
    CGFloat loginBgHeight = 312;
    CGFloat loginBgWidth = SVC_ScreenWidth-52;
    registerButtomView = [[UIView alloc] initWithFrame:CGRectMake(26, 265, loginBgWidth, loginBgHeight)];
//    registerButtomView.layer.cornerRadius = 5.0;
//    registerButtomView.layer.masksToBounds = YES;
//    registerButtomView.layer.borderColor = Rgba(255,255,255,0.08).CGColor;
//    registerButtomView.layer.borderWidth = 0.5;
//    registerButtomView.backgroundColor = Rgba(255,255,255,0.02);
    [self.view addSubview:registerButtomView];
    registerButtomView.hidden = YES;
    
    
    UIImageView *registerBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, loginBgWidth, loginBgHeight)];
    registerBgImageView.image = [UIImage imageNamed:@"login_btnbg2"];
    [registerButtomView addSubview:registerBgImageView];
    
    // 创建账号底层
    UIView *accountView = [[UIView alloc] initWithFrame:CGRectMake(27, 50, loginBgWidth-54, 40)];
    accountView.layer.cornerRadius = 4.0;
    accountView.layer.masksToBounds = YES;
    accountView.backgroundColor = Rgba(255,255,255,0.1);
    [registerButtomView addSubview:accountView];
    
    // 账户名
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 40)];
    accountLabel.adjustsFontSizeToFitWidth = YES;
    accountLabel.text = Localized(@"account.name");
    accountLabel.textAlignment = NSTextAlignmentLeft;
    accountLabel.textColor = [UIColor whiteColor];
    accountLabel.font = [UIFont systemFontOfSize:13];
    [accountView addSubview:accountLabel];
     
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    
    // 账号输入框
    accountRegisterTextField = [[UITextField alloc] initWithFrame:CGRectMake(71, 0, loginBgWidth-54-76, 40)];
    accountRegisterTextField.textColor = [UIColor whiteColor];
    accountRegisterTextField.clearButtonMode = UITextFieldViewModeAlways;
    accountRegisterTextField.font = [UIFont systemFontOfSize:13];
    accountRegisterTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"account.name.tip") attributes:@{NSForegroundColorAttributeName: color}];
    [accountView addSubview:accountRegisterTextField];
    
    
    // 创建密码底层
    UIView *passwordView = [[UIView alloc] initWithFrame:CGRectMake(27, 100, loginBgWidth-54, 40)];
    passwordView.layer.cornerRadius = 4.0;
    passwordView.layer.masksToBounds = YES;
    passwordView.backgroundColor = Rgba(255,255,255,0.1);
    [registerButtomView addSubview:passwordView];
    
    // 输入密码
    UILabel *passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 40)];
    passwordLabel.adjustsFontSizeToFitWidth = YES;
    passwordLabel.text = Localized(@"enter.password");
    passwordLabel.textAlignment = NSTextAlignmentLeft;
    passwordLabel.textColor = [UIColor whiteColor];
    passwordLabel.font = [UIFont systemFontOfSize:13];
    [passwordView addSubview:passwordLabel];
    
    // 密码输入框
    passwordRegisterTextField = [[UITextField alloc] initWithFrame:CGRectMake(71, 0, loginBgWidth-54-76, 40)];
    passwordRegisterTextField.textColor = [UIColor whiteColor];
    passwordRegisterTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordRegisterTextField.font = [UIFont systemFontOfSize:13];
    passwordRegisterTextField.secureTextEntry = YES;
    passwordRegisterTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"more.than.eight.characters") attributes:@{NSForegroundColorAttributeName: color}];
    [passwordView addSubview:passwordRegisterTextField];
    
    // 创建确认密码底层
    UIView *passwordConfirmView = [[UIView alloc] initWithFrame:CGRectMake(27, 150, loginBgWidth-54, 40)];
    passwordConfirmView.layer.cornerRadius = 4.0;
    passwordConfirmView.layer.masksToBounds = YES;
    passwordConfirmView.backgroundColor = Rgba(255,255,255,0.1);
    [registerButtomView addSubview:passwordConfirmView];
    
    // 输入确认密码
    UILabel *passwordConfirmLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 60, 40)];
    passwordConfirmLabel.adjustsFontSizeToFitWidth = YES;
    passwordConfirmLabel.text =Localized(@"confirm.password");
    passwordConfirmLabel.textAlignment = NSTextAlignmentLeft;
    passwordConfirmLabel.textColor = [UIColor whiteColor];
    passwordConfirmLabel.font = [UIFont systemFontOfSize:13];
    [passwordConfirmView addSubview:passwordConfirmLabel];
    
    // 确认密码输入框
    passwordConfirmTextField = [[UITextField alloc] initWithFrame:CGRectMake(71, 0, loginBgWidth-54-76, 40)];
    passwordConfirmTextField.textColor = [UIColor whiteColor];
    passwordConfirmTextField.clearButtonMode = UITextFieldViewModeAlways;
    passwordConfirmTextField.font = [UIFont systemFontOfSize:13];
    passwordConfirmTextField.secureTextEntry = YES;
    passwordConfirmTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"enter.new.password.settings") attributes:@{NSForegroundColorAttributeName: color}];
    [passwordConfirmView addSubview:passwordConfirmTextField];
    
    // 注册按钮
    CGFloat btnWidth = loginBgWidth-60;
    createWalletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    createWalletBtn.frame = CGRectMake(30, 225, btnWidth, 55);
    createWalletBtn.layer.cornerRadius = 1.0;
    createWalletBtn.layer.masksToBounds = YES;
    [createWalletBtn setTitle:Localized(@"create.wallet") forState:UIControlStateNormal];
    [createWalletBtn.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [createWalletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [createWalletBtn setBackgroundImage:[UIImage imageNamed:@"login_btn"] forState:UIControlStateNormal];
    [createWalletBtn addTarget:self action:@selector(createWallet:) forControlEvents:UIControlEventTouchUpInside];
    [registerButtomView addSubview:createWalletBtn];
    //    loginBtn.userInteractionEnabled = NO;
//    [createWalletBtn setBackgroundColor:SVCV1B5Color];
    
    
//     if ([currentLanguage isEqualToString:@"en"])
//     {
//         accountLabel.frame = CGRectMake(13, 0, 89, 51);
//         accountLabel.font = [UIFont systemFontOfSize:10];
//         accountRegisterTextField.frame = CGRectMake(102, 0, SVC_ScreenWidth-56-92-20, 51);
//
//         passwordLabel.frame = CGRectMake(13, 0, 89, 51);
//         passwordLabel.font = [UIFont systemFontOfSize:10];
//         passwordRegisterTextField.frame = CGRectMake(102, 0, SVC_ScreenWidth-56-92-20, 51);
//
//         passwordConfirmLabel.frame = CGRectMake(13, 0, 89, 51);
//         passwordConfirmLabel.font = [UIFont systemFontOfSize:10];
//         passwordConfirmTextField.frame = CGRectMake(102, 0, SVC_ScreenWidth-56-92-20, 51);
//     }
}

#pragma mark - action

-(void)loginSelect:(SVCSegButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
        loginButtomView.hidden = YES;
    }else
    {
        sender.selected = YES;
        self.registerSegBtn.selected = NO;
        loginButtomView.hidden = NO;
        registerButtomView.hidden = YES;
    }
    
}

-(void)registerSelect:(SVCSegButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
        registerButtomView.hidden = YES;
    }else
    {
        sender.selected = YES;
        self.loginSegBtn.selected = NO;
        loginButtomView.hidden = YES;
        registerButtomView.hidden = NO;
    }
}

#pragma mark - 登录点击事件
-(void)login:(UIButton *)btn
{
//    SVCDisclaimerViewController *disclaimerVc = [[SVCDisclaimerViewController alloc] init];
//    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
//    temporaryBarButtonItem.title = @"登录";
//    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
//    [self.navigationController pushViewController:disclaimerVc animated:NO];
    
    
    [MBProgressHUD showMessage:Localized(@"loading")];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SVC_LOGIN_USER_TOKEN_ID];
    [homePageRequest loginWithUsername:accountTextField.text withPassword:passwordTextField.text];
    
}

-(void)createWallet:(UIButton *)btn
{
    if (accountRegisterTextField.text.length<8||accountRegisterTextField.text.length>30)
    {
        [MBProgressHUD showError:Localized(@"account.not.legal")];
        return;
    }
    if (passwordRegisterTextField.text.length<8||passwordRegisterTextField.text.length>20)
    {
        [MBProgressHUD showError:Localized(@"password.format.not.legal")];
        return;
    }

    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:SVC_LOGIN_USER_TOKEN_ID];
    [homePageRequest detectionRegistereUsernameWithUsernam:accountRegisterTextField.text];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [accountTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [accountRegisterTextField resignFirstResponder];
    [passwordRegisterTextField resignFirstResponder];
    [passwordConfirmTextField resignFirstResponder];
}

-(void)SingleTap
{
    [accountTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    [accountRegisterTextField resignFirstResponder];
    [passwordRegisterTextField resignFirstResponder];
    [passwordConfirmTextField resignFirstResponder];
}

@end
