//
//  GcalendarDetailViewController.m
//  GUKE
//
//  Created by gaomeng on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GcalendarDetailViewController.h"

#import "GeventDetailViewController.h"

@interface GcalendarDetailViewController ()
{
    int _page;//第几页
    int _pageCapacity;//一页请求几条数据
    NSArray *_dataArray;//数据源
}
@end

@implementation GcalendarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadNavigation];
    
    _tableView = [[RefreshTableView alloc]init];
    _tableView.frame = CGRectMake(0, 64, 320, 568-64);
    
    _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _page = 1;
    _pageCapacity = 20;
    
    [_tableView showRefreshHeader:YES];//进入界面先刷新数据
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



//请求网络数据
-(void)prepareNetData{
    
    NSString *pageCapacityStr = [NSString stringWithFormat:@"%d",_pageCapacity];
    NSString *pageStr = [NSString stringWithFormat:@"%d",_page];
    
    NSString *dateStr = [NSString stringWithFormat:@"%d-%d-%d",[self.calDay getYear],[self.calDay getMonth],[self.calDay getDay]];
    
    
    NSLog(@"%@",dateStr);
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"date":dateStr,@"pageSize":pageCapacityStr,@"page":pageStr};
    
    __weak typeof (self)bself = self;
    [AFRequestService responseData:CALENDAR_ACTIVITIESTABLEVIEW andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            NSLog(@"loadSuccess");
            NSLog(@"%@",dict);
            
            NSArray *eventArray = [dict objectForKey:@"eventlist"];
            NSMutableArray *dataArray  = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in eventArray) {
                GeventModel *m = [[GeventModel alloc]initWithDic:dic];
                [dataArray addObject:m];
            }
            
            if (dataArray.count < _pageCapacity) {
                
                _tableView.isHaveMoreData = NO;
                
            }else
            {
                _tableView.isHaveMoreData = YES;
            }
            
            [bself reloadData:dataArray isReload:_tableView.isReloadData];
            
            
        }else{
            NSLog(@"%d",[code intValue]);
            if (_tableView.isReloadData) {
                
                _page --;
                
                [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
            }
        }
    }];
    
    
    
    
    
}



- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.row == 0) {
        height = 65;
        
    }else{
        height = 100;
    }
    
    return height;
}





#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}





#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.separatorInset = UIEdgeInsetsZero;
    }
    
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    
    if (indexPath.row == 0) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15,17, 320, 40)];
        NSString *weekDay = nil;
        switch ([self.calDay getWeekDay]) {
            case 1:
                weekDay = @"一";
                break;
            case 2:
                weekDay = @"二";
                break;
            case 3:
                weekDay = @"三";
                break;
            case 4:
                weekDay = @"四";
                break;
            case 5:
                weekDay = @"五";
                break;
            case 6:
                weekDay = @"六";
                break;
            case 7:
                weekDay = @"日";
                break;
            default:
                break;
        }
        
        label.text = [NSString stringWithFormat:@"%d年%d月%d日  星期%@",[self.calDay getYear],[self.calDay getMonth],[self.calDay getDay],weekDay];
        label.textColor = RGB(41, 139, 170);
        label.font = [UIFont boldSystemFontOfSize:17];
        
        [cell.contentView addSubview:label];
        
    }else{
        
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 290, 70)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.numberOfLines = 3;
        GeventModel *m = _dataArray[indexPath.row - 1];
        titleLabel.text = [NSString _859ToUTF8:m.eventTitle];
        [cell.contentView addSubview:titleLabel];
     
        
    }
    
    
    
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count+1;
}












-(void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%@",indexPath);
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    GeventDetailViewController *aaa = [[GeventDetailViewController alloc]init];
    
    aaa.dataModel = _dataArray[indexPath.row -1];
    
    [self.navigationController pushViewController:aaa animated:YES];
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
    loginLabel.text = @"会议日程";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gPoPu)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}


-(void)gPoPu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
