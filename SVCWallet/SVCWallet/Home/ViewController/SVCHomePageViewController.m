//
//  SVCHomePageViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/3/1.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCHomePageViewController.h"

#import "SVCManagementWalletViewController.h"// 管理钱包-修改密码
#import "SVCTermsUseViewController.h"// 使用条款
#import "SVCAboutWeViewController.h"// 关于我们
#import "SVCLanguageSwitchViewController.h"// 语言切换
#import "SVCTwoLevelPwdSettingViewController.h"// PIN设置
#import "SVCTwoLevelPwdModifyViewController.h"// 修改PIN密码
#import "SVCIntelligentContractViewController.h"// 智能合约

#import "SVCSendMainViewController.h"// 发送主界面
#import "SVCReceiveMainViewController.h"// 接收主界面
#import "SVCScanViewController.h"// 扫描界面

#import "SVCHomePageCell.h"

#import "SVCHomePageTradeElement.h"

#import "WJSlideMenu.h"
#import "SVCSegButton.h"

@interface SVCHomePageViewController ()<UITableViewDataSource,UITableViewDelegate,WJSlideMenuDelegate,SVCHomePageHttpRequestDelegate>
{
    SVCHomePageHttpRequest *homePageHttpRequest;// 网络请求
    
    UILabel *accountNameLabel;// 账户名称
    UILabel *balanceLabel;// 余额
    
    UITableView *homePageTableView;// 首页列表
    NSMutableArray *homePageDataSource;// 数据源
    
    UIView *homePageHeaderView;// 表头
    
    UILabel *navTitleLabel;
    BOOL isAllSeg;
    BOOL isSendSeg;
    BOOL isReceiveSeg;
    
    
    UILabel *pinStatusTitleLabel;
}
@property (nonatomic,weak)WJSlideMenu *menu;
@property (nonatomic,weak)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;


@property (nonatomic,weak)UITableView *slideTableView;

@property (nonatomic, strong) SVCSegButton *allSegBtn; // 全部切换按钮
@property (nonatomic, strong) SVCSegButton *sendSegBtn; // 发送切换按钮
@property (nonatomic, strong) SVCSegButton *receiveSegBtn; // 接收切换按钮

/**
 * 空数据视图
 */
@property (nonatomic,strong) UIView *emptyDataSourceView;
@property (nonatomic,strong) UILabel *emptyTitleLabel;

@end

@implementation SVCHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = SVCV1B7Color;
    
    isAllSeg = YES;
    isSendSeg = NO;
    isReceiveSeg = NO;
    
    homePageDataSource = [NSMutableArray array];
    
    homePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageHttpRequest.delegate = self;
    
    [self initSlideView];
    [self initHomePageView];
    [self initEmptyView];
    [MBProgressHUD showMessage:Localized(@"loading")];
//    [homePageHttpRequest loadHomePageTransactionLogWithLastId:@"0"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = SVCV1B7Color;
    self.navigationController.navigationBar.hidden = YES;
    
    if (isAllSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionLogWithLastId:@"0"];
    }
    if (isSendSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionSendLogWithLastId:@"0"];
    }
    if (isReceiveSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionReceiveLogWithLastId:@"0"];
    }
    [self.slideTableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - 登出接口回调
-(void)logoutWithResultBody:(NSDictionary *)resultBody
{
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
//        [defaults setObject:@"" forKey:SVC_LOGIN_USERNAME];// 存储当前用户账号
        [defaults setObject:@"" forKey:SVC_LOGIN_ADDRESS];// 存储当前用户地址
        [defaults setObject:@"0" forKey:SVC_LOGIN_STATUS];//当前登录系统的用户登录状态。0 未登录  1 已登录
        [defaults setObject:@"" forKey:SVC_LOGIN_USER_TOKEN_ID];
        [defaults setObject:@"0" forKey:SVC_LOGIN_ACCOUNTMONEY];
        [defaults setObject:@"0" forKey:SVC_PIN_SETTING_STATUS];
        [defaults synchronize];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)logoutFailed
{
    
}

#pragma mark - 交易日志信息获取接口回调
-(void)loadHomePageTransactionLogWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        NSDictionary *dataDic = [resultBody objectForKey:@"data"];
        
        NSString * balance = [NSString stringWithFormat:@"%@",dataDic[@"balance"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:balance forKey:SVC_LOGIN_ACCOUNTMONEY];// 存储当前用户账户余额
        [defaults synchronize];
        
        NSString *balanceStr = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ACCOUNTMONEY];
        if ([balanceStr isEqualToString:@""] || balanceStr == NULL || balanceStr == nil)
        {
            balanceStr = @"0.00";
        }
        balanceLabel.text = balanceStr;
        
        NSMutableArray *currentLogArray = [dataDic objectForKey:@"logs"];
        SVCHomePageTradeElement *currentHomePageElement = nil;
        for (NSDictionary *currentLogDic in currentLogArray)
        {
            currentHomePageElement = [[SVCHomePageTradeElement alloc] init];
            currentHomePageElement.tradeId = [NSString stringWithFormat:@"%@",currentLogDic[@"id"]];
            currentHomePageElement.fromusername = [NSString stringWithFormat:@"%@",currentLogDic[@"fromusername"]];
            currentHomePageElement.fromaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"fromaddress"]];
            currentHomePageElement.tousername = [NSString stringWithFormat:@"%@",currentLogDic[@"tousername"]];
            currentHomePageElement.toaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"toaddress"]];
            currentHomePageElement.changeType = [NSString stringWithFormat:@"%@",currentLogDic[@"changeType"]];
            currentHomePageElement.changeAmount = [NSString stringWithFormat:@"%@",currentLogDic[@"changeAmount"]];
            currentHomePageElement.changeFee = [NSString stringWithFormat:@"%@",currentLogDic[@"changeFee"]];
            currentHomePageElement.changeTotal = [NSString stringWithFormat:@"%@",currentLogDic[@"changeTotal"]];
            currentHomePageElement.datetime = [NSString stringWithFormat:@"%@",currentLogDic[@"datetime"]];
            currentHomePageElement.noteInfo = [NSString stringWithFormat:@"%@",currentLogDic[@"comment"]];
            [homePageDataSource addObject:currentHomePageElement];
        }
        
        if (homePageDataSource.count==0)
        {
            self.emptyDataSourceView.hidden = NO;
            self.emptyTitleLabel.text = Localized(@"no.sending.receiving.records");
        }
        else
        {
            self.emptyDataSourceView.hidden = YES;
        }
        [homePageTableView reloadData];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)loadHomePageTransactionLogFailed
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
     [MBProgressHUD showError:Localized(@"networkError")];
}

