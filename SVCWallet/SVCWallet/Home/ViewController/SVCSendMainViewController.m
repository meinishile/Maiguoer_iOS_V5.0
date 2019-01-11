//
//  SVCSendMainViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCSendMainViewController.h"

#import "SVCScanViewController.h"

#import "SVCTwoLevelPwdAuthView.h"

@interface SVCSendMainViewController ()<SVCHomePageHttpRequestDelegate,SVCTwoLevelPwdAuthViewDelegate>
{
    SVCHomePageHttpRequest *homePageHttpRequest;//网络请求
}
/** 可用SVC */
@property (nonatomic,strong) UILabel *availableSVCLabel;
/** 发送账户输入框 */
@property (nonatomic,strong) UILabel *sendAccountTextField;
/** 对方账户输入框 */
@property (nonatomic,strong) UITextField *otherAccountTextField;
/** 发送数量输入框 */
@property (nonatomic,strong) UITextField *sendNumTextField;
/** 备注输入框 */
@property (nonatomic,strong) UITextField *noteTextField;

@end

@implementation SVCSendMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localized(@"send");
    self.view.backgroundColor = SVCV1B7Color;
    
    homePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageHttpRequest.delegate = self;
    
    UIButton *scanButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [scanButton setBackgroundImage:[UIImage imageNamed:@"homepage_nav_scan02"] forState:UIControlStateNormal];
    [scanButton addTarget:self action:@selector(scanClickEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:scanButton];
    
    [self initSendView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

#pragma mark - 发送接口回调
-(void)applySendInfoWithResultBody:(NSDictionary *)resultBody
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
        NSString * balance = [NSString stringWithFormat:@"%@",dataDic[@"balance"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:balance forKey:SVC_LOGIN_ACCOUNTMONEY];// 存储当前用户账户余额
        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)applySendInfoFailed
{
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:Localized(@"networkError")];
}

-(void)initSendView
{
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 22, 22)];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = @[rightItem];
    
    
    UIImageView *logoImageBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageBgView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageBgView];
    
    self.availableSVCLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 15, SVC_ScreenWidth-40, 17)];
    self.availableSVCLabel.textColor = [UIColor whiteColor];
    self.availableSVCLabel.textAlignment = NSTextAlignmentLeft;
    self.availableSVCLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:self.availableSVCLabel];
    
    NSString *availableSVCStr = [SVCMyProfileManager getAccountBalance];
    NSMutableAttributedString *availableSVCAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ SVC：%@",Localized(@"available"),availableSVCStr]];
    [availableSVCAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,Localized(@"available").length+5)]; //设置字体颜色
    [availableSVCAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T9Color range:NSMakeRange(Localized(@"available").length+5,availableSVCStr.length)]; //设置字体颜色
    self.availableSVCLabel.attributedText = availableSVCAttr;
    
//    if (![self.targetAmount isEqualToString:@""])
//    {
//        if (self.targetAmount.floatValue > availableSVCStr.floatValue)
//        {
//
//            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"余额不足提示" message:@"您输入的SVC数量已超过可用数量，请确认后重新输入。" preferredStyle:UIAlertControllerStyleAlert];
//
//            UIAlertAction *action1 = [UIAlertAction actionWithTitle: @"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alert addAction:action1];
//            [self presentViewController:alert animated:YES completion:^{
//
//            }];
//        }
//    }
    
    UIView *whiteButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, 45, SVC_ScreenWidth-24, 135)];
    whiteButtomView.layer.cornerRadius = 4.0;
    whiteButtomView.layer.masksToBounds = YES;
    whiteButtomView.backgroundColor = Rgba(255,255,255,0.05);
    [self.view addSubview:whiteButtomView];
    
    UIView *line1View = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, SVC_ScreenWidth-24, 0.5)];
    line1View.backgroundColor = Rgba(233, 233, 233, 0.2);
    [whiteButtomView addSubview:line1View];
    
    UIView *line2View = [[UIView alloc] initWithFrame:CGRectMake(0, 89.5, SVC_ScreenWidth-24, 0.5)];
    line2View.backgroundColor = Rgba(233, 233, 233, 0.2);
    [whiteButtomView addSubview:line2View];
    
    UILabel *sendAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 66, 45)];
    sendAccountLabel.textColor = [UIColor whiteColor];
    sendAccountLabel.textAlignment = NSTextAlignmentLeft;
    sendAccountLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:sendAccountLabel];
    sendAccountLabel.text = Localized(@"send.address");
    
    UIColor *color = Rgba(255, 255, 255, 0.4);
    
    // 发送账户输入框
    self.sendAccountTextField = [[UILabel alloc] initWithFrame:CGRectMake(79, 0, SVC_ScreenWidth-90-24, 45)];
    self.sendAccountTextField.userInteractionEnabled = NO;
    self.sendAccountTextField.adjustsFontSizeToFitWidth = YES;
    self.sendAccountTextField.textColor = [UIColor whiteColor];
