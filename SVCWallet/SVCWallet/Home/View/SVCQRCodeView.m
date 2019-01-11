//
//  SVCQRCodeView.m
//  SVCWallet
//
//  Created by SVC on 2018/3/6.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCQRCodeView.h"


@interface SVCQRCodeView ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *cautionLabel;

@property (nonatomic, strong) UIImageView *qrCodeView;

@property (nonatomic, strong) UIImageView *logoIconView;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *amountLabel;

@property (nonatomic, strong) UILabel *pvMsgLabel;

@end

@implementation SVCQRCodeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubView];
        
        self.backgroundColor = SVCV1B7Color;
        self.layer.cornerRadius = 6;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setupSubView
{
    CGFloat selfW = self.frame.size.width;
    
//    UIView *logoBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfW, 44)];
//    logoBaseView.backgroundColor = Rgb(246, 246, 246);
//    [self addSubview:logoBaseView];
    
//    CGFloat logoViewW = 21;
//    CGFloat logoViewH = 18;
//    CGFloat logoViewX = 18;
//    CGFloat logoViewY = (44 - logoViewH)/2;
//    UIImage *image = [UIImage imageNamed:@"my_qr_icon"];
//    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logoViewX, logoViewY, logoViewW, logoViewH)];
//    logoView.image = image;
//    [logoBaseView addSubview:logoView];
    
//    CGFloat logoLabelX = CGRectGetMaxX(logoView.frame) + 10;
//    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoLabelX, 15, 200, 14)];
//    logoLabel.font = [UIFont systemFontOfSize:14];
//    logoLabel.textColor = SVCV1T3Color;
//    logoLabel.text = @"SVCWallet";
//    [logoBaseView addSubview:logoLabel];
    
//    CGFloat titleLabelY = CGRectGetMaxY(logoBaseView.frame) + 24;
//    CGFloat titleLabelW = selfW;
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabelY, titleLabelW, 16)];
//    self.titleLabel.font = [UIFont systemFontOfSize:14];
//    self.titleLabel.textColor = SVCV1T5Color;
//    self.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:self.titleLabel];
    
    CGFloat qrCodeViewW = 178;
    CGFloat qrCodeViewX = (selfW - qrCodeViewW)/2;
    CGFloat qrCodeViewY =  0;
    
    UIView *whiteButtomView = [[UIView alloc] initWithFrame:CGRectMake(qrCodeViewX, qrCodeViewY, qrCodeViewW, qrCodeViewW)];
    whiteButtomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:whiteButtomView];
    
    self.qrCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, qrCodeViewW, qrCodeViewW)];
    [whiteButtomView addSubview:self.qrCodeView];
    
//    CGFloat logoIconViewW = 48;
//    CGFloat logoIconViewX = (qrCodeViewW - logoIconViewW)/2;
//    self.logoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(logoIconViewX, logoIconViewX, logoIconViewW, logoIconViewW)];
//    self.logoIconView.image = [UIImage imageNamed:@"common_qr_logo"];
//    self.logoIconView.backgroundColor = [UIColor whiteColor];
//    self.logoIconView.layer.cornerRadius = 6;
//    self.logoIconView.clipsToBounds = YES;
//    self.logoIconView.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.logoIconView.layer.borderWidth = 1.0;
//    [self.qrCodeView addSubview:self.logoIconView];
    
//    CGFloat saveBtnW = 134.0/375 *SVC_ScreenWidth;
//    CGFloat saveBtnH = 44;
//    CGFloat saveBtnY = CGRectGetMaxY(self.qrCodeView.frame) + 50;
//    CGFloat saveBtnX = (selfW - saveBtnW *2 - 30)/2;
//    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH)];
//    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.saveBtn setTitleColor:SVCV1T5Color forState:UIControlStateNormal];
//    self.saveBtn.layer.cornerRadius = 4;
//    self.saveBtn.clipsToBounds = YES;
//    self.saveBtn.layer.borderWidth = 1.0;
//    self.saveBtn.layer.borderColor = Rgb(186, 186, 186).CGColor;
//    self.saveBtn.backgroundColor = [UIColor whiteColor];
//    [self addSubview:self.saveBtn];
    
