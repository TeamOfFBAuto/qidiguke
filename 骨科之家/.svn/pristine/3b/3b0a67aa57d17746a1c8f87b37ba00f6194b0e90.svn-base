//
//  searchFriendsViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SearchFriendsViewController.h"
#import "Interface.h"
#import "FriendIfo.h"
#import "FriendsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "FriendDetailViewController.h"
@interface SearchFriendsViewController ()
{
    UIView *head_bg;
    UITextField *searchField;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
}
@end

@implementation SearchFriendsViewController

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
    userArray = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo_arrow"]];
    logoView.frame = CGRectMake(-5, 0, 40, 40);
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 160, 30)];
    loginLabel.text = LOCALIZATION(@"friend_search");
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
    [self creatUI];
    [self creatTable];
}
- (void)creatUI
{
    if (currentDev) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
        
    }
    if (currentDev1) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, viewSize.width, 40)];
    }
    else{
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    }
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_head"]]];
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [right_searchBtn setBackgroundImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = 301;
    
    searchField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, viewSize.width-20, 30)];
    searchField.backgroundColor = [UIColor clearColor];
    searchField.returnKeyType = UIReturnKeySearch;
    searchField.placeholder = @"Name/E-mail/Phone";
    searchField.rightView = right_searchBtn;
    searchField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchField.rightViewMode = UITextFieldViewModeAlways;
    searchField.delegate = self;
    [searchField becomeFirstResponder];
    
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"searchbglinered"]];
    line.frame = CGRectMake(5, 35, viewSize.width-10, 4);
    [head_bg addSubview:line];
    [head_bg addSubview:searchField];
    [self.view addSubview:head_bg];
    
}
- (void)btnClick:(UIButton *)sender
{
    [self requestUserData];
}
- (void)creatTable
{
    if (currentDev) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-64) style:UITableViewStylePlain];
        
    }
    else if(currentDev1){
         _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-64) style:UITableViewStylePlain];
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,head_bg.frame.size.height+head_bg.frame.origin.y ,viewSize.width, viewSize.height - head_bg.frame.size.height-head_bg.frame.origin.y-44) style:UITableViewStylePlain];
        
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)requestUserData
{
    [userArray removeAllObjects];
    UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
    NSDictionary *parameters = @{@"userId":model.userId,@"sid":model.sid,@"keyword":searchField.text,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:USER_SEARCH_URL andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict =(NSDictionary *)responseData;
        NSLog(@"%@",dict);
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == 0) {
            NSArray *userLists = [dict objectForKey:@"userlist"];
            for (int i = 0; i < [userLists count]; ++i) {
                FriendIfo *friendModel = [[FriendIfo alloc]init];
                NSDictionary * userlist = (NSDictionary *)userLists[i];
                friendModel.dstUserId = [userlist objectForKey:@"userId"];
                friendModel.dstUserName = [userlist objectForKey:@"firstname"];
                friendModel.icon = [userlist objectForKey:@"icon"];
                [userArray addObject:friendModel];
                friendModel = nil;
            }
            
            [_tableView reloadData];
        }
        else if (codeNum == 1){
            NSString *alertcontext = LOCALIZATION(@"login_error_pwd");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }
        else {
            return ;
        }
        
    }];
    
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
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self requestUserData];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //[self requestUserData];
    
    
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
    static NSString *cellName = @"cell";
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendsTableViewCell" owner:self options:nil]lastObject];
    }
    FriendIfo *model = (FriendIfo *)userArray[indexPath.row];
    cell.nameLable.text = model.dstUserName;
    [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.icon]] placeholderImage:[UIImage imageNamed:@"user_default_small_96"]];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]init];
    friendDetail.friendModel = (FriendIfo *)userArray[indexPath.row];
    [self.navigationController pushViewController:friendDetail animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
