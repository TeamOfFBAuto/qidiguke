//
//  CochatViewController.m
//  leliao
//
//  Created by qidi on 14-6-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendListViewController.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "Interface.h"
#import "FriendIfo.h"
#import "FriendsTableViewCell.h"
#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "SearchFriendsViewController.h"
@interface FriendListViewController ()
{
    UIView *head_bg;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
}
@end

@implementation FriendListViewController

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
    self.view.backgroundColor = [SingleInstance colorFromHexRGB:@"f5f5f5"];
    [self navigetion];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self creatHead];
    [self getFriendList];
    [self creatTable];
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo"]];
    logoView.frame = CGRectMake(0, 5, 30, 30);
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 160, 30)];
    loginLabel.text = LOCALIZATION(@"login_title");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn1.frame = CGRectMake(0, 10, 20, 20);
    rightBtn1.tag =201;
    [rightBtn1 setBackgroundImage:[UIImage imageNamed:@"search_icon"] forState:UIControlStateNormal];
    [rightBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightBtn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn2.frame = CGRectMake(40, 10, 20, 20);
    rightBtn2.tag =202;
    [rightBtn2 setBackgroundImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [rightBtn2 addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightBtn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn3.frame = CGRectMake(80, 10, 20, 20);
    rightBtn3.tag =203;
    [rightBtn3 setBackgroundImage:[UIImage imageNamed:@"set_icon"] forState:UIControlStateNormal];
    [rightBtn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [leftView addSubview:rightBtn1];
    [leftView addSubview:rightBtn2];
    [leftView addSubview:rightBtn3];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.rightBarButtonItem = rightitem;
}
- (void)creatHead
{
    if (currentDev) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
        
    }
    else if (currentDev1) {
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 64, viewSize.width, 40)];
    }
    else{
        head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    }
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_head"]]];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tab_ini"]];
    imgView.frame =CGRectMake(0, 34, 80, 6);
    // 通讯录
    NSString *ContactsText = LOCALIZATION(@"home_friend");
    UIButton *Contacts = [UIButton buttonWithType:UIButtonTypeCustom];
    Contacts.tag = 206;
    Contacts.backgroundColor = [UIColor clearColor];
    Contacts.frame = CGRectMake(0, 5, 80, 30);
    [Contacts setTitle:ContactsText forState:UIControlStateNormal];
    [Contacts setTitleColor:[SingleInstance colorFromHexRGB:@"9a9a9a"] forState:UIControlStateNormal];
    [Contacts addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    Contacts.titleLabel.textAlignment = NSTextAlignmentCenter;
    Contacts.titleLabel.font = [UIFont systemFontOfSize:16];
    // 事项
    NSString *mettertext = LOCALIZATION(@"home_matter");
    UIButton *metter = [UIButton buttonWithType:UIButtonTypeCustom];
    metter.tag = 206;
    metter.backgroundColor = [UIColor clearColor];
    metter.frame = CGRectMake(80, 5, 80, 30);
    [metter setTitle:mettertext forState:UIControlStateNormal];
    [metter setTitleColor:[SingleInstance colorFromHexRGB:@"9a9a9a"] forState:UIControlStateNormal];
    [metter addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    metter.titleLabel.textAlignment = NSTextAlignmentCenter;
    metter.titleLabel.font = [UIFont systemFontOfSize:16];
    // 朋友圈
    NSString *MomentsText = LOCALIZATION(@"home_group");
    UIButton *Moments = [UIButton buttonWithType:UIButtonTypeCustom];
    Moments.tag = 205;
    Moments.backgroundColor = [UIColor clearColor];
    Moments.frame = CGRectMake(160, 5, 80, 30);
    [Moments setTitle:MomentsText forState:UIControlStateNormal];
    [Moments setTitleColor:[SingleInstance colorFromHexRGB:@"9a9a9a"] forState:UIControlStateNormal];
    [Moments addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    Moments.titleLabel.textAlignment = NSTextAlignmentCenter;
    Moments.titleLabel.font = [UIFont systemFontOfSize:16];
    // 聊天
    UIButton *Cochat = [UIButton buttonWithType:UIButtonTypeCustom];
    Cochat.tag = 204;
    Cochat.backgroundColor = [UIColor clearColor];
    Cochat.userInteractionEnabled = NO;
    Cochat.frame = CGRectMake(240, 5, 80, 30);
    NSString *CochatText = LOCALIZATION(@"home_chat");
    [Cochat setTitle:CochatText forState:UIControlStateNormal];
    [Cochat setTitleColor:[SingleInstance colorFromHexRGB:@"9a9a9a"] forState:UIControlStateNormal];
    [Cochat addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    Cochat.titleLabel.textAlignment = NSTextAlignmentCenter;
    Cochat.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [head_bg addSubview:Cochat];
    [head_bg addSubview:Moments];
    [head_bg addSubview:Contacts];
    [head_bg addSubview:metter];
    [head_bg addSubview:imgView];
    Cochat = nil;
    Moments = nil;
    Contacts = nil;
    metter = nil;
    [self.view addSubview:head_bg];
    
}
- (void)creatTable
{
    frindsArray = [[NSMutableArray alloc]init];
    userArray = [[NSMutableArray alloc]init];
    _sortedArrForArrays = [[NSMutableArray alloc]init];
    _sectionHeadsKeys = [[NSMutableArray alloc] init];
    CGFloat height = head_bg.frame.size.height + head_bg.frame.origin.y;
//    if (currentDev) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, viewSize.width, viewSize.height-height) style:UITableViewStylePlain];
//    }
//    else if (currentDev1)
//    {
//        
//    }
//    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, height, viewSize.width, viewSize.height-height) style:UITableViewStylePlain];
    //}
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
//
//获取用户群组及联系人列表
- (void)getFriendList
{
    UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
    NSDictionary *parameters = @{@"userId":model.userId,@"sid":model.sid,@"pageSize":[NSString stringWithFormat:@"%d",INT_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:FRIEND_LIST_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSLog(@"%@",dict);
        
        if ([self bindData:dict]) {
            [_tableView reloadData];
        }
        
    } andCathtype:2 andID:1];
}
- (BOOL)bindData:(NSDictionary *)dict
{
    
    NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
    if (codeNum == 0) {
        NSArray *contactlists = [dict objectForKey:@"friendlist"];
        for (int i = 0; i <[contactlists count]; ++i) {
            NSDictionary *contactlist = (NSDictionary *)contactlists[i];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.createDate = [contactlist objectForKey:@"createDate"];
            model.dstUserId = [contactlist valueForKey:@"dstUserId"];
            model.dstUserName = [contactlist objectForKey:@"dstUserName"];
            model.friendId = [contactlist objectForKey:@"friendId"];
            model.status = [contactlist objectForKey:@"status"];
            model.userId = [contactlist objectForKey:@"userId"];
            [self getFriendDetail:model];
            [frindsArray addObject:model];
            
        }
        self.sortedArrForArrays = [self getChineseStringArr:frindsArray];
        
        
    }
    else if (codeNum == 1){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"登入失败" message:@"用户名重复，请联系管理员" delegate:self cancelButtonTitle:@"ok"otherButtonTitles:nil];
        [alert show];
    }
    
    return YES;
}
- (void)getFriendDetail:(FriendIfo *)friendModel
{
    UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
    __block FriendIfo * friend = friendModel;
    NSDictionary *parameters = @{@"userId":model.userId,@"sid":model.sid,@"viewId":friend.dstUserId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSLog(@"%@",dict);
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == 0) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            friend.icon = [userDetail valueForKey:@"icon"];
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
        
        
        
    } andCathtype:2 andID:2];
}

- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 201) {
        SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType: kCATransitionMoveIn];
        [animation setSubtype: kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:search animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
    }
    else if (sender.tag == 202){
        NSLog(@"%d",sender.tag);
    }
    else if (sender.tag == 203){
        NSLog(@"%d",sender.tag);
    }
}

