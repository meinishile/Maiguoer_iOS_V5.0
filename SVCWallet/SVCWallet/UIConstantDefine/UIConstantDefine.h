//
//  UIConstantDefine.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#ifndef UIConstantDefine_h
#define UIConstantDefine_h

// 判断是否为iOS7
#define iOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
// 判断是否为iOS8
#define iOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
// 判断是否为iOS6
#define iOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
// 判断是否为iOS9
#define iOS9 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

/************************标准的设备尺寸 begin***********************/
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone5S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneplus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone7 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone7S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/************************标准的设备尺寸 end***********************/

/************************标准的控件尺寸 begin***********************/
#define StandardKeyboardAndPickerViewPortraitHeight 216.0f//标准键盘宽度
#define SVC_ScreenWidth  [UIScreen mainScreen].bounds.size.width //标准屏幕宽度
#define SVC_ScreenHeight  ([UIScreen mainScreen].bounds.size.height == 812.0 ?  [UIScreen mainScreen].bounds.size.height-24-34 :[UIScreen mainScreen].bounds.size.height)//  iphonex  安全区域  顶部24  底部34   为了适配的通用高度

#define SVC_AllScreenHeight [UIScreen mainScreen].bounds.size.height//标准屏幕高度

#define SVCStandardNavigationBarHeight 44.0f//标准导航栏高度
#define SVCStandardToolBarHeight 44.0f//标准工具栏高度 iphonex  底部多了34安全区域
#define SVCStandardStatusBarHeight ([UIScreen mainScreen].bounds.size.height == 812.0 ?  44.0f :20.0f)//标准状态栏高度
/************************标准的控件尺寸 end***********************/



/*
 *  获取当前保存在NSUserDefaults的本地语言
 */
#define currentLanguage [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]]

/*
 *  根据获取语言文件所在路径
 *  文件名类型Type为lproj，即.lproj的文件夹。  zh-Hans.lproj和en.lproj
 *  存在NSUserDefaults，中英文就分别设置为zh-Hans和en，不可改变。
 */
#define LanguagePath    [[NSBundle mainBundle] pathForResource:currentLanguage ofType:@"lproj"]

//等同于上面定义的三个宏
#define Localized(key)  [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]


#endif /* UIConstantDefine_h */