#pragma mark - 发送日志接口回调
-(void)loadHomePageTransactionSendLogWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        NSDictionary *dataDic = [resultBody objectForKey:@"data"];
        
        NSString * balance = [NSString stringWithFormat:@"%@",dataDic[@"balance"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:balance forKey:SVC_LOGIN_ACCOUNTMONEY];// 存储当前用户账户余额
        [defaults synchronize];
        
        NSString *balanceStr = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ACCOUNTMONEY];
        if ([balanceStr isEqualToString:@""] || balanceStr == NULL || balanceStr == nil)
        {
            balanceStr = @"0.00";
        }
        balanceLabel.text = balanceStr;
        
        NSMutableArray *currentLogArray = [dataDic objectForKey:@"logs"];
        SVCHomePageTradeElement *currentHomePageElement = nil;
        for (NSDictionary *currentLogDic in currentLogArray)
        {
            currentHomePageElement = [[SVCHomePageTradeElement alloc] init];
            currentHomePageElement.tradeId = [NSString stringWithFormat:@"%@",currentLogDic[@"id"]];
            currentHomePageElement.fromusername = [NSString stringWithFormat:@"%@",currentLogDic[@"fromusername"]];
            currentHomePageElement.fromaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"fromaddress"]];
            currentHomePageElement.tousername = [NSString stringWithFormat:@"%@",currentLogDic[@"tousername"]];
            currentHomePageElement.toaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"toaddress"]];
            currentHomePageElement.changeType = [NSString stringWithFormat:@"%@",currentLogDic[@"changeType"]];
            currentHomePageElement.changeAmount = [NSString stringWithFormat:@"%@",currentLogDic[@"changeAmount"]];
            currentHomePageElement.changeFee = [NSString stringWithFormat:@"%@",currentLogDic[@"changeFee"]];
            currentHomePageElement.changeTotal = [NSString stringWithFormat:@"%@",currentLogDic[@"changeTotal"]];
            currentHomePageElement.datetime = [NSString stringWithFormat:@"%@",currentLogDic[@"datetime"]];
            currentHomePageElement.noteInfo = [NSString stringWithFormat:@"%@",currentLogDic[@"comment"]];
            [homePageDataSource addObject:currentHomePageElement];
        }
        if (homePageDataSource.count==0)
        {
            self.emptyDataSourceView.hidden = NO;
            self.emptyTitleLabel.text =Localized(@"no.send.record");
        }
        else
        {
            self.emptyDataSourceView.hidden = YES;
        }
        [homePageTableView reloadData];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)loadHomePageTransactionSendLogFailed
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
    [MBProgressHUD showError:Localized(@"networkError")];
}

