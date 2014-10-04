//
//  RemindViewController.m
//  WeiTongShi
//
//  Created by qidi on 14-6-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "RemindViewController.h"
#import "RemindTableViewCell.h"
#import "RemindTableViewCellOneTableViewCell.h"

#import <AudioToolbox/AudioToolbox.h>
// 是够获取群组聊天信息
#define GET_GNEW @"ison%d"
// 是否开启声音
#define IS_VOICE @"voice"
// 是否使用听筒
#define USER_RECEIVE @"receiver"
// 是否开启震动
#define IS_SHAKE @"shake"
// 拒接
#define REJECT   @"reject"
@interface RemindViewController ()
{
    NSArray *dataArry;
}
@end

@implementation RemindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    dataArry = @[LOCALIZATION(@"setting_notify_groupchat"),LOCALIZATION(@"setting_notify_voice"),LOCALIZATION(@"setting_notify_vibrate")];//,LOCALIZATION(@"setting_notify_night")
    [self initSwichOn];
    [self creatUI];
    [self navigetion];
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"setting_notify");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [logoView addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 初始化选择按钮
- (void)initSwichOn{
    BOOL isButtonOn;
    for (int i = 0; i<[dataArry count]; i++) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:GET_GNEW,i]] == nil) {
            if (i == 1) {
               isButtonOn = NO;
            }
            else{
             isButtonOn = YES;
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isButtonOn] forKey:[NSString stringWithFormat:GET_GNEW,i]];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
}
// UIButtonClick Action
- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 201) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        return;
    }
}

- (void)creatUI
{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = GETColor(234, 234, 234);
    // 解决IOS7下tableview分割线左边短了一点
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    //[bgView addSubview:tableView];
    [self setExtraCellLineHidden:tableView];
    [self.view addSubview:tableView];
    
}
#pragma mark ====== TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArry count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell2";
    BOOL flag = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:GET_GNEW,indexPath.row]] boolValue];
    if (indexPath.row == 0) {
        RemindTableViewCellOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RemindTableViewCellOneTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.itemLabel.text = dataArry[indexPath.row];
        cell.switckController.selected = flag;
        cell.switckController.on = flag;
        if (ISIOS_PREV) {
            cell.switckController.frame = CGRectMake(viewSize.width - 70, 10,40, 40);
        }
        
        cell.switckController.tag = indexPath.row + INT16_MAX;
        [cell.switckController addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }else
    {
        RemindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"RemindTableViewCell" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 1) {
            cell.itemLabel.text = dataArry[indexPath.row];
            cell.switckController.on = flag;
            if (ISIOS_PREV) {
                cell.switckController.frame = CGRectMake(viewSize.width - 70, 10,40, 40);
            }
        }
        else{
            
            cell.itemLabel.text = dataArry[indexPath.row];
            cell.switckController.selected = flag;
            cell.switckController.on = flag;
            if (ISIOS_PREV) {
                cell.switckController.frame = CGRectMake(viewSize.width - 70, 10,40, 40);
            }
            
        }
        cell.switckController.tag = indexPath.row + INT16_MAX;
        [cell.switckController addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        return cell;
    }

}
- (void)switchAction:(UISwitch *)sender
{
    NSInteger index = sender.tag - INT16_MAX;
    BOOL isButtonOn = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:isButtonOn] forKey:[NSString stringWithFormat:GET_GNEW,index]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    switch (index) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            
            break;
        case 4:
            break;
            
        default:
            break;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 55;
    }
    return 50;
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){

        dataArry = nil;
        self.view = nil;
        
    }
}
-(void)dealloc{
    dataArry = nil;
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
