//
//  GroupMemberListViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-9.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GroupMemberListViewController.h"
#import "GroupMemberList.h"
#import "FriendIfo.h"
#import "QiDiPopoverView.h"
#import "UserLoginViewController.h"
#import "VChatViewController.h"
#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "MyCollectionViewCell.h"
#import "AddGroupMemberViewController.h"
#import "DelGroupMemberViewController.h"
#import "UserAddedGroupDB.h"
#import "SqliteFieldAndTable.h"
#import "GroupMember.h"
#import "userContactDB.h"
#import "Interface.h"
@interface GroupMemberListViewController ()
{
    MBProgressHUD *HUD;
    QiDiPopoverView *popOver;
    UITextField *addGroupName;
    UITextField *alertGroupName;
    UILabel *loginLabel;
    
    UIScrollView *_scrollView;
    UIView *collectionBgView;
    CGFloat groupNameBgView_Y;
    
    UIView *gropNameBgView;
    UILabel *groupNameLab;
    UILabel *groupName;
    
    UIView *creatorBgView;
    UILabel *creatorLabel;
    UILabel *creator;
    
    UIView *creatorDateBgView;
    UILabel *creatorDateLabel;
    UILabel *creatorDate;
    
    UIView *groupMemoBgView;
    UILabel *groupMemoLabel;
    UILabel *groupMemo;
    