#pragma mark -接收日志接口回调
-(void)loadHomePageTransactionReceiveLogWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        NSDictionary *dataDic = [resultBody objectForKey:@"data"];
        
        NSString * balance = [NSString stringWithFormat:@"%@",dataDic[@"balance"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:balance forKey:SVC_LOGIN_ACCOUNTMONEY];// 存储当前用户账户余额
        [defaults synchronize];
        
        NSString *balanceStr = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ACCOUNTMONEY];
        if ([balanceStr isEqualToString:@""] || balanceStr == NULL || balanceStr == nil)
        {
            balanceStr = @"0.00";
        }
        balanceLabel.text = balanceStr;
        
        NSMutableArray *currentLogArray = [dataDic objectForKey:@"logs"];
        SVCHomePageTradeElement *currentHomePageElement = nil;
        for (NSDictionary *currentLogDic in currentLogArray)
        {
            currentHomePageElement = [[SVCHomePageTradeElement alloc] init];
            currentHomePageElement.tradeId = [NSString stringWithFormat:@"%@",currentLogDic[@"id"]];
            currentHomePageElement.fromusername = [NSString stringWithFormat:@"%@",currentLogDic[@"fromusername"]];
            currentHomePageElement.fromaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"fromaddress"]];
            currentHomePageElement.tousername = [NSString stringWithFormat:@"%@",currentLogDic[@"tousername"]];
            currentHomePageElement.toaddress = [NSString stringWithFormat:@"%@",currentLogDic[@"toaddress"]];
            currentHomePageElement.changeType = [NSString stringWithFormat:@"%@",currentLogDic[@"changeType"]];
            currentHomePageElement.changeAmount = [NSString stringWithFormat:@"%@",currentLogDic[@"changeAmount"]];
            currentHomePageElement.changeFee = [NSString stringWithFormat:@"%@",currentLogDic[@"changeFee"]];
            currentHomePageElement.changeTotal = [NSString stringWithFormat:@"%@",currentLogDic[@"changeTotal"]];
            currentHomePageElement.datetime = [NSString stringWithFormat:@"%@",currentLogDic[@"datetime"]];
            currentHomePageElement.noteInfo = [NSString stringWithFormat:@"%@",currentLogDic[@"comment"]];
            [homePageDataSource addObject:currentHomePageElement];
        }
        if (homePageDataSource.count==0)
        {
            self.emptyDataSourceView.hidden = NO;
            self.emptyTitleLabel.text = Localized(@"no.receiving.record");
        }
        else
        {
            self.emptyDataSourceView.hidden = YES;
        }
        [homePageTableView reloadData];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)loadHomePageTransactionReceiveLogFailed
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [homePageTableView.mj_header endRefreshing];
        [homePageTableView.mj_footer endRefreshing];
    });
    [MBProgressHUD showError:Localized(@"networkError")];
}

#pragma mark - 创建界面
-(void)initSlideView
{
    // ******************** 添加控件 ****************************

    // 创建slideMenu
    CGRect frame = self.view.bounds;
    frame.origin.y -= 20;
    WJSlideMenu *menu = [[WJSlideMenu alloc]initWithFrame:frame];
    menu.delegate = self;
//    menu.backgroundColor = [UIColor redColor];
    [self.view addSubview:menu];
    self.menu = menu;
    // ******************** 根据自身需求布局页面 *******************
    
    // 可选设置
    menu.leftMovex = 240; //不设置默认是200
    menu.rightMovex = 220;//不设置默认是200
    
    // 根据需求自定义修改navLeftBtn
    [self.menu.navLeftBtn setImage:[UIImage imageNamed:@"homepage_nav_settings"] forState:UIControlStateNormal];
    self.menu.navLeftBtn.backgroundColor = [UIColor clearColor];
//    self.menu.navLeftBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 20, 13, 20);
    
    // 根据需求自定义修改navRigthBtn
    [self.menu.navRigthBtn setImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
    self.menu.navRigthBtn.backgroundColor = [UIColor clearColor];
//    self.menu.navRigthBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 20, 13, 20);
    
    // 根据需求自定义修改navBgView titleView 等等
    self.menu.navBgView.backgroundColor = [UIColor clearColor];
    self.menu.titleView.backgroundColor = [UIColor clearColor];
    self.menu.navRigthBtn.backgroundColor = [UIColor clearColor];
    self.menu.mainView.backgroundColor = SVCV1B7Color;
    
    //  比如添加一个titleView的文字
    navTitleLabel = [[UILabel alloc]initWithFrame:self.menu.titleView.bounds];
    navTitleLabel.textAlignment = NSTextAlignmentCenter;
    navTitleLabel.textColor = [UIColor whiteColor];
    navTitleLabel.text = @"";
    [self.menu.titleView addSubview:navTitleLabel];
    
    
    
    
    // 创建TableView
    CGRect leftFrme = self.menu.leftMenuView.bounds;
    
    UIImageView *tableBgView = [[UIImageView alloc] initWithFrame:leftFrme];
    tableBgView.image = [UIImage imageNamed:@"side_bg"];
    [self.menu.leftMenuView addSubview:tableBgView];
    
    //    leftFrme.origin.y = 100;
    UITableView *tableView = [[UITableView alloc]initWithFrame:leftFrme style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 230)];
    headerView.backgroundColor = [UIColor clearColor];
    tableView.tableHeaderView = headerView;
    
    UIView *blackButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 200)];
    blackButtomView.backgroundColor = [UIColor clearColor];
    [headerView addSubview:blackButtomView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(120-66, 64, 132, 102)];
    logoImageView.image = [UIImage imageNamed:@"side_logo"];
    [blackButtomView addSubview:logoImageView];
    
    self.slideTableView = tableView;
    
    [self.menu.leftMenuView addSubview:self.slideTableView];
    
    // 创建dataSource
    NSArray *array = @[Localized(@"wallet.manager"),Localized(@"intelligent.contract"),Localized(@"PIN.set"),Localized(@"terms.use"),@"Language",Localized(@"about.us"),Localized(@"log.out")];
    [self.dataSource addObjectsFromArray:array];
}

