//
//  SVCQRCodeView.h
//  SVCWallet
//
//  Created by SVC on 2018/3/6.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCQRCodeView : UIView

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *qrCodeURL;

@property (nonatomic, strong) NSString *logoIconURL;

@property (nonatomic, strong) NSString *saveBtnTitle;

@property (nonatomic, strong) NSString *shareBtnTitle;


@property (nonatomic, strong) NSString *amountStr;
@property (nonatomic, strong) NSString *pvStr;
@property (nonatomic, strong) NSString *upStr;


@property (nonatomic, strong) NSMutableAttributedString *cautionStr;

@end
