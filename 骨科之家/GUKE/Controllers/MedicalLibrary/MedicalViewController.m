//
//  MedicalViewController.m
//  GUKE
//  病历库
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MedicalViewController.h"
#import "CreatMedicalViewController.h"
#import "BingLiListFeed.h"
#import "BinglilistModels.h"
#import "MedicalCell.h"
#import "LiuLanBingLiViewController.h"


@interface MedicalViewController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * data_array;
    int currentPage;
}

// 自定义导航栏
- (void)loadNavigation;
// 创建病历库列表
- (void)loadUITableView;
// "新建病历"按钮
- (void)loadNewInformationBtn;
@end

@implementation MedicalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    data_array = [NSMutableArray array];
    [self loadNavigation];
    [self loadUITableView];
    [self loadNewInformationBtn];
    [self layOutlist];
}

// 导航的设置
- (void)loadNavigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 4, 36, 36);
    
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 7, 160, 30)];
    loginLabel.text = @"病历库";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}

// 创建资料库列表
- (void)loadUITableView
{
    self.tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-50) style:UITableViewStylePlain with:Dragging_upLoadmore];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    [self.view addSubview:self.tableView];
    
}

// "新建资料"按钮
- (void)loadNewInformationBtn
{
    UIButton *NewInformationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NewInformationBtn.frame = CGRectMake(20, SCREEN_HEIGHT-40-64, SCREEN_WIDTH-40, 30);
    NewInformationBtn.layer.cornerRadius = 5.0f;
    NewInformationBtn.backgroundColor = GETColor(39, 207, 104);
    [NewInformationBtn setTitle:@"新建病历" forState:UIControlStateNormal];
    [NewInformationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [NewInformationBtn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
    NewInformationBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:NewInformationBtn];
}

// "新建资料"的点击事件
- (void)Click
{
    CreatMedicalViewController *creat = [[CreatMedicalViewController alloc] init];
    [self.navigationController pushViewController:creat animated:YES];
}

// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark--获取列表数据

-(void)layOutlist{

    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"pageSize":@"20",@"page":[NSString stringWithFormat:@"%d",currentPage]};
    
    __weak typeof(self)wself=self;
    
    [AFRequestService responseData:BINGLI_LIST andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        
        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        NSString * page=[NSString stringWithFormat:@"%@",[dict objectForKey:@"page"]];
        NSString * pageCount=[NSString stringWithFormat:@"%@",[dict objectForKey:@"pageCount"]];
        NSString * recordCount=[NSString stringWithFormat:@"%@",[dict objectForKey:@"recordCount"]];
        
        NSLog(@"xxxxx======%@",dict);
        
        [self endPull];
        
        if ([code intValue]==0)//说明请求数据成功
        {
            if (data_array.count == [recordCount intValue]) {
                [SNTools showMBProgressWithText:@"没有更多数据了" addToView:self.view];
                return ;
            }
            
            if (currentPage == 1)
            {
                [data_array removeAllObjects];
            }
            
            
            NSArray * array = [dict objectForKey:@"binglilist"];
            
            for (NSDictionary * dic in array) {
                
                BingLiListFeed *feed=[[BingLiListFeed alloc]init];
                
                [feed setBingLiListFeedDic:dic];
                
                [data_array addObject:feed];
            }
            [wself.tableView reloadData];
        }
        
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    MedicalCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MedicalCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setInfoWith:[data_array objectAtIndex:indexPath.row]];
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BingLiListFeed * feed = [data_array objectAtIndex:indexPath.row];
    LiuLanBingLiViewController * liulan = [[LiuLanBingLiViewController alloc] init];
    liulan.feed = feed;
    [self.navigationController pushViewController:liulan animated:YES];
    
}


#pragma mark - PullTableViewDelegate
- (void)pullTableViewDidTriggerRefresh:(PullTableView*)pullTableView
{
    currentPage = 1;
    [self layOutlist];
}
- (void)pullTableViewDidTriggerLoadMore:(PullTableView*)pullTableView
{
    currentPage++;
    [self layOutlist];
}
- (void)endPull{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullLastRefreshDate = [NSDate date];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
