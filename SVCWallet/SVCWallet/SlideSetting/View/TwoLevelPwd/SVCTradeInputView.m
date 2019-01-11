//
//  SVCTradeInputView.m
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#define SVCTradeInputViewNumCount 6


// 快速生成颜色
#define SVCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

typedef enum {
    SVCTradeInputViewButtonTypeWithCancle = 10000,
    SVCTradeInputViewButtonTypeWithOk = 20000,
}SVCTradeInputViewButtonType;

#import "SVCTradeInputView.h"
#import "SVCTradeKeyboard.h"
#import "NSString+Extension.h"

@interface SVCTradeInputView ()
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;


@end

@implementation SVCTradeInputView

#pragma mark - LazyLoad

- (NSMutableArray *)nums
{
    if (_nums == nil) {
        _nums = [NSMutableArray array];
    }
    return _nums;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 注册keyboard通知 */
        //        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    //    /** 确定按钮 */
    //    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self addSubview:okBtn];
    //    self.okBtn = okBtn;
    //    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_up"] forState:UIControlStateNormal];
    //    [self.okBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_ok_down"] forState:UIControlStateHighlighted];
    //    [self.okBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.okBtn.tag = SVCTradeInputViewButtonTypeWithOk;
    //
    //    /** 取消按钮 */
    //    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [self addSubview:cancleBtn];
    //    self.cancleBtn = cancleBtn;
    //    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_up"] forState:UIControlStateNormal];
    //    [self.cancleBtn setBackgroundImage:[UIImage imageNamed:@"trade.bundle/password_cancel_down"] forState:UIControlStateHighlighted];
    //    [self.cancleBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    //    self.cancleBtn.tag = SVCTradeInputViewButtonTypeWithCancle;
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote:(NSString *)state
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:SVCTradeKeyboardDeleteButtonClick object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteConfirm) name:SVCTradeKeyboardDeleteConfirmButtonClick object:nil];
    
    // 确定通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok) name:SVCTradeKeyboardOkButtonClick object:nil];
    
    //      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:SVCTradeKeyboardNumberButtonClick object:nil];
    
    if ([state isEqualToString:@"0"]) {
        // 数字通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:SVCTradeKeyboardNumberButtonClick object:nil];
        
    }else if ([state isEqualToString:@"1"]) {
        // 数字通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(numberConfirm:) name:SVCTradeKeyboardNumberConfirmButtonClick object:nil];
    }
    
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    /** 取消按钮 */
    self.cancleBtn.width = SVC_ScreenWidth * 0.409375;
    self.cancleBtn.height = SVC_ScreenWidth * 0.128125;
    self.cancleBtn.x = SVC_ScreenWidth * 0.05;
    self.cancleBtn.y = self.height - (SVC_ScreenWidth * 0.05 + self.cancleBtn.height);
    
    /** 确定按钮 */
    self.okBtn.y = self.cancleBtn.y;
    self.okBtn.width = self.cancleBtn.width;
    self.okBtn.height = self.cancleBtn.height;
    self.okBtn.x = CGRectGetMaxX(self.cancleBtn.frame) + SVC_ScreenWidth * 0.025;
}

#pragma mark - Private

// 删除
- (void)delete
{
    self.settingStatus = @"0";
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

-(void)deleteConfirm
{
    self.settingStatus = @"1";
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 删除
- (void)dropAll
{
    [self.nums removeAllObjects];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    if (self.nums.count >= SVCTradeInputViewNumCount)
    {
        return;
    }
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    if (self.nums.count == 6)
    {
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[SVCTradeInputViewPwdKey] = pwd;
        
        
        if ([self.settingStatus isEqualToString:@"0"])
        {
            //之前
            [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewFinish object:self userInfo:dict];
        }
        else
        {
            //            if ([_secondString isEqualToString:@"1"]) {
            //
            //            [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewSureSecondKey object:self userInfo:dict];
            //
            //            }else{
            //                [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewConfirmFinish object:self userInfo:dict];
            //            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewConfirmFinish object:self userInfo:dict];
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewOkButtonClick object:self userInfo:dict];
        [self.nums removeAllObjects];
    }
    [self setNeedsDisplay];
}


// 数字
- (void)numberConfirm:(NSNotification *)note
{
    if (self.nums.count >= SVCTradeInputViewNumCount)
    {
        return;
    }
    NSDictionary *userInfo = note.userInfo;
    NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
    [self.nums addObject:numObj];
    if (self.nums.count == 6)
    {
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[SVCTradeInputViewPwdKey] = pwd;
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewConfirmFinish object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewOkButtonClick object:self userInfo:dict];
        [self.nums removeAllObjects];
    }
    [self setNeedsDisplay];
}

// 确定
- (void)ok
{
    
}

// 按钮点击
- (void)btnClick:(UIButton *)btn
{
    if (btn.tag == SVCTradeInputViewButtonTypeWithCancle) {  // 取消按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:cancleBtnClick:)]) {
            [self.delegate tradeInputView:self cancleBtnClick:btn];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewCancleButtonClick object:self];
    } else if (btn.tag == SVCTradeInputViewButtonTypeWithOk) {  // 确定按钮点击
        if ([self.delegate respondsToSelector:@selector(tradeInputView:okBtnClick:)]) {
            [self.delegate tradeInputView:self okBtnClick:btn];
        }
        // 包装通知字典
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[SVCTradeInputViewPwdKey] = pwd;
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeInputViewOkButtonClick object:self userInfo:dict];
    } else {
        
    }
}

- (void)drawRect:(CGRect)rect
{
    // 画图
    //    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    
    CGFloat x = SVC_ScreenWidth * 0.096875 * 0.5f;
    CGFloat y = SVC_ScreenWidth * 0.40625 * 0.5f+55;
    CGFloat w = SVC_ScreenWidth * 0.846875f;
    CGFloat h = SVC_ScreenWidth * 0.121875f;
    
    UIImage *field = [UIImage imageNamed:@"twoLevelPwd_input_bg"];
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    // 画点
    UIImage *pointImage = [UIImage imageNamed:@"twoLevelPwd_input_yuan"];
    CGFloat pointW = SVC_ScreenWidth * 0.05;
    CGFloat pointH = pointW;
    CGFloat pointY = SVC_ScreenWidth * 0.24+55;
    CGFloat pointX;
    CGFloat margin = SVC_ScreenWidth * 0.0484375;
    CGFloat padding = SVC_ScreenWidth * 0.045578125;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    //    // ok按钮状态
    //    BOOL statue = NO;
    //    if (self.nums.count == SVCTradeInputViewNumCount) {
    //        statue = YES;
    //    } else {
    //        statue = NO;
    //    }
    //    self.okBtn.enabled = statue;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
