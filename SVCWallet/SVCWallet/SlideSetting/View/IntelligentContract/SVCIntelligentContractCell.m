//
//  SVCIntelligentContractCell.m
//  SVCWallet
//
//  Created by SVC on 2018/4/26.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCIntelligentContractCell.h"

#import "SVCIntelligentContractElement.h"

@implementation SVCIntelligentContractCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = SVCV1B7Color;
        [self setupSubviews];
    }
    return self;
}

-(void)setupSubviews
{
    UIView *grayButtomView = [[UIView alloc] initWithFrame:CGRectMake(12, 10, SVC_ScreenWidth-24, 105)];
    grayButtomView.backgroundColor = SVCV1B8Color;
    [self addSubview:grayButtomView];
    
    // 合约状态图
    self.contractStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 77, 105)];
    [grayButtomView addSubview:self.contractStatusImageView];
//    self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg01"];
//    self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg02"];
    
    // 合约数量标题
    UILabel *contractNoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 35, 77-6, 14)];
    contractNoTitleLabel.adjustsFontSizeToFitWidth = YES;
    contractNoTitleLabel.textColor = [UIColor whiteColor];
    contractNoTitleLabel.textAlignment = NSTextAlignmentCenter;
    contractNoTitleLabel.font = [UIFont systemFontOfSize:14];
    contractNoTitleLabel.text = Localized(@"contract.number");
    [grayButtomView addSubview:contractNoTitleLabel];
    
    // 合约数量
    self.contractNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 63, 77-6, 13)];
    self.contractNumLabel.adjustsFontSizeToFitWidth = YES;
    self.contractNumLabel.textColor = [UIColor whiteColor];
    self.contractNumLabel.textAlignment = NSTextAlignmentCenter;
    self.contractNumLabel.font = [UIFont systemFontOfSize:13];
    [grayButtomView addSubview:self.contractNumLabel];
//    self.contractNumLabel.text = @"90399238824";
    
    // 已完成
    self.finishedLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 19, (SVC_ScreenWidth-24-92-20)/2, 13)];
    self.finishedLabel.adjustsFontSizeToFitWidth = YES;
    self.finishedLabel.textColor = [UIColor whiteColor];
    self.finishedLabel.textAlignment = NSTextAlignmentLeft;
    self.finishedLabel.font = [UIFont systemFontOfSize:13];
    [grayButtomView addSubview:self.finishedLabel];
//    self.finishedLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"completed"),@"20000000000"];
    
    // 待完成
    self.finishingLabel = [[UILabel alloc] initWithFrame:CGRectMake(92+(SVC_ScreenWidth-24-92-20)/2, 19, (SVC_ScreenWidth-24-92-20)/2, 13)];
    self.finishingLabel.adjustsFontSizeToFitWidth = YES;
    self.finishingLabel.textColor = [UIColor whiteColor];
    self.finishingLabel.textAlignment = NSTextAlignmentRight;
    self.finishingLabel.font = [UIFont systemFontOfSize:13];
    [grayButtomView addSubview:self.finishingLabel];
//    self.finishingLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"pending"),@"2000000000"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(77, 57.8, SVC_ScreenWidth-24-77, 0.2)];
    lineView.backgroundColor = Rgba(255, 255, 255, 0.5);
    [grayButtomView addSubview:lineView];
    
    // 合约完成状态
    self.finishStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(92, 73, SVC_ScreenWidth-24-92-20, 14)];
    self.finishStatusLabel.adjustsFontSizeToFitWidth = YES;
    self.finishStatusLabel.textColor = [UIColor whiteColor];
    self.finishStatusLabel.textAlignment = NSTextAlignmentLeft;
    self.finishStatusLabel.font = [UIFont systemFontOfSize:14];
    [grayButtomView addSubview:self.finishStatusLabel];
    
    
//    NSString *isDoneStr = @"0";
//
//    NSString *nextTimeStr = [NSString stringWithFormat:@"%@ ",@"2018-06-20"];
//    NSString *amountStr = [NSString stringWithFormat:@"%@ ",@"1111"];
//    if (isDoneStr.intValue == 0)
//    {
//        self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg01"];
//        NSMutableAttributedString *finishStatusAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@%@：%@",Localized(@"next.execution.time"),nextTimeStr,Localized(@"amount"),amountStr]];
//        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,Localized(@"next.execution.time").length+1)]; //设置字体颜色
//        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:Rgba(252, 0, 53, 1.0) range:NSMakeRange(Localized(@"next.execution.time").length+1,nextTimeStr.length)]; //设置字体颜色
//        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(Localized(@"next.execution.time").length+1+nextTimeStr.length,Localized(@"amount").length+1)]; //设置字体颜色
//        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:Rgba(252, 0, 53, 1.0) range:NSMakeRange(Localized(@"next.execution.time").length+1+nextTimeStr.length+Localized(@"amount").length+1,amountStr.length)]; //设置字体颜色
//        self.finishStatusLabel.attributedText = finishStatusAttr;
//    }
//    else
//    {
//        self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg02"];
//        self.finishStatusLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"contract.completed"),nextTimeStr];
//    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.contractNumLabel.text = self.targetIntelligentContractElement.total;
    self.finishedLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"completed"),self.targetIntelligentContractElement.done];
    self.finishingLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"pending"),self.targetIntelligentContractElement.beDone];
    
    NSString *nextTimeStr = [NSString stringWithFormat:@"%@ ",self.targetIntelligentContractElement.relatedDate];
    NSString *amountStr = [NSString stringWithFormat:@"%@ ",self.targetIntelligentContractElement.grant];
    if (self.targetIntelligentContractElement.isDone.intValue == 0)
    {
        self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg01"];
        NSMutableAttributedString *finishStatusAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@%@：%@",Localized(@"next.execution.time"),nextTimeStr,Localized(@"amount"),amountStr]];
        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,Localized(@"next.execution.time").length+1)]; //设置字体颜色
        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:Rgba(252, 0, 53, 1.0) range:NSMakeRange(Localized(@"next.execution.time").length+1,nextTimeStr.length)]; //设置字体颜色
        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(Localized(@"next.execution.time").length+1+nextTimeStr.length,Localized(@"amount").length+1)]; //设置字体颜色
        [finishStatusAttr addAttribute:NSForegroundColorAttributeName value:Rgba(252, 0, 53, 1.0) range:NSMakeRange(Localized(@"next.execution.time").length+1+nextTimeStr.length+Localized(@"amount").length+1,amountStr.length)]; //设置字体颜色
        self.finishStatusLabel.attributedText = finishStatusAttr;
    }
    else
    {
        self.contractStatusImageView.image = [UIImage imageNamed:@"side_icon02_bg02"];
        self.finishStatusLabel.text = [NSString stringWithFormat:@"%@：%@",Localized(@"contract.completed"),nextTimeStr];
    }
    
    
    
}

@end
