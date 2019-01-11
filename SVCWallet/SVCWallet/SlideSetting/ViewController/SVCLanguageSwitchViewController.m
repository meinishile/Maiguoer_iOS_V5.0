//
//  SVCLanguageSwitchViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/7.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCLanguageSwitchViewController.h"

@interface SVCLanguageSwitchViewController ()
{
    UIButton *chineseBtn;// 简体中文选择按钮
    UIButton *englishBtn;// English选择按钮
    
    UIImageView *chineseSelectImageView;// 简体中文选择图标
    UIImageView *englishSelectImageView;// English选择图标
}
@end

@implementation SVCLanguageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = Localized(@"language.environment");
    self.view.backgroundColor = SVCV1B7Color;
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


#pragma mark - 初始化界面
-(void)initUI
{
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageView];
    
    UIView *buttomWhiteView = [[UIView alloc] initWithFrame:CGRectMake(12, 20, SVC_ScreenWidth-24, 88)];
    buttomWhiteView.layer.cornerRadius = 4.0;
    buttomWhiteView.layer.masksToBounds = YES;
    buttomWhiteView.backgroundColor = Rgba(255,255,255,0.05);
    [self.view addSubview:buttomWhiteView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SVC_ScreenWidth-24, 0.5)];
    lineView.backgroundColor = Rgba(233, 233, 233, 0.2);
    [buttomWhiteView addSubview:lineView];
    
    UILabel *chineseTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 18, 62, 15)];
    chineseTitleLabel.text = @"简体中文";
    //    chineseTitleLabel.text = [[NSString alloc]initWithFormat:@"%@",Localized(@"SimplifiedChinese")];
    chineseTitleLabel.textColor = [UIColor whiteColor];
    chineseTitleLabel.textAlignment = NSTextAlignmentLeft;
    chineseTitleLabel.font = [UIFont systemFontOfSize:15];
    [buttomWhiteView addSubview:chineseTitleLabel];
    
    UILabel *englishTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 44+18, 62, 17)];
    englishTitleLabel.text = @"English";
    englishTitleLabel.textColor = [UIColor whiteColor];
    englishTitleLabel.textAlignment = NSTextAlignmentLeft;
    englishTitleLabel.font = [UIFont systemFontOfSize:15];
    [buttomWhiteView addSubview:englishTitleLabel];
    
    chineseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    chineseBtn.frame = CGRectMake(0, 0, SVC_ScreenWidth, 44);
    chineseBtn.tag = 0;
    [chineseBtn setTitleColor:SVCV1T5Color forState:UIControlStateNormal];
    [chineseBtn addTarget:self action:@selector(languageSwitchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttomWhiteView addSubview:chineseBtn];
    
    englishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    englishBtn.frame = CGRectMake(0, 44, SVC_ScreenWidth, 44);
    englishBtn.tag = 1;
    [englishBtn setTitleColor:SVCV1T5Color forState:UIControlStateNormal];
    [englishBtn addTarget:self action:@selector(languageSwitchEvent:) forControlEvents:UIControlEventTouchUpInside];
    [buttomWhiteView addSubview:englishBtn];
    
    
    chineseSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SVC_ScreenWidth-24-27, 18, 12, 9)];
    chineseSelectImageView.image = [UIImage imageNamed:@"side_icon05_pre"];
    [buttomWhiteView addSubview:chineseSelectImageView];
    
    englishSelectImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SVC_ScreenWidth-24-27, 44+18, 12, 9)];
    englishSelectImageView.image = [UIImage imageNamed:@"side_icon05_pre"];
    [buttomWhiteView addSubview:englishSelectImageView];
    
    NSString * languageString = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([languageString isEqualToString:@"en"]) {
        chineseBtn.userInteractionEnabled = YES;
        englishBtn.userInteractionEnabled = NO;
        chineseSelectImageView.hidden = YES;
        englishSelectImageView.hidden = NO;
    }else{
        chineseBtn.userInteractionEnabled = NO;
        englishBtn.userInteractionEnabled = YES;
        chineseSelectImageView.hidden = NO;
        englishSelectImageView.hidden = YES;
    }
}

#pragma mark - Action
-(void)languageSwitchEvent:(UIButton *)button
{
    switch (button.tag)
    {
        case 0:
        {
            chineseBtn.userInteractionEnabled = NO;
            englishBtn.userInteractionEnabled = YES;
            chineseSelectImageView.hidden = NO;
            englishSelectImageView.hidden = YES;
            
            [SVCLanguage changeLanguage];
            
        }
            break;
        case 1:
        {
            chineseBtn.userInteractionEnabled = YES;
            englishBtn.userInteractionEnabled = NO;
            chineseSelectImageView.hidden = YES;
            englishSelectImageView.hidden = NO;
            [SVCLanguage changeLanguage];
        }
            break;
            
        default:
            break;
    }
}

@end
