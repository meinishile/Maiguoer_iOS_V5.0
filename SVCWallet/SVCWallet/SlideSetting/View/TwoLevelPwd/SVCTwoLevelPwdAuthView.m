//
//  SVCTwoLevelPwdAuthView.m
//  SVCWallet
//
//  Created by SVC on 2018/4/13.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCTwoLevelPwdAuthView.h"

#import "SVCTwoLevelPwdInputView.h"

#import "SVCTradeKeyboard.h"

@interface SVCTwoLevelPwdAuthView ()<UIGestureRecognizerDelegate, SVCTwoLevelPwdInputViewDelegate,SVCHomePageHttpRequestDelegate>{
    
//    SVCHomePageHttpRequest *homePageHttpRequest;// 网络请求
    
    UIImageView *dimView;//覆盖整个屏幕的背景图
    UIView * fieldBg;//当前操作区域背景视图
}

/** 键盘 */
@property (nonatomic, weak) SVCTradeKeyboard *keyboard;
/** 输入框 */
@property (nonatomic, weak) SVCTwoLevelPwdInputView *inputView;

@end

@implementation SVCTwoLevelPwdAuthView

- (instancetype)initWithFrame:(CGRect)frame
{
    //initWithFrame会被系统的init方法自动调用。
    
    self = [super initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1.000;
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        self.clearsContextBeforeDrawing = YES;
        self.clipsToBounds = NO;
        self.contentMode = UIViewContentModeScaleToFill;
        self.hidden = NO;
        self.multipleTouchEnabled = NO;
        self.opaque = YES;
        self.tag = 0;
        self.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeSelf)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
        
        fieldBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
        fieldBg.alpha = 1.0;
        fieldBg.autoresizesSubviews = YES;
        fieldBg.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        fieldBg.backgroundColor = [UIColor clearColor];
        fieldBg.clearsContextBeforeDrawing = YES;
        fieldBg.clipsToBounds = NO;
        fieldBg.contentMode = UIViewContentModeScaleToFill;
        fieldBg.hidden = NO;
        fieldBg.multipleTouchEnabled = NO;
        fieldBg.opaque = YES;
        fieldBg.tag = 0;
        fieldBg.userInteractionEnabled = YES;
        [self addSubview:fieldBg];
        
        //设置背景层为方角
        fieldBg.layer.cornerRadius = 0.0;//SVCV3StandardCornerRadius;
        fieldBg.layer.masksToBounds = YES;
        
        /** 键盘 */
        [self setupkeyboard];
        /** 输入框 */
        [self setupInputView];
    }
    return self;
}

/** 输入框 */
- (void)setupInputView
{
    SVCTwoLevelPwdInputView *inputView = nil;
    inputView = [[SVCTwoLevelPwdInputView alloc] initWithFrame:CGRectMake(50/2, 268/2, SVC_ScreenWidth-50, 340/2)];
    inputView.delegate = self;
    [self addSubview:inputView];
    self.inputView = inputView;
    
    /** 注册取消按钮点击的通知 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelAction) name:SVCTwoLevelPasswordInputViewCancleButtonClick object:nil];
    
    //右上角的取消按钮
    UIButton * cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(inputView.frame)-58/2/2, CGRectGetMinY(inputView.frame)-24/2, 58/2, 58/2)];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateHighlighted];
    [cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelBtn];
}

/** 键盘 */
- (void)setupkeyboard
{
    SVCTradeKeyboard *keyboard = [[SVCTradeKeyboard alloc] init];
    keyboard.settingStatus = @"2";
    [self addSubview:keyboard];
    self.keyboard = keyboard;
    
    /** 键盘起始frame */
    self.keyboard.x = 0;
    self.keyboard.y = SVC_ScreenHeight-SVC_ScreenWidth * 0.65;
    self.keyboard.width = SVC_ScreenWidth;
    self.keyboard.height = SVC_ScreenWidth * 0.65;
    
}

- (void) show{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    //显示覆盖整个屏幕的暗色背景图
    dimView = [[UIImageView alloc] initWithFrame:keyWindow.bounds];
    dimView.image = [self backgroundAlphaChangeImageWithSize:keyWindow.bounds.size withAlpha:0.3];
    dimView.userInteractionEnabled = YES;
    [keyWindow addSubview:dimView];
    
    //显示当前视图
    [dimView addSubview:self];
}

#pragma mark - action

- (void)dealloc {
    //    [super dealloc];
    dimView = nil;
    //release variable that owned by self;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) removeSelf {
    dimView = nil;
    
    [self.superview removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSelf)])
    {
        [self.delegate removeSelf];
    }
}

//用户点击了输入控件右上角的关闭按钮
- (void) cancelAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeSelfBack)])
    {
        [self.delegate removeSelfBack];
    }
    [self removeSelf];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    BOOL result = FALSE;
    
    CGPoint point = [gestureRecognizer locationInView:self];
    
    //    //触摸区域不在当前操作区域。可以移除掉整个视图
    //    if (!CGRectContainsPoint(fieldBg.frame, point)) {
    //        result = TRUE;
    //    }
    
    return result;
}


#pragma mark - 验证PIN密码接口回调
-(void)validationPINWithResultBody:(NSDictionary *)resultBody
{
    [self removeSelf];
    [MBProgressHUD hideHUD];
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishInputtingTwoLevelPassword:)])
        {
            [self.delegate finishInputtingTwoLevelPassword:@""];
        }
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)validationPINFailed
{
    [self removeSelf];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showError:Localized(@"networkError")];
}

#pragma mark - SVCTwoLevelPasswordInputViewDelegate

- (void)finishInputtingTwoLevelPassword:(NSString *)pwd
{
//    [self removeSelf];
    SVCHomePageHttpRequest *homePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageHttpRequest.delegate = self;
    [homePageHttpRequest validationPINWithUsername:[SVCMyProfileManager getUsername] withSecpwd:pwd];
}


- (UIImage *)backgroundAlphaChangeImageWithSize:(CGSize)size withAlpha:(CGFloat) alpha{
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    CGFloat innerRadius = 0;
    CGFloat outerRadius = sqrtf(size.width * size.width + size.height * size.height) * 0.5;
    
    BOOL opaque = NO;
    UIGraphicsBeginImageContextWithOptions(size, opaque, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    const size_t locationCount = 2;
    //    CGFloat locations[locationCount] = { 0.0, 1.0 };
    //    CGFloat components[locationCount * 4] = {
    //        0.0, 0.0, 0.0, 0.1, // More transparent black
    //        0.0, 0.0, 0.0, 0.7  // More opaque black
    //    };
    const size_t locationCount = 2;
    CGFloat locations[locationCount] = { 0.0, 0.0 };
    CGFloat components[locationCount * 4] = {
        0.0, 0.0, 0.0, 0.0, // More transparent black
        0.0, 0.0, 0.0, alpha  // More opaque black //0.7->alpha
    };
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, locationCount);
    
    CGContextDrawRadialGradient(context, gradient, center, innerRadius, center, outerRadius, 0);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    return image;
}

@end
