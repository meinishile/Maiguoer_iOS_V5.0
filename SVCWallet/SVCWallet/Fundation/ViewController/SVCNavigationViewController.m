//
//  SVCNavigationViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCNavigationViewController.h"

@interface SVCNavigationViewController ()

@end

@implementation SVCNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    //由颜色生成图片
    
    UIImage * bg = [SVCUIColorTools imageWithColor:SVCV1B1Color];
    
    //设置导航条的背景图片
    [[UINavigationBar appearance]  setBackgroundImage:bg forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //去掉导航栏下部的黑色横线
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    //设置导航栏title的字体颜色
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:Rgb(255,255,255)};
    
    
    // 操作navBar相当操作整个应用中的所有导航栏
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    //全局设置UIBarButtonItem的字体颜色
    [barItem setTintColor:[UIColor whiteColor]];
    //全局设置UIBarButtonItem的字体大小
    [barItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
