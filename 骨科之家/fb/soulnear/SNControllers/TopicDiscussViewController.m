//
//  TopicDiscussViewController.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TopicDiscussViewController.h"
#import "TDListViewController.h"


@interface TopicDiscussViewController ()
{
    ///数据存储
    NSMutableArray * data_array;
    ///当前页数
    int currentPage;

}

@end

@implementation TopicDiscussViewController
@synthesize myTableView = _myTableView;


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
    
    [self getTopicDiscussData];
}


#pragma mark -  数据请求
-(void)getTopicDiscussData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"pageSize":@"20",@"page":[NSString stringWithFormat:@"%d",currentPage]};
    
    [AFRequestService responseData:TOPIC_DISCUSS_TYPE_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
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
            
            NSArray * array = [dict objectForKey:@"typelist"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array) {
                    [data_array addObject:dic];
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
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.text = [NSString _859ToUTF8:[[data_array objectAtIndex:indexPath.row] objectForKey:@"typeName"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * theID = [[data_array objectAtIndex:indexPath.row] objectForKey:@"typeId"];
    
    TDListViewController * detail = [[TDListViewController alloc] init];
    detail.typeId = theID;
    [self.navigationController pushViewController:detail animated:YES];
    
}


#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self getTopicDiscussData];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage++;
    [self getTopicDiscussData];
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
