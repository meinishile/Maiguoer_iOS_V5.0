//
//  SVCSegButton.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCSegButton : UIButton

@property (nonatomic, strong) UIColor *titleColor;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withColor:(UIColor *)color withFontSize:(CGFloat)fontSize withItemNum:(int)itemNum;

/**
 * 自定义完整的方法
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title withBgColor:(UIColor *)color withTitleColor:(UIColor *)titleColor withUnselectColor:(UIColor *)unselectColor withLineColor:(UIColor *)lineColor withFontSize:(CGFloat)fontSize withItemNum:(int)itemNum;

@end
