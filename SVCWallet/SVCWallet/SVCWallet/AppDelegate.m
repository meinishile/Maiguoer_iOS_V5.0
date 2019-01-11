//
//  AppDelegate.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "AppDelegate.h"

#import "AFNetworkReachabilityManager.h"

#import "SVCNavigationViewController.h"
#import "SVCLoginViewController.h"// 登录注册
#import "SVCHomePageViewController.h"// 首页

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //UI显示默认处理
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //获取系统默认语言
    [SVCLanguage getCurrentLanguage];
    //开启自适应键盘   测试分支奇幻
    [IQKeyboardManager sharedManager].enable = YES;
    //处理网络类型分析以及变动后的及时更新
    [self networkTypeAnalyze];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    //版本分析处理
    //取出沙盒中存储的上次使用软件的版本号
    NSString *clientVersionBeforeUpgrade = [[NSUserDefaults standardUserDefaults] stringForKey:SVC_CLIENT_VERSION_BEFORE_UPGRADE];
    //获得当前软件的版本号
    NSString *clientCurrentVersion = [SVCSystemInfoTool getClientVersion];
    
    //    不需要升级
    if (![self isUpgradeLaunchingWithVersionBeforeUpgrade:clientVersionBeforeUpgrade withClientCurrentVersion:clientCurrentVersion])
    {
        NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_USER_TOKEN_ID];
//        NSString * currentLoginUserName = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_USERNAME];
        NSString * currentLoginAddress = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ADDRESS];
        NSString * currentLoginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_STATUS];
        if (currentLoginAddress == nil || [currentLoginAddress isEqualToString:@""] || currentLoginStatus == nil || [currentLoginStatus isEqualToString:@""] || [currentLoginStatus isEqualToString:@"0"] || tokenId == nil || [tokenId isEqualToString:@""])
        {
            SVCLoginViewController *loginController = [[SVCLoginViewController alloc] init];
            SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:loginController];
            
            self.window.rootViewController = nav;
        }
        else
        {
            SVCHomePageViewController *homePageController = [[SVCHomePageViewController alloc] init];
            SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:homePageController];
            
            self.window.rootViewController = nav;
        }
    }
    else
    {
        //将boundle中文件拷贝到对应运行目录
        [self analysisCopyProcessing];
        
        
        NSString *tokenId = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_USER_TOKEN_ID];
        NSString * currentLoginAddress = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ADDRESS];
        NSString * currentLoginStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_STATUS];
        if (currentLoginAddress == nil || [currentLoginAddress isEqualToString:@""] || currentLoginStatus == nil || [currentLoginStatus isEqualToString:@""] || [currentLoginStatus isEqualToString:@"0"] || tokenId == nil || [tokenId isEqualToString:@""])
        {
            SVCLoginViewController *loginController = [[SVCLoginViewController alloc] init];
            SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:loginController];
            
            self.window.rootViewController = nav;
        }
        else
        {
            SVCHomePageViewController *homePageController = [[SVCHomePageViewController alloc] init];
            SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:homePageController];
            
            self.window.rootViewController = nav;
        }
        
        //存储新版本号到系统配置中
        [[NSUserDefaults standardUserDefaults] setObject:clientCurrentVersion forKey:SVC_CLIENT_VERSION_BEFORE_UPGRADE];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark -- 切换系统语言
-(void)changelanguage
{
    SVCHomePageViewController *homePageController = [[SVCHomePageViewController alloc] init];
    SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:homePageController];
    
    self.window.rootViewController = nav;
}


#pragma mark - 事件通知

//登陆状态改变
-(void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess == YES)
    {
        SVCHomePageViewController *homePageController = [[SVCHomePageViewController alloc] init];
        SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:homePageController];
        
        self.window.rootViewController = nav;
    }
    else
    {
        SVCLoginViewController *loginController = [[SVCLoginViewController alloc] init];
        SVCNavigationViewController *nav = [[SVCNavigationViewController alloc] initWithRootViewController:loginController];
        
        self.window.rootViewController = nav;
    }
}


#pragma mark - 网络类型分析以及变动处理