//    CGFloat shareBtnX = CGRectGetMaxX(self.saveBtn.frame) + 30;
//    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtnX, saveBtnY, saveBtnW, saveBtnH)];
//    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
//    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    self.shareBtn.layer.cornerRadius = 4;
//    self.shareBtn.clipsToBounds = YES;
//    self.shareBtn.backgroundColor =  SVCV1T6Color;
//    [self addSubview:self.shareBtn];
}

-(void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}

-(void)setSaveBtnTitle:(NSString *)saveBtnTitle
{
    [self.saveBtn setTitle:saveBtnTitle forState:UIControlStateNormal];
}

-(void)setShareBtnTitle:(NSString *)shareBtnTitle
{
    [self.shareBtn setTitle:shareBtnTitle forState:UIControlStateNormal];
}

-(void)setQrCodeURL:(NSString *)qrCodeURL
{
    UIImage *qrCodeImage = [SVCUIImageTools setupQRCodeWithUrlStr:qrCodeURL];
    self.qrCodeView.image = qrCodeImage;
}

-(void)setLogoIconURL:(NSString *)logoIconURL
{
    _logoIconURL = logoIconURL;
    
//    [self.logoIconView sd_setImageWithURL:[SVCStringTools getPicUrlAccordingNetworkStatusWithUrlStr:logoIconURL withCachedImageType:SVCCachedImageTypeAvatar] placeholderImage:[SVCMyProfileManager getUserDefaultAvatarImage]];
}


//-(void)setAmountStr:(NSString *)amountStr
//{
//    _amountStr = amountStr;
//}
//
//-(void)setPvStr:(NSString *)pvStr
//{
//    _pvStr = pvStr;
//}
//
//-(void)setUpStr:(NSString *)upStr
//{
//    _upStr = upStr;
//    CGFloat selfW = self.frame.size.width;
//
//    CGFloat moneyLabelY = CGRectGetMaxY(self.qrCodeView.frame) + 35;
//    CGFloat moneyLabelX = selfW/2 - 50;
//    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabelX, moneyLabelY, 20, 30)];
//    moneyLabel.font = [UIFont systemFontOfSize:30];
//    moneyLabel.textColor = Rgb(255, 162, 0);
//    moneyLabel.textAlignment = NSTextAlignmentLeft;
//    moneyLabel.text = @"¥";
//    [self addSubview:moneyLabel];
//
//    CGFloat amountLabelY = CGRectGetMaxY(self.qrCodeView.frame) + 40;
//    CGFloat amountLabelX = CGRectGetMaxX(moneyLabel.frame) + 10;
//    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(amountLabelX, amountLabelY, 150, 40)];
//    amountLabel.font = [UIFont systemFontOfSize:40];
//    amountLabel.textColor = Rgb(255, 162, 0);
//    amountLabel.textAlignment = NSTextAlignmentLeft;
//    amountLabel.text = self.amountStr;
//    [self addSubview:amountLabel];
//
//    CGFloat pvMsgLabelY = CGRectGetMaxY(amountLabel.frame) + 15;
//    UILabel *pvMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, pvMsgLabelY, selfW, 12)];
//    pvMsgLabel.font = [UIFont systemFontOfSize:13];
//    pvMsgLabel.textColor = Rgb(102, 102, 102);
//    pvMsgLabel.textAlignment = NSTextAlignmentCenter;
//    CGFloat pvRate = self.pvStr.floatValue/self.amountStr.intValue;
//    CGFloat upRate = self.upStr.floatValue/self.amountStr.intValue;
//    pvMsgLabel.text = [NSString stringWithFormat:@"PV让利：%@   价值数额：%@",self.pvStr,self.upStr];
//    [self addSubview:pvMsgLabel];
//}

