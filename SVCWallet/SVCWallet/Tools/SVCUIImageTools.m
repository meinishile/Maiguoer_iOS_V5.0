//
//  SVCUIImageTools.m
//  SVCWallet
//
//  Created by SVC on 2018/3/6.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCUIImageTools.h"

@implementation SVCUIImageTools


/**
 * 方法描述：返回二维码图片
 * 创建人：
 * 创建时间：2018-03-06
 * 传参说明：
 * 返回参数说明：
 */
+(UIImage *)setupQRCodeWithUrlStr:(NSString *)urlStr
{
    NSData *stringData = [urlStr dataUsingEncoding: NSUTF8StringEncoding];
    
    //生成
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrFilter setDefaults];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    UIColor *onColor = [UIColor blackColor];
    UIColor *offColor = [UIColor clearColor];
    CIImage *qrImage;
    
    //上色
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:@"inputImage",qrFilter.outputImage,@"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],@"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],nil];
    
    if (iOS9) {
        qrImage = [colorFilter outputImage];
    }else{
        qrImage = [qrFilter outputImage];
    }
    
    //绘制
    CGSize size = CGSizeMake(300, 300);
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRelease(cgImage);
    
    return codeImage;
}

@end
