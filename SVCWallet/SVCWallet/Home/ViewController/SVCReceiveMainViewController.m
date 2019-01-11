//
//  SVCReceiveMainViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCReceiveMainViewController.h"

#import "SVCQRCodeView.h"

@interface SVCReceiveMainViewController ()
{
    NSString * currentLoginAddress;
    UIScrollView *scrollView;
}
/** 二维码生成界面 */
@property (nonatomic,strong) SVCQRCodeView *qrCodeMsgView;
/** SVC数量填写输入框 */
@property (nonatomic,strong) UITextField *SVCNumTextField;
/** 账户地址 */
@property (nonatomic,strong) UILabel *accountAddressLabel;

@end

@implementation SVCReceiveMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Localized(@"receive");
    self.view.backgroundColor = SVCV1B7Color;
    
    [self initQrcodeView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}


-(void)initQrcodeView
{
    UIImageView *logoImageBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageBgView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageBgView];
    
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
        scrollView.contentSize = CGSizeMake(SVC_ScreenWidth,SVC_ScreenHeight+120);
    }
    
    
    
    UIColor *color = Rgba(255, 255, 255, 0.4);
    
    currentLoginAddress = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ADDRESS];
    if ([currentLoginAddress isEqualToString:@""] || currentLoginAddress == NULL || currentLoginAddress == nil)
    {
        currentLoginAddress = @"";
    }
    
    // 账号输入框
    self.SVCNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 94, SVC_ScreenWidth-160, 35)];
    self.SVCNumTextField.textColor = [UIColor whiteColor];
    self.SVCNumTextField.textAlignment = NSTextAlignmentCenter;
    self.SVCNumTextField.font = [UIFont systemFontOfSize:17];
    self.SVCNumTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:Localized(@"fill.number.receiving.SVC") attributes:@{NSForegroundColorAttributeName: color}];
    [self.view addSubview:self.SVCNumTextField];
    [self.SVCNumTextField addTarget:self action:@selector(changingEvent) forControlEvents:UIControlEventEditingChanged];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(79, CGRectGetMaxY(self.SVCNumTextField.frame), SVC_ScreenWidth-158, 0.3)];
    lineView.backgroundColor = Rgba(255, 255, 255, 0.5);;
    [self.view addSubview:lineView];
    
    self.qrCodeMsgView = [[SVCQRCodeView alloc] initWithFrame:CGRectMake(20, 150, SVC_ScreenWidth - 40, 178)];
    [self.view addSubview:self.qrCodeMsgView];
    self.qrCodeMsgView.qrCodeURL = [NSString stringWithFormat:@"%@?address=%@&amount=%@",@"svc://transfer",currentLoginAddress,@"0"];
    
    self.accountAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.qrCodeMsgView.frame)+28, SVC_ScreenWidth-20, 17)];
    self.accountAddressLabel.textAlignment = NSTextAlignmentCenter;
    self.accountAddressLabel.numberOfLines = 0;
    [self.view addSubview:self.accountAddressLabel];
    
    
    NSMutableAttributedString *addressAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"account.address"),currentLoginAddress]];
    [addressAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,Localized(@"account.address").length+1)]; //设置字体颜色
    [addressAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(Localized(@"account.address").length+1,currentLoginAddress.length)]; //设置字体颜色
    [addressAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, Localized(@"account.address").length+1)]; //设置字体字号和字体类别
    [addressAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"account.address").length+1, currentLoginAddress.length)]; //设置字体字号和字体类别
    self.accountAddressLabel.attributedText = addressAttr;
    
    CGRect rect = [self.accountAddressLabel.attributedText boundingRectWithSize:CGSizeMake(SVC_ScreenWidth-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    self.accountAddressLabel.frame = CGRectMake(10, CGRectGetMaxY(self.qrCodeMsgView.frame)+28, SVC_ScreenWidth-20, rect.size.height);
//    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    
    // 复制地址按钮
    UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyBtn.frame = CGRectMake(8, CGRectGetMaxY(self.accountAddressLabel.frame)+70, SVC_ScreenWidth-16, 45);
    copyBtn.layer.cornerRadius = 4.0;
    copyBtn.layer.masksToBounds = YES;
    copyBtn.layer.borderColor = SVCV1B5Color.CGColor;
    copyBtn.layer.borderWidth = 0.5;
    [copyBtn setTitle:Localized(@"copy.address") forState:UIControlStateNormal];
    [copyBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [copyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [copyBtn addTarget:self action:@selector(copyEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyBtn];
    [copyBtn setBackgroundColor:SVCV1B5Color];
    
    if (iPhone4)
    {
        [scrollView addSubview:self.SVCNumTextField];
        [scrollView addSubview:lineView];
        [scrollView addSubview:self.qrCodeMsgView];
        [scrollView addSubview:self.accountAddressLabel];
        [scrollView addSubview:copyBtn];
    }
}

#pragma mark - 复制地址按钮
-(void)copyEvent
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = currentLoginAddress;
    [MBProgressHUD showSuccess:Localized(@"copy.success")];
}

-(void)changingEvent
{
    self.qrCodeMsgView.qrCodeURL = [NSString stringWithFormat:@"%@?address=%@&amount=%@",@"svc://transfer",currentLoginAddress,self.SVCNumTextField.text];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.SVCNumTextField resignFirstResponder];
}

-(void)SingleTap
{
    [self.SVCNumTextField resignFirstResponder];
}

@end