-(void)setCautionStr:(NSMutableAttributedString *)cautionStr
{
    _cautionStr = cautionStr;
    
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat selfW = self.frame.size.width;
    
    UIView *logoBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfW, 44)];
    logoBaseView.backgroundColor = SVCV1B7Color;
    [self addSubview:logoBaseView];
    
    CGFloat logoViewW = 21;
    CGFloat logoViewH = 18;
    CGFloat logoViewX = 18;
    CGFloat logoViewY = (44 - logoViewH)/2;
    UIImage *image = [UIImage imageNamed:@"my_qr_icon"];
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(logoViewX, logoViewY, logoViewW, logoViewH)];
    logoView.image = image;
    [logoBaseView addSubview:logoView];
    
    CGFloat logoLabelX = CGRectGetMaxX(logoView.frame) + 10;
    UILabel *logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoLabelX, 15, 200, 14)];
    logoLabel.font = [UIFont systemFontOfSize:14];
    logoLabel.textColor = SVCV1T3Color;
    [logoBaseView addSubview:logoLabel];
    
    CGFloat titleLabelY = CGRectGetMaxY(logoBaseView.frame) + 24;
    CGFloat titleLabelW = selfW;
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabelY, titleLabelW, 14)];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = SVCV1T5Color;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLabel];
    
    CGFloat cautionLabelY;
    CGFloat cautionLabelW = selfW;
    self.cautionLabel = [[UILabel alloc] init];
    self.cautionLabel.font = [UIFont systemFontOfSize:12];
    self.cautionLabel.textColor = SVCV1T5Color;
    self.cautionLabel.textAlignment = NSTextAlignmentCenter;
//    if ([currentLanguage isEqualToString:@"en"]) {
//
//        cautionLabelY = CGRectGetMaxY(self.titleLabel.frame) + 10;
//        self.cautionLabel.numberOfLines = 2;
//        self.cautionLabel.frame = CGRectMake(10, cautionLabelY, cautionLabelW - 20, 30);
//    }else{
//
//        cautionLabelY = CGRectGetMaxY(self.titleLabel.frame) + 15;
//        self.cautionLabel.frame = CGRectMake(0, cautionLabelY, cautionLabelW, 13);
//    }
    
    
    cautionLabelY = CGRectGetMaxY(self.titleLabel.frame) + 10;
    self.cautionLabel.numberOfLines = 2;
    self.cautionLabel.frame = CGRectMake(10, cautionLabelY, cautionLabelW - 20, 30);
    self.cautionLabel.attributedText = cautionStr;
    [self addSubview:self.cautionLabel];
    
    CGFloat qrCodeViewW = 178;
    CGFloat qrCodeViewX = (selfW - qrCodeViewW)/2;
    CGFloat qrCodeViewY = CGRectGetMaxY(self.cautionLabel.frame) + 18;
    self.qrCodeView = [[UIImageView alloc] initWithFrame:CGRectMake(qrCodeViewX, qrCodeViewY, qrCodeViewW, qrCodeViewW)];
    [self addSubview:self.qrCodeView];
    
    CGFloat logoIconViewW = 48;
    CGFloat logoIconViewX = (qrCodeViewW - logoIconViewW)/2;
    self.logoIconView = [[UIImageView alloc] initWithFrame:CGRectMake(logoIconViewX, logoIconViewX, logoIconViewW, logoIconViewW)];
    self.logoIconView.image = [UIImage imageNamed:@"common_qr_logo"];
    self.logoIconView.backgroundColor = [UIColor whiteColor];
    self.logoIconView.layer.cornerRadius = 6;
    self.logoIconView.clipsToBounds = YES;
    self.logoIconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.logoIconView.layer.borderWidth = 1.0;
//    [self.qrCodeView addSubview:self.logoIconView];
    
    CGFloat saveBtnW = 134.0/375 *SVC_ScreenWidth;
    CGFloat saveBtnH = 44;
    CGFloat saveBtnY = CGRectGetMaxY(self.qrCodeView.frame) + 30;
    CGFloat saveBtnX = (selfW - saveBtnW *2 - 30)/2;
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(saveBtnX, saveBtnY, saveBtnW, saveBtnH)];
    self.saveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.saveBtn setTitleColor:SVCV1T5Color forState:UIControlStateNormal];
    self.saveBtn.layer.cornerRadius = 4;
    self.saveBtn.clipsToBounds = YES;
    self.saveBtn.layer.borderWidth = 1.0;
    self.saveBtn.layer.borderColor = Rgb(186, 186, 186).CGColor;
    self.saveBtn.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.saveBtn];
    
    CGFloat shareBtnX = CGRectGetMaxX(self.saveBtn.frame) + 30;
    self.shareBtn = [[UIButton alloc] initWithFrame:CGRectMake(shareBtnX, saveBtnY, saveBtnW, saveBtnH)];
    self.shareBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.shareBtn.layer.cornerRadius = 4;
    self.shareBtn.clipsToBounds = YES;
    self.shareBtn.backgroundColor =  SVCV1B2Color;
    [self addSubview:self.shareBtn];
}

@end
