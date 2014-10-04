//
//  ChooseCaseTypeViewController.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ChooseCaseTypeViewController.h"

@interface ChooseCaseTypeViewController ()
{
    NSMutableArray * data_array;
}

@end

@implementation ChooseCaseTypeViewController
@synthesize myTableView = _myTableView;
@synthesize feed = _feed;
@synthesize delete_array = _delete_array;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aTitle = @"选择病历分类";
    data_array = [NSMutableArray array];
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_myTableView];
    
    [self loadBingLiListData];
    
}

#pragma mark - 请求数据
-(void)loadBingLiListData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID};
    
    [AFRequestService responseData:BINGLI_TYPE_LIST_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        NSLog(@"病历分类数据 --- - %@",dict);
        if ([code intValue]==0)//说明请求数据成功
        {
            NSArray * array = [dict objectForKey:@"fenleilist"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array) {
                    [data_array addObject:dic];
                }
                [_myTableView reloadData];
            }
        }else
        {
            [SNTools showMBProgressWithText:@"加载数据失败" addToView:self.view];
        }
    }];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [NSString _859ToUTF8:[[data_array objectAtIndex:indexPath.row] objectForKey:@"fenleiName"]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _feed.fenleiId = [[data_array objectAtIndex:indexPath.row] objectForKey:@"fenleiId"];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[[data_array objectAtIndex:indexPath.row] objectForKey:@"fenleiId"],@"typeId",nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadData" object:dic];
    
//    [self.navigationController popViewControllerAnimated:YES];
    
    
    [self upLoadBingLi];
}


-(void)upLoadBingLi
{
//    NSMutableDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"bingliId":_feed.bingliId,@"psname":_feed.psnname,@"sex":_feed.sex,@"jiuzhen":_feed.jiuzhen,@"zhenduan":_feed.zhenduan,@"mobile":_feed.mobile,@"relateMobile":_feed.relateMobile,@"fangan":_feed.fangan,@"binglihao":_feed.binglihao,@"leibieId":_feed.leibieId,@"idno":_feed.idno,@"bianma":_feed.bianma,@"memo":_feed.memo,@"fenleiId":_feed.fenleiId};
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    [parameters setObject:GET_U_ID forKey:@"userId"];
    [parameters setObject:GET_S_ID forKey:@"sid"];
    
    if (_feed.bingliId.length)
    {
        [parameters setObject:_feed.bingliId forKey:@"bingliId"];
    }
    
    if (_feed.psnname.length)
    {
        [parameters setObject:_feed.psnname forKey:@"psnname"];
    }
    if (_feed.sex.length)
    {
        [parameters setObject:_feed.sex forKey:@"sex"];
    }
    if (_feed.jiuzhen.length)
    {
        [parameters setObject:_feed.jiuzhen forKey:@"jiuzhen"];
    }
    if (_feed.zhenduan.length)
    {
        [parameters setObject:_feed.zhenduan forKey:@"zhenduan"];
    }
    if (_feed.mobile.length)
    {
        [parameters setObject:_feed.mobile forKey:@"mobile"];
    }
    if (_feed.fangan.length)
    {
        [parameters setObject:_feed.fangan forKey:@"fangan"];
    }
    if (_feed.binglihao.length)
    {
        [parameters setObject:_feed.binglihao forKey:@"binglihao"];
    }
    if (_feed.idno.length)
    {
        [parameters setObject:_feed.idno forKey:@"idno"];
    }
    if (_feed.bianma.length)
    {
        [parameters setObject:_feed.bianma forKey:@"bianma"];
    }
    if (_feed.fenleiId.length)
    {
        [parameters setObject:_feed.fenleiId forKey:@"fenleiId"];
    }
    
    if (_delete_array.count)
    {
        
        NSString * delete_id = [_delete_array componentsJoinedByString:@","];
        [parameters setObject:delete_id forKey:@"removeAttachIds"];
    }
    
    
    __weak typeof(self)wself=self;
    
//    [AFRequestService responseData:WRITE_BINGLI_URL andparameters:parameters andResponseData:^(id responseData) {
//        
//        NSDictionary * dict = (NSDictionary *)responseData;
//        NSLog(@"dict ------  %@",dict);
//        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
//        
//        if ([code intValue]==0)//说明请求数据成功
//        {
//        }
//    }];
    
    
    [AFRequestService bingliresponseDataWithImage:WRITE_BINGLI_URL andparameters:parameters andDataArray:_feed.attach_array andfieldType:@"attach1" andfileName:@"attach1.jpg" andResponseData:^(NSData *responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict -------   %@",dict);
        
        if ([[dict objectForKey:@"code"]intValue] == 0)
        {
            [wself.navigationController popViewControllerAnimated:YES];
        }
    }];
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
