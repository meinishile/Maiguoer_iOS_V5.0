//
//  SVCTwoLevelPwdInputView.m
//  SVCWallet
//
//  Created by SVC on 2018/4/13.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//


#define SVCTradeInputViewNumCount 6

// 快速生成颜色
#define SVCColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "SVCTwoLevelPwdInputView.h"

#import "SVCTradeKeyboard.h"
#import "NSString+Extension.h"

@interface SVCTwoLevelPwdInputView (){
    
}
/** 数字数组 */
@property (nonatomic, strong) NSMutableArray *nums;
@end

@implementation SVCTwoLevelPwdInputView

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
        [self setupKeyboardNote];
        /** 添加子控件 */
        [self setupSubViews];
    }
    return self;
}

/** 添加子控件 */
- (void)setupSubViews
{
    //标题标签
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38/2, self.frame.size.width, 40/2)];
    [titleLabel setFont:[UIFont systemFontOfSize:36/2]];
    [titleLabel setTextColor:[UIColor colorWithRed:20.0/255.0 green:20.0/255.0 blue:20.0/255.0 alpha:1.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setText:Localized(@"verify.PIN")];
    [self addSubview:titleLabel];
    
    //提示输入标签
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 188/2, self.frame.size.width, 40/2)];
    
    [tipsLabel setTextColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0]];
    [tipsLabel setTextAlignment:NSTextAlignmentCenter];
    tipsLabel.text = Localized(@"enter.six.digit.PIN");
    
    if ([currentLanguage isEqualToString:@"en"])
    {
        
        [tipsLabel setFont:[UIFont systemFontOfSize:12]];
    }
    else
    {
        
        [tipsLabel setFont:[UIFont systemFontOfSize:30/2]];
        
    }
    [self addSubview:tipsLabel];
}

/** 注册keyboard通知 */
- (void)setupKeyboardNote
{
    // 删除通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delete) name:SVCTradeKeyboardDeleteButtonClick object:nil];
    
    // 确定通知。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ok:) name:SVCTradeKeyboardOkButtonClick object:nil];
    
    
    
    // 数字通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(number:) name:SVCTradeKeyboardNumberButtonClick object:nil];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - Private

// 删除
- (void)delete
{
    [self.nums removeLastObject];
    [self setNeedsDisplay];
}

// 数字
- (void)number:(NSNotification *)note
{
    
    //正好位数够了，需要进行二级密码验证操作
    if ((self.nums.count+1) == SVCTradeInputViewNumCount) {
        NSDictionary *userInfo = note.userInfo;
        NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
        [self.nums addObject:numObj];
        [self setNeedsDisplay];
        
        //生成二级密码字符串
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        
        //直接通过上级代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishInputtingTwoLevelPassword:)])
        {
            [self.delegate finishInputtingTwoLevelPassword:pwd];
        }
    }else if ((self.nums.count+1) > SVCTradeInputViewNumCount){
        return;
    }else{
        NSDictionary *userInfo = note.userInfo;
        NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
        [self.nums addObject:numObj];
        [self setNeedsDisplay];
    }
}

////
- (void)ok:(NSNotification *)note
{
    //正好位数够了，需要进行二级密码验证操作
    if ((self.nums.count+1) == SVCTradeInputViewNumCount) {
        NSDictionary *userInfo = note.userInfo;
        NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
        [self.nums addObject:numObj];
        
        [self setNeedsDisplay];
        
        //生成二级密码字符串
        NSMutableString *pwd = [NSMutableString string];
        for (int i = 0; i < self.nums.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@", self.nums[i]];
            [pwd appendString:str];
        }
        
        //直接通过上级代理
        if (self.delegate && [self.delegate respondsToSelector:@selector(finishInputtingTwoLevelPassword:)])
        {
            [self.delegate finishInputtingTwoLevelPassword:pwd];
        }
    }else if ((self.nums.count+1) > SVCTradeInputViewNumCount){
        return;
    }else{
        NSDictionary *userInfo = note.userInfo;
        NSNumber *numObj = userInfo[SVCTradeKeyboardNumberKey];
        [self.nums addObject:numObj];
        [self setNeedsDisplay];
    }
    
}

- (void)drawRect:(CGRect)rect
{
    //绘制背景图
    //    UIImage *bg = [UIImage imageNamed:@"trade.bundle/pssword_bg"];
    UIImage *bg = [[UIImage imageNamed:@"window_bg"] stretchableImageWithLeftCapWidth:20/2/2 topCapHeight:20/2/2];
    [bg drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];//对右上角的关闭按钮进行特殊处理
    
    //绘制密码背景框
    UIImage *field = [UIImage imageNamed:@"password_input_bg"];
    //    CGFloat x = SVC_ScreenWidth * 0.096875 * 0.5;
    //    CGFloat y = SVC_ScreenWidth * 0.40625 * 0.5;
    //    CGFloat w = SVC_ScreenWidth * 0.846875;
    //    CGFloat h = SVC_ScreenWidth * 0.121875;
    
    //    CGFloat x = 30/2;
    CGFloat x = self.frame.size.width/2-480/2/2;
    CGFloat y = 240/2;
    CGFloat w = 480/2;
    CGFloat h = 70/2;
    [field drawInRect:CGRectMake(x, y, w, h)];
    
    //
    //    // 画字
    //    NSString *title = @"";
    //
    //    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:SVC_ScreenWidth * 0.053125] andMaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    //    CGFloat titleW = size.width;
    //    CGFloat titleH = size.height;
    //    CGFloat titleX = (self.width - titleW) * 0.5;
    //    CGFloat titleY = SVC_ScreenWidth * 0.03125;
    //    CGRect titleRect = CGRectMake(titleX, titleY, titleW, titleH);
    //
    //    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    //    attr[NSFontAttributeName] = [UIFont systemFontOfSize:SVC_ScreenWidth * 0.053125];
    //    attr[NSForegroundColorAttributeName] = SVCColor(102, 102, 102);
    //
    //    [title drawInRect:titleRect withAttributes:attr];
    
    // 绘制密码
    UIImage *pointImage = [UIImage imageNamed:@"yuan"];
    //    CGFloat pointW = SVC_ScreenWidth * 0.05;
    //    CGFloat pointH = pointW;
    //    CGFloat pointY = SVC_ScreenWidth * 0.24;
    //    CGFloat pointX;
    //    CGFloat margin = SVC_ScreenWidth * 0.0484375;
    //    CGFloat padding = SVC_ScreenWidth * 0.045578125;
    CGFloat pointW = 32/2;
    CGFloat pointH = pointW;
    CGFloat pointY = 260/2;
    CGFloat pointX;
    //    CGFloat margin = 32/2;
    CGFloat margin = self.frame.size.width/2-480/2/2;
    CGFloat padding = 24/2;
    for (int i = 0; i < self.nums.count; i++) {
        pointX = margin + padding + i * (pointW + 2 * padding);
        [pointImage drawInRect:CGRectMake(pointX, pointY, pointW, pointH)];
    }
    
    //    //ok按钮状态
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

#pragma mark - 动作

//点击关闭按钮的动作
- (void) inputViewCancelAction{
    [[NSNotificationCenter defaultCenter] postNotificationName:SVCTwoLevelPasswordInputViewCancleButtonClick object:self];
}

@end
