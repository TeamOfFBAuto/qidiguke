//
//  IndustryNewsController.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "IndustryNewsController.h"
#import "IndustryNewsModel.h"
#import "IndustryNewsCell.h"
#import "IndustryNewsDetailViewController.h"

@interface IndustryNewsController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    ///数据存放
    NSMutableArray * data_array;
    PullTableView * _myTableView;
    ///当前页
    int currentPage;
}
@end

@implementation IndustryNewsController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.aTitle = @"业界动态";
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    data_array = [NSMutableArray array];
    currentPage = 1;
    
    _myTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.pullDelegate = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.view addSubview:_myTableView];
    _myTableView.pullTableIsRefreshing = YES;
    
    
    [self getIndustryNewsDataWithPage:currentPage];
}

#pragma mark - 请求数据方法
-(void)getIndustryNewsDataWithPage:(int)page
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"pageSize":@"20",@"page":@"1"};
    
    [AFRequestService responseData:INDUSTRY_NEWS_URL andparameters:parameters andResponseData:^(id responseData) {
        
        [self endPull];
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            if (page == 1) {
                [data_array removeAllObjects];
            }
            
            if (page > [[dict objectForKey:@"pageCount"] intValue])
            {
                currentPage = 1;
                [SNTools showMBProgressWithText:@"没有更多数据了" addToView:self.view];            
                
                return;
            }
            
            NSArray * array = [dict objectForKey:@"dongtailist"];
            
            for (NSDictionary * dic in array)
            {
                IndustryNewsModel * model = [[IndustryNewsModel alloc] initWithDic:dic];
                [data_array addObject:model];
            }
            
            [_myTableView reloadData];
        }
    }];
    
}


#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    IndustryNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"IndustryNewsCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    IndustryNewsModel * model = [data_array objectAtIndex:indexPath.row];
    
    [cell setInfoWith:model];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IndustryNewsModel * model = [data_array objectAtIndex:indexPath.row];
    IndustryNewsDetailViewController * detail = [[IndustryNewsDetailViewController alloc] init];
    detail.theId = model.dongtaiId;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self getIndustryNewsDataWithPage:currentPage];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage++;
    [self getIndustryNewsDataWithPage:currentPage];
}
- (void)endPull{
    _myTableView.pullTableIsLoadingMore = NO;
    _myTableView.pullTableIsRefreshing = NO;
    _myTableView.pullLastRefreshDate = [NSDate date];
}

@end

















