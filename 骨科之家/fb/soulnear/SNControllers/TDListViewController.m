//
//  TDDetailViewController.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TDListViewController.h"
#import "TDListCell.h"
#import "TDDetailViewController.h"

@interface TDListViewController ()
{
    NSMutableArray * data_array;
    int currentPage;
}

@end

@implementation TDListViewController
@synthesize myTableView = _myTableView;
@synthesize typeId = _typeId;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aTitle = @"主题讨论";
    self.view.backgroundColor = [UIColor whiteColor];
    
    data_array = [NSMutableArray array];
    currentPage = 1;
    
    _myTableView = [[PullTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    _myTableView.pullDelegate = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.view addSubview:_myTableView];
    
    UIView * vvv = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    _myTableView.tableFooterView = vvv;
    
    [self getTopicDiscussListData];
}


#pragma mark -  数据请求
-(void)getTopicDiscussListData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"typeId":_typeId,@"pageSize":@"20",@"page":[NSString stringWithFormat:@"%d",currentPage]};
    
    [AFRequestService responseData:TOPIC_DISCUSS_LIST_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict -------  %@",dict);
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            if (currentPage == 1)
            {
                [data_array removeAllObjects];
            }
            
            if (data_array.count == [[dict objectForKey:@"recordCount"] intValue])
            {
                [SNTools showMBProgressWithText:@"没有更多数据了" addToView:self.view];
                
                return ;
            }
            
            NSArray * array = [dict objectForKey:@"zhutilist"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array)
                {
                    TDListModel * model = [[TDListModel alloc] initWithDic:dic];
                    [data_array addObject:model];
                }
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
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    TDListCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TDListCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setInfoWith:[data_array objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDListModel * model = [data_array objectAtIndex:indexPath.row];
    
    TDDetailViewController * detail = [[TDDetailViewController alloc] init];
    detail.info = model;
    [self.navigationController pushViewController:detail animated:YES];
}


#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self getTopicDiscussListData];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage++;
    [self getTopicDiscussListData];
}
- (void)endPull{
    _myTableView.pullTableIsLoadingMore = NO;
    _myTableView.pullTableIsRefreshing = NO;
    _myTableView.pullLastRefreshDate = [NSDate date];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