-(void)initHomePageView
{
    // 创建TableView
    CGRect leftFrme = self.menu.mainView.bounds;
    leftFrme.origin.y = 64;
    leftFrme.size.height -= 64;
    homePageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight) style:UITableViewStylePlain];
    homePageTableView.delegate = self;
    homePageTableView.dataSource = self;
    homePageTableView.separatorColor = [UIColor clearColor];
    homePageTableView.backgroundColor = [UIColor clearColor];
    homePageTableView.estimatedRowHeight = 0;
    homePageTableView.estimatedSectionHeaderHeight = 0;
    homePageTableView.estimatedSectionFooterHeight = 0;
    
    UIImageView *logoImageBgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    logoImageBgView.image = [UIImage imageNamed:@"bg"];
    [self.menu.mainView addSubview:logoImageBgView];
    [self.menu.mainView addSubview:homePageTableView];
    
    [self.menu.mainView bringSubviewToFront:self.menu.navBgView];
    
    if (iPhoneX)
    {
        homePageTableView.frame = CGRectMake(0, 20, SVC_ScreenWidth, SVC_ScreenHeight-20);
    }
    
    homePageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    homePageTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore)];
    
    
    homePageHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, 305)];
    homePageHeaderView.backgroundColor = SVCV1B7Color;
    homePageTableView.tableHeaderView = homePageHeaderView;
//    [self.menu.mainView addSubview:homePageHeaderView];
    
    CGFloat loginBgHeight = (211.0f/375.0f)*SVC_ScreenWidth;
    UIImageView *loginBgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, 305)];
    loginBgImageView.image = [UIImage imageNamed:@"homepage_bg"];
    [homePageHeaderView addSubview:loginBgImageView];
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake((SVC_ScreenWidth-60.0)/2.0, 87, 60, 60)];
    logoImageView.image = [UIImage imageNamed:@"homepage_logo"];
    [homePageHeaderView addSubview:logoImageView];
    
    accountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(logoImageView.frame)+10, SVC_ScreenWidth-40, 16)];
    accountNameLabel.textColor = [UIColor whiteColor];
    accountNameLabel.textAlignment = NSTextAlignmentCenter;
    accountNameLabel.font = [UIFont systemFontOfSize:16];
    [homePageHeaderView addSubview:accountNameLabel];
    accountNameLabel.text = [SVCMyProfileManager getUsername];
    
    
    NSString *balance = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_LOGIN_ACCOUNTMONEY];
    if ([balance isEqualToString:@""] || balance == NULL || balance == nil)
    {
        balance = @"0.00";
    }
    balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(accountNameLabel.frame)+30, SVC_ScreenWidth-40, 29)];
    balanceLabel.textColor = SVCV1T7Color;
    balanceLabel.textAlignment = NSTextAlignmentCenter;
    balanceLabel.font = [UIFont boldSystemFontOfSize:29];
    [homePageHeaderView addSubview:balanceLabel];
    balanceLabel.text = balance;
    
    
    UIView *blueButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, 232, SVC_ScreenWidth, 73)];
    blueButtomView.backgroundColor = [UIColor clearColor];
    [homePageHeaderView addSubview:blueButtomView];
    
    UIImageView *sendImageView = [[UIImageView alloc] init];
    sendImageView.image = [UIImage imageNamed:@"homepage_send"];
    [blueButtomView addSubview:sendImageView];
    
    UILabel *sendLabel = [[UILabel alloc] init];
    sendLabel.text = Localized(@"send");
    sendLabel.textColor = [UIColor whiteColor];
    sendLabel.textAlignment = NSTextAlignmentLeft;
    sendLabel.font = [UIFont systemFontOfSize:17];
    [blueButtomView addSubview:sendLabel];
    CGRect rect1 = [sendLabel.text boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    sendImageView.frame = CGRectMake(SVC_ScreenWidth/4-(37+rect1.size.width+20)/2, 22, 37, 37);
    sendLabel.frame = CGRectMake(CGRectGetMaxX(sendImageView.frame)+20, 30, rect1.size.width, 17);
    
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sendButton.frame = CGRectMake(0, 0, SVC_ScreenWidth/2, 73);
    [sendButton addTarget:self action:@selector(sendClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [blueButtomView addSubview:sendButton];
    
    UIButton *receiveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    receiveButton.frame = CGRectMake(SVC_ScreenWidth/2, 0, SVC_ScreenWidth/2, 73);
    [receiveButton addTarget:self action:@selector(receiveClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [blueButtomView addSubview:receiveButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/2-0.5, 16, 1, 41)];
    lineView.backgroundColor = [UIColor whiteColor];
    [blueButtomView addSubview:lineView];
    
    UIImageView *receiveImageView = [[UIImageView alloc] init];
    receiveImageView.image = [UIImage imageNamed:@"homepage_receive"];
    [blueButtomView addSubview:receiveImageView];
    
    UILabel *receiveLabel = [[UILabel alloc] init];
    receiveLabel.text = Localized(@"receive");
    receiveLabel.textColor = [UIColor whiteColor];
    receiveLabel.textAlignment = NSTextAlignmentLeft;
    receiveLabel.font = [UIFont systemFontOfSize:17];
    [blueButtomView addSubview:receiveLabel];
    
    CGRect rect2 = [receiveLabel.text boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    
    receiveImageView.frame = CGRectMake(SVC_ScreenWidth/4-(37+rect2.size.width+20)/2+SVC_ScreenWidth/2, 22, 37, 37);
    receiveLabel.frame = CGRectMake(CGRectGetMaxX(receiveImageView.frame)+20, 30, rect2.size.width, 17);
    
    self.menu.translucentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.menu.translucentView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.menu.translucentView.hidden = YES;
    [self.menu.mainView addSubview:self.menu.translucentView];
    
}

-(void)initEmptyView
{
    self.emptyDataSourceView = [[UIView alloc] initWithFrame:CGRectMake(0, 305, SVC_ScreenWidth, SVC_ScreenHeight-305)];
//    self.emptyDataSourceView.backgroundColor = SVCV1B8Color;
    [homePageTableView addSubview:self.emptyDataSourceView];
    self.emptyDataSourceView.hidden = YES;
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/2-35, 80, 70, 69)];
    emptyImageView.image = [UIImage imageNamed:@"homepage_anonymous"];
    [self.emptyDataSourceView addSubview:emptyImageView];
    
    self.emptyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(emptyImageView.frame)+15, SVC_ScreenWidth-100, 15)];
    self.emptyTitleLabel.text = Localized(@"no.sending.receiving.records");
    self.emptyTitleLabel.textColor = SVCV1T3Color;
    self.emptyTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.emptyDataSourceView addSubview:self.emptyTitleLabel];
}


