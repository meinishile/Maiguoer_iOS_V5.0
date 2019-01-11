//
//  SVCManagementWalletViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCManagementWalletViewController.h"

@interface SVCManagementWalletViewController ()<SVCHomePageHttpRequestDelegate>
{
    SVCHomePageHttpRequest *homePageHttpRequest;// 网络请求
}

/** 当前账户 */
@property (nonatomic,strong) UILabel *currentAccountLabel;
/** 当前密码输入框 */
@property (nonatomic,strong) UITextField *currentPwdTextField;
/** 新密码输入框 */
@property (nonatomic,strong) UITextField *newsPwdTextField;
/** 确认密码输入框 */
@property (nonatomic,strong) UITextField *confirmPwdTextField;

@end

@implementation SVCManagementWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localized(@"change.password");
    self.view.backgroundColor = SVCV1B7Color;
    
    homePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageHttpRequest.delegate = self;
    
    [self initModifyPwdView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self setNavigationBarWithColor:SVCV1B2Color];
//    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:SVCV1T5Color}];
    
}

#pragma mark - 修改密码接口回调
-(void)modifyPasswordWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)modifyPasswordFailed
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:@"网络错误"];
}

-(void)initModifyPwdView
{
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageView];
    
    self.currentAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 15, SVC_ScreenWidth-40, 17)];
    self.currentAccountLabel.textColor = [UIColor whiteColor];
    self.currentAccountLabel.textAlignment = NSTextAlignmentLeft;
    self.currentAccountLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.currentAccountLabel];
    self.currentAccountLabel.text = [NSString stringWithFormat:@"%@%@",Localized(@"current.account"),[SVCMyProfileManager getUsername]];
    
    UIView *whiteButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, SVC_ScreenWidth-24, 135)];
    whiteButtomView.backgroundColor = Rgba(255,255,255,0.05);
    [self.view addSubview:whiteButtomView];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SVC_ScreenWidth-24, 0.5)];
    line1View.backgroundColor = Rgba(233, 233, 233, 0.2);
//    line1View.backgroundColor = [UIColor redColor];
    [whiteButtomView addSubview:line1View];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, SVC_ScreenWidth-24, 0.5)];
    line2View.backgroundColor = Rgba(233, 233, 233, 0.2);
