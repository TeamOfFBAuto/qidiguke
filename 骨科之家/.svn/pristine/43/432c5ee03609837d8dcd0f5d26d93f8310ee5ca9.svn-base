//
//  GroupsViewController.m
//  VColleagueChat
//
//  Created by lqy on 4/22/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "GroupsViewController.h"
#import "UINavigationItem+selfArchItem.h"
#import "RSSwitch.h"
#import "GrouplistsTableViewCell.h"
#import "VChatViewController.h"
#import "ContactsListViewController.h"
#import "ASIFormDataRequest.h"
#import "VChatModel.h"
#import "LatestListModel.h"
#import "Cache.h"
#import "SqliteBase.h"
@interface GroupsViewController ()<UITableViewDataSource,UITableViewDelegate,GrouplistsTableViewCellDelegate>{
    RSSwitch *rsSwitch;
    
    UIButton *refreshBtn;
    
    UITableView *_tableView;
    ASIFormDataRequest *listReql;
    
    ASIFormDataRequest *vChatReql;
    
    ASIFormDataRequest *vLatListReql;
    
    NSInteger indexPop;
}

#if ! __has_feature(objc_arc)
@property (nonatomic,retain) LatestListModel *chatNewModel;
@property (nonatomic,retain) NSMutableArray *dataSoureArr;
//@property (nonatomic,retain) NSMutableArray *dataSoureArrB;
#else
@property (nonatomic,strong) LatestListModel *chatNewModel;
@property (nonatomic,strong) NSMutableArray *dataSoureArr;
//@property (nonatomic,strong) NSMutableArray *dataSoureArrB;
#endif

@end

@implementation GroupsViewController


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    ASISafeRelease(vLatListReql)
    ASISafeRelease(vChatReql)
    ASISafeRelease(listReql);
    
    SSRCRelease(rsSwitch);
    SSRCRelease(_tableView);
    SSRCSafeRelease(_dataSoureArr);
//    SSRCSafeRelease(_dataSoureArrB)
    SSRCSuperDealloc;
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7_OR_LATER) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
//        self.dataSoureArr = [NSMutableArray arrayWithObjects:@"V聊",@"销售群",@"测试",@"测试群主", nil];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    indexPop = INT_MAX;
    [self prepareLoadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self layoutView];
    [self prepareLoadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGChat:) name:kPushNewGChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushGPChat:) name:kPushNewGPChat object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushPChat:) name:kPushNewPChat object:nil];
    
    //// stoping the process in app backgroud state
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterInBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterInforground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)returnClick{
    return;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutView{
    [self.navigationItem selfArchSetReturnAnimated:NO Sel:@selector(returnClick) target:self];
    [self.navigationItem selfArchSetTitle:@"V聊"];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 70, 34);
    [btn setTitle:@"增加群组" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setBackgroundImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(addGroup) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:btn];
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    
    CGFloat heightForBac = 50.0f;
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, heightForBac)];
    [self.view addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"group_middle.png"];
    imgView.userInteractionEnabled = YES;
    imgView.backgroundColor = [UIColor grayColor];
    
    // 选择切换按钮
    rsSwitch = [[RSSwitch alloc] initWithFrame:CGRectMake(10, 10, 220, 30) leftImgNormal:[UIImage imageNamed:@"button_left_default"] leftImgSelect:[UIImage imageNamed:@"button_left_select"] rightImgNormal:[UIImage imageNamed:@"button_right_default"] rightImgSelect:[UIImage imageNamed:@"button_right_select"]];
    
    [rsSwitch setLeftTilte:@"系统群组" lColor:RGB(103, 26, 96) RightTitle:@"最近联系人" rColor:RGB(0, 0, 0)];
    [imgView addSubview:rsSwitch];
    
    refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.frame = CGRectMake(260, 15, 50, 30);
    [refreshBtn setBackgroundImage:[UIImage imageNamed:@"btn_group_refresh.png"] forState:UIControlStateNormal];
    [refreshBtn setTitle:@"刷新" forState:UIControlStateNormal];
    refreshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [refreshBtn setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    __block GroupsViewController *weakSelf = self;
    rsSwitch.switchSelcet = ^(NSInteger select){
        [weakSelf switchSelect:select];
    };
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, heightForBac, 320, SCREEN_HEIGHT-64-heightForBac)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = RGBA(110, 110, 110, .4);
    [self.view addSubview:_tableView];

    SSRCRelease(right);
    SSRCRelease(imgView);
    
}
- (void)refresh:(UIButton *)sender{
    
}
- (void)addGroup{
    ContactsListViewController *vc = [[ContactsListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    SSRCRelease(vc);
}
- (void)switchSelect:(NSInteger)t{
    [self prepareLoadData];
}


#pragma mark tableview delegate datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [GrouplistsTableViewCell heightForViewWithObject:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (rsSwitch.switchTag == 0) return self.dataSoureArr.count+1;
    return self.dataSoureArr.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellInde = @"cellIndentGrouplistcell";
    static NSString *cellIndeSys = @"cellIndentGrouplistcellsys";
    GrouplistsTableViewCell *cell = nil;
    if (indexPath.row == 0 && rsSwitch.switchTag == 0) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndeSys];
        if (!cell) {
            cell = [[GrouplistsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndeSys type:YES];
            cell.delegate = self;
            SSRCAutorelease(cell)
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellInde];
        if (!cell) {
            cell = [[GrouplistsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellInde];
            cell.delegate = self;
            SSRCAutorelease(cell)
        }
    }
    if (rsSwitch.switchTag == 0) {
        if (indexPath.row) {
            [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row-1] withObject:1 withType:YES];
        }else{
            [cell fillViewWithObject:_chatNewModel withObject:0 withType:NO];
        }
    }
    else{
        [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row] withObject:2 withType:NO];
    }
    return cell;
}

