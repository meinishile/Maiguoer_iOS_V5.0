//
//  SVCAboutWeViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCAboutWeViewController.h"

@interface SVCAboutWeViewController ()
{
    UILabel *versionLabel;// 版本号
}

@end

@implementation SVCAboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Localized(@"about.us");
    self.view.backgroundColor = SVCV1B7Color;
    
    [self initAboutWeView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

-(void)initAboutWeView
{
    UIImageView *logoImageBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageBgView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageBgView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SVC_ScreenWidth-132.0)/2.0, 46, 132, 102)];
    logoImageView.image = [UIImage imageNamed:@"side_logo"];
    [self.view addSubview:logoImageView];
    
//    UILabel *appNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoImageView.frame)+19, SVC_ScreenWidth-20, 15)];
//    appNameLabel.text = @"SVC Wallet";
//    appNameLabel.textColor = [UIColor whiteColor];
//    appNameLabel.textAlignment = NSTextAlignmentCenter;
//    appNameLabel.font = [UIFont systemFontOfSize:15];
//    [self.view addSubview:appNameLabel];
    
    versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(logoImageView.frame)+14, SVC_ScreenWidth-20, 12)];
    versionLabel.text = [NSString stringWithFormat:@"v%@",[SVCSystemInfoTool getClientVersion]];
    versionLabel.textColor = Rgba(255, 255, 255, 1);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:versionLabel];
    
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = Localized(@"about.us.content");
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:contentLabel];
    CGSize maxSize = CGSizeMake(SVC_ScreenWidth - 38, MAXFLOAT);
    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    contentLabel.frame = CGRectMake(15, CGRectGetMaxY(versionLabel.frame)+32, SVC_ScreenWidth-38, size.height);
}

@end
