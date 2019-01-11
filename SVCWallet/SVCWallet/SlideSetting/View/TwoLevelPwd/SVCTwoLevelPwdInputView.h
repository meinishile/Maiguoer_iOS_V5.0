//
//  SVCTwoLevelPwdInputView.h
//  SVCWallet
//
//  Created by SVC on 2018/4/13.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *SVCTwoLevelPasswordInputViewCancleButtonClick = @"SVCTradeInputViewCancleButtonClick";

#import <UIKit/UIKit.h>
#import "UIView+Extension.h"


/**
 *
 * 类描述：标准的PIN输入键盘(不由外部直接使用，由SVCTwoLevelPwdAuthView内部使用)
 * 创建人：
 * 创建时间：2018-04-13
 * 版本号：V1.1
 *
 */

@protocol SVCTwoLevelPwdInputViewDelegate <NSObject>

@optional

// 方法描述：标准输入框完成PIN输入后的回调
- (void) finishInputtingTwoLevelPassword:(NSString *) pwd;

@end

@interface SVCTwoLevelPwdInputView : UIView

@property (nonatomic, weak) id<SVCTwoLevelPwdInputViewDelegate> delegate;

@end
