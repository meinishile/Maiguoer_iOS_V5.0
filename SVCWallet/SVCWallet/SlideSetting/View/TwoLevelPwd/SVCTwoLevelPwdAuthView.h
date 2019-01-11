//
//  SVCTwoLevelPwdAuthView.h
//  SVCWallet
//
//  Created by SVC on 2018/4/13.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SVCTwoLevelPwdAuthViewDelegate <NSObject>

@required

// 方法描述：完成PIN输入后的回调 已经做了接口请求验证  返回参数为 code状态   string 类型
- (void) finishInputtingTwoLevelPassword:(NSString *) pwd;


@optional
//方法描述：PIN输入框移除自身的响应事件
- (void) removeSelf;

// 方法描述：二级密码输入框移除自身的响应事件
- (void) removeSelfBack;

@end

/**
 *
 * 类描述：标准的PIN输入主界面
 * 创建人：
 * 创建时间：2018-04-13
 * 修改人：
 * 修改时间：
 * 修改备注：
 * 版本号：V1.1
 *
 */

@interface SVCTwoLevelPwdAuthView : UIView

@property (nonatomic, weak) id<SVCTwoLevelPwdAuthViewDelegate> delegate;

- (void) show;

@end