    UIButton *comeinChatBtn;
    UIButton *delChatBtn;
}
@end
static NSString * const CellIdentifier = @"cellection";
static NSInteger const comeInChat_tag = 12345;
static NSInteger const delInChat_tag = 12346;
static NSInteger const dialogBtn_tag = 12347;
static NSInteger const subMitBtn_tag = 12348;
static NSInteger const dialogName_tag = 12347;
static NSInteger const subMitName_tag = 12351;
static NSInteger const codeSuccess_tag = 12349;
static NSInteger const codeSuccess_Nametag = 12350;
static NSInteger const codeError_tag = 123410;
static NSInteger const DEL_BTN_tag = 123411;
static NSInteger const ADD_BTN_tag = 123412;
static NSInteger const codeDelOk_tag = 123413;
@implementation GroupMemberListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.groupMemberList = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // 加载本地的数据成员
    [self getMemberList];
   
    //开个子线程将数据添加到数据库中
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestBindData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
        
    });
    if ( self.groupModel.groupId.length > 0) {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:self.groupModel.groupId forKey:@"groupId"];
        [def synchronize];
    }
    else{
        return;
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self layoutView];
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
    
    loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text =[NSString stringWithFormat:@"%@（%d）人",self.groupModel.groupName,[self.groupMemberList count]] ;
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
    if ([self isCreator]) {
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * rightBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn1.frame = CGRectMake(0, 0, 40, 40);
    rightBtn1.tag =ADD_BTN_tag;
        [rightBtn1 setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"add_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    rightBtn1.imageEdgeInsets = UIEdgeInsetsMake(10,20,10,0);
        
    [rightBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn2.frame = CGRectMake(40, 0, 40, 40);
    rightBtn2.tag =DEL_BTN_tag;
    [rightBtn2 setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"del_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    rightBtn2.imageEdgeInsets = UIEdgeInsetsMake(8,18,8,0);
        
    [rightBtn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn1];
    [rightView addSubview:rightBtn2];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightitem;
         }
    
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
// 获取数据群组列表信息
- (void)getMemberList
{
    
    [self.groupMemberList removeAllObjects];
    // 从数据库中获取数据
    [self.groupMemberList addObjectsFromArray:[GroupMember selectFeildString:nil andcuId:GET_U_ID andGroupId:GET_GROUPID]];
    // 如果数据空中存在数据，则加载到列表上
    if ([self.groupMemberList count] > 0) {
        loginLabel.text =[NSString stringWithFormat:@"%@(%d)人",self.groupModel.groupName,[self.groupMemberList count]] ;
        [self.collectionView reloadData];
        [self adaptiveHeight];
    }
    // 如果数据库中没有数据
    else{
        [self requestBindData];
    }
}
// 
- (void)requestBindData
{
    // 定义变量，接受数据是否发生变化
   __block BOOL isChang = NO;
    // 判断群组id是否为空，若为空，则结束操作
    NSString * groupId = GET_GROUPID;
    if (groupId.length <= 0) {
        return;
    }
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupId":GET_GROUPID,@"pageSize":[NSString stringWithFormat:@"%d",INT32_MAX],@"page":[NSString stringWithFormat:@"%d",1]};
    [AFRequestService responseData:GROUP_MEMBER_LIST andparameters:parameters andResponseData:^(id responseData){
        
        NSDictionary *dict =(NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSArray *groupLists = [dict objectForKey:@"memberlist"];
            for (int i = 0; i <[groupLists count]; ++i) {
                NSDictionary *contactlist = (NSDictionary *)groupLists[i];
                SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                if ([sqliteAndtable getGroupMememberFeildandValue:contactlist]) {
                    isChang = YES;
                }
                sqliteAndtable = nil;
            }
            // 数据有变化则重新加载本地数据
            if (isChang) {
                [self getMemberList];
            }
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            GroupMemberListViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self requestBindData];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
        else{
            return ;
        }
    }];
}
// 判断是否当前用户是否是群创建者
- (BOOL)isCreator{
    if ([GET_USER_ID isEqualToString: self.groupModel.creator]) {
        return YES;
    }
    else{
        return NO;
    }
}
// 进行总体的布局
- (void)layoutView
{
    if (IOS7_LATER) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewSize.height - 64)];
        
    }
    else{
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewSize.height-44)];
    }
    _scrollView.contentSize =_scrollView.frame.size;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    collectionBgView = [[UIView alloc]init];
    collectionBgView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //左右Cell之间的间隔
    layout.minimumInteritemSpacing = 30;
    //上下Cell的间隔
    layout.minimumLineSpacing = 0;
    
    layout.itemSize = CGSizeMake(50, 70);
    //横向排列
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //页脚,,页眉的尺寸
    layout.headerReferenceSize = CGSizeMake(310, 0);
    layout.footerReferenceSize = CGSizeMake(310, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(7, 5, viewSize.width-20, [self collectionHeight:[self.groupMemberList count]]) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionView setShowsVerticalScrollIndicator:NO];
    [self.collectionView setScrollsToTop:NO];
    [self.collectionView setScrollEnabled:NO];
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView setAlwaysBounceVertical:YES];
    
    collectionBgView.frame = CGRectMake(5, 5, viewSize.width-10, self.collectionView.frame.size.height+10);
    UIImageView *line = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"speratechbgline"]];
    line.frame = CGRectMake(3, 38, viewSize.width-16, 3);
    
    UIImageView *line1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"speratechbgline"]];
    line1.frame = CGRectMake(3, 38, viewSize.width-16, 3);
    
    UIImageView *line2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"speratechbgline"]];
    line2.frame = CGRectMake(3, 38, viewSize.width-16, 3);
    
    UIImageView *line3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"speratechbgline"]];
    line3.frame = CGRectMake(3, 38, viewSize.width-16, 3);
    // 群聊名称
    groupNameBgView_Y = collectionBgView.frame.size.height + collectionBgView.frame.origin.y;
    gropNameBgView = [[UIView alloc]initWithFrame:CGRectMake(5, groupNameBgView_Y, viewSize.width-10, 40)];
    
    groupNameLab = [[UILabel alloc]initWithFrame:CGRectMake(5, 10,100, 20)];
    groupNameLab.text = LOCALIZATION(@"chat_groupname");
    groupNameLab.textColor = [UIColor blackColor];
    groupNameLab.backgroundColor = [UIColor clearColor];
    groupNameLab.font = [UIFont systemFontOfSize:16];
    
    groupName = [[UILabel alloc]initWithFrame:CGRectMake(gropNameBgView.frame.size.width - 100-5,10, 100, 20)];
    groupName.text = self.groupModel.groupName;
    groupName.textColor = [UIColor grayColor];
    groupName.backgroundColor = [UIColor clearColor];
    groupName.font = [UIFont systemFontOfSize:15];
    groupName.textAlignment = NSTextAlignmentRight;
    
    [gropNameBgView addSubview:groupNameLab];
    [gropNameBgView addSubview:groupName];
    [gropNameBgView addSubview:line];
    groupNameLab = nil;
    line = nil;

   // 创建人
    creatorBgView = [[UIView alloc]initWithFrame:CGRectMake(5, groupNameBgView_Y+42, viewSize.width-10, 40)];
    
   
    creatorLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10,100, 20)];
    creatorLabel.text = nil;
    creatorLabel.text = LOCALIZATION(@"chat_groupinfo_creator");
    creatorLabel.textColor = [UIColor blackColor];
    creatorLabel.backgroundColor = [UIColor clearColor];
    creatorLabel.font = [UIFont systemFontOfSize:16];
    
    creator = [[UILabel alloc]initWithFrame:CGRectMake(gropNameBgView.frame.size.width - 100-5,10, 100, 20)];
    creator.text = self.groupModel.creatorName;
    creator.textColor = [UIColor grayColor];
    creator.backgroundColor = [UIColor clearColor];
    creator.font = [UIFont systemFontOfSize:15];
    creator.textAlignment = NSTextAlignmentRight;
    
    [creatorBgView addSubview:creatorLabel];
    [creatorBgView addSubview:creator];
    [creatorBgView addSubview:line1];
    creatorLabel = nil;
    creator = nil;
    line1 = nil;
    // 创建时间
    creatorDateBgView = [[UIView alloc]initWithFrame:CGRectMake(5, groupNameBgView_Y+82, viewSize.width-10, 40)];
    
    
    creatorDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10,100, 20)];
    creatorDateLabel.text = nil;
    creatorDateLabel.text = LOCALIZATION(@"chat_groupinfo_createdate");
    creatorDateLabel.textColor = [UIColor blackColor];
    creatorDateLabel.backgroundColor = [UIColor clearColor];
    creatorDateLabel.font = [UIFont systemFontOfSize:16];
    
    creatorDate = [[UILabel alloc]initWithFrame:CGRectMake(gropNameBgView.frame.size.width - 100-5,10, 100, 20)];
    creatorDate.text = [[self.groupModel.addTime componentsSeparatedByString:@" "]firstObject];
    creatorDate.textColor = [UIColor grayColor];
    creatorDate.backgroundColor = [UIColor clearColor];
    creatorDate.font = [UIFont systemFontOfSize:15];
    creatorDate.textAlignment = NSTextAlignmentRight;
    
    [creatorDateBgView addSubview:creatorDateLabel];
    [creatorDateBgView addSubview:creatorDate];
    [creatorDateBgView addSubview:line2];
    creatorDateLabel = nil;
    creatorDate = nil;
    line2 = nil;
    
    // 群备注
    groupMemoBgView = [[UIView alloc]initWithFrame:CGRectMake(5, groupNameBgView_Y+122, viewSize.width-10, 40)];
    
    
    groupMemoLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10,100, 20)];
    groupMemoLabel.text = nil;
    groupMemoLabel.text = LOCALIZATION(@"chat_groupinfo_memo");
    groupMemoLabel.textColor = [UIColor blackColor];
    groupMemoLabel.backgroundColor = [UIColor clearColor];
    groupMemoLabel.font = [UIFont systemFontOfSize:16];
    
    if ([self isCreator]) {
    
    groupMemo = [[UILabel alloc]initWithFrame:CGRectMake(gropNameBgView.frame.size.width -200-5,10, 200, 20)];
        if ([self.groupModel.memo isEqualToString:@""] || self.groupModel.memo == NULL) {
            groupMemo.text = LOCALIZATION(@"chat_groupinfo_memo_hint");
        }
        else{
            groupMemo.text = self.groupModel.memo;
        }
    groupMemo.textColor = [UIColor grayColor];
    groupMemo.backgroundColor = [UIColor clearColor];
    groupMemo.font = [UIFont systemFontOfSize:15];
    groupMemo.textAlignment = NSTextAlignmentRight;
    [groupMemoBgView addSubview:groupMemo];
    
    // 添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addMemotapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [groupMemoBgView addGestureRecognizer:tap];
    tap = nil;
        
        // 添加点击事件
        UITapGestureRecognizer *groupTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(alertNametapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
       [gropNameBgView addGestureRecognizer:groupTap];
        groupTap = nil;
    }
    [groupMemoBgView addSubview:groupMemoLabel];
    [groupMemoBgView addSubview:line3];
    groupMemoLabel = nil;
    line3 = nil;
    
    
    //进入群聊按钮
    comeinChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    comeinChatBtn.backgroundColor = GETColor(233, 233, 233);
    comeinChatBtn.layer.cornerRadius = 5;
    comeinChatBtn.tag = comeInChat_tag;
    //[comeinChatBtn setBackgroundImage:[UIImage imageNamed:@"button_bj_b"] forState:UIControlStateNormal];
    comeinChatBtn.frame = CGRectMake(5, groupMemoBgView.frame.size.height+groupMemoBgView.frame.origin.y+20, viewSize.width-10, 30);
    [comeinChatBtn setTitle:LOCALIZATION(@"chat_beginchat") forState:UIControlStateNormal];
    [comeinChatBtn setTitleColor:GETColor(97, 97, 97) forState:UIControlStateNormal];
    [comeinChatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    comeinChatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    comeinChatBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    // 删除群组或退出
    delChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delChatBtn.backgroundColor = GETColor(229, 56, 57);
    delChatBtn.layer.cornerRadius = 5;
    delChatBtn.tag = delInChat_tag;
    delChatBtn.frame = CGRectMake(5, comeinChatBtn.frame.size.height+comeinChatBtn.frame.origin.y+10, viewSize.width-10, 30);
    [delChatBtn setTitle:LOCALIZATION(@"button_delAndexit") forState:UIControlStateNormal];
    [delChatBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [delChatBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    delChatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    delChatBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    
    [collectionBgView addSubview:self.collectionView];
    [_scrollView addSubview:collectionBgView];
    
    [_scrollView addSubview:gropNameBgView];
    [_scrollView addSubview:creatorBgView];
    [_scrollView addSubview:creatorDateBgView];
    [_scrollView addSubview:groupMemoBgView];
    [_scrollView addSubview:comeinChatBtn];
    [_scrollView addSubview:delChatBtn];
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, delChatBtn.frame.size.height+delChatBtn.frame.origin.y+10);
    line = nil;
    line1 = nil;
    line2 = nil;
    line3 = nil;
    
    [self.view addSubview:_scrollView];
    
}
// 自适应高度
- (void)adaptiveHeight
{
    self.collectionView.frame =  CGRectMake(7, 5, viewSize.width-20, [self collectionHeight:[self.groupMemberList count]]);
    collectionBgView.frame = CGRectMake(5, 5, viewSize.width-10, self.collectionView.frame.size.height+10);
    collectionBgView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    groupNameBgView_Y = collectionBgView.frame.size.height + collectionBgView.frame.origin.y;
    NSLog(@"%f",groupNameBgView_Y);
    gropNameBgView.frame = CGRectMake(5, groupNameBgView_Y, viewSize.width-10, 40);
    creatorBgView.frame = CGRectMake(5, groupNameBgView_Y+42, viewSize.width-10, 40);
    creatorDateBgView.frame= CGRectMake(5, groupNameBgView_Y+82, viewSize.width-10, 40);
    groupMemoBgView.frame = CGRectMake(5, groupNameBgView_Y+122, viewSize.width-10, 40);
    comeinChatBtn.frame = CGRectMake(5, groupMemoBgView.frame.size.height+groupMemoBgView.frame.origin.y+20, viewSize.width-10, 30);
    delChatBtn.frame = CGRectMake(5, comeinChatBtn.frame.size.height+comeinChatBtn.frame.origin.y+10, viewSize.width-10, 30);
    _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width, delChatBtn.frame.size.height+delChatBtn.frame.origin.y+10);

}
// 进入群聊和退出群的事件
- (void)btnClick:(UIButton *)sender
{
    // 添加群成员
    if (sender.tag == ADD_BTN_tag) {
        AddGroupMemberViewController *addGroupMember = [[AddGroupMemberViewController alloc]init];
        addGroupMember.groupId = self.groupModel.groupId;
        addGroupMember.groupName = self.groupModel.groupName;
        [self.navigationController pushViewController:addGroupMember animated:YES];
    }
    // 删除群成员
    else if (sender.tag == DEL_BTN_tag){
        DelGroupMemberViewController *delGroupMember = [[DelGroupMemberViewController alloc]init];
        delGroupMember.groupId = self.groupModel.groupId;
        delGroupMember.groupName = self.groupModel.groupName;
        [self.navigationController pushViewController:delGroupMember animated:YES];
    }
    // 进入群聊
   else if (sender.tag == comeInChat_tag) {
        VChatViewController *vc = [[VChatViewController alloc] init];
        vc.type = VChatType_pGroup;
        vc.recvId = [NSNumber numberWithInt:[self.groupModel.groupId intValue]];
        vc.recvFirstName = self.groupModel.groupName;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 删除并退出
    else if (sender.tag == delInChat_tag){
       
                NSString *alertcontext = LOCALIZATION(@"chat_groupinfo_deleteconfirm");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                NSString *alertNo = LOCALIZATION(@"button_cancel");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:alertNo,nil];
                alert.tag = codeDelOk_tag;
                [alert show];
            
    }
    // 取消按钮
    else if (sender.tag == dialogBtn_tag){
        [popOver dismiss];
    }
    // 提交群备注
    else if (sender.tag == subMitBtn_tag){
        [self submitMemo];
    }
    // 修改群聊名称
    else if (sender.tag == subMitName_tag){
        [self submitGroupName];
    }
    else{
        
    }
    
}
// 提交备注
- (void)submitMemo{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupId":self.groupModel.groupId,@"memo":addGroupName.text};
    [AFRequestService responseData:CHANGE_GROUP_MEMO andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            [UserAddedGroupDB updateGroupInfoByFeild:nil andValue:addGroupName.text andKey:@"memo" andGroupId:self.groupModel.groupId];
            NSString *alertcontext = LOCALIZATION(@"chat_group_membermemo_success");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            alert.tag = codeSuccess_tag;
            [alert show];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            GroupMemberListViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self submitMemo];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
        
        
        else{
            return;
        }
        
    }];
}
//
- (void)submitGroupName{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupId":self.groupModel.groupId,@"groupName":alertGroupName.text};
    [AFRequestService responseData:CHANG_GROUP_NAME andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            [UserAddedGroupDB updateGroupInfoByFeild:nil andValue:alertGroupName.text andKey:@"groupName"andGroupId:self.groupModel.groupId];
            NSString *alertcontext = LOCALIZATION(@"chat_group_membermemo_success");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            alert.tag = codeSuccess_Nametag;
            [alert show];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            GroupMemberListViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self submitGroupName];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
        
        
        else{
            return;
        }
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == codeSuccess_tag) {
        [popOver dismiss];
        groupMemo.text = addGroupName.text;
    }
    else if (alertView.tag == codeSuccess_Nametag){
        [popOver dismiss];
        groupName.text = alertGroupName.text;
    }
    else if (alertView.tag == codeError_tag){
        
    }
    else if (alertView.tag == codeDelOk_tag){
        if (buttonIndex == 0) {
            [self delGroup];
        }
        else{
            return;
        }
        
    }
    else{
        
    }
}
// 删除群组
- (void)delGroup{
    [userContactDB delContactInfo:self.groupModel.groupId];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"groupId":self.groupModel.groupId};
    [AFRequestService responseData:DEL_GROUP_URL andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            // 删除用户所在的本地群组
            [UserAddedGroupDB delGroupInfo:self.groupModel.groupId];
            //同时删除此用户组内的数据
            [GroupMember delGroupMemberInfo:self.groupModel.groupId];
            // 同是删除其在的聊天列表
            [userContactDB delContactInfo:self.groupModel.groupId];
            // 返回父控制器
            // 跳转到主界面
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate showControlView:Root_contact];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            GroupMemberListViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self delGroup];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];
        }
        else if (codeNum == CODE_OTHER){
            NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid":GET_S_ID,@"groupId": self.groupModel.groupId,@"delUserId":GET_USER_ID};
            [AFRequestService responseData:DEL_GROUP_MEMBER andparameters:parameters andResponseData:^(id responseData) {
                NSDictionary *dict = (NSDictionary *)responseData;
                NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                if (codeNum == CODE_SUCCESS) {
                    // 删除用户所在的本地群组
                    [UserAddedGroupDB delGroupInfo:self.groupModel.groupId];
                    //同时删除此用户组内的数据
                    [GroupMember delGroupMemberInfo:self.groupModel.groupId];
                    // 返回父控制器
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else if (codeNum == CODE_ERROE){
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    GroupMemberListViewController __weak *_Self = self;
                    [sqliteAndtable repeatLogin:^(BOOL flag) {
                        if (flag) {
                            [_Self delGroup];
                        }
                        else{
                            UserLoginViewController *login = [[UserLoginViewController alloc]init];
                            [_Self.navigationController pushViewController:login animated:YES];
                            login = nil;
                        }
                        
                    }];
                }
                else{
                    return;
                }
                
                
            }];
        }
        else{
            return;
        }
    }];
}
// 修改群名称
- (void)alertNametapAction{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    popOver = [[QiDiPopoverView alloc] init];
    [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatGroupNameView]];
}
// 群备注添加事件
- (void)addMemotapAction
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if(!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    
    popOver = [[QiDiPopoverView alloc] init];
    [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatGroup]];
}
//- (void)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.groupMemberList count];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell * collectionCell = [self.collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if ([self.groupMemberList count]) {
        GroupMemberList *model = (GroupMemberList *)self.groupMemberList[indexPath.row];
        [collectionCell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        collectionCell.lable.text = model.firstname;
    }
        return collectionCell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]init];
    FriendIfo *friendModel = [[FriendIfo alloc]init];
    GroupMemberList *model = (GroupMemberList *)self.groupMemberList[indexPath.row];
    friendModel.dstUserId = model.userId;
    friendDetail.friendModel = friendModel;
    [self.navigationController pushViewController:friendDetail animated:YES];
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
// 动态确定collectionView的高度
- (CGFloat)collectionHeight:(NSInteger)count
{
    NSInteger i = 0;
    if (count % 4 == 0) {
        i = count/4;
    }
    else{
        i = count/4 + 1;
    }
    return 70.0 * i;
}

