//
//  GroupListViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-9.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GroupListViewController.h"
#import "SearchFriendsViewController.h"
#import "SetUpViewController.h"
#import "GroupMemberListViewController.h"
#import "AddGroupMemberViewController.h"
#import "UserLoginViewController.h"

#import "Interface.h"
#import "GroupList.h"
#import "GroupListTableViewCell.h"
#import "SqliteFieldAndTable.h"

#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "QiDiPopoverView.h"
#import "UserAddedGroupDB.h"
@interface GroupListViewController ()
{
    
    QiDiPopoverView *popOver;
    MBProgressHUD *HUD;
    NSMutableArray *groupList;
    UITableView *_tableView;
    UITextField *groupName;
}
@end

@implementation GroupListViewController
-(void)dealloc{
    NSLog(@"调用了dealloc……！");
    popOver = nil;
    HUD = nil;
    groupList = nil;
    _tableView = nil;
    groupName = nil;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        groupList = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self writeServerToLocal];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self creatTable];
}
- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"chat_allgrouptitle");
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
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88+44, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 44, 44);
    rightBtn1.backgroundColor = [UIColor clearColor];
    [rightBtn1 setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    
    [rightBtn1 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    rightBtn1.tag =SEARCH_BTN_TAG;
    
    [rightBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(44, 0, 44, 44);
    rightBtn2.tag =ADD_BTN_TAG;
    [rightBtn2 setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"addfri_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightBtn2 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    [rightBtn2 addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * rightBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn3.frame = CGRectMake(88, 0, 44, 44);
    rightBtn3.tag =SET_BTN_TAG;
    [rightBtn3 setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"set_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightBtn3 setImageEdgeInsets:UIEdgeInsetsMake(9.5, 16, 9.5, 3)];
    [rightBtn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn1];
    [rightView addSubview:rightBtn2];
    [rightView addSubview:rightBtn3];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightitem;

    
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}
// btnClickAction
- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == SEARCH_BTN_TAG) {
        SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType: kCATransitionMoveIn];
        [animation setSubtype: kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:search animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
    }
    else if (sender.tag == ADD_BTN_TAG){
        
    }
    else if (sender.tag == SET_BTN_TAG){
        SetUpViewController *setUp = [[SetUpViewController alloc]init];
        [self.navigationController pushViewController:setUp animated:YES];
    }
    else if (sender.tag == CONTACT_BTN_TAG){
        SetUpViewController *setUp = [[SetUpViewController alloc]init];
        [self.navigationController pushViewController:setUp animated:YES];
    }
    // 增加群组对话框
    else if (sender.tag == DIALOG_Btn_TAG){ // 取消对话框
        [popOver dismiss];
        
    }
    else if (sender.tag == SUBMIT_BTN_TAG){ // 添加群组
        [popOver dismiss];
        [self creatGroup];
    }
}
// 创建群组
- (void)creatGroup
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupName":groupName.text,@"groupType":[NSString stringWithFormat:@"%d",0]};
    [AFRequestService responseData:CREATE_GROUP andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *groupDict = (NSDictionary *)[dict objectForKey:@"group"];
            //添加到数据库中
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            [sqliteAndtable getReturnAddGroup:groupDict];
            sqliteAndtable = nil;
            
            AddGroupMemberViewController *addGroupMember = [[AddGroupMemberViewController alloc]init];
            addGroupMember.groupId = [groupDict objectForKey:@"groupId"];
            addGroupMember.groupName = [groupDict objectForKey:@"groupName"];
            [self.navigationController pushViewController:addGroupMember animated:YES];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            GroupListViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self creatGroup];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
    }];
}

