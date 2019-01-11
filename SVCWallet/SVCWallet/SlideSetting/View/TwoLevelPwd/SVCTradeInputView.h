//
//  SVCTradeInputView.h
//  SVCWallet
//
//  Created by SVC on 2018/4/11.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SVCTradeInputViewCancleButtonClick = @"SVCTradeInputViewCancleButtonClick";
static NSString *SVCTradeInputViewOkButtonClick = @"SVCTradeInputViewOkButtonClick";
static NSString *SVCTradeInputViewFinish = @"SVCTradeInputViewFinish";
static NSString *SVCTradeInputViewConfirmFinish = @"SVCTradeInputViewConfirmFinish";
static NSString *SVCTradeInputViewSureSecondKey = @"SVCTradeInputViewSureSecondKey";
static NSString *SVCTradeInputViewPwdKey = @"SVCTradeInputViewPwdKey";

static NSString *SVCTradeInputViewModifyFinish = @"SVCTradeInputViewModifyFinish";

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"

@class SVCTradeInputView;

@protocol SVCTradeInputViewDelegate <NSObject>

@optional
/** 确定按钮点击 */
- (void)tradeInputView:(SVCTradeInputView *)tradeInputView okBtnClick:(UIButton *)okBtn;
/** 取消按钮点击 */
- (void)tradeInputView:(SVCTradeInputView *)tradeInputView cancleBtnClick:(UIButton *)cancleBtn;

@end

@interface SVCTradeInputView : UIView

@property (nonatomic, weak) id<SVCTradeInputViewDelegate> delegate;
/** 确定按钮 */
@property (nonatomic, weak) UIButton *okBtn;
/** 取消按钮 */
@property (nonatomic, weak) UIButton *cancleBtn;

@property (nonatomic,strong) NSString *settingStatus;


- (void)dropAll;

- (void)setupKeyboardNote:(NSString *)state;

@end