#pragma mark - action

-(void)allSelect:(SVCSegButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
    }else
    {
        sender.selected = YES;
        self.sendSegBtn.selected = NO;
        self.receiveSegBtn.selected = NO;
        isAllSeg = YES;
        isSendSeg = NO;
        isReceiveSeg = NO;
//        [homePageTableView setContentOffset:CGPointMake(0,109+125) animated:YES];
        
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionLogWithLastId:@"0"];
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [homePageTableView reloadData];
    }
}

-(void)sendSelect:(SVCSegButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
    }else
    {
        sender.selected = YES;
        self.allSegBtn.selected = NO;
        self.receiveSegBtn.selected = NO;
        
        isAllSeg = NO;
        isSendSeg = YES;
        isReceiveSeg = NO;
        
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionSendLogWithLastId:@"0"];
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [homePageTableView reloadData];
    }
    
}

-(void)receiveSelect:(SVCSegButton *)sender
{
    if (sender.selected == YES) {
        sender.selected = NO;
    }else
    {
        sender.selected = YES;
        self.allSegBtn.selected = NO;
        self.sendSegBtn.selected = NO;
        
        isAllSeg = NO;
        isSendSeg = NO;
        isReceiveSeg = YES;
        
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionReceiveLogWithLastId:@"0"];
        NSIndexPath* indexPat = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPat atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [homePageTableView reloadData];
    }
}

-(void)sendClickEvent
{
    SVCSendMainViewController *sendMainVc = [[SVCSendMainViewController alloc] init];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:sendMainVc animated:YES];
}

-(void)receiveClickEvent
{
    SVCReceiveMainViewController *receiveMainVc = [[SVCReceiveMainViewController alloc] init];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:receiveMainVc animated:YES];
}

#pragma mark - 上拉加载&&下拉刷新
// 下拉刷新
-(void)headerRefresh
{
    if (isAllSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionLogWithLastId:@"0"];
    }
    if (isSendSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionSendLogWithLastId:@"0"];
    }
    if (isReceiveSeg == YES)
    {
        [homePageDataSource removeAllObjects];
        [homePageHttpRequest loadHomePageTransactionReceiveLogWithLastId:@"0"];
    }
}

