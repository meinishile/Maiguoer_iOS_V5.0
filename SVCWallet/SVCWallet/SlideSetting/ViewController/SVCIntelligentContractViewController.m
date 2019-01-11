//
//  SVCIntelligentContractViewController.m
//  SVCWallet
//
//  Created by SVC on 2018/4/26.
//  Copyright © 2018年 SVCWallet. All rights reserved.
//

#import "SVCIntelligentContractViewController.h"

#import "SVCIntelligentContractCell.h"

#import "SVCIntelligentContractElement.h"

@interface SVCIntelligentContractViewController ()<UITableViewDelegate,UITableViewDataSource,SVCHomePageHttpRequestDelegate>
{
    SVCHomePageHttpRequest *homePageHttpRequest;// 网络请求
    UITableView *contractTableView;// 智能合约列表
    NSMutableArray *contractDataSource;// 智能合约列表数据源
}

/**
 * 空数据视图
 */
@property (nonatomic,strong) UIView *emptyDataSourceView;
@property (nonatomic,strong) UILabel *emptyTitleLabel;

@end

@implementation SVCIntelligentContractViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = Localized(@"intelligent.contract");
    self.view.backgroundColor = SVCV1B7Color;
    
    contractDataSource = [NSMutableArray array];
    
    homePageHttpRequest = [[SVCHomePageHttpRequest alloc] init];
    homePageHttpRequest.delegate = self;
    
    [self initIntelligentContractView];
    [self initEmptyView];
    
    
    [homePageHttpRequest loadIntelligentContractListInfoWithLastId:@"0"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}


#pragma mark - 智能合约列表获取接口回调
-(void)loadIntelligentContractListInfoWithResultBody:(NSDictionary *)resultBody
{
    [MBProgressHUD hideHUD];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [contractTableView.mj_header endRefreshing];
        [contractTableView.mj_footer endRefreshing];
    });
    
    //错误码
    NSString *resultCode= [[resultBody objectForKey:HTTP_FIELD_RESULT_CODE] stringValue];
    //获取服务器处理信息反馈
    NSString * resultMessage = [resultBody objectForKey:HTTP_FIELD_RESULT_MESSAGE];
    
    if ([resultCode isEqualToString:@"0"])
    {
        [MBProgressHUD showSuccess:resultMessage];
        
        NSDictionary *dataDic = [resultBody objectForKey:@"data"];
        NSMutableArray *currentDataSource = [dataDic objectForKey:@"list"];
        
        SVCIntelligentContractElement *currentElement = nil;
        for (NSDictionary *currentListDic in currentDataSource)
        {
            currentElement = [[SVCIntelligentContractElement alloc] init];
            currentElement.contractId = [currentListDic objectForKey:@"id"];
            currentElement.isDone = [currentListDic objectForKey:@"isDone"];
            currentElement.total = [currentListDic objectForKey:@"total"];
            currentElement.done = [currentListDic objectForKey:@"done"];
            currentElement.beDone = [currentListDic objectForKey:@"beDone"];
            currentElement.grant = [currentListDic objectForKey:@"grant"];
            currentElement.relatedDate = [currentListDic objectForKey:@"relatedDate"];
            currentElement.datetime = [currentListDic objectForKey:@"datetime"];
            [contractDataSource addObject:currentElement];
        }
        
        if (contractDataSource.count==0)
        {
            self.emptyDataSourceView.hidden = NO;
        }
        else
        {
            self.emptyDataSourceView.hidden = YES;
        }
        
        [contractTableView reloadData];
    }
    else
    {
        [MBProgressHUD showError:resultMessage];
    }
}

-(void)loadIntelligentContractListInfoFailed
{
    [MBProgressHUD hideHUD];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [contractTableView.mj_header endRefreshing];
        [contractTableView.mj_footer endRefreshing];
    });
    [MBProgressHUD showError:Localized(@"networkError")];
}

#pragma mark - 初始化智能合约列表
-(void)initIntelligentContractView
{
    contractTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight) style:UITableViewStylePlain];
    contractTableView.delegate = self;
    contractTableView.dataSource = self;
    contractTableView.separatorColor = [UIColor clearColor];
    contractTableView.backgroundColor = SVCV1B7Color;
    contractTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    contractTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerLoadMore)];
    [self.view addSubview:contractTableView];
}

-(void)initEmptyView
{
    self.emptyDataSourceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SVC_ScreenWidth, SVC_ScreenHeight)];
    [contractTableView addSubview:self.emptyDataSourceView];
    self.emptyDataSourceView.hidden = YES;
    
    UIImageView *emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SVC_ScreenWidth/2-35, 120, 70, 69)];
    emptyImageView.image = [UIImage imageNamed:@"homepage_anonymous"];
    [self.emptyDataSourceView addSubview:emptyImageView];
    
    self.emptyTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(emptyImageView.frame)+15, SVC_ScreenWidth-100, 15)];
    self.emptyTitleLabel.text = Localized(@"no.smart.contract.record");
    self.emptyTitleLabel.textColor = SVCV1T3Color;
    self.emptyTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyTitleLabel.font = [UIFont systemFontOfSize:14];
    [self.emptyDataSourceView addSubview:self.emptyTitleLabel];
}

#pragma mark - 上拉加载&&下拉刷新
// 下拉刷新
-(void)headerRefresh
{
    [contractDataSource removeAllObjects];
    [homePageHttpRequest loadIntelligentContractListInfoWithLastId:@"0"];
}

// 上拉加载
-(void)footerLoadMore
{
    if (contractDataSource.count>0)
    {
        SVCIntelligentContractElement *currentElement = [[SVCIntelligentContractElement alloc] init];
        currentElement = contractDataSource[contractDataSource.count-1];
        [homePageHttpRequest loadIntelligentContractListInfoWithLastId:currentElement.contractId];
    }
}

#pragma mark - UITableViewDatasourc
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return contractDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat:@"%ld",indexPath.row];
    SVCIntelligentContractCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil)
    {
        cell = [[SVCIntelligentContractCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (contractDataSource.count>indexPath.row)
    {
        SVCIntelligentContractElement *currentElement = [[SVCIntelligentContractElement alloc] init];
        currentElement = contractDataSource[indexPath.row];
        cell.targetIntelligentContractElement = currentElement;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
}

@end
