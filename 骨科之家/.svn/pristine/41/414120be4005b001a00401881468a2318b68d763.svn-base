//
//  InferiorsTableViewController.m
//  UNITOA
//  下级列表
//  Created by ianMac on 14-8-5.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "InferiorsTableViewController.h"
#import "MBProgressHUD.h"
#import "Interface.h"
#import "InferiorsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "FriendDetailViewController.h"


@interface InferiorsTableViewController ()
{
    MBProgressHUD *HUD;
    NSMutableArray *dataArray;
    NSString *tempUserId;
}


// 获取下级用户列表数据
- (void)getInferiorsData;
@end

@implementation InferiorsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        tempUserId = [[NSString alloc] init];
        dataArray = [[NSMutableArray alloc] init];
    }
    return self;
}
- (instancetype)initWithDstUserId:(NSString *)dstUserId
{
    if (self = [super init]) {
        tempUserId = [NSString stringWithFormat:@"%@",dstUserId];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self navigetion];
    [self creatUI];
    [self getInferiorsData];  
}

- (void)creatUI
{
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 解决IOS7下tableview分割线左边短了一点
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:self.tableView];
}

- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_unis_logo@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = @"下级列表";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgNavi addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}


- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)getInferiorsData
{
    [HUD show:YES];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"dstUserId":tempUserId};
    [AFRequestService responseData:SUB_USER_LIST_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSArray *userList = [dict objectForKey:@"userlist"];
            for (NSDictionary *user in userList) {
                UserIfo *userModel = [[UserIfo alloc] init];
                userModel.userId = [user objectForKey:@"userId"];
                userModel.firstname = [user objectForKey:@"firstname"];
                userModel.icon = [IMAGE_BASE_URL stringByAppendingString:[user objectForKey:@"icon"]];
                [dataArray addObject:userModel];
            }
            
        }
        else{
            
            NSString *alertcontext = LOCALIZATION(@"login_error_pwd");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }
        [HUD hide:YES];
        [self.tableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *str = @"cell";
    InferiorsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"InferiorsTableViewCell" owner:self options:nil] lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.nameLabel.text = ((UserIfo *)[dataArray objectAtIndex:indexPath.row]).firstname;
    [cell.userImage setImageWithURL:[NSURL URLWithString:((UserIfo *)[dataArray objectAtIndex:indexPath.row]).icon] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:((UserIfo *)[dataArray objectAtIndex:indexPath.row]).userId];
    [self.navigationController pushViewController:fdvc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        HUD = nil;
        dataArray = nil;
        tempUserId = nil;
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    HUD = nil;
    dataArray = nil;
    tempUserId = nil;
}
@end