- (UIView *)creatGroup{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 64, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor blackColor];
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 40)];
    groupNameLabel.text = LOCALIZATION(@"chat_groupinfo_memo");
    groupNameLabel.textColor = [UIColor whiteColor];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:groupNameLabel];
    
    UIImageView *lineBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, contaiterView.frame.size.width, 2)];
    lineBg1.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg1];
    
    addGroupName = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, contaiterView.frame.size.width-10, 30)];
    [addGroupName setBorderStyle:UITextBorderStyleLine];
    addGroupName.layer.borderColor = [[UIColor orangeColor]CGColor];
    addGroupName.font = [UIFont systemFontOfSize:16];
    addGroupName.textColor = [UIColor whiteColor];
    addGroupName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    addGroupName.keyboardAppearance = UIKeyboardAppearanceDefault;
    addGroupName.keyboardType = UIKeyboardTypeDefault;
    addGroupName.returnKeyType = UIReturnKeyGo;
    addGroupName.tag = 101;
    [addGroupName becomeFirstResponder];
    addGroupName.delegate = self;
    [contaiterView addSubview:addGroupName];
    
    UIImageView *lineBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 90, contaiterView.frame.size.width-10, 4)];
    lineBg2.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg2];
    
    UIButton *dialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialogBtn.frame = CGRectMake(30, 120, 70, 40);
    dialogBtn.backgroundColor = [UIColor clearColor];
    dialogBtn.tag = dialogBtn_tag;
    [dialogBtn setTitle:LOCALIZATION(@"dialog_cancel") forState:UIControlStateNormal];
    [dialogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    dialogBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dialogBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(150, 120, 70, 40);
    subMitBtn.backgroundColor = [UIColor clearColor];
    subMitBtn.tag = subMitBtn_tag;
    [subMitBtn setTitle:LOCALIZATION(@"button_submit") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subMitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:dialogBtn];
    [contaiterView addSubview:subMitBtn];
    
    return contaiterView;
}