#pragma mark ====== TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    else{
        return  [[self.sortedArrForArrays objectAtIndex:section-1] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count]+1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    else{
        return [_sectionHeadsKeys objectAtIndex:section-1];
    }
    
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeadsKeys;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index+1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cell";
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendsTableViewCell" owner:self options:nil]lastObject];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.imgView.image = [UIImage imageNamed:@"newfriend"];
            cell.nameLable.text = LOCALIZATION(@"friendlist_new");
            
        }
        else {
            cell.imgView.image = [UIImage imageNamed:@"group_default"];
            cell.nameLable.text = LOCALIZATION(@"friendlist_allgroup")
        }
    }
    
    else{
         NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section-1];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.nameLable.text = str.friendModel.dstUserName;
            [cell.imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,str.friendModel.icon]] placeholderImage:[UIImage imageNamed:@"user_default_small_96"]];
        } else {
            NSLog(@"arr out of range");
        }
        //cell.imgView.image = [UIImage imageNamed:@"user_default_small_96"];
        
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
    }
    else{
    FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]init];
    NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section-1];
    ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
    friendDetail.friendModel = str.friendModel;
    [self.navigationController pushViewController:friendDetail animated:YES];    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// 按首字母对名字进行分组排序
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        FriendIfo *model = (FriendIfo *)arrToSort[i];
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.string=model.dstUserName;
        chineseString.friendModel = model;
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
        chineseString = nil;
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;
    
    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![_sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [_sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] initWithObjects:nil];
            checkValueAtIndex = NO;
        }
        if([_sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
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

-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    NSString *addFriend = LOCALIZATION(@"home_addfriend");
    NSString *createGroup = LOCALIZATION(@"home_addgroup");
    [actionSheet addButtonWithTitle:addFriend block:^{
        SearchFriendsViewController *search = [[SearchFriendsViewController alloc]init];
        CATransition *animation = [CATransition animation];
        [animation setDuration:0.3];
        [animation setType: kCATransitionMoveIn];
        [animation setSubtype: kCATransitionFromTop];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
        [self.navigationController pushViewController:search animated:NO];
        [self.navigationController.view.layer addAnimation:animation forKey:nil];
        
    }];
    [actionSheet addButtonWithTitle:createGroup block:^{
        NSLog(@"pushed hoge2 button");
    }];
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
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