// 上拉加载
-(void)footerLoadMore
{
    if (homePageDataSource.count>0)
    {
        if (isAllSeg == YES)
        {
            SVCHomePageTradeElement *allElement = [[SVCHomePageTradeElement alloc] init];
            allElement = homePageDataSource[homePageDataSource.count-1];
            [homePageHttpRequest loadHomePageTransactionLogWithLastId:allElement.tradeId];
        }
        if (isSendSeg == YES)
        {
            SVCHomePageTradeElement *sendElement = [[SVCHomePageTradeElement alloc] init];
            sendElement = homePageDataSource[homePageDataSource.count-1];
            [homePageHttpRequest loadHomePageTransactionSendLogWithLastId:sendElement.tradeId];
        }
        if (isReceiveSeg == YES)
        {
            SVCHomePageTradeElement *receiveElement = [[SVCHomePageTradeElement alloc] init];
            receiveElement = homePageDataSource[homePageDataSource.count-1];
            [homePageHttpRequest loadHomePageTransactionReceiveLogWithLastId:receiveElement.tradeId];
        }
    }
    
}



#pragma mark - UITableView DataSource && Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == homePageTableView)
    {
        return homePageDataSource.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == homePageTableView)
    {
        NSString *cellID = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        SVCHomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[SVCHomePageCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        if (homePageDataSource.count>indexPath.row)
        {
            SVCHomePageTradeElement *currentHomePageElement = homePageDataSource[indexPath.row];
            cell.targetHomePageTradeElement = currentHomePageElement;
        }
        
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }
    else
    {
        static NSString *cellID = @"cellID";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.backgroundColor = [UIColor clearColor];
            switch (indexPath.row)
            {
                case 0:
                {
                    UIImageView *manageWalletImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    manageWalletImageView.image = [UIImage imageNamed:@"side_icon01"];
                    [cell addSubview:manageWalletImageView];
                    
                    UILabel *manageWalletLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(manageWalletImageView.frame)+16, 19, 180, 15)];
                    manageWalletLabel.text = Localized(@"wallet.manager");
                    manageWalletLabel.textColor = [UIColor whiteColor];
                    manageWalletLabel.textAlignment = NSTextAlignmentLeft;
                    manageWalletLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:manageWalletLabel];
                }
                    break;
                case 1:
                {
                    UIImageView *intelligentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    intelligentImageView.image = [UIImage imageNamed:@"side_icon07"];
                    [cell addSubview:intelligentImageView];
                    
                    UILabel *intelligentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(intelligentImageView.frame)+16, 19, 180, 15)];
                    intelligentLabel.text = Localized(@"intelligent.contract");
                    intelligentLabel.textColor = [UIColor whiteColor];
                    intelligentLabel.textAlignment = NSTextAlignmentLeft;
                    intelligentLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:intelligentLabel];
                }
                    break;
                case 2:
                {
                    UIImageView *pinImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    pinImageView.image = [UIImage imageNamed:@"side_icon06"];
                    [cell addSubview:pinImageView];
                    
                    pinStatusTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pinImageView.frame)+16, 19, 120, 15)];
                    pinStatusTitleLabel.textColor = [UIColor whiteColor];
                    pinStatusTitleLabel.textAlignment = NSTextAlignmentLeft;
                    pinStatusTitleLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:pinStatusTitleLabel];
                }
                    break;
                case 3:
                {
                    UIImageView *termsImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    termsImageView.image = [UIImage imageNamed:@"side_icon02"];
                    [cell addSubview:termsImageView];
                    
                    UILabel *termsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(termsImageView.frame)+16, 19, 120, 15)];
                    termsLabel.text = Localized(@"terms.use");
                    termsLabel.textColor = [UIColor whiteColor];
                    termsLabel.textAlignment = NSTextAlignmentLeft;
                    termsLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:termsLabel];
                }
                    break;
                case 4:
                {
                    UIImageView *aboutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    aboutImageView.image = [UIImage imageNamed:@"side_icon05"];
                    [cell addSubview:aboutImageView];
                    
                    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aboutImageView.frame)+16, 19, 120, 15)];
                    aboutLabel.text = @"Language";
                    aboutLabel.textColor = [UIColor whiteColor];
                    aboutLabel.textAlignment = NSTextAlignmentLeft;
                    aboutLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:aboutLabel];
                }
                    break;
                case 5:
                {
                    UIImageView *aboutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    aboutImageView.image = [UIImage imageNamed:@"side_icon03"];
                    [cell addSubview:aboutImageView];
                    
                    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aboutImageView.frame)+16, 19, 120, 15)];
                    aboutLabel.text = Localized(@"about.us");
                    aboutLabel.textColor = [UIColor whiteColor];
                    aboutLabel.textAlignment = NSTextAlignmentLeft;
                    aboutLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:aboutLabel];
                }
                    break;
                default:
                {
                    UIImageView *logoutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 16, 20, 20)];
                    logoutImageView.image = [UIImage imageNamed:@"side_icon04"];
                    [cell addSubview:logoutImageView];
                    
                    UILabel *logoutLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoutImageView.frame)+16, 19, 120, 15)];
                    logoutLabel.text = Localized(@"log.out");
                    logoutLabel.textColor = [UIColor whiteColor];
                    logoutLabel.textAlignment = NSTextAlignmentLeft;
                    logoutLabel.font = [UIFont systemFontOfSize:15];
                    [cell addSubview:logoutLabel];
                }
                    break;
            }
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 2)
        {
            NSString * currentPINStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_PIN_SETTING_STATUS];
            if ([currentPINStatus isEqualToString:@""] || currentPINStatus == NULL || currentPINStatus == nil || [currentPINStatus isEqualToString:@"(null)"]  || [currentPINStatus isEqualToString:@"null"])
            {
                currentPINStatus = @"";
            }
            
            if (currentPINStatus.intValue==1)// 1 已设置   0 未设置
            {
                pinStatusTitleLabel.text = Localized(@"Modify.PIN");
            }
            else
            {
                pinStatusTitleLabel.text = Localized(@"PIN.set");
            }
        }
        
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == homePageTableView)
    {
        return 155;
    }
    else
    {
        return 54;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == homePageTableView)
    {
        
    }
    else
    {
        switch (indexPath.row)
        {
            case 0:// 管理钱包
            {
                SVCManagementWalletViewController *managementWalletVc = [[SVCManagementWalletViewController alloc] init];
                UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
                temporaryBarButtonItem.title = Localized(@"back");
                self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
                [self.navigationController pushViewController:managementWalletVc animated:YES];
                [self.menu closeLeftMenuView];
            }
                break;
            case 1:// 管理钱包
            {
                SVCIntelligentContractViewController *contractVc = [[SVCIntelligentContractViewController alloc] init];
                UIBarButtonItem *contractBarButtonItem = [[UIBarButtonItem alloc] init];
                contractBarButtonItem.title = Localized(@"back");
                self.navigationItem.backBarButtonItem = contractBarButtonItem;
                [self.navigationController pushViewController:contractVc animated:YES];
                [self.menu closeLeftMenuView];
            }
                break;
            case 2:// PIN设置
            {
                
                NSString * currentPINStatus = [[NSUserDefaults standardUserDefaults] objectForKey:SVC_PIN_SETTING_STATUS];
                if ([currentPINStatus isEqualToString:@""] || currentPINStatus == NULL || currentPINStatus == nil || [currentPINStatus isEqualToString:@"(null)"]  || [currentPINStatus isEqualToString:@"null"])
                {
                    currentPINStatus = @"";
                }
                
                if (currentPINStatus.intValue==1)// 1 已设置   0 未设置
                {
                    SVCTwoLevelPwdModifyViewController *modifyTwoLevelPwdVc = [[SVCTwoLevelPwdModifyViewController alloc] init];
                    UIBarButtonItem *modifyTwoLevelPwdBarButtonItem = [[UIBarButtonItem alloc] init];
                    modifyTwoLevelPwdBarButtonItem.title = Localized(@"back");
                    self.navigationItem.backBarButtonItem = modifyTwoLevelPwdBarButtonItem;
                    [self.navigationController pushViewController:modifyTwoLevelPwdVc animated:YES];
                }
                else
                {
                    SVCTwoLevelPwdSettingViewController *setTwoLevelPwdVc = [[SVCTwoLevelPwdSettingViewController alloc] init];
                    UIBarButtonItem *setTwoLevelPwdBarButtonItem = [[UIBarButtonItem alloc] init];
                    setTwoLevelPwdBarButtonItem.title = Localized(@"back");
                    self.navigationItem.backBarButtonItem = setTwoLevelPwdBarButtonItem;
                    [self.navigationController pushViewController:setTwoLevelPwdVc animated:YES];
                }
                
                [self.menu closeLeftMenuView];
            }
                break;
            case 3:
            {
                SVCTermsUseViewController *termsUseVc = [[SVCTermsUseViewController alloc] init];
                UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
                temporaryBarButtonItem.title = Localized(@"back");
                self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
                [self.navigationController pushViewController:termsUseVc animated:YES];
                [self.menu closeLeftMenuView];
            }
                break;
            case 4:
            {
                SVCLanguageSwitchViewController *languageVc = [[SVCLanguageSwitchViewController alloc] init];
                UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
                temporaryBarButtonItem.title = Localized(@"back");
                self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
                [self.navigationController pushViewController:languageVc animated:YES];
                [self.menu closeLeftMenuView];
            }
                break;
            case 5:
            {
                SVCAboutWeViewController *aboutWeVc = [[SVCAboutWeViewController alloc] init];
                UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
                temporaryBarButtonItem.title = Localized(@"back");
                self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
                [self.navigationController pushViewController:aboutWeVc animated:YES];
                [self.menu closeLeftMenuView];
            }
                break;
            default:
            {
                [homePageHttpRequest logout];
            }
                break;
        }
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == homePageTableView)
    {
        UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, 40)];
        sectionHeaderView.backgroundColor = SVCV1B6Color;
        
        UIView *whiteButtomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, 40)];
        whiteButtomView.backgroundColor = SVCV1B6Color;
        [sectionHeaderView addSubview:whiteButtomView];
        
        