- (UIView *)creatGroupNameView{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 64, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor blackColor];
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 40)];
    groupNameLabel.text = LOCALIZATION(@"chat_groupname");
    groupNameLabel.textColor = [UIColor whiteColor];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:groupNameLabel];
    
    UIImageView *lineBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, contaiterView.frame.size.width, 2)];
    lineBg1.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg1];
    
    alertGroupName = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, contaiterView.frame.size.width-10, 30)];
    [alertGroupName setBorderStyle:UITextBorderStyleLine];
    alertGroupName.layer.borderColor = [[UIColor orangeColor]CGColor];
    alertGroupName.font = [UIFont systemFontOfSize:16];
    alertGroupName.textColor = [UIColor whiteColor];
    alertGroupName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    alertGroupName.keyboardAppearance = UIKeyboardAppearanceDefault;
    alertGroupName.keyboardType = UIKeyboardTypeDefault;
    alertGroupName.returnKeyType = UIReturnKeyGo;
    [alertGroupName becomeFirstResponder];
    alertGroupName.delegate = self;
    [contaiterView addSubview:alertGroupName];
    
    UIImageView *lineBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 90, contaiterView.frame.size.width-10, 4)];
    lineBg2.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg2];
    
    UIButton *dialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialogBtn.frame = CGRectMake(30, 120, 70, 40);
    dialogBtn.backgroundColor = [UIColor clearColor];
    dialogBtn.tag = dialogName_tag;
    [dialogBtn setTitle:LOCALIZATION(@"dialog_cancel") forState:UIControlStateNormal];
    [dialogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    dialogBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dialogBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(150, 120, 70, 40);
    subMitBtn.backgroundColor = [UIColor clearColor];
    subMitBtn.tag = subMitName_tag;
    [subMitBtn setTitle:LOCALIZATION(@"button_submit") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subMitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:dialogBtn];
    [contaiterView addSubview:subMitBtn];
    
    return contaiterView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        HUD = nil;
        popOver = nil;
        addGroupName = nil;
        alertGroupName = nil;
        loginLabel = nil;
    
        _scrollView = nil;
        collectionBgView = nil;
    
        gropNameBgView = nil;
        groupNameLab = nil;
        groupName = nil;
    
        creatorBgView = nil;
        creatorLabel = nil;
        creator = nil;
    
        creatorDateBgView = nil;
        creatorDateLabel = nil;
        creatorDate = nil;
    
        groupMemoBgView = nil;
        groupMemoLabel = nil;
        groupMemo = nil;
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    HUD = nil;
    popOver = nil;
    addGroupName = nil;
    alertGroupName = nil;
    loginLabel = nil;
    
    _scrollView = nil;
    collectionBgView = nil;
    
    gropNameBgView = nil;
    groupNameLab = nil;
    groupName = nil;
    
    creatorBgView = nil;
    creatorLabel = nil;
    creator = nil;
    
    creatorDateBgView = nil;
    creatorDateLabel = nil;
    creatorDate = nil;
    
    groupMemoBgView = nil;
    groupMemoLabel = nil;
    groupMemo = nil;
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
