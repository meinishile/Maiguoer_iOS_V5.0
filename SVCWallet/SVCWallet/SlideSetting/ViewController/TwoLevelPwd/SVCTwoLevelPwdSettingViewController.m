//
//  SVCTwoLevelPwdSettingViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCTwoLevelPwdSettingViewController.h"

#import "SVCTwoLevelPwdConfirmViewController.h"

#import "SVCTradeInputView.h"
#import "SVCTradeKeyboard.h"

@interface SVCTwoLevelPwdSettingViewController ()
{
    
}

/** 键盘 */
@property (nonatomic, weak) SVCTradeKeyboard *keyboard;
/** 输入框 */
@property (nonatomic, weak) SVCTradeInputView *inputView;
/** 响应者 */
@property (nonatomic, weak) UITextField *responsder;
/** 键盘状态 */
@property (nonatomic, assign, getter=isKeyboardShow) BOOL keyboardShow;
/** 返回密码 */
@property (nonatomic, copy) NSString *passWord;

@end

@implementation SVCTwoLevelPwdSettingViewController

-(void)loadView{
    [super loadView];
    
    //    self.title = @"设置新二级密码";
    //    [self.view setBackgroundColor:SVCV3B3Color];
    //    self.skinColorManager = [SVCSkinPeeler getColor];
    //    /** 键盘 */
    //    [self setupkeyboard];
    //    /** 输入框 */
    //    [self setupInputView];
    //    /** 响应者 */
    //    [self setupResponsder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageView];
    
    self.title = Localized(@"PIN.set");
//    [self.view setBackgroundColor:SVCV1B4Color];
    /** 键盘 */
    [self setupkeyboard];
    /** 输入框 */
    [self setupInputView];
    /** 响应者 */
    [self setupResponsder];
    
    [self showKeyboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputFinish:) name:SVCTradeInputViewFinish object:nil];
    //    MGELog(@"%@",self.oldPwd);
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"nav_back" highIcon:@"nav_back" target:self action:@selector(back)];
    
    //    meHttpRequest = [[SVCMeHttpRequest alloc] init];
    //    meHttpRequest.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = SVCV1B7Color;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)back
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/** 输入框 */
- (void)setupInputView
{
    
    SVCTradeInputView *inputView = [[SVCTradeInputView alloc] init];
    inputView.settingStatus = @"0";
    [inputView setupKeyboardNote:@"0"];
    inputView.backgroundColor = [UIColor clearColor];
    [inputView.okBtn setHidden:YES];
    [inputView.cancleBtn setHidden:YES];
    inputView.layer.borderColor = SVCV1B7Color.CGColor;
    inputView.layer.borderWidth = 1.0;
    [self.view addSubview:inputView];
    self.inputView = inputView;
    
    self.inputView.height = SVC_ScreenWidth * 0.5625;
    self.inputView.y = 0;
    self.inputView.width = SVC_ScreenWidth * 0.94375;
    self.inputView.x = (SVC_ScreenWidth - self.inputView.width) * 0.5;
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.text = Localized(@"enter.setting.PIN");
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:16];
    textLabel.textColor = [UIColor whiteColor];
    [inputView addSubview:textLabel];
    
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.text = Localized(@"verify.PIN.rollout.SVC");
    noticeLabel.lineBreakMode = NSLineBreakByCharWrapping;
    noticeLabel.numberOfLines = 0;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    if ([currentLanguage isEqualToString:@"en"])
    {
        
        [noticeLabel setFont:[UIFont systemFontOfSize:10]];
    }
    else
    {
        
        [noticeLabel setFont:[UIFont systemFontOfSize:13]];
        
    }
//    noticeLabel.font = [UIFont systemFontOfSize:13];
    noticeLabel.textColor = Rgba(255, 255, 255, 0.4);
    [inputView addSubview:noticeLabel];
    
    UILabel *warningLabel = [[UILabel alloc] init];
    warningLabel.text = Localized(@"PIN.will.not.recover");
    warningLabel.lineBreakMode = NSLineBreakByCharWrapping;
    warningLabel.numberOfLines = 0;
    warningLabel.textAlignment = NSTextAlignmentCenter;
    warningLabel.font = [UIFont systemFontOfSize:13];
    warningLabel.textColor = SVCV1T6Color;
    [inputView addSubview:warningLabel];
    
    textLabel.frame = CGRectMake(0, 0, SVC_ScreenWidth, 16);
    noticeLabel.frame = CGRectMake(0, CGRectGetMaxY(textLabel.frame)+30, SVC_ScreenWidth, 14);
    warningLabel.frame = CGRectMake(0, CGRectGetMaxY(noticeLabel.frame)+5, SVC_ScreenWidth, 14);
}

/** 响应者 */
- (void)setupResponsder
{
    UITextField *responsder = [[UITextField alloc] init];
    [self.view addSubview:responsder];
    self.responsder = responsder;
}

/** 键盘 */
- (void)setupkeyboard
{
    SVCTradeKeyboard *keyboard = [[SVCTradeKeyboard alloc] init];
    keyboard.settingStatus = @"0";
    [self.view addSubview:keyboard];
    self.keyboard = keyboard;
    
    self.keyboard.x = 0;
    self.keyboard.y = SVC_ScreenHeight-64;
    self.keyboard.width = SVC_ScreenWidth;
    self.keyboard.height = SVC_ScreenWidth * 0.65;
    
}

- (void)coverClick
{
    if (self.isKeyboardShow) {  // 键盘是弹出状态
        [self hidenKeyboard:nil];
    } else {  // 键盘是隐藏状态
        [self showKeyboard];
    }
}

/** 键盘弹出 */
- (void)showKeyboard
{
    self.keyboardShow = YES;
    
    CGFloat marginTop;
    if (iPhone4) {
        marginTop = 42;
    } else if (iPhone5) {
        marginTop = 70;
    } else if (iPhone6) {
        marginTop = 90;
    } else {
        marginTop = 110;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformMakeTranslation(0, -self.keyboard.height);
        self.inputView.transform = CGAffineTransformMakeTranslation(0, marginTop - self.inputView.y);
    } completion:^(BOOL finished) {
        
    }];
}

/** 键盘退下 */
- (void)hidenKeyboard:(void (^)(BOOL finished))completion
{
    self.keyboardShow = NO;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.keyboard.transform = CGAffineTransformIdentity;
        self.inputView.transform = CGAffineTransformIdentity;
    } completion:completion];
}

/** 输入框的确定按钮点击 */
- (void)inputFinish:(NSNotification *)note
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 获取密码
    NSString *pwd = note.userInfo[SVCTradeInputViewPwdKey];
    
    SVCTwoLevelPwdConfirmViewController *confirmTwoLevelPwdVc = [[SVCTwoLevelPwdConfirmViewController alloc] init];
    confirmTwoLevelPwdVc.isModifyPINFlag = self.isModifyPINFlag;
    confirmTwoLevelPwdVc.oldPINPwd = self.oldPINPwd;
    UIBarButtonItem *confirmTwoLevelPwdBarButtonItem = [[UIBarButtonItem alloc] init];
    confirmTwoLevelPwdVc.keyString  = pwd;
    confirmTwoLevelPwdBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = confirmTwoLevelPwdBarButtonItem;
    [self.navigationController pushViewController:confirmTwoLevelPwdVc animated:YES];
}

#pragma mark - Public Interface

/** 快速创建 */
+ (instancetype)tradeView
{
    return [[self alloc] init];
}

#pragma mark - 释放内存相关处理
- (void)dealloc {
    //    [super dealloc];//dealloc is fobidden in ARC
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