//        self.allSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"all") withColor:SVCV1T1Color withFontSize:14 withItemNum:3];
        self.allSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"all") withBgColor:SVCV1B6Color withTitleColor:[UIColor whiteColor] withUnselectColor:Rgba(255,255,255,0.4) withLineColor:SVCV1B5Color withFontSize:14 withItemNum:3];
        self.allSegBtn.selected = isAllSeg;
        self.allSegBtn.enabled = !isAllSeg;
        [self.allSegBtn addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [whiteButtomView addSubview:self.allSegBtn];
        
//        self.sendSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/3, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"send") withColor:SVCV1T1Color withFontSize:14 withItemNum:3];
        self.sendSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/3, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"send") withBgColor:SVCV1B6Color withTitleColor:[UIColor whiteColor] withUnselectColor:Rgba(255,255,255,0.4) withLineColor:SVCV1B5Color withFontSize:14 withItemNum:3];
        self.sendSegBtn.selected = isSendSeg;
        self.sendSegBtn.enabled = !isSendSeg;
        [self.sendSegBtn addTarget:self action:@selector(sendSelect:) forControlEvents:UIControlEventTouchUpInside];
        [whiteButtomView addSubview:self.sendSegBtn];
        
//        self.receiveSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(SVC_ScreenWidth*2/3, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"receive") withColor:SVCV1T1Color withFontSize:14 withItemNum:3];
        self.receiveSegBtn = [[SVCSegButton alloc] initWithFrame:CGRectMake(SVC_ScreenWidth*2/3, 0, SVC_ScreenWidth/3, 40) withTitle:Localized(@"receive") withBgColor:SVCV1B6Color withTitleColor:[UIColor whiteColor] withUnselectColor:Rgba(255,255,255,0.4) withLineColor:SVCV1B5Color withFontSize:14 withItemNum:3];
        self.receiveSegBtn.selected = isReceiveSeg;
        self.receiveSegBtn.enabled = !isReceiveSeg;
        [self.receiveSegBtn addTarget:self action:@selector(receiveSelect:) forControlEvents:UIControlEventTouchUpInside];
        [whiteButtomView addSubview:self.receiveSegBtn];
        
        return sectionHeaderView;
    }
    else
    {
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == homePageTableView)
    {
        return 40;
    }
    else
    {
        return 0;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //该方法是当scrollView滑动时触发，因为UITableView继承自UIScrollView因此在这里也可以调用
    CGFloat sectionHeaderHeight = 305;//这个sectionHeaderHeight其实是section 的header到顶部的距离
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y>=0)
    {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        
        [self.menu.navLeftBtn setImage:[UIImage imageNamed:@"homepage_nav_settings"] forState:UIControlStateNormal];
        [self.menu.navRigthBtn setImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
        self.menu.navBgView.backgroundColor = [UIColor clearColor];
        self.menu.titleView.backgroundColor = [UIColor clearColor];
        navTitleLabel.text = @"";
    }
    else if (scrollView.contentOffset.y >= sectionHeaderHeight)
    {
        if (iPhoneX)
        {
            scrollView.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
        }
        else
        {
            scrollView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
        }
        
        [self.menu.navLeftBtn setImage:[UIImage imageNamed:@"homepage_nav_settings"] forState:UIControlStateNormal];
        [self.menu.navRigthBtn setImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
        self.menu.navBgView.backgroundColor = SVCV1B1Color;
        self.menu.titleView.backgroundColor = [UIColor clearColor];
        navTitleLabel.text = @"SVC";
    }

    
//    if (scrollView.contentOffset.y <= 305-64)
//    {
//        [self.menu.navLeftBtn setImage:[UIImage imageNamed:@"homepage_nav_settings"] forState:UIControlStateNormal];
//        [self.menu.navRigthBtn setImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
//        self.menu.navBgView.backgroundColor = [UIColor clearColor];
//        self.menu.titleView.backgroundColor = [UIColor clearColor];
//        navTitleLabel.text = @"";
//    }
//    else
//    {
//        [self.menu.navLeftBtn setImage:[UIImage imageNamed:@"homepage_nav_settings"] forState:UIControlStateNormal];
//        [self.menu.navRigthBtn setImage:[UIImage imageNamed:@"homepage_nav_scan"] forState:UIControlStateNormal];
//        self.menu.navBgView.backgroundColor = SVCV1B1Color;
//        self.menu.titleView.backgroundColor = [UIColor clearColor];
//        navTitleLabel.text = @"SVC";
//    }
}



#pragma mark - setter
// 懒加载
- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


#pragma mark -WJSlideMenuDelegate
-(void)enterScanningView
{
    SVCScanViewController *scanningVc = [[SVCScanViewController alloc] init];
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.title = Localized(@"back");
    self.navigationItem.backBarButtonItem = temporaryBarButtonItem;
    [self.navigationController pushViewController:scanningVc animated:YES];
}

@end
