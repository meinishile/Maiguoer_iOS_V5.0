//
//  SVCScanningView.h
//  SVCWallet
//
//  Created by SVC on 2018/3/5.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SVCScanningStyle) {
    SVCScanningStyleQRCode = 0,
    SVCScanningStyleBook,
    SVCScanningStyleStreet,
    SVCScanningStyleWord,
};

@interface SVCScanningView : UIView

@property(nonatomic,assign,readonly) SVCScanningStyle scanningStylel;

- (void)transformScanningTypeWithStyle:(SVCScanningStyle)style;

@property (nonatomic, strong) UIButton *myQRCodeButton;

@end
