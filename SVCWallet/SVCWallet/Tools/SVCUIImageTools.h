//
//  SVCUIImageTools.h
//  SVCWallet
//
//  Created by SVC on 2018/3/6.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCUIImageTools : NSObject


/**
 * 方法描述：返回二维码图片
 * 创建人：
 * 创建时间：2018-03-06
 * 传参说明：
 * 返回参数说明：
 */
+(UIImage *)setupQRCodeWithUrlStr:(NSString *)urlStr;

@end