// 进入聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VChatViewController *vc = [[VChatViewController alloc] init];
    NSLog(@"%d",indexPath.row);
    if (rsSwitch.switchTag == 0 ) {
        if (indexPath.row) {
            vc.type = VChatType_pGroup;
            LatestListModel *model = [self.dataSoureArr objectAtIndex:indexPath.row-1];
            NSLog(@"%d",indexPath.row-1);
            model.isNewMsg = NO;
            vc.recvId = [NSNumber numberWithInt:[[model l_groupId] intValue]];
        }else{
            self.chatNewModel.isNewMsg = NO;
        }
    }
    else if (rsSwitch.switchTag == 1){
        LatestContactModel *model = [self.dataSoureArr objectAtIndex:indexPath.row] ;
        if (model.contactType == ContactType_P) {
            vc.type = VChatType_pChat;
            vc.recvId = [NSNumber numberWithInt:[model.c_contactId intValue]];
            vc.recvName = model.c_contactUsername;
            NSLog(@"私信对象:%@,%@",model.c_contactId,model.c_contactUsername);
        }else if (model.contactType == ContactType_Group){
            vc.type = VChatType_pGroup;
            vc.recvId = [NSNumber numberWithInt:[model.c_contactId intValue]];
        }else{
            return;
        }
        model.isNewMsg = NO;
        NSLog(@"私信对象:%@,%@,%@",model.c_contactType,model.c_contactId,model.c_contactUsername);
    }
    [self.navigationController pushViewController:vc animated:YES];
    [_tableView reloadData];
    indexPop = indexPath.row;
    SSRCRelease(vc)
}


