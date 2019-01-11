//
//  SVCHomePageCell.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCHomePageCell.h"

#import "SVCHomePageTradeElement.h"

@implementation SVCHomePageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, SVC_ScreenWidth-20, 145)];
    self.buttomView.layer.cornerRadius = 4.0;
    self.buttomView.layer.masksToBounds = YES;
//    self.buttomView.backgroundColor = SVCV1B8Color;
    self.buttomView.backgroundColor = Rgba(255,255,255,0.1);
    [self.contentView addSubview:self.buttomView];
    
    // 发送或接收图标
    self.typeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 22, 22)];
    [self.buttomView addSubview:self.typeImageView];
    
    // 时间
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.typeImageView.frame)+6, 15, SVC_ScreenWidth-50, 12)];
    self.dateLabel.textColor = Rgba(255, 255, 255, 0.5);
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.font = [UIFont systemFontOfSize:12];
    [self.buttomView addSubview:self.dateLabel];
    
    // 地址
    self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 42, SVC_ScreenWidth-30, 16)];
    self.addressLabel.textColor = [UIColor whiteColor];
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    self.addressLabel.font = [UIFont systemFontOfSize:15];
    [self.buttomView addSubview:self.addressLabel];
    
    // 备注
    self.noteLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.addressLabel.frame)+15, SVC_ScreenWidth-30, 12)];
    self.noteLabel.textColor = Rgba(255, 255, 255, 0.5);
    self.noteLabel.textAlignment = NSTextAlignmentLeft;
    self.noteLabel.font = [UIFont systemFontOfSize:12];
    [self.buttomView addSubview:self.noteLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, 100.3, SVC_ScreenWidth-15, 0.2)];
    lineView.backgroundColor = Rgba(255, 255, 255, 0.5)
    ;
    [self.buttomView addSubview:lineView];
    
    // 数量
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(lineView.frame)+16, (SVC_ScreenWidth-20)/3-4, 15)];
    self.numberLabel.adjustsFontSizeToFitWidth = YES;
    self.numberLabel.textColor = Rgba(255, 255, 255, 0.5);
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = [UIFont systemFontOfSize:15];
    [self.buttomView addSubview:self.numberLabel];
    
    // 手续费
    self.poundageLabel = [[UILabel alloc] initWithFrame:CGRectMake((SVC_ScreenWidth-20)/3+2, CGRectGetMaxY(lineView.frame)+16, (SVC_ScreenWidth-20)/3-4, 15)];
    self.poundageLabel.textColor = Rgba(255, 255, 255, 0.5);
    self.poundageLabel.adjustsFontSizeToFitWidth = YES;
    self.poundageLabel.textAlignment = NSTextAlignmentCenter;
    self.poundageLabel.font = [UIFont systemFontOfSize:15];
    [self.buttomView addSubview:self.poundageLabel];
    
    // 合计
    self.combinedLabel = [[UILabel alloc] initWithFrame:CGRectMake((SVC_ScreenWidth-20)*2/3+2, CGRectGetMaxY(lineView.frame)+16, (SVC_ScreenWidth-20)/3-4, 15)];
    self.combinedLabel.adjustsFontSizeToFitWidth = YES;
    self.combinedLabel.textColor = Rgba(255, 255, 255, 0.5);
    self.combinedLabel.textAlignment = NSTextAlignmentCenter;
    self.combinedLabel.font = [UIFont systemFontOfSize:15];
    [self.buttomView addSubview:self.combinedLabel];
    
    
    
