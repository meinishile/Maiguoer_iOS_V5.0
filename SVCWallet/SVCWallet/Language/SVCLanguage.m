//
//  SVCLanguage.m
//  SVCWallet
//
//  Created by SVC on 2018/3/6.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCLanguage.h"
#import "AppDelegate.h"

@implementation SVCLanguage


+(void)getCurrentLanguage{
    /*
     *  获取当前系统语言，判断首次应该使用哪个语言文件,默认
     */
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]) {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *language = [languages objectAtIndex:0];
        if ([language hasPrefix:@"en"])
        {//开头匹配
            [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}


+(void)changeLanguage{
    if ([currentLanguage isEqualToString:@"en"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    NSLog(@"语言==%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"]);
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate changelanguage];
    
    
}

@end
