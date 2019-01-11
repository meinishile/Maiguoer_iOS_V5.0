//
//  SVCSegButton.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCSegButton.h"

@interface SVCSegButton ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic,copy) UIColor *lineColor;
@property (nonatomic,copy) UIColor *titlesColor;
@property (nonatomic,copy) UIColor *unselectColor;
@end

@implementation SVCSegButton

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withColor:(UIColor *)color withFontSize:(CGFloat)fontSize withItemNum:(int)itemNum
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //设置按钮的基本属性
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //设置按钮底部下划线
        CGSize lineViewS = [self sizeWithText:title font:self.titleLabel.font];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake((SVC_ScreenWidth/itemNum - lineViewS.width)/2, 38, lineViewS.width, 2)];
        self.lineView.backgroundColor = SVCV1B5Color;
        [self addSubview:self.lineView];
        
        self.titleColor = color;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withBgColor:(UIColor *)color withTitleColor:(UIColor *)titleColor withUnselectColor:(UIColor *)unselectColor withLineColor:(UIColor *)lineColor withFontSize:(CGFloat)fontSize withItemNum:(int)itemNum
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titlesColor = titleColor;
        self.lineColor = lineColor;
        self.unselectColor = unselectColor;
        
        //设置按钮的基本属性
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        self.backgroundColor = color;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        //设置按钮底部下划线
        CGSize lineViewS = [self sizeWithText:title font:self.titleLabel.font];
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake((SVC_ScreenWidth/itemNum - lineViewS.width)/2, 38, lineViewS.width, 2)];
        self.lineView.backgroundColor = lineColor;
        [self addSubview:self.lineView];
        
        self.titleColor = color;
        
    }
    return self;
}

//重写selected的set方法
-(void)setSelected:(BOOL)selected
{
    if (selected == YES) {
        [self setTitleColor:self.titlesColor forState:UIControlStateNormal];
        self.lineView.backgroundColor = self.lineColor;
        self.lineView.hidden = NO;
        self.enabled = NO;
    }else
    {
//        [self setTitleColor:Rgba(255,255,255,0.4) forState:UIControlStateNormal];
        [self setTitleColor:self.unselectColor forState:UIControlStateNormal];
        self.lineView.hidden = YES;
        self.enabled = YES;
    }
}

//计算单行文字时Label的尺寸
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font
{
    return [self sizeWithText:text withFont:font withMaxWidth:MAXFLOAT];
}

//计算多行文字时Label的尺寸
- (CGSize)sizeWithText:(NSString *)text withFont:(UIFont *)font withMaxWidth:(CGFloat)maxWidth
{
    NSMutableDictionary *attrsDict = [NSMutableDictionary dictionary];
    attrsDict[NSFontAttributeName] = font;
    CGSize size = CGSizeMake(maxWidth, MAXFLOAT);
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrsDict context:nil].size;
}


@end
