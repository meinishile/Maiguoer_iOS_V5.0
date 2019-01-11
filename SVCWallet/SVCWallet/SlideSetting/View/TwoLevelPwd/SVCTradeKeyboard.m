//
//  SVCTradeKeyboard.m
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#define SVCKeyboardBtnCount 12

#import "SVCTradeKeyboard.h"


@interface SVCTradeKeyboard ()
// 所有数字按钮的数组
@property (nonatomic, strong) NSMutableArray *numBtns;
@end

@implementation SVCTradeKeyboard

#pragma mark - LazyLoad

- (NSMutableArray *)numBtns
{
    if (_numBtns == nil) {
        _numBtns = [NSMutableArray array];
    }
    return _numBtns;
}

#pragma mark - LifeCircle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        /** 添加所有按键 */
        [self setupAllBtns];
    }
    return self;
}

/** 添加所有按键 */
- (void)setupAllBtns
{
    for (int i = 0; i < SVCKeyboardBtnCount; i++) {
        // 创建按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        // 按钮音效监听
        //        [btn addTarget:self action:@selector(playTock) forControlEvents:UIControlEventTouchDown];
        // 按钮公共属性
        [btn setBackgroundImage:[UIImage imageNamed:@"number_bg"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        
        if (i == 9) {
            //            [btn setTitle:@"隐藏" forState:UIControlStateNormal];
            //            btn.titleLabel.font = [UIFont systemFontOfSize:SVC_ScreenWidth * 0.046875];
            //            [btn addTarget:self action:@selector(okBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [btn setEnabled:NO];
        } else if (i == 10) {  // 0 按钮
            [btn setTitle:@"0" forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:SVC_ScreenWidth * 0.06875];
            btn.tag = 0;
            [btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numBtns addObject:btn];
        } else if (i == 11) {  // 删除按钮
            [btn setTitle:Localized(@"delete") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:SVC_ScreenWidth * 0.046875];
            [btn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        } else {  // 其他数字按钮
            [btn setTitle:[NSString stringWithFormat:@"%d", i + 1] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:SVC_ScreenWidth * 0.06875];
            btn.tag = i + 1;
            [btn addTarget:self action:@selector(numBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self.numBtns addObject:btn];
        }
    }
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 定义总列数
    NSInteger totalCol = 3;
    
    // 定义间距
    CGFloat pad = SVC_ScreenWidth * 0.015625;
    
    // 定义x y w h
    CGFloat x;
    CGFloat y;
    CGFloat w = SVC_ScreenWidth * 0.3125;
    CGFloat h = SVC_ScreenWidth * 0.14375;
    
    // 列数 行数
    NSInteger row;
    NSInteger col;
    for (int i = 0; i < SVCKeyboardBtnCount; i++) {
        row = i / totalCol;
        col = i % totalCol;
        x = pad + col * (w + pad);
        y = row * (h + pad) + pad;
        UIButton *btn = self.subviews[i];
        btn.frame = CGRectMake(x, y, w, h);
    }
}

#pragma mark - Private

/** 删除按钮点击 */
- (void)deleteBtnClick
{
    if ([self.delegate respondsToSelector:@selector(tradeKeyboardDeleteBtnClick)]) {
        [self.delegate tradeKeyboardDeleteBtnClick];
    }
    
    if ([self.settingStatus isEqualToString:@"0"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardDeleteButtonClick object:self];
    }else if ([self.settingStatus isEqualToString:@"1"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardDeleteConfirmButtonClick object:self];
        
    }else if ([self.settingStatus isEqualToString:@"2"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardDeleteButtonClick object:self];
        
        
        
    }
    
}

/** 确定按钮点击 */
- (void)okBtnClick
{
    if ([self.delegate respondsToSelector:@selector(tradeKeyboardOkBtnClick)]) {
        [self.delegate tradeKeyboardOkBtnClick];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardOkButtonClick object:self];
}

/** 数字按钮点击 */
- (void)numBtnClick:(UIButton *)numBtn
{
    if ([self.delegate respondsToSelector:@selector(tradeKeyboard:numBtnClick:)]) {
        [self.delegate tradeKeyboard:self numBtnClick:numBtn.tag];
    }
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[SVCTradeKeyboardNumberKey] = @(numBtn.tag);
    
    if ([self.settingStatus isEqualToString:@"0"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardNumberButtonClick object:self userInfo:userInfo];
    }else if ([self.settingStatus isEqualToString:@"1"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardNumberConfirmButtonClick object:self userInfo:userInfo];
    }else if ([self.settingStatus isEqualToString:@"2"]){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SVCTradeKeyboardOkButtonClick object:self userInfo:userInfo];
    }
    
    
}

///** 播放系统音效 */
//- (void)playTock
//{
//    SVCAudioTool *tool = [[SVCAudioTool alloc] initSystemSoundWithName:@"Tock" SoundType:@"caf"];
//    [tool play];
//}

@end
