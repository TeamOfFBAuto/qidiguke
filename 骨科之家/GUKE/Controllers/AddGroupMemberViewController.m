//
//  AddGroupMemberViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AddGroupMemberViewController.h"
#import "UIImageView+WebCache.h"
#import "SqliteFieldAndTable.h"
#import "UserLoginViewController.h"
#import "GroupListViewController.h"
#import "Interface.h"
#define SEARCH_RIGHT_BTN_TAG 3000
@interface AddGroupMemberViewController ()
{
    MBProgressHUD *HUD;
    UIView *head_bg;
    UITextField *searchField;
    UITableView *_tableView;
    NSMutableArray * userArray;
    BOOL isChecked;
    NSMutableArray *nameArray;
    NSMutableString *userNames;
}
@end

@implementation AddGroupMemberViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        userArray = [[NSMutableArray alloc]init];
        // 存储用户名
        nameArray = [[NSMutableArray alloc]init];
        // 标记选中的表格数据
        isChecked = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    userNames = [[NSMutableString alloc]init];
    [self navigation];
    [self dataRequest];
    [self creatUI];
    [self creatTable];
    
    
}
- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = self.groupName;
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
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(0, 10, 60, 30);
    subMitBtn.tag = SUBMIT_BTN_TAG;
    [subMitBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_add@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [subMitBtn setTitle:LOCALIZATION(@"dialog_ok") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    subMitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:subMitBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatUI
{
    head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];

    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"home_head@2x" ofType:@"png"]]]];
    
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = SEARCH_RIGHT_BTN_TAG;
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, viewSize.width-20, 30)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"Name/E-mail/Phone";
    searchField.rightView = right_searchBtn;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    searchField.delegate = self;
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]]];
    
    line.frame = CGRectMake(5, 35, viewSize.width-10, 4);
    [head_bg addSubview:line];
    [head_bg addSubview:searchField];
    [self.view addSubview:head_bg];
    
}
- (void)btnClick:(UIButton *)sender
{
    if(sender.tag == SUBMIT_BTN_TAG){
        [self submitMember];
    }
}
- (void)submitMember{
    for (NSString *userName in nameArray) {
        if (userName == nil || userName <= 0 ) {
            [userNames appendFormat:@"%@",userName];
            
        }
        else{
            [userNames appendFormat:@",%@",userName];
        }
        
    }
    if (userNames == nil || userNames.length == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"%@",[userNames description]);
        NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"groupId": self.groupId,@"addUsername":userNames};
        [AFRequestService responseData:ADD_GROUP_MEMBER andparameters:parameters andResponseData:^(id responseData) {
            NSDictionary *dict = (NSDictionary *)responseData;
            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
            if (codeNum == CODE_SUCCESS) {
                if (self.flag == 1) {
                    GroupListViewController *groupVC = [[GroupListViewController alloc]init];
                    [self.navigationController pushViewController:groupVC animated:YES];
                }
                else{
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
            else if (codeNum == CODE_ERROE){
                SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                AddGroupMemberViewController __weak *_Self = self;
                [sqliteAndtable repeatLogin:^(BOOL flag) {
                    if (flag) {
                        [_Self submitMember];
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
    
}
- (void)creatTable
{
    if (IOS7_LATER) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-64) style:UITableViewStylePlain];
        
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-44) style:UITableViewStylePlain];
        
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:_tableView];

    [self.view addSubview:_tableView];
}
// 数据请求
- (void)dataRequest
{
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    [HUD show:YES];
    NSDictionary *parameters = nil;
    if (searchField.text == nil) {
        parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"keyword": @"",@"page": [NSString stringWithFormat:@"%d",1],@"pageSize":[NSString stringWithFormat:@"%d",INT32_MAX]};
    }
    else{
        parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"keyword": searchField.text,@"page": [NSString stringWithFormat:@"%d",1],@"pageSize":[NSString stringWithFormat:@"%d",INT32_MAX]};
    }
    
    [AFRequestService responseData:USER_SEARCH_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        if ([self saveData:dict]) {
            [_tableView reloadData];
            [HUD hide:YES];
        }
        else{
            return;
        }
        
    }];
    
}
- (BOOL)saveData:(NSDictionary *)dict
{
    [userArray removeAllObjects];
    NSInteger codeNum = [[dict objectForKey:@"code"] intValue];
    if (codeNum == CODE_SUCCESS) {
        NSArray *userLists = [dict objectForKey:@"userlist"];
        for (int i = 0; i<[userLists count]; ++i) {
            UserIfo *model = [[UserIfo alloc]init];
            NSDictionary *userList = userLists[i];
            model.firstname = [userList valueForKeyPath:@"firstname"];
            model.username = [userList valueForKeyPath:@"username"];
            model.icon = [userList valueForKeyPath:@"icon"];
            [userArray addObject:model];
            model = nil;
        }
        return YES;
    }
    else if(codeNum == CODE_ERROE) {
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        AddGroupMemberViewController __weak *_Self = self;
        [sqliteAndtable repeatLogin:^(BOOL flag) {
            if (flag) {
                [_Self dataRequest];
            }
            else{
                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                [_Self.navigationController pushViewController:login animated:YES];
                login = nil;
            }
            
        }];
        return NO;

    }
    else{
        return NO;
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self dataRequest];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self dataRequest];
    return YES;
    
}
#pragma mark ====== UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = [NSString stringWithFormat:@"cell%d%d",indexPath.row,indexPath.section];
    AddGroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[AddGroupMemberTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UserIfo *model = (UserIfo *)userArray[indexPath.row];
    cell.checkTitle.tag = 401+indexPath.row;
    cell.checkTitle.titleLabel.text = model.username;
    
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.icon]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
    
    cell.nameLabel.text = model.firstname;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton *titleBtn = (UIButton *)[tableCell viewWithTag:401+indexPath.row];
   
    BOOL isSelected = (tableCell.accessoryType == UITableViewCellAccessoryCheckmark);
    
    if (isSelected) {
        tableCell.accessoryType = UITableViewCellAccessoryNone;
        isChecked = NO;
    }
    else {
        tableCell.accessoryType = UITableViewCellAccessoryCheckmark;
        isChecked = YES;
    }

    if (isChecked) {
        [nameArray addObject:titleBtn.titleLabel.text];
    }
    else{
        [nameArray removeObject:titleBtn.titleLabel.text];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
        
        HUD = nil;
        head_bg = nil;
        searchField = nil;
        _tableView = nil;
        userArray = nil;
        userNames = nil;
        self.view = nil;
    
    }
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    HUD = nil;
    head_bg = nil;
    searchField = nil;
    _tableView = nil;
    userArray = nil;
    userNames = nil;
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
