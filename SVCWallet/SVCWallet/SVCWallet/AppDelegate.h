//
//  AppDelegate.h
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


- (void)changelanguage;


@end

