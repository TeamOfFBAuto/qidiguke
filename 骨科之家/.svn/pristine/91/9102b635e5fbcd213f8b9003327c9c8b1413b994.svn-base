//
//  MedicalViewController.m
//  GUKE
//  病历库
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MedicalViewController.h"
#import "CreatMedicalViewController.h"


@interface MedicalViewController ()

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
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigation];
    [self loadUITableView];
    [self loadNewInformationBtn];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-50) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    NewInformationBtn.frame = CGRectMake(20, SCREEN_HEIGHT-40, SCREEN_WIDTH-40, 30);
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