//    // 测试数据
//    self.noteLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"card_remarks"),@"哈哈哈"];
//    self.dateLabel.text = @"2018-06-15 14:31:59";
//    NSString *numStr = @"+100";
//    NSString *poundageStr = @"0.00";
//    NSString *combinedStr = @"100";
//
//    NSMutableAttributedString *numAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"number"),numStr]];
//    [numAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"number").length+1)]; //设置字体颜色
//    [numAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"number").length+1)]; //设置字体字号和字体类别
//    [numAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"number").length+1, numStr.length)]; //设置字体字号和字体类别
//
//
//    NSMutableAttributedString *poundageAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"poundage"),poundageStr]];
//    [poundageAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"poundage").length+1)]; //设置字体颜色
//    [poundageAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 1.0) range:NSMakeRange(Localized(@"poundage").length+1,poundageStr.length)]; //设置字体颜色
//    [poundageAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"poundage").length+1)]; //设置字体字号和字体类别
//    [poundageAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"poundage").length+1, poundageStr.length)]; //设置字体字号和字体类别
//
//
//    NSMutableAttributedString *combinedAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"combined"),combinedStr]];
//    [combinedAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"combined").length+1)]; //设置字体颜色
//
//    [combinedAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"combined").length+1)]; //设置字体字号和字体类别
//    [combinedAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"combined").length+1, combinedStr.length)]; //设置字体字号和字体类别
//
//    NSString *changeType = @"1";
//
//    if (changeType.intValue==0)// 发送
//    {
//        self.addressLabel.text = @"gojljaoomaboajarlkjaoeooj9275jkaj23423j4kj3l";
//        self.typeImageView.image = [UIImage imageNamed:@"homepage_send02"];
//        [numAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T10Color range:NSMakeRange(Localized(@"number").length+1,numStr.length)]; //设置字体颜色
//        [combinedAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T10Color range:NSMakeRange(Localized(@"combined").length+1,combinedStr.length)]; //设置字体颜色
//    }
//    else// 接收
//    {
//        [numAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T6Color range:NSMakeRange(Localized(@"number").length+1,numStr.length)]; //设置字体颜色
//        [combinedAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T6Color range:NSMakeRange(Localized(@"combined").length+1,combinedStr.length)]; //设置字体颜色
//        self.addressLabel.text = @"gojljaoomaboajarlkfafdf399999999994kj3l";
//        self.typeImageView.image = [UIImage imageNamed:@"homepage_receive02"];
//    }
//
//    self.numberLabel.attributedText = numAttr;
//    self.poundageLabel.attributedText = poundageAttr;
//    self.combinedLabel.attributedText = combinedAttr;
}


-(void)layoutSubviews
{
    [super layoutSubviews];

    self.noteLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"card_remarks"),self.targetHomePageTradeElement.noteInfo];
    self.dateLabel.text = self.targetHomePageTradeElement.datetime;
    NSString *numStr = self.targetHomePageTradeElement.changeAmount;
    NSString *poundageStr = self.targetHomePageTradeElement.changeFee;
    NSString *combinedStr = self.targetHomePageTradeElement.changeTotal;

    NSMutableAttributedString *numAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"number"),numStr]];
    [numAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"number").length+1)]; //设置字体颜色
    [numAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"number").length+1)]; //设置字体字号和字体类别
    [numAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"number").length+1, numStr.length)]; //设置字体字号和字体类别


    NSMutableAttributedString *poundageAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"poundage"),poundageStr]];
    [poundageAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"poundage").length+1)]; //设置字体颜色
    [poundageAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 1.0) range:NSMakeRange(Localized(@"poundage").length+1,poundageStr.length)]; //设置字体颜色
    [poundageAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"poundage").length+1)]; //设置字体字号和字体类别
    [poundageAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"poundage").length+1, poundageStr.length)]; //设置字体字号和字体类别


    NSMutableAttributedString *combinedAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@",Localized(@"combined"),combinedStr]];
    [combinedAttr addAttribute:NSForegroundColorAttributeName value:Rgba(255, 255, 255, 0.5) range:NSMakeRange(0,Localized(@"combined").length+1)]; //设置字体颜色

    [combinedAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, Localized(@"combined").length+1)]; //设置字体字号和字体类别
    [combinedAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(Localized(@"combined").length+1, combinedStr.length)]; //设置字体字号和字体类别



    if (self.targetHomePageTradeElement.changeType.intValue==0)// 发送
    {
        self.addressLabel.text = self.targetHomePageTradeElement.toaddress;
        self.typeImageView.image = [UIImage imageNamed:@"homepage_send02"];
        [numAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T10Color range:NSMakeRange(Localized(@"number").length+1,numStr.length)]; //设置字体颜色
        [combinedAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T10Color range:NSMakeRange(Localized(@"combined").length+1,combinedStr.length)]; //设置字体颜色
    }
    else// 接收
    {
        [numAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T6Color range:NSMakeRange(Localized(@"number").length+1,numStr.length)]; //设置字体颜色
        [combinedAttr addAttribute:NSForegroundColorAttributeName value:SVCV1T6Color range:NSMakeRange(Localized(@"combined").length+1,combinedStr.length)]; //设置字体颜色
        self.addressLabel.text = self.targetHomePageTradeElement.fromaddress;
        self.typeImageView.image = [UIImage imageNamed:@"homepage_receive02"];
    }

    self.numberLabel.attributedText = numAttr;
    self.poundageLabel.attributedText = poundageAttr;
    self.combinedLabel.attributedText = combinedAttr;
}

@end