//处理网络类型分析以及变动后的及时更新 //added at 2018-03-05
- (void) networkTypeAnalyze{
    
    //0.其他 1.wifi  2.2G  3.3G   4.4G
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:SVC_CLIENT_NETWORK_TYPE];//启动后的默认值设置为wifi
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        SVCLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        NSString * network_type_in_SVC = @"1";
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                network_type_in_SVC = @"0";
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{     // 没有网络连接
                network_type_in_SVC = @"";
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{ // 使用3G网络。不区分2G，3G，4G
                network_type_in_SVC = @"3";
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{ // 使用WiFi网络
                network_type_in_SVC = @"1";
                break;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:network_type_in_SVC forKey:SVC_CLIENT_NETWORK_TYPE];
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}


#pragma mark - 版本号相关处理

/**
 * 方法描述：是否需要进行客户端版本升级处理
 * 创建人：
 * 创建时间：2018-03-05
 * 传参说明：
 * 返回参数说明：
 */
- (BOOL) isUpgradeLaunchingWithVersionBeforeUpgrade:(NSString *) clientVersionBeforeUpgrade withClientCurrentVersion:(NSString *) clientCurrentVersion{
    //版本号分析处理
    NSArray * versionArrayBeforeUpgrade = [clientVersionBeforeUpgrade componentsSeparatedByString:@"."];
    int versionClass1BeforeUpgrade = 0;
    int versionClass2BeforeUpgrade = 0;
    int versionClass3BeforeUpgrade = 0;
    if (versionArrayBeforeUpgrade.count==3) {
        versionClass1BeforeUpgrade = ((NSString *)versionArrayBeforeUpgrade[0]).intValue;
        versionClass2BeforeUpgrade = ((NSString *)versionArrayBeforeUpgrade[1]).intValue;
        versionClass3BeforeUpgrade = ((NSString *)versionArrayBeforeUpgrade[2]).intValue;
    }
    
    NSArray * versionArrayOfCurrentVersion = [clientCurrentVersion componentsSeparatedByString:@"."];
    int versionClass1OfCurrentVersion = 0;
    int versionClass2OfCurrentVersion = 0;
    int versionClass3OfCurrentVersion = 0;
    if (versionArrayOfCurrentVersion.count==3) {
        versionClass1OfCurrentVersion = ((NSString *)versionArrayOfCurrentVersion[0]).intValue;
        versionClass2OfCurrentVersion = ((NSString *)versionArrayOfCurrentVersion[1]).intValue;
        versionClass3OfCurrentVersion = ((NSString *)versionArrayOfCurrentVersion[2]).intValue;
    }
    
    //分析是否正在进行客户端升级运行
    BOOL isUpgradeLaunching = NO;
    //原客户端一级版本号小于新客户端一级版本号
    if (versionClass1BeforeUpgrade < versionClass1OfCurrentVersion) {
        isUpgradeLaunching = YES;
    }
    //原客户端一级版本号等于新客户端一级版本号。需继续分析下级版本号
    else if (versionClass1BeforeUpgrade == versionClass1OfCurrentVersion){
        //原客户端二级版本号小于新客户端二级版本号
        if (versionClass2BeforeUpgrade < versionClass2OfCurrentVersion){
            isUpgradeLaunching = YES;
        }
        //原客户端二级版本号等于新客户端二级版本号。需继续分析下级版本号
        else if (versionClass2BeforeUpgrade == versionClass2OfCurrentVersion){
            //原客户端三级级版本号小于新客户端三级版本号
            if (versionClass3BeforeUpgrade < versionClass3OfCurrentVersion){
                isUpgradeLaunching = YES;
            }
            //原客户端三级版本号等于新客户端三级版本号。版本号相同，已没有下级版本号
            else if (versionClass3BeforeUpgrade == versionClass3OfCurrentVersion){
                isUpgradeLaunching = NO;
            }
            //原客户端一级版本号等于新客户端一级版本号，并且原客户端二级版本号等于新客户端二级版本号，并且原客户端三级版本号大于新客户端三级版本号 (正式服务器上不存在此情况)
            else{
                isUpgradeLaunching = NO;
            }
        }
        //原客户端一级版本号等于新客户端一级版本号，并且原客户端二级版本号大于新客户端二级版本号 (正式服务器上不存在此情况)
        else{
            isUpgradeLaunching = NO;
        }
    }
    //原客户端一级版本号大于新客户端一级版本号(正式服务器上不存在此情况)
    else{
        isUpgradeLaunching = NO;
    }
    
    return isUpgradeLaunching;
}


#pragma mark - 将nsboundle中文件拷贝到客户端对应运行目录的相关操作

- (void) analysisCopyProcessing
{
    //for maigueorV1.1 meet modified by wangxin at 2015-04-03 begin
    //    //判断是否需要拷贝
    //    BOOL isAlreadyCopied = [[[NSUserDefaults standardUserDefaults] objectForKey:@"APP_RESOURCE_COPY"] boolValue];
    //    if (!isAlreadyCopied)
    //    {
    //        [self cpyToDocument];
    //    }
    //首先删除原始老的运行目录下的Documents下的所有文件
    NSMutableString *newFolderPath = [NSMutableString stringWithFormat:@"%@/",[self getDocumentDirectory]];//运行目录的document路径
    NSLog(@"%@",newFolderPath);
    //运行目录中的document路径或者子路径数组
    NSArray * newFolderPathSubFileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:newFolderPath  error:nil];//boundle文件的路径数组
    for (int i = 0; i<newFolderPathSubFileArray.count; i++){
        NSString *childNewfolder = [NSString stringWithFormat:@"%@%@",newFolderPath,[newFolderPathSubFileArray objectAtIndex:i]];
        NSLog(@"%@",childNewfolder);
        
        //        BOOL deleteResult = [[NSFileManager defaultManager] removeItemAtPath:childNewfolder error:nil];
        //        SVCLog(@"delete %d succ",deleteResult);
    }
    
    
    [self cpyToDocument];
    //for maigueorV1.1 meet modified by wangxin at 2015-04-03 end
}

