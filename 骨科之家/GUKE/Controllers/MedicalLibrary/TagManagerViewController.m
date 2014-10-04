//
//  TagManagerViewController.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//a

#import "TagManagerViewController.h"
#import "AddTagViewController.h"

@interface TagManagerViewController ()

@end

@implementation TagManagerViewController
@synthesize myTableView = _myTableView;
@synthesize myFeed = _myFeed;
@synthesize data_array = _data_array;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.aTitle = @"标签";
    
    _data_array = [NSMutableArray array];
    
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = IOS7_OR_LATER ? -5:5;
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(0,0,50,30);
    right_button.layer.cornerRadius = 5;
    right_button.backgroundColor = RGB(0,136,161);
    [right_button addTarget:self action:@selector(addTagTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setTitle:@"添加" forState:UIControlStateNormal];
    right_button.titleLabel.font  = [UIFont systemFontOfSize:15];
    [right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem * right_item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceButton,right_item,nil];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_myTableView];
    
    UIView * vvv = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    _myTableView.tableFooterView = vvv;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(BiaoqianUpLoad:) name:@"BiaoqianUpLoad" object:nil];
}

#pragma mark - 数据有更新，重新请求
-(void)BiaoqianUpLoad:(NSNotification *)notification
{
    [self getBiaoQianData];
    
}

-(void)addTagTap:(UIButton *)button
{
    AddTagViewController * add = [[AddTagViewController alloc] init];
    add.feed = _myFeed;
    [self.navigationController pushViewController:add animated:YES];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myFeed.tag_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    TagListFeed * feed = [_myFeed.tag_array objectAtIndex:indexPath.row];

    cell.textLabel.text = feed.tag;
    
    UIButton * delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
    delete_button.frame = CGRectMake(DEVICE_WIDTH - 70,5,60,34);
    delete_button.tag = 100 + indexPath.row;
    [delete_button setTitle:@"删除" forState:UIControlStateNormal];
    [delete_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    delete_button.layer.borderColor = [UIColor blueColor].CGColor;
    delete_button.layer.cornerRadius = 5;
    delete_button.layer.borderWidth = 0.5;
    [delete_button addTarget:self action:@selector(deleteButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:delete_button];
    
    return cell;
}



-(void)deleteButtonTap:(UIButton *)button
{
    TagListFeed * feed = [_myFeed.tag_array objectAtIndex:button.tag-100];
    
    __weak typeof(self)bself = self;
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"tagId":feed.tagId};
    
    MBProgressHUD * hud = [SNTools returnMBProgressWithText:@"正在删除..." addToView:self.view];
    hud.mode = MBProgressHUDModeDeterminate;
    [AFRequestService responseData:BINGLI_TAG_DELETE_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            hud.labelText = @"删除成功";
            [hud hide:YES afterDelay:1.5];
            [bself.myFeed.tag_array removeObjectAtIndex:button.tag-100];
            [bself.myTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:button.tag-100 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
            [bself.myTableView reloadData];
        }
    }];
}

#pragma mark - 获取标签数据
-(void)getBiaoQianData
{
    __weak typeof(self)bself = self;
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"bingliId":_myFeed.bingliId};
    
    [AFRequestService responseData:BINGLI_TAG_LIST_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        NSLog(@"dict --=-=--   %@",dict);
        if ([code intValue]==0)//说明请求数据成功
        {
            [bself.myFeed.tag_array removeAllObjects];
            NSArray * array = [dict objectForKey:@"taglist"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * aDic in array) {
                    TagListFeed * feed = [[TagListFeed alloc] initWithDic:aDic];
                    [bself.myFeed.tag_array addObject:feed];
                }
                [bself.myTableView reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