// 创建tableView
- (void)creatTable
{
    NSString *alertText = LOCALIZATION(@"chat_loading");
    [self creatHUD:alertText];
    [HUD show:YES];
    if (IOS7_LATER) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-64) style:UITableViewStylePlain];
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-44) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    [self setExtraCellLineHidden:_tableView];

    UIView *linebg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 0)];
    [self.view addSubview:linebg];
    [self.view addSubview:_tableView];
    
    
}
// 执行方法，重新加载数据
- (void)dataChange:(NSNotification *)noti{
    [self getGroupList];
    // NSLog(@"接听到了数据的推送消息");
}
// 获取本地数据
- (void)getGroupList
{
    [groupList removeAllObjects];
    [groupList addObjectsFromArray:[UserAddedGroupDB selectFeildString:nil andcuId:GET_USER_ID]];
    [_tableView reloadData];
    [HUD hide:YES];
}
// 开辟子线程把服务器上的数据写到本地数据库中 同事加载本地数据
- (void)writeServerToLocal{
    // 后台执行加载数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        [sqliteAndtable getGroupInfo];
        sqliteAndtable = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self getGroupList];
        });
    });
    
}
#pragma mark ====== TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [groupList count]+1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    GroupListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GroupListTableViewCell" owner:self options:nil]lastObject];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.row == [groupList count]) {
        cell.groupNameLabel.text = [NSString stringWithFormat:LOCALIZATION(@"chat_allgroupfooter"),[groupList count]];
        cell.groupNameLabel.textAlignment = NSTextAlignmentCenter;
        cell.groupNameLabel.textColor = [UIColor grayColor];
        cell.groupNameLabel.font = [UIFont systemFontOfSize:13];
        cell.groupNameLabel.alpha = 0.5;
        cell.imgView.alpha = 0;
    }
    else{
    GroupList *model = (GroupList *)groupList[indexPath.row];
    cell.imgView.image = [UIImage imageNamed:@"group"];
    cell.groupNameLabel.text = model.groupName;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [groupList count]) {
        return;
    }
    else{
    GroupList *groupModel = (GroupList *)groupList[indexPath.row];
    GroupMemberListViewController *groupMember = [[GroupMemberListViewController alloc]init];
    groupMember.groupModel = groupModel;
    [self.navigationController pushViewController:groupMember animated:YES];
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }else{
        return 55;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else{
        return 20;
    }
}
//-(void)showPopover:(id)sender
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    popoverController.cornerRadius = 0;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverWithTouch:event];
    
}
// 弹出视图的时间方法
-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    
    NSString *addFriend = LOCALIZATION(@"home_addfriend");
    NSString *createGroup = LOCALIZATION(@"home_addgroup");
    
    [actionSheet addButtonWithTitle:addFriend icon:@"add_icon.png" block:^{
        SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType: kCATransitionMoveIn];
        [animation setSubtype: kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:search animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        
    }];
    
    [actionSheet addButtonWithTitle:createGroup icon:@"group_icon.png" block:^{
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        if(!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }  
        popOver = [[QiDiPopoverView alloc] init];
        [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatGroupView]];
        
    }];
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
}
// 创建群组的视图
- (UIView *)creatGroupView{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 110, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor blackColor];
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 40)];
    groupNameLabel.text = LOCALIZATION(@"chat_groupname");
    groupNameLabel.textColor = [UIColor whiteColor];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:groupNameLabel];
    
    UIImageView *lineBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, contaiterView.frame.size.width, 2)];
    lineBg1.image = [UIImage imageNamed:@"searchbglinered"];
    [contaiterView addSubview:lineBg1];
    
    groupName = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, contaiterView.frame.size.width-10, 30)];
    [groupName setBorderStyle:UITextBorderStyleLine];
    groupName.layer.borderColor = [[UIColor orangeColor]CGColor];
    groupName.font = [UIFont systemFontOfSize:16];
    groupName.textColor = [UIColor whiteColor];
    groupName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    groupName.keyboardAppearance = UIKeyboardAppearanceDefault;
    groupName.keyboardType = UIKeyboardTypeDefault;
    groupName.returnKeyType = UIReturnKeyGo;
    groupName.tag = 101;
    groupName.delegate = self;
    [contaiterView addSubview:groupName];
    
    UIImageView *lineBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 90, contaiterView.frame.size.width-10, 4)];
    lineBg2.image = [UIImage imageNamed:@"searchbglinered"];
    [contaiterView addSubview:lineBg2];
    
    UIButton *dialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialogBtn.frame = CGRectMake(30, 120, 70, 40);
    dialogBtn.backgroundColor = [UIColor clearColor];
    dialogBtn.tag = DIALOG_Btn_TAG;
    [dialogBtn setTitle:LOCALIZATION(@"dialog_cancel") forState:UIControlStateNormal];
    [dialogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    dialogBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dialogBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(150, 120, 70, 40);
    subMitBtn.backgroundColor = [UIColor clearColor];
    subMitBtn.tag = SUBMIT_BTN_TAG;
    [subMitBtn setTitle:LOCALIZATION(@"button_submit") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subMitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:dialogBtn];
    [contaiterView addSubview:subMitBtn];
    
    return contaiterView;
}
// 小菊花提示框
-(void)creatHUD:(NSString *)hud{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.view] ;
        [self.view addSubview:HUD];
        HUD.delegate = self;
    }
    HUD.labelText = hud;
}
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    if (HUD && HUD.superview) {
        [HUD removeFromSuperview];
        HUD = nil;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        popOver = nil;
        HUD = nil;
        groupList = nil;
        _tableView = nil;
        groupName = nil;
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
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