-(void)cpyToDocument
{
    if( [self compareFolerAndCopy:@"Documents" tofolder:nil])
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",1] forKey:@"APP_RESOURCE_COPY"];
    }
}

- (BOOL)compareFolerAndCopy:(NSString*)srcfolder tofolder:(NSString*)newfolder
{
    NSString *folderPath = [NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle] resourcePath],srcfolder];
    NSLog(@"folder %@",folderPath);//boundle文件的路径
    NSMutableString *newFolderPath = [NSMutableString stringWithFormat:@"%@/",[self getDocumentDirectory]];//运行目录的document路径
    
    if (newfolder != nil && [newfolder length] != 0 )
    {
        [newFolderPath appendFormat:@"%@",newfolder];//运行目录中的document路径或者子路径
    }
    //    SVCLog(@"%@",newFolderPath);
    
    
    NSArray * srcFileArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:folderPath  error:nil];//boundle文件的路径数组
    
    //    SVCLog(@"%@",srcFileArr);
    
    int ncount = (int)[srcFileArr count];
    
    if (ncount < 1)
    {
        return NO;
    }
    
    for (int i = 0; i<ncount; i++)
    {
        BOOL isDir = NO;
        
        NSString *childSrcFolder = [NSString stringWithFormat:@"%@/%@",folderPath,[srcFileArr objectAtIndex:i]];
        NSString *childNewfolder = [NSString stringWithFormat:@"%@/%@",newFolderPath,[srcFileArr objectAtIndex:i]];
        //        SVCLog(@"childSrcFolder %@",childSrcFolder);//boundle文件的路径
        //        SVCLog(@"childNewfolder %@",childNewfolder);//document文件的路径
        
        //boundle中文件存在
        if ([[NSFileManager defaultManager] fileExistsAtPath:childSrcFolder isDirectory:(&isDir)])
        {
            //boundle中文件存在，并且是文件夹
            if (isDir)
            {
                if (![[NSFileManager defaultManager] fileExistsAtPath:childNewfolder ])
                {
                    [self copyFile:srcfolder tofile:newfolder file:[srcFileArr objectAtIndex:i]];
                }
                else
                {
                    NSString *childSrc = [NSString stringWithFormat:@"%@/%@",srcfolder,[srcFileArr objectAtIndex:i]];
                    
                    NSMutableString *childNew = [NSMutableString stringWithString:@""];
                    
                    if (newfolder != nil)
                    {
                        [childNew appendFormat:@"%@/",newfolder];
                    }
                    [childNew appendFormat:@"%@",[srcFileArr objectAtIndex:i]];
                    [self compareFolerAndCopy:childSrc tofolder:childNew];
                }
            }
            //boundle中文件存在，不是文件夹
            else
            {
                //                SVCLog(@" no =%@",[srcFileArr objectAtIndex:i]);
                [self copyFile:srcfolder tofile:newfolder file:[srcFileArr objectAtIndex:i]];
            }
            isDir = NO;
        }
    }
    
    return YES;
    
}


- (BOOL)copyFile:(NSString*)oldfolder tofile:(NSString*)newfolder file:(NSString*)fileName
{
    fileName = [fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableString *oldFile = [NSMutableString stringWithFormat:@"%@/",[[NSBundle mainBundle] bundlePath]];
    if (oldfolder != nil)
    {
        [oldFile appendFormat:@"%@/",oldfolder];
    }
    [oldFile appendFormat:@"%@",fileName];
    //    SVCLog(@"old = %@",oldFile);
    if(![[NSFileManager defaultManager] fileExistsAtPath:oldFile])
    {
        return NO;
    }
    NSMutableString *newFile = [NSMutableString stringWithFormat:@"%@/",[self getDocumentDirectory]];
    if (newfolder != nil)
    {
        [newFile appendFormat:@"%@/",newfolder];
    }
    [newFile appendFormat:@"%@",fileName];
    //    SVCLog(@"newFile = %@",newFile);
    
    if([[NSFileManager defaultManager] fileExistsAtPath:newFile])
    {
        [self deleteDocumentFile:newFile];
        //        SVCLog(@"file is exist");
    }
    
    NSError *error;
    if ([[NSFileManager defaultManager] copyItemAtPath:oldFile toPath:newFile error:&error])
    {
        return YES;
    }
    //    SVCLog(@"error:%@",[error description]);
    //    SVCLog(@"userInfo:%@",[error userInfo]);
    
    return NO;
}

- (NSString*)getDocumentDirectory
{
    return [NSHomeDirectory()
            stringByAppendingPathComponent:@"Documents"];
}

- (BOOL)deleteDocumentFile:(NSString*)fileName
{
    if ([[NSFileManager defaultManager] removeItemAtPath:fileName error:nil])
    {
        NSLog(@"delete %@ succ",fileName);
        return YES;
    }
    return NO;
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"SVCWallet"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