//    line2View.backgroundColor = [UIColor redColor];
    [whiteButtomView addSubview:line2View];
    
    
    UILabel *currentPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 66, 45)];
    currentPwdLabel.textColor = [UIColor whiteColor];
    currentPwdLabel.textAlignment = NSTextAlignmentLeft;
    currentPwdLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:currentPwdLabel];
    currentPwdLabel.text = Localized(@"current.password");
    
    
    UIColor *color = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.4];
    
    // 当前密码输入框
    self.currentPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(currentPwdLabel.frame)+10, 0, SVC_ScreenWidth-130, 45)];
    self.currentPwdTextField.textColor = [UIColor whiteColor];
    self.currentPwdTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.currentPwdTextField.secureTextEntry = YES;
    self.currentPwdTextField.font = [UIFont systemFontOfSize:15];
    self.currentPwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"enter.current.password") attributes:@{NSForegroundColorAttributeName: color}];
    [whiteButtomView addSubview:self.currentPwdTextField];
    
    UILabel *newsPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 45, 66, 45)];
    newsPwdLabel.textColor = [UIColor whiteColor];
    newsPwdLabel.textAlignment = NSTextAlignmentLeft;
    newsPwdLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:newsPwdLabel];
    newsPwdLabel.text = Localized(@"new.secret");
    
    // 新密码输入框
    self.newsPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(newsPwdLabel.frame)+10, 45, SVC_ScreenWidth-130, 45)];
    self.newsPwdTextField.textColor = [UIColor whiteColor];
    self.newsPwdTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.newsPwdTextField.secureTextEntry = YES;
    self.newsPwdTextField.font = [UIFont systemFontOfSize:15];
    self.newsPwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"more.than.eight.characters") attributes:@{NSForegroundColorAttributeName: color}];
    [whiteButtomView addSubview:self.newsPwdTextField];
    
    UILabel *confirmPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 90, 66, 45)];
    confirmPwdLabel.textColor = [UIColor whiteColor];
    confirmPwdLabel.textAlignment = NSTextAlignmentLeft;
    confirmPwdLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:confirmPwdLabel];
    confirmPwdLabel.text = Localized(@"confirm.password");
    
    // 确认密码输入框
    self.confirmPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 90, SVC_ScreenWidth-130, 45)];
    self.confirmPwdTextField.textColor = [UIColor whiteColor];
    self.confirmPwdTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.confirmPwdTextField.secureTextEntry = YES;
    self.confirmPwdTextField.font = [UIFont systemFontOfSize:15];
    self.confirmPwdTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName: color}];
    [whiteButtomView addSubview:self.confirmPwdTextField];
    
    
    if ([currentLanguage isEqualToString:@"en"])
    {
        currentPwdLabel.font = [UIFont systemFontOfSize:10];
        CGRect rect1 = currentPwdLabel.frame;
        rect1.size.width += 34;
        currentPwdLabel.frame = rect1;
        self.currentPwdTextField.frame = CGRectMake(CGRectGetMaxX(currentPwdLabel.frame)+10, 0, SVC_ScreenWidth-130-34, 45);
        
        newsPwdLabel.font = [UIFont systemFontOfSize:10];
        CGRect rect2 = newsPwdLabel.frame;
        rect2.size.width += 34;
        newsPwdLabel.frame = rect2;
        self.newsPwdTextField.frame = CGRectMake(CGRectGetMaxX(newsPwdLabel.frame)+10, 45, SVC_ScreenWidth-130-34, 45);
        
        confirmPwdLabel.font = [UIFont systemFontOfSize:10];
        CGRect rect3 = confirmPwdLabel.frame;
        rect3.size.width += 34;
        confirmPwdLabel.frame = rect3;
        self.confirmPwdTextField.frame = CGRectMake(CGRectGetMaxX(confirmPwdLabel.frame)+10, 90, SVC_ScreenWidth-130-34, 45);
    }
    
    // 确认修改按钮
    UIButton *sureModifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureModifyBtn.frame = CGRectMake(8, CGRectGetMaxY(whiteButtomView.frame)+75, SVC_ScreenWidth-16, 45);
    sureModifyBtn.layer.cornerRadius = 4.0;
    sureModifyBtn.layer.masksToBounds = YES;
    [sureModifyBtn setTitle:Localized(@"confirm.change") forState:UIControlStateNormal];
    [sureModifyBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sureModifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureModifyBtn addTarget:self action:@selector(sureModifyEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureModifyBtn];
    [sureModifyBtn setBackgroundColor:SVCV1B5Color];
}


-(void)sureModifyEvent
{
    if (self.currentPwdTextField.text.length==0)
    {
        [MBProgressHUD showError:Localized(@"password.cannot.empty")];
        return;
    }
    if (self.currentPwdTextField.text.length<8||self.currentPwdTextField.text.length>20)
    {
        [MBProgressHUD showError:Localized(@"password.format.not.legal")];
        return;
    }
    if (self.newsPwdTextField.text.length==0 || self.confirmPwdTextField.text.length==0)
    {
        [MBProgressHUD showError:Localized(@"new.password.cannot.empty")];
        return;
    }
    if (![self.newsPwdTextField.text isEqualToString:self.confirmPwdTextField.text])
    {
        [MBProgressHUD showError:Localized(@"do.no.match.new.password")];
        return;
    }
    if (self.newsPwdTextField.text.length<8||self.newsPwdTextField.text.length>20 ||self.confirmPwdTextField.text.length<8||self.confirmPwdTextField.text.length>20)
    {
        [MBProgressHUD showError:Localized(@"new.password.format.not.legal")];
        return;
    }
    [MBProgressHUD showMessage:Localized(@"loading")];
    [homePageHttpRequest modifyPasswordWithUserName:[SVCMyProfileManager getUsername] withOldPassword:self.currentPwdTextField.text withNewPassword:self.newsPwdTextField.text];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.currentPwdTextField resignFirstResponder];
    [self.newsPwdTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
}


@end