//    self.sendAccountTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.sendAccountTextField.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:self.sendAccountTextField];
    NSString *currentLoginAddress = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ADDRESS];
    if ([currentLoginAddress isEqualToString:@""] || currentLoginAddress == NULL || currentLoginAddress == nil)
    {
        currentLoginAddress = @"";
    }
    self.sendAccountTextField.text = currentLoginAddress;
    
    UILabel *otherAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 45, 66, 45)];
    otherAccountLabel.textColor = [UIColor whiteColor];
    otherAccountLabel.textAlignment = NSTextAlignmentLeft;
    otherAccountLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:otherAccountLabel];
    otherAccountLabel.text = Localized(@"receive.address");
    
    // 对方账户输入框
    self.otherAccountTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 45, SVC_ScreenWidth-90-24, 45)];
    self.otherAccountTextField.textColor = [UIColor whiteColor];
//    self.otherAccountTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.otherAccountTextField.font = [UIFont systemFontOfSize:15];
    self.otherAccountTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"enter.other.account.add") attributes:@{NSForegroundColorAttributeName: color}];
    [whiteButtomView addSubview:self.otherAccountTextField];
    
    UILabel *sendNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 90, 66, 45)];
    sendNumLabel.textColor = [UIColor whiteColor];
    sendNumLabel.textAlignment = NSTextAlignmentLeft;
    sendNumLabel.font = [UIFont systemFontOfSize:15];
    [whiteButtomView addSubview:sendNumLabel];
    sendNumLabel.text = Localized(@"send.number");
    
    // 发送数量输入框
    self.sendNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 90, SVC_ScreenWidth-90-24, 45)];
    self.sendNumTextField.textColor = [UIColor whiteColor];
    
    self.sendNumTextField.font = [UIFont systemFontOfSize:15];
    self.sendNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"number.SVC") attributes:@{NSForegroundColorAttributeName: color}];
    [whiteButtomView addSubview:self.sendNumTextField];
    
    
    UIView *noteButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, CGRectGetMaxY(whiteButtomView.frame)+10, SVC_ScreenWidth-24, 45)];
    noteButtomView.backgroundColor = Rgba(255,255,255,0.05);
    [self.view addSubview:noteButtomView];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, 0, 66, 45)];
    noteLabel.textColor = [UIColor whiteColor];
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.font = [UIFont systemFontOfSize:15];
    [noteButtomView addSubview:noteLabel];
    noteLabel.text = Localized(@"remarks");
    
    // 备注输入框
    self.noteTextField = [[UITextField alloc] initWithFrame:CGRectMake(79, 0, SVC_ScreenWidth-90-24, 45)];
    self.noteTextField.textColor = [UIColor whiteColor];
    self.noteTextField.clearButtonMode = UITextFieldViewModeAlways;
    self.noteTextField.font = [UIFont systemFontOfSize:15];
    self.noteTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"optional") attributes:@{NSForegroundColorAttributeName: color}];
    [noteButtomView addSubview:self.noteTextField];
    
    if ([self.targetAddress isEqualToString:@""] || self.targetAddress == nil)
    {
        self.otherAccountTextField.userInteractionEnabled = YES;
        self.otherAccountTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    else
    {
        self.otherAccountTextField.text = self.targetAddress;
        self.otherAccountTextField.userInteractionEnabled = NO;
    }
    
    if ([self.targetAmount isEqualToString:@""] || self.targetAmount == nil)
    {
        self.sendNumTextField.userInteractionEnabled = YES;
        self.sendNumTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    else
    {
        self.sendNumTextField.text = self.targetAmount;
        self.sendNumTextField.userInteractionEnabled = YES;
        self.sendNumTextField.clearButtonMode = UITextFieldViewModeAlways;
    }
    
    
    // 确认修改按钮
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(8, CGRectGetMaxY(noteButtomView.frame)+75, SVC_ScreenWidth-16, 45);
    sureBtn.layer.cornerRadius = 4.0;
    sureBtn.layer.masksToBounds = YES;
    sureBtn.layer.borderColor = SVCV1B5Color.CGColor;
    sureBtn.layer.borderWidth = 0.5;
    [sureBtn setTitle:Localized(@"sure") forState:UIControlStateNormal];
    [sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
    [sureBtn setBackgroundColor:SVCV1B5Color];
    
    
    if ([currentLanguage isEqualToString:@"en"])
    {
        sendAccountLabel.font = [UIFont systemFontOfSize:10];
        otherAccountLabel.font = [UIFont systemFontOfSize:10];
        sendNumLabel.font = [UIFont systemFontOfSize:10];
        
        sendAccountLabel.frame = CGRectMake(11, 0, 86, 45);
        self.sendAccountTextField.frame = CGRectMake(99, 0, SVC_ScreenWidth-110-24, 45);
        otherAccountLabel.frame = CGRectMake(11, 45, 86, 45);
        self.otherAccountTextField.frame = CGRectMake(99, 45, SVC_ScreenWidth-110-24, 45);
        sendNumLabel.frame = CGRectMake(11, 90, 86, 45);
        self.sendNumTextField.frame = CGRectMake(99, 90, SVC_ScreenWidth-150, 45);
    }
}


#pragma mark - Action

-(void)rightClick
{
    SVCScanViewController *scanningVc = [[SVCScanViewController alloc] init];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:scanningVc animated:YES];
}

-(void)sureEvent
{
    [self.sendNumTextField resignFirstResponder];
    [self.noteTextField resignFirstResponder];
    if (self.otherAccountTextField.text.length==0)
    {
        [MBProgressHUD showError:Localized(@"please.enter.billing.address")];
        return;
    }
    if (self.sendNumTextField.text.length==0)
    {
        [MBProgressHUD showError:Localized(@"please.enter.number.sent")];
        return;
    }
    if (self.sendNumTextField.text.floatValue>[SVCMyProfileManager getAccountBalance].floatValue)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"insufficient.tip") message:Localized(@"more.than.balance.tip") preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action1 = [UIAlertAction actionWithTitle: Localized(@"know") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [alert addAction:action1];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
    else
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:Localized(@"sends.SVC") message:[NSString stringWithFormat:@"%@： %@",Localized(@"confirm.address"),self.otherAccountTextField.text] preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *action1 = [UIAlertAction actionWithTitle: Localized(@"sure1") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:Localized(@"fees.prompt") message:[NSString stringWithFormat:Localized(@"fees.content"),self.sendNumTextField.text,@"0.01"] preferredStyle:UIAlertControllerStyleAlert];

            UIAlertAction *action21 = [UIAlertAction actionWithTitle: Localized(@"sure1") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                SVCTwoLevelPwdAuthView * twoLevelPasswordAuthView = [[SVCTwoLevelPwdAuthView alloc] init];
                twoLevelPasswordAuthView.delegate = self;
                [twoLevelPasswordAuthView show];
            }];
            UIAlertAction *action22 = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
            [alert1 addAction:action21];
            [alert1 addAction:action22];
            [self presentViewController:alert1 animated:YES completion:^{

            }];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:Localized(@"cancel") style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:^{

        }];
    }
}

-(void)scanClickEvent
{
    SVCScanViewController *scanningVc = [[SVCScanViewController alloc] init];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:scanningVc animated:YES];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.sendNumTextField resignFirstResponder];
    [self.noteTextField resignFirstResponder];
}

#pragma mark - SVCTwoLevelPwdAuthViewDelegate

- (void) finishInputtingTwoLevelPassword:(NSString *)pwd
{
    [homePageHttpRequest applySendInfoWithToAddress:self.otherAccountTextField.text withAmount:self.sendNumTextField.text withComment:self.noteTextField.text];
}

@end
