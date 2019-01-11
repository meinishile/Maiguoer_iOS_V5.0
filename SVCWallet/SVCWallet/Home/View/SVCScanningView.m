//
//  SVCScanningView.m
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCScanningView.h"

#define kSVCQRCodeTipString Localized(@"automaticallyScan")
#define kSVCBookTipString @"将书、CD、电影海报放入框内，即可自动扫描"
#define kSVCStreetTipString @"扫一下周围环境，讯在附近街景"
#define kSVCWordTipString @"将英文单词放入框内"

#define kSVCQRCodeRectPaddingX 55

typedef void(^TransformScanningAnimationBlock)(void);

@interface SVCScanningView ()

@property (nonatomic, assign, readwrite) SVCScanningStyle scanningStyle;

@property (nonatomic, strong) UIImageView *scanningImageView;

@property (nonatomic, assign) CGRect clearRect;

@property (nonatomic, strong) UILabel *QRCodeTipLabel;

@end

@implementation SVCScanningView

- (void)scanning {
    CGRect animationRect = self.scanningImageView.frame;
    animationRect.origin.y += CGRectGetWidth(self.bounds) - CGRectGetMinX(animationRect) * 2 - CGRectGetHeight(animationRect);
    
    [UIView beginAnimations:@"changeSizeAndColor" context:nil];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDuration:3.0];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationRepeatCount:0];
    [UIView setAnimationRepeatAutoreverses:YES];
    
    self.scanningImageView.hidden = NO;
    self.scanningImageView.frame = animationRect;
    [UIView commitAnimations];
}

#pragma mark - Propertys

- (UIImageView *)scanningImageView {
    if (!_scanningImageView)
    {
        _scanningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(55, 80, CGRectGetWidth(self.bounds) - 110, 3)];
        _scanningImageView.image = [UIImage imageNamed:@"richscan_img_line"];
    }
    return _scanningImageView;
}

- (UILabel *)QRCodeTipLabel
{
    if (!_QRCodeTipLabel)
    {
        _QRCodeTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.clearRect) + 30, CGRectGetWidth(self.bounds) - 20, 20)];
        _QRCodeTipLabel.text = kSVCQRCodeTipString;
        _QRCodeTipLabel.numberOfLines = 0;
        _QRCodeTipLabel.textColor = [UIColor whiteColor];
        _QRCodeTipLabel.backgroundColor = [UIColor clearColor];
        _QRCodeTipLabel.textAlignment = NSTextAlignmentCenter;
        _QRCodeTipLabel.font = [UIFont systemFontOfSize:12];
    }
    return _QRCodeTipLabel;
}

- (UIButton *)myQRCodeButton
{
    if (!_myQRCodeButton)
    {
        _myQRCodeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_QRCodeTipLabel.frame) + 30, 80, 20)];
        _myQRCodeButton.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.0, _myQRCodeButton.center.y);
//        [_myQRCodeButton setTitle:@"我的二维码" forState:UIControlStateNormal];
        [_myQRCodeButton setTitleColor:[UIColor colorWithRed:0.275 green:0.491 blue:1.000 alpha:1.000] forState:UIControlStateNormal];
        _myQRCodeButton.backgroundColor = [UIColor clearColor];
        _myQRCodeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _myQRCodeButton;
}

#pragma mark - Public Api

