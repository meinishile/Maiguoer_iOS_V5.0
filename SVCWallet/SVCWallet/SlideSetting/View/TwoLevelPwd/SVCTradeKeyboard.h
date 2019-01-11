//
//  SVCTradeKeyboard.h
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation///Foundation.h>

static NSString *SVCTradeKeyboardDeleteButtonClick = @"SVCTradeKeyboardDeleteButtonClick";
static NSString *SVCTradeKeyboardDeleteConfirmButtonClick = @"SVCTradeKeyboardDeleteConfirmButtonClick";
static NSString *SVCTradeKeyboardOkButtonClick = @"SVCTradeKeyboardOkButtonClick";
static NSString *SVCTradeKeyboardNumberButtonClick = @"SVCTradeKeyboardNumberButtonClick";
static NSString *SVCTradeKeyboardNumberConfirmButtonClick = @"SVCTradeKeyboardNumberConfirmButtonClick";
static NSString *SVCTradeKeyboardNumberKey = @"SVCTradeKeyboardNumberKey";

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@class SVCTradeKeyboard;

@protocol SVCTradeKeyboardDelegate <NSObject>

@optional
/** 数字按钮点击 */
- (void)tradeKeyboard:(SVCTradeKeyboard *)keyboard numBtnClick:(NSInteger)num;
/** 删除按钮点击 */
- (void)tradeKeyboardDeleteBtnClick;
/** 确定按钮点击 */
- (void)tradeKeyboardOkBtnClick;
@end

@interface SVCTradeKeyboard : UIView

// 代理
@property (nonatomic, weak) id<SVCTradeKeyboardDelegate> delegate;

@property (nonatomic,copy) NSString *settingStatus;

@end
