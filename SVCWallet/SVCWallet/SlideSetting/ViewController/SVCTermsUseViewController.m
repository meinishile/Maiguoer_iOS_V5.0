//
//  SVCTermsUseViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/2.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCTermsUseViewController.h"

@interface SVCTermsUseViewController ()

@end

@implementation SVCTermsUseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = Localized(@"terms.use");
    self.view.backgroundColor = SVCV1B7Color;
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageView.image = [UIImage imageNamed:@"bg"];
    [self.view addSubview:logoImageView];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.text = Localized(@"terms.content");
    contentLabel.textColor = [UIColor whiteColor];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:contentLabel];
    CGSize maxSize = CGSizeMake(SVC_ScreenWidth - 45, MAXFLOAT);
    CGSize size = [contentLabel.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    contentLabel.frame = CGRectMake(20, 28, SVC_ScreenWidth-45, size.height);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}



@end