- (void)transformScanningTypeWithStyle:(SVCScanningStyle)style
{
    self.scanningStyle = style;
    [UIView animateWithDuration:0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setNeedsDisplay];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Life Cycle

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
        
        self.clearRect = CGRectMake(kSVCQRCodeRectPaddingX, 80, CGRectGetWidth(frame) - kSVCQRCodeRectPaddingX * 2, CGRectGetWidth(frame) - kSVCQRCodeRectPaddingX * 2);
        
        [self addSubview:self.scanningImageView];
        [self addSubview:self.QRCodeTipLabel];
        //[self addSubview:self.myQRCodeButton];
        
        //[self scanning];
        [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(change) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);
    
    CGRect clearRect;
    CGFloat paddingX;
    
    CGFloat tipLabelPadding;
    
    self.scanningImageView.hidden = YES;
    self.myQRCodeButton.hidden = YES;
    switch (self.scanningStyle)
    {
        case SVCScanningStyleQRCode:
        {
            tipLabelPadding = 30;
            self.QRCodeTipLabel.text = kSVCQRCodeTipString;
            
            self.myQRCodeButton.hidden = NO;
            self.scanningImageView .hidden = NO;
            paddingX = kSVCQRCodeRectPaddingX;
            clearRect = CGRectMake(paddingX, 80, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
            break;
        }
        case SVCScanningStyleStreet:
        case SVCScanningStyleBook:
            tipLabelPadding = 20;
            if (self.scanningStyle == SVCScanningStyleStreet)
            {
                self.QRCodeTipLabel.text = kSVCStreetTipString;
            }
            else
            {
                self.QRCodeTipLabel.text = kSVCBookTipString;
            }
            
            paddingX = 20;
            clearRect = CGRectMake(paddingX, 20, CGRectGetWidth(rect) - paddingX * 2, CGRectGetWidth(rect) - paddingX * 2);
            break;
        case SVCScanningStyleWord:
            tipLabelPadding = 25;
            self.QRCodeTipLabel.text = kSVCWordTipString;
            
            paddingX = 50;
            clearRect = CGRectMake(paddingX, 100, CGRectGetWidth(rect) - paddingX * 2, 50);
            break;
        default:
            break;
    }
    
    self.clearRect = clearRect;
    
    CGRect QRCodeTipLabelFrame = self.QRCodeTipLabel.frame;
    QRCodeTipLabelFrame.origin.y = CGRectGetMaxY(self.clearRect) + tipLabelPadding;
    self.QRCodeTipLabel.frame = QRCodeTipLabelFrame;
    
    CGContextClearRect(context, clearRect);
    
    CGContextSaveGState(context);
    
    
    UIImage *topLeftImage = [UIImage imageNamed:@"richscan_img_01"];
    UIImage *topRightImage = [UIImage imageNamed:@"richscan_img_02"];
    UIImage *bottomLeftImage = [UIImage imageNamed:@"richscan_img_03"];
    UIImage *bottomRightImage = [UIImage imageNamed:@"richscan_img_04"];
    
    [topLeftImage drawInRect:CGRectMake(clearRect.origin.x, clearRect.origin.y, topLeftImage.size.width, topLeftImage.size.height)];
    
    [topRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - topRightImage.size.width, clearRect.origin.y, topRightImage.size.width, topRightImage.size.height)];
    
    [bottomLeftImage drawInRect:CGRectMake(clearRect.origin.x, CGRectGetMaxY(clearRect) - bottomLeftImage.size.height, bottomLeftImage.size.width, bottomLeftImage.size.height)];
    
    [bottomRightImage drawInRect:CGRectMake(CGRectGetMaxX(clearRect) - bottomRightImage.size.width, CGRectGetMaxY(clearRect) - bottomRightImage.size.height, bottomRightImage.size.width, bottomRightImage.size.height)];
    
    CGFloat padding = 0.5;
    CGContextMoveToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMinY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMaxX(clearRect) + padding, CGRectGetMaxY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMaxY(clearRect) + padding);
    CGContextAddLineToPoint(context, CGRectGetMinX(clearRect) - padding, CGRectGetMinY(clearRect) - padding);
    CGContextSetLineWidth(context, padding);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextStrokePath(context);
}

- (void)change
{
    CGFloat y = self.scanningImageView.frame.origin.y;
    
    y += 1;
    
    if (y >= 80 + self.clearRect.size.height) {
        y = 80;
    }
    self.scanningImageView.frame = CGRectMake(55, y, CGRectGetWidth(self.bounds) - 110, 3);
}


@end