#pragma mark cell delegate
- (void)detailCell:(GrouplistsTableViewCell *)cell{
    NSIndexPath *indexpath = [_tableView indexPathForCell:cell];
    if (indexpath) {
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- group list
- (void)getUserContact{
    ASISafeRelease(listReql);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithBool:0] forKey:@"page"];
    [dic setObject:[NSNumber numberWithInteger:15] forKey:@"pageSize"];
    listReql = [HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_USERADDEDGROUPLIST userCommon:YES];
    SSRCRetain(listReql);
    
    [listReql setDelegate:self];
    [listReql setDidFailSelector:@selector(fail:)];
    [listReql setDidFinishSelector:@selector(finish:)];
    [listReql startAsynchronous];
}
#pragma mark ---- 接听推送消息 获取推送消息之后是刷新操作还是 直接获取推送的消息呢  这块得考虑 获取推送消息有可能不全得情况
- (void)getVchat{
    ASISafeRelease(vChatReql)
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInteger:15] forKey:@"pageSize"];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"page"];
    vChatReql = [HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_NEWBOARDARTICLE userCommon:YES];
    SSRCRetain(vChatReql);
    
    [vChatReql setDelegate:self];
    [vChatReql setDidFailSelector:@selector(fail:)];
    [vChatReql setDidFinishSelector:@selector(finish:)];
    [vChatReql startAsynchronous];
}
- (void)getLatChat{
    ASISafeRelease(vLatListReql)
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    vLatListReql = [HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_USERCONTACT userCommon:YES];
    SSRCRetain(vLatListReql);
    
    [vLatListReql setDelegate:self];
    [vLatListReql setDidFailSelector:@selector(fail:)];
    [vLatListReql setDidFinishSelector:@selector(finish:)];
    [vLatListReql startAsynchronous];
}
// 请求失败
- (void)fail:(ASIHTTPRequest *)request{
 
}
// 请求成功
- (void)finish:(ASIHTTPRequest *)request{
    NSString *response = [[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding];
    SSRCAutorelease(response);
    NSDictionary *dic = [response JSONValue];
    if (request.responseStatusCode == 200 && [[NSString stringWithFormat:@"%@",[dic objectForKey:CKEY]]isEqualToString:SUC_CKEY]){
        if (request == vChatReql) {
            id data = [dic objectForKey:@"latestArticle"];
            
            if (data && [data isKindOfClass:[NSDictionary class]]) {
                NSArray *ad = [VChatModel vChatMakeModel:[NSArray arrayWithObject:data]];
                if (ad.count) {
                    if (!self.chatNewModel) {
                        LatestListModel *m = [[LatestListModel alloc] init] ;
                        self.chatNewModel = m;
                        SSRCRelease(m)
                    }
                    self.chatNewModel.latestArticleModel = [ad objectAtIndex:0];
                    if ([SqliteBase isInDataBase:[NSString stringWithFormat:@"%d",self.chatNewModel.latestArticleModel.articleId]]) {
                        self.chatNewModel.isNewMsg = YES;
                    }
                }
                [_tableView reloadData];
                
            }
        }else if (request == listReql){
            id datas = [dic objectForKey:@"grouplist"];
            [self updata:[LatestListModel makeModel:datas withType:NO] type:1];
            [Cache wirteInCacheFoler:datas withPath:[Cache cacheNameWithURL:SUB_URL_USERADDEDGROUPLIST]];
            
            
        }else if (request == vLatListReql){
            id datas = [dic objectForKey:@"contactlist"];
           
            [self updata:[LatestContactModel makeModel:datas withType:NO] type:2];
            [Cache wirteInCacheFoler:datas withPath:[Cache cacheNameWithURL:SUB_URL_USERCONTACT]];
        }
    }
}
// 进行数据的更新
- (void)updata:(NSArray *)datas type:(NSInteger)t{
    NSInteger b = 0;
    if (t == 1) {
        b = 0;
//        self.dataSoureArr = [NSMutableArray arrayWithArray:datas];
    }else if (t == 2){
        b = 1;
    }
    if (rsSwitch.switchTag == b) {
        self.dataSoureArr = [NSMutableArray arrayWithArray:datas];
        [_tableView reloadData];
    }
}


#pragma mark --
- (void)prepareLoadData{
    if (rsSwitch.switchTag == 0) {
        [self prepareLoadL];
    }else{
        [self prepareLoadR];
    }
}

- (void)prepareLoadL{
    if (!_dataSoureArr) {
        self.dataSoureArr = [NSMutableArray array];
    }
    [self.dataSoureArr removeAllObjects];
    id cache = [NSArray arrayWithContentsOfFile:[Cache cacheNameWithURL:SUB_URL_USERADDEDGROUPLIST]];
    if (cache && [cache isKindOfClass:[NSArray class]]) {
        self.dataSoureArr = [NSMutableArray arrayWithArray:[LatestListModel makeModel:cache withType:NO]];
    }
    [_tableView reloadData];
    [self getVchat];
    [self getUserContact];
}
- (void)prepareLoadR{
    if (!_dataSoureArr) {
        self.dataSoureArr = [NSMutableArray array];
    }
    [self.dataSoureArr removeAllObjects];
    id cache = [NSArray arrayWithContentsOfFile:[Cache cacheNameWithURL:SUB_URL_USERCONTACT]];
    if (cache && [cache isKindOfClass:[NSArray class]]) {
        self.dataSoureArr = [NSMutableArray arrayWithArray:[LatestContactModel makeModel:cache withType:NO]];
    }
    [_tableView reloadData];
    [self getLatChat];
}

#pragma mark -- noti
- (void)pushGChat:(id)noti{
    NSLog(@"收到V群聊信息");
    [self getVchat];
}
- (void)pushGPChat:(id)noti{
    NSLog(@"收到新的群组聊天信息");
    [self getUserContact];
    [self getLatChat];
}
- (void)pushPChat:(id)noti{
    
    [self getLatChat];
}
//先读取缓存数据
/*
 Notification method handler when app enter in forground
 @param the fired notification object
 */
- (void)appEnterInforground:(NSNotification*)notification{
    [self getLatChat];
    [self getUserContact];
    [self getVchat];
}
/*
 Notification method handler when app enter in background
 @param the fired notification object
 */
- (void)appEnterInBackground:(NSNotification*)notification{
    
}

/*
 articleId = 0;
 isGroupArticle = 0;
 order = 1;
 recordCount = 5;
 recvId = 246;
 sid = 8BB79278;
 sort = 0;
 typeId = 10;
 userId = 41;
 */
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
