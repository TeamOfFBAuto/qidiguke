//
//  VChatViewController.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import "VChatViewController.h"
#import "BubbleCell.h"
#import "Toolbar.h"

#import "VoiceRecorderBaseVC.h"
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"

#import "UUID.h"

#import "VChatModel.h"
#import "GetDateFormater.h"
#import "VoicePlayCenter.h"

#import "UIImage+UIImageExt.h"
#import "UIImage+fixOrientation.h"

#import "SDImageCache.h"
#import "SqliteBase.h"

#import "PullTableView.h"
#import "FriendDetailViewController.h"
#import "GroupMemberListViewController.h"
#import "UserLoginViewController.h"
#import "UserAddedGroupDB.h"
#import "interface.h"
#import "GroupList.h"
#import "LoadToLocal.h"

@interface VChatViewController ()<PullTableViewDelegate,UITableViewDataSource,UITableViewDelegate,ToolbarDelegate,VoicePlayCenterDelegate,BubbleCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    PullTableView *_tableView;
    Toolbar *toolBar;
    NSMutableArray *objectArry;
    
    ASIFormDataRequest *listRequest;
    VoicePlayCenter *voicePlayCenter;
    NSMutableArray *_groupList;
    GroupList *groupModel;
    
    UIView *background;
    UIImageView *imgViewExtend;
}
#if !__has_feature(objc_arc)
@property (nonatomic,retain) NSMutableArray *dataSoureArr;
@property (retain, nonatomic)  ChatVoiceRecorderVC      *recorderVC;
@property (nonatomic,retain) NSOperationQueue *sendQueue;
@property (nonatomic,retain) NSDictionary *selfTypeDic;
#else
@property (nonatomic,strong) NSMutableArray *dataSoureArr;
@property (strong, nonatomic)  ChatVoiceRecorderVC      *recorderVC;
@property (nonatomic,strong) NSOperationQueue *sendQueue;
@property (strong, nonatomic) NSDictionary *selfTypeDic;
#endif




@end

@implementation VChatViewController
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NEW object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SSRCSafeRelease(_recvName);
    SSRCSafeRelease(_recvId);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    ASISafeRelease(listRequest);
    
    for (ASIFormDataRequest *req in self.sendQueue.operations) {
        ASISafeRelease(req);
    }
    [_sendQueue cancelAllOperations];
    SSRCSafeRelease(_sendQueue);
    SSRCSafeRelease(voicePlayCenter);
    
    
    SSRCSafeRelease(_selfTypeDic);
    SSRCSafeRelease(_recorderVC);
    SSRCRelease(toolBar);
    SSRCSafeRelease(_dataSoureArr);
    SSRCRelease(_tableView);
     SSRCRelease(groupModel);
    SSRCSuperDealloc;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PUSH_NEW object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (IOS7_OR_LATER) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        objectArry = [[NSMutableArray alloc] init];
        _groupList = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self navigetion];
    self.selfTypeDic = [self dicWithVType:_type];
    
    [self layoutView];
    [self prepareToGetData];
    [self getGroupList];
    // 监听推送通知消息（实现消息消息的即时获取）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noti:) name:PUSH_NEW object:nil];
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"] ];
    UIImageView *logoView = [[UIImageView alloc]initWithImage:image];
    [image release];
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = self.recvFirstName;
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    [logoView release];
    [loginLabel release];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [bgNavi addGestureRecognizer:tap];
    [tap release];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    [bgNavi release];
    self.navigationItem.leftBarButtonItem = leftItem;
    [leftItem release];
    
    UIButton * personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    personBtn.frame = CGRectMake(0, 10, 23, 23);
    [personBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_bj_peo@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    if (self.type == VChatType_VC) {
        personBtn.hidden = YES;
    }
    
    [personBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:personBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    [rightitem release];
}
- (void)tapAction{
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取本地数据
- (void)getGroupList
{
    [_groupList removeAllObjects];
    [_groupList addObjectsFromArray:[UserAddedGroupDB selectFeildString:nil andcuId:GET_USER_ID]];
    for (GroupList *model in _groupList) {
        NSLog(@"%@",model.groupId);
        if([[NSString stringWithFormat:@"%@",self.recvId] isEqualToString:model.groupId]){
            groupModel = [[GroupList alloc] init];
            groupModel = [model retain];
        }
        
    }
    [_groupList release];
}
- (void)btnClick{
    if (self.type == VChatType_pGroup) {
        GroupMemberListViewController *Gmvc = [[GroupMemberListViewController alloc] init];
        Gmvc.groupModel = groupModel;
        [self.navigationController pushViewController:Gmvc animated:YES];
        //[groupModel release];
        [Gmvc release];
        
    }else{
        FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]initWithUserId:[NSString stringWithFormat:@"%@",self.recvId]];
        [self.navigationController pushViewController:friendDetail animated:YES];
        [friendDetail release];
    }

}
- (void)layoutView{
    self.view.backgroundColor = [UIColor whiteColor];
    //整个视图上添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    // 创建下拉上拉得tableview 进入PullTableView理解 使用了EGOTableViewPullRefresh
    _tableView = [[PullTableView alloc] initWithFrame:CGRectMake(0, 0, 320,SCREEN_HEIGHT-64-defaultToolbarHeight) style:UITableViewStylePlain with:Dragging_upRefresh];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundView = nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.pullDelegate = self;
    [self.view addSubview:_tableView];
    
    toolBar = [[Toolbar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-defaultToolbarHeight - 64, 0, 0)];
    toolBar.delegate = self;
    [toolBar showInView:self.view withValidHeight:SCREEN_HEIGHT - 64];
}
   // toolBar的frame变化
- (void)toolViewDidChangeFrame:(Toolbar *)textView{
    CGRect r = _tableView.frame;
    r.size.height = toolBar.frame.origin.y;
    _tableView.frame = r;
    if (self.dataSoureArr.count) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSoureArr.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    VChatModel *model = [_dataSoureArr objectAtIndex:indexPath.row];
    CGFloat height = 0.0f;
    // 自适应高度
    if (model.shareSource.length == 0) {
        
    
    if (model.sendType == SEND_Type_content) {
        height = [BubbleSubTextCell heightForViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
    }else if (model.sendType == SEND_Type_voice){
        height = [BubbleSubVoiceCell heightForViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
    }else if (model.sendType == SEND_Type_photo){
        height = [BubbleSubImageCell heightForViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
    }
}
    else {
        height = [BubbleSubShareCell heightForViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
    }
    return  height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSoureArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *bubbleCell00 = @"bubbleCell00";// 分享来源的cell
    static NSString *bubbleCell01 = @"bubbleCell01";
    static NSString *bubbleCell02 = @"bubbleCell02";
    static NSString *bubbleCell03 = @"bubbleCell03";
   
    VChatModel *model = [_dataSoureArr objectAtIndex:indexPath.row];
    NSLog(@"%@",model.shareSource);
    if(model.shareSource.length == 0){
    // 绑定文本内容
    if (model.sendType == SEND_Type_content) {
        BubbleSubTextCell *cell = [tableView dequeueReusableCellWithIdentifier:bubbleCell01];
        if (!cell) {
            cell = [[BubbleSubTextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubbleCell01];
            cell.delegate = self;
            SSRCAutorelease(cell);
        }
        cell.tag = indexPath.row;
        [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
        cell.block = ^(NSString *str)
        {
            FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:str];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.dstUserId = str;
            model.dstUser = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:str];
            fdvc.friendModel = model;
            [self.navigationController pushViewController:fdvc animated:YES];
            [fdvc release];
        };
        return cell;
    }
    // 绑定声音内容
    else if (model.sendType == SEND_Type_voice){
        BubbleSubVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:bubbleCell02];
        if (!cell) {
            cell = [[BubbleSubVoiceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubbleCell02];
            cell.delegate = self;
            SSRCAutorelease(cell);
        }
        cell.block = ^(NSString *str)
        {
            FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:str];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.dstUserId = str;
            model.dstUser = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:str];
            fdvc.friendModel = model;
            [self.navigationController pushViewController:fdvc animated:YES];
            [fdvc release];
        };
        [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
        return cell;
    }
    // 绑定图片内容
    else if (model.sendType == SEND_Type_photo){
        BubbleSubImageCell *cell = [tableView dequeueReusableCellWithIdentifier:bubbleCell03];
        if (!cell) {
            cell = [[BubbleSubImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubbleCell03];
            cell.delegate = self;
            SSRCAutorelease(cell);
        }
        cell.block = ^(NSString *str)
        {
            FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:str];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.dstUserId = str;
            model.dstUser = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:str];
            fdvc.friendModel = model;
            [self.navigationController pushViewController:fdvc animated:YES];
            [fdvc release];
        };
        [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
        return nil;
    }
   }
    else{
        BubbleSubShareCell *cell = [tableView dequeueReusableCellWithIdentifier:bubbleCell00];
        if (!cell) {
            cell = [[BubbleSubShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bubbleCell00];
            cell.delegate = self;
            SSRCAutorelease(cell);
        }
        cell.block = ^(NSString *str)
        {
            FriendDetailViewController *fdvc = [[FriendDetailViewController alloc] initWithUserId:str];
            FriendIfo *model = [[FriendIfo alloc]init];
            model.dstUserId = str;
            model.dstUser = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:str];
            fdvc.friendModel = model;
            [self.navigationController pushViewController:fdvc animated:YES];
            [fdvc release];
        };
        [cell fillViewWithObject:[self.dataSoureArr objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}
#pragma mark--------table pull delegate
//上拉加载更多
-(void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView{
    [self getDataList:DRAG_DOWN];
}
// 下拉激活上面的
-(void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView{
    [self getDataList:DRAG_UP];
}
- (void)endPull{
    _tableView.pullTableIsLoadingMore = NO;
    _tableView.pullTableIsRefreshing = NO;
    _tableView.pullLastRefreshDate = [NSDate date];
}

#pragma mark --- cell delegate 单元格代理(语音的代理方法）
// 长按对未发送语音进行操作
- (void)longPageExcBubb:(id)object{
    [objectArry removeAllObjects];
    [objectArry addObject:object];
    if ([[object isSend] isEqualToString:ISNOSENT]) {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重发" otherButtonTitles:@"删除", nil];
        action.tag = 480;
        [action showInView:self.view];
        
    }
    else{
        return;
    }
    
}
// 点击播放声音的代理方法
- (void)pageExcBubble:(id)cell with:(id)content{
    if (!voicePlayCenter) {
        voicePlayCenter = [[VoicePlayCenter alloc] init];
        voicePlayCenter.playDelegate = self;// 播放声音的代理方法
        voicePlayCenter.playType = Play_chat;
    }
    PlayerModel *model = [[PlayerModel alloc] init];
    model.fileId = content;
    [voicePlayCenter downloadPlayVoice:[model autorelease]];
    
}
- (void)stopPlayVoice:(PlayerModel *)model{
    for (int i = 0; i < self.dataSoureArr.count; i++) {
        VChatModel *datamodel1 = [self.dataSoureArr objectAtIndex:i];
        
        VChatAttachModel *datamodel = nil;
        if ([datamodel1.attachlist count]) {
            datamodel = [datamodel1.attachlist firstObject];
        }
        if (datamodel && [model.fileId isEqualToString:datamodel.fileurl]) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            datamodel1.statusModel.isPlaying = NO;
            id cell = [_tableView cellForRowAtIndexPath:indexpath];
            if ([cell isKindOfClass:[BubbleSubVoiceCell class]]) {
                [cell stopVocicePlaybalck];
            }
        }
    }
}
- (void)startPlayVoice:(PlayerModel *)model{
    for (int i = 0; i < self.dataSoureArr.count; i++) {
        VChatModel *datamodel1 = [self.dataSoureArr objectAtIndex:i];
        
        VChatAttachModel *datamodel = nil;
        if ([datamodel1.attachlist count]) {
            datamodel = [datamodel1.attachlist firstObject];
        }
        if (datamodel && [model.fileId isEqualToString:datamodel.fileurl]) {
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
            datamodel1.statusModel.isPlaying = YES;
            id cell = [_tableView cellForRowAtIndexPath:indexpath];
            if ([cell isKindOfClass:[BubbleSubVoiceCell class]]) {
                [cell startVoicePlaybalck];
            }
        }
    }
}
#pragma mark --- cell delegate 单元格代理(图片的代理方法）
// 长按对未发送的图片进行操作
- (void)longPageExcBubbClickImage:(id)object{
    [objectArry removeAllObjects];
    [objectArry addObject:object];
    if ([[object isSend] isEqualToString:ISNOSENT]) {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重发" otherButtonTitles:@"删除", nil];
        action.tag = 479;
        [action showInView:self.view];
        
    }
    else{
        return;
    }
    
}
// 点击放大的代理
- (void)pageExcBubbleClickImage:(id)cell{
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    imgViewExtend = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    BubbleSubImageCell *imageCell = (BubbleSubImageCell *)cell;
    imgViewExtend.image = imageCell.pictureImageView.image;
    imgViewExtend.contentMode = UIViewContentModeScaleAspectFit;
    imgViewExtend.userInteractionEnabled = YES;
    [background addSubview:imgViewExtend];
    [self shakeToShow:imgViewExtend];//放大过程中的动画
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suoxiao)];
    tap.numberOfTapsRequired = 1;
    [imgViewExtend addGestureRecognizer:tap];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [imgViewExtend addGestureRecognizer:longPressGestureRecognizer];
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:background];
    [self.view.window.rootViewController.view addSubview:background];
}
#pragma mark --- cell delegate 单元格代理(图片的代理方法）
- (void)pageExcBubbleClickText:(id)cell with:(id)object
{
    [objectArry removeAllObjects];
    [objectArry addObject:object];
    if ([[object isSend] isEqualToString:ISNOSENT]) {
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"复制" otherButtonTitles:@"重发",@"删除", nil];
        action.tag = 478;
        [action showInView:self.view];
       
    }
    else{
        UIActionSheet *action = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"复制" otherButtonTitles:nil];
        action.tag = 477;
        [action showInView:self.view];
    }
    
}
//---------------------------------------------------------------------
#pragma mark - "分享图片"的放大以及保存 -

-(void)suoxiao
{
    [background removeFromSuperview];
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)_longpress
{
    if (_longpress.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    [self handleLongTouch];
    
}

//*************放大过程中出现的缓慢动画*************
- (void)shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)handleLongTouch {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    [sheet showInView:background];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 478) {
        id object = [objectArry firstObject];
        if(buttonIndex == 0){
            // 粘贴文字
            [[UIPasteboard generalPasteboard] setPersistent:YES];
            [[UIPasteboard generalPasteboard] setValue:[object context] forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        }
        else if(buttonIndex == 1){
            if ([object context].length) {
                // 重新发送，删除数据库内之前存在的数据
                [SqliteBase deleteData:nil andArticleId:[object articleId]];
                [self delUploadUI:object andreSend:1];
                [self sureUpload:[object context] withType:SEND_Type_content withuuid:[object uid]];
            }
        }
        else if(buttonIndex == 2){
            [SqliteBase deleteData:nil andArticleId:[object articleId]];
            [self delUploadUI:object andreSend:0];
        }
    }
    else if(actionSheet.tag == 477){
         id object = [objectArry firstObject];
        if(buttonIndex == 0){
            // 粘贴文字
            [[UIPasteboard generalPasteboard] setPersistent:YES];
            [[UIPasteboard generalPasteboard] setValue:[object context] forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
        }
        else{
            return;
        }
    }
    // 对图片的重发和删除操作
    else if(actionSheet.tag == 479){
        id object = [objectArry firstObject];
        if(buttonIndex == 0){
            // 重新发送，删除数据库内之前存在的数据
            [SqliteBase deleteData:nil andArticleId:[object articleId]];
            [self delUploadUI:object andreSend:1];
            NSString *path = [[[object attachlist] firstObject] filename];
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            [self sureUpload:image withType:SEND_Type_photo withuuid:[object uid]];
            // 删除本地文件
            [self delLocalFile:path];
        }
        else if(buttonIndex == 1){
            [SqliteBase deleteData:nil andArticleId:[object articleId]];
            [self delUploadUI:object andreSend:0];
        }

    }
    // 对语音的重发和删除操作
    else if(actionSheet.tag == 480){
        id object = [objectArry firstObject];
        if(buttonIndex == 0){
            // 重新发送，删除数据库内之前存在的数据
            [SqliteBase deleteData:nil andArticleId:[object articleId]];
            [self delUploadUI:object andreSend:1];
            NSString *path = [[[[[object attachlist] firstObject] fileurl] componentsSeparatedByString:@"."] firstObject];
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:path,@"fid",[[[object attachlist] firstObject] filename],@"fileName",[[[object attachlist] firstObject] voiceLength],@"length", nil];
            [self sureUpload:dic withType:SEND_Type_voice withuuid:[object uid]];
            // 删除本地文件
            //[self delLocalFile:path];
        }
        else if(buttonIndex == 1){
            [SqliteBase deleteData:nil andArticleId:[object articleId]];
            [self delUploadUI:object andreSend:0];
        }
        
    }
    else{
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        UIImageWriteToSavedPhotosAlbum(imgViewExtend.image, nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
    }
}
- (void)delLocalFile:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        [fileManager removeItemAtPath:path error:nil];
    }
    
}

//---------------------------------------------------------------------

#pragma mark ---------toolbar delegate

// 触发录音事件
- (void)recordStartQiDi
{
    NSString *originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    if (!self.recorderVC) {
        self.recorderVC = [[[ChatVoiceRecorderVC alloc]init] autorelease];
        _recorderVC.vrbDelegate = (id)self;
    }
    [self.recorderVC beginRecordByFileName:originWav];
}

// 结束录音事件
- (void)recordEndQiDi
{
    [self.recorderVC end];
}

// 聊天页面的ToolView
- (void)toolView:(Toolbar *)textView index:(NSInteger)index{
    
    if (index == 1){
        [self takePotoPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // 启用相册
    else if (index == 2){
        [self takePotoPicture:UIImagePickerControllerSourceTypeCamera];
    }
    // 发送按钮
    else if (index == 5){
        HPGrowingTextView *textViewWithTag = (HPGrowingTextView *)[textView viewWithTag:textView_tag_toolbar];
        NSString *temp = [textViewWithTag.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (temp.length>0) {
            NSString *uuid = [UUID createUUID];//创建通用的唯一标识
            [self sureUpload:textViewWithTag.text withType:SEND_Type_content withuuid:uuid];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"msg_newtext_empty") message:nil delegate:nil cancelButtonTitle:LOCALIZATION(@"known") otherButtonTitles: nil];
            [alertView show];
            SSRCRelease(alertView)
        }
        textViewWithTag.text = nil;

    }  
}
// 取消第一相应者的身份
- (void)tapClick:(UITapGestureRecognizer *)recoginzer{
    [toolBar endEditing:NO];
}
// 点击发送按钮执行（键盘上得事件）
- (BOOL)placeTextViewShouldReturn:(HPGrowingTextView *)textView{
    NSString *temp = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (temp.length) {
        NSString *uuid = [UUID createUUID];//创建通用的唯一标识
        [self sureUpload:textView.text withType:SEND_Type_content withuuid:uuid];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"msg_newtext_empty") message:nil delegate:nil cancelButtonTitle:LOCALIZATION(@"known") otherButtonTitles: nil];
        [alertView show];
        SSRCRelease(alertView)
    }
    textView.text = nil;
    return YES;
}
#pragma mark imagepicker delegate
-(void)takePotoPicture:(UIImagePickerControllerSourceType)sourceType{
    //指定图片来源
    //    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断如果摄像机不能用图片来源与图片库
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能使用相机" message:@"本地图片" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles: nil];
            [alertView show];
            [alertView release];
            return;
        }
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    //[[TabBarView sharedTabBarView] hideTabbar:YES animated:YES];
    [self presentViewController:picker animated:YES completion:^{}];
    [picker release];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [[[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation] retain];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 发送图片
    [self sureUpload:image withType:SEND_Type_photo withuuid:[UUID createUUID]];
    [image release];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark record 开始录音
#pragma mark ---------record delegate
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString *)_fileName withVoiceLenth:(CGFloat)length{
    int a =(int) length;
    if (a > 0) {
        [self wavToAmr:_filePath with:_fileName length:length];
    }
}
-(void)wavToAmr:(NSString *)_filePath  with:(NSString *)_fileName length:(CGFloat)length{
    [VoiceConverter wavToAmr:_filePath amrSavePath:[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_fileName,@"fid",_filePath,@"fileName",[NSNumber numberWithInt:(int)length],@"length", nil];
    NSLog(@"%@==%@",_filePath,_fileName);
    [self sureUpload:dic withType:SEND_Type_voice withuuid:[UUID createUUID]];
}

- (void)sureUploadUI:(VChatModel *)model{
    if (!self.dataSoureArr) {
        self.dataSoureArr = [NSMutableArray array];
    }
    if (model.uid) {
        [_dataSoureArr addObject:model];
    }
    [_tableView reloadData];
    if (self.dataSoureArr.count) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSoureArr.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
- (void)delUploadUI:(VChatModel *)model andreSend:(NSInteger)reSend{
    if (!self.dataSoureArr) {
        self.dataSoureArr = [NSMutableArray array];
    }
    if (model.uid) {
        [_dataSoureArr removeObject:model];
    }
    if (reSend == 1) {
        return;
    }else{
    [_tableView reloadData];
    }
}
//// 发送信息方法
- (void)sureUpload:(id)object withType:(SEND_TYPE)type withuuid:(NSString *)uuid{
    
    if (!uuid) {
        return;
    }
    VChatModel *model = [[VChatModel alloc] init];
    model.articleId = [uuid integerValue];// 设置文章的id为通用唯一标识 这个需要斟酌
    model.userId = [NSString stringWithFormat:@"%@",GET_U_ID];
    model.uid = uuid;//返回自带信息
    model.icon = GET_U_ICON;
    
    model.sendType = type;
    model.creatDate = [GetDateFormater getDate:DATE_FORMAT withDate:[NSDate date]];
    model.firstname = GET_U_NAME;
    NSLog(@"%@",GET_U_NAME);
    model.typeId = [_selfTypeDic objectForKey:@"typeId"];
    model.isGroupArticle = [_selfTypeDic objectForKey:@"isGroupArticle"];
    model.recvId = [_selfTypeDic objectForKey:@"recvId"];
    model.isSend = ISSEND;//初始标注是已发送成功的
    model.statusModel.sendType = Sending;
    
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //common
    [dic setObject:uuid forKey:@"uid"];
    [dic setObject:[NSNumber numberWithInteger:[model.typeId integerValue]] forKey:@"typeId"];
    [dic setObject:[NSNumber numberWithInteger:[model.isGroupArticle integerValue]] forKey:@"isGroupArticle"];
    [dic setObject:[NSNumber numberWithInteger:[model.recvId integerValue]] forKey:@"recvId"];
    
    if (_recvName && _type == VChatType_pChat) {
        [dic setObject:_recvName forKey:@"recvname"];
    }else if (_type == VChatType_pChat){
        NSLog(@"error with not recvName");
    }
    
    
    ASIFormDataRequest *request = nil;
    NSData *data = nil;
    NSString *filename = nil;
    
    // 分发送的类型经行讨论
    if (type == SEND_Type_content) {
        model.context = object;//文本发送
        [dic setObject:object forKey:@"context"];
        //[dic setObject:@"" forKey:@"recvname"];//接受人
        
    }else if (type == SEND_Type_photo){
        
        UIImage *image = [object imageByScalingOrgSize:CGSIZE_SCALE_MAX];
        model.imgData = image;
        VChatAttachModel *attmodel = [[VChatAttachModel alloc] init];
        filename = [NSString stringWithFormat:@"%@.jpg",uuid];
        attmodel.fileurl = filename;
        attmodel.filename = filename;
        [model.attachlist addObject:attmodel];
        data = UIImageJPEGRepresentation(image, 1);
        attmodel.fielData = data;
        
        [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"%@%@",GLOBAL_URL_FILEGET,attmodel.fileurl]];
        
        SSRCRelease(attmodel);
    }else if (type == SEND_Type_voice){
        
        VChatAttachModel *attmodel = [[VChatAttachModel alloc] init];
        filename = [NSString stringWithFormat:@"%@.amr",[object objectForKey:@"fid"]];
        attmodel.fileurl = [NSString stringWithFormat:@"%@.amr",[object objectForKey:@"fid"]];
        attmodel.filename = [object objectForKey:@"fileName"];
        attmodel.voiceLength = [object objectForKey:@"length"];
        [model.attachlist addObject:attmodel];
        
        SSRCRelease(attmodel);
        data = [NSData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:[[(NSDictionary *)object objectForKey:@"fid"] stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
        attmodel.fielData = data;
        [dic setObject:[object objectForKey:@"length"] forKey:@"voiceLength1"];
        
        
    }
    
    [self sureUploadUI:model];
    // 在此把数据写到本地
    [model release];
    request = [HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_NEWARTICLE userCommon:YES];
    if (type == SEND_Type_voice) {
        if (uuid && data && filename) {
            [request addData:data withFileName:filename andContentType:nil forKey:@"attach1"];
        }else{
            return;
        }
        
    }else if (type == SEND_Type_photo){
        if (uuid && data && filename) {
            [request addData:data withFileName:filename andContentType:nil forKey:@"attach1"];
        }else{
            return;
        }
    }
    // 将对象添加到request的userInfo字典中，以便在发送失败或是成功的代理方法中使用
    request.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:model,@"model", nil];
    [request setTimeOutSeconds:30.0f];
    [request setShouldAttemptPersistentConnection:NO];
    //[request startAsynchronous];
    [request setDidFailSelector:@selector(messegeRequestFaild:)];
    [request setDidFinishSelector:@selector(messageRequestFinish:)];
    [request setDelegate:self];
    if (!_sendQueue) {
        _sendQueue = [[NSOperationQueue alloc] init];
        _sendQueue.maxConcurrentOperationCount = 4;//
    }
    [_sendQueue addOperation:request];
    
}
// 发送信息方法

- (void)messegeRequestFaild:(ASIHTTPRequest *)request{
    VChatModel *model = [request.userInfo objectForKey:@"model"];
    // 0 表示未能成功上传，但是以保存在数据库中
    model.isSend = ISNOSENT;
    model.articleId = [self getMaxArticleId];
   
    if ([model sendType] == SEND_Type_photo || [model sendType] == SEND_Type_voice) {
        LoadToLocal *loadData = [[LoadToLocal alloc]init];
        // 获取数据库中最大的attachId
      [[[model attachlist] firstObject] setAttachId:[NSString stringWithFormat:@"%d",[self getMaxAttId]]];
        // 若数据为图片则写为本地文件
        if ([model sendType] == SEND_Type_photo) {
           [[[model attachlist] firstObject] setFilename:[loadData getFileUrl:[[[model attachlist] firstObject] filename] andfile:[[[model attachlist] firstObject] fielData]]];
        }
      
    }
     // 把文件写到本地数据库
     [SqliteBase witeInbase:TABLE_HD withData:[NSArray arrayWithObjects:model, nil]];
    // 标注发送失败
    model.statusModel.sendType = SendFailed;
    
    [_tableView reloadData];
}
- (void)messageRequestFinish:(ASIHTTPRequest *)request{
    NSDictionary *dic = [[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSLog(@"%@",dic);
    NSUInteger codeNum = [[dic objectForKey:CKEY] integerValue];
    VChatModel *model = [request.userInfo objectForKey:@"model"];
    if (request.responseStatusCode == 200 && codeNum == CODE_SUCCESS){
        model.statusModel.sendType = SendNormal;
        if (model.sendType == SEND_Type_voice || model.sendType == SEND_Type_photo) {
            id attachlist = [dic objectForKey:@"attachlist"];
            if (attachlist && [attachlist isKindOfClass:[NSArray class]]) {
                
                if ([model.attachlist count] && [attachlist count]) {
                    VChatAttachModel *oldattmodel = [model.attachlist firstObject];
                    id newattdic = [attachlist firstObject];
                    NSString *oldurl = oldattmodel.fileurl;
                    oldattmodel.attachId = [NSString stringWithFormat:@"%@",[newattdic objectForKey:@"attachId"]];
                    oldattmodel.displayHtml = [newattdic objectForKey:@"displayHtml"];
                    oldattmodel.fileurl = [newattdic objectForKey:@"fileurl"];
                    oldattmodel.filename = [newattdic objectForKey:@"filename"];
                    oldattmodel.voiceLength = [newattdic objectForKey:@"voiceLength"];
                    [[SDImageCache sharedImageCache] moveImageKey:[NSString stringWithFormat:@"%@%@",GLOBAL_URL_FILEGET,oldurl] forKey:[NSString stringWithFormat:@"%@%@",GLOBAL_URL_FILEGET,oldattmodel.fileurl]];
                    
                }
            }
        }
        model.articleId = [[dic objectForKey:@"articleId"] integerValue];
        model.uid = [dic objectForKey:@"uid"];
        model.isSend = ISSEND;
    }
    else{
        if(codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    //[self ];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
            }];
        }
        model.isSend = ISNOSENT;
        model.articleId = [self getMaxArticleId];
        if ([model sendType] == SEND_Type_photo || [model sendType] == SEND_Type_voice) {
            LoadToLocal *loadData = [[LoadToLocal alloc]init];
            [[[model attachlist] firstObject] setAttachId:[NSString stringWithFormat:@"%d",[self getMaxAttId]]];
            // 若数据为图片则写为本地文件
            if ([model sendType] == SEND_Type_photo) {
                [[[model attachlist] firstObject] setFilename:[loadData getFileUrl:[[[model attachlist] firstObject] filename] andfile:[[[model attachlist] firstObject] fielData]]];
            }
        }
        model.statusModel.sendType = SendFailed;
    }
    //wirte in database //写入本地数据库
    [SqliteBase witeInbase:TABLE_HD withData:[NSArray arrayWithObjects:model, nil]];
    [_tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (NSInteger)getIndex{
    NSInteger index = 0;
    // 获取文章的id
    if (self.dataSoureArr.count) {
        index = [[self.dataSoureArr objectAtIndex:0] articleId];
    }
    
    for (VChatModel *model in self.dataSoureArr) {
        if (model.statusModel.sendType == SendNormal) {
            index = model.articleId;
            break;
        }
    }
    return index;
}
//  获取最大的ArticleId，插入数据库
- (NSInteger)getMaxArticleId
{
    NSMutableDictionary *dic = [self dicWithVType:_type];
    [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"articleId"];
    // 从本地读出的数据
    NSArray *array = [SqliteBase readbase:TABLE_HD query:dic count:1];
    NSInteger articleId = ((VChatModel *)[array firstObject]).articleId;
    return  articleId+1;
}
//  获取最大的AttId，插入数据库
- (NSInteger)getMaxAttId
{
    NSMutableDictionary *dic = [self dicWithVType:_type];
    [dic setObject:[NSString stringWithFormat:@"0"] forKey:@"articleId"];
    // 从本地读出的数据
    NSArray *array = [SqliteBase readbase:TABLE_HD query:dic count:1];
    NSInteger attachId = [[[[((VChatModel *)[array firstObject]) attachlist] firstObject] attachId] integerValue];
    return  attachId+1;
}
- (void)prepareToGetData{
    self.dataSoureArr = [NSMutableArray array];
    NSMutableDictionary *dic = [self dicWithVType:_type];
    [dic setObject:@"0" forKey:@"articleId"];
    NSArray *caches = [SqliteBase readbase:TABLE_HD query:dic count:15];
    [self updateVIDatas:caches dragg:DRAG_DOWN];
    [self getDataList:DRAG_DOWN];
 
}
- (void)noti:(NSNotification *)noti{
    [self getDataList:DRAG_DOWN];
    //    NSLog(@"接听到了数据的推送消息");
}
- (void)getDataList:(NSString *)dragg{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"ison0"] boolValue] == NO &&( _type == VChatType_VC || _type == VChatType_pGroup) && [dragg isEqualToString:DRAG_DOWN]){
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:dragg forKey:DRAGG];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ASISafeRelease(listRequest);
    NSMutableDictionary *dic = [self dicWithVType:_type];
    
    NSInteger index = 0;
    if ([dragg isEqualToString:DRAG_UP]) {
        index = [self getIndex];
    }
    [dic setObject:[NSNumber numberWithInteger:index] forKey:@"articleId"];
    [dic setObject:[NSNumber numberWithInteger:0] forKey:@"sort"];
    [dic setObject:[NSNumber numberWithInteger:1] forKey:@"order"];
    [dic setObject:[NSNumber numberWithInteger:5] forKey:@"recordCount"];
    listRequest = SSRCReturnRetained([HttpRequsetFactory getRequestKeys:dic subUrl:SUB_URL_NERARTICLELIST userCommon:YES]);
    listRequest.userInfo = [NSDictionary dictionaryWithObjectsAndKeys:dragg,DRAGG, nil];
    [listRequest setDelegate:self];
    [listRequest setDidFailSelector:@selector(fail:)];
    [listRequest setDidFinishSelector:@selector(finish:)];
    [listRequest startAsynchronous];
}
// 请求失败，加载本地数据
- (void)fail:(ASIHTTPRequest *)request{
    [self endPull];
    
    //进入本地缓存查找数据
    NSString *dragg = [request.userInfo objectForKey:DRAGG];
    
    if ([dragg isEqualToString:DRAG_UP]) {
        //加载更多数据
        NSMutableDictionary *dic = [self dicWithVType:_type];
        
        [dic setObject:[NSString stringWithFormat:@"%d",[self getIndex]] forKey:@"articleId"];
        // 从本地读出的数据
        NSArray *caches = [SqliteBase readbase:TABLE_HD query:dic count:15];
        [self updateVIDatas:caches dragg:DRAG_UP];
    }
}
// 请求成功
- (void)finish:(ASIHTTPRequest *)request{
    [self endPull];
    NSDictionary *dic = [[[[NSString alloc] initWithData:request.responseData encoding:NSUTF8StringEncoding] autorelease] JSONValue];
    NSUInteger codeNum = [[dic objectForKey:CKEY] integerValue];
    if (request.responseStatusCode == 200 && codeNum == CODE_SUCCESS){
        id articlelist = [dic objectForKey:@"articlelist"];
        if ([articlelist isKindOfClass:[NSArray class]]) {  
            [self updateVIDatas:[VChatModel vChatMakeModel:articlelist] dragg:[request.userInfo objectForKey:DRAGG]];
        }
    }
    else if (codeNum == CODE_ERROE){
        SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
        [sqliteAndtable repeatLogin:^(BOOL flag) {
            if (flag) {
                [self getDataList:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:DRAGG]]];
            }
            else{
                UserLoginViewController *login = [[UserLoginViewController alloc]init];
                [self.navigationController pushViewController:login animated:YES];
                login = nil;
            }
        }];
    }
}


- (BOOL)isInSelfDataSource:(NSInteger)arti andisPlay:(NSInteger)isRead{
    for (int i = self.dataSoureArr.count-1; i>=0; i--) {
        if ([[self.dataSoureArr objectAtIndex:i] articleId] == arti) {
            [[[[self.dataSoureArr objectAtIndex:i] attachlist] firstObject] setIsRead:isRead];
            return YES;
        }
    }
    
    return NO;
}

- (void)updateVIDatas:(NSArray *)datas dragg:(NSString *)dragg{
    if (![datas count]) {
        return;
    }
    // 写到数据库中
    [SqliteBase witeInbase:TABLE_HD withData:datas];
    
    // 如果数据源为空，则初始化
    if (!self.dataSoureArr) {
        self.dataSoureArr = [NSMutableArray array];
    }
    // 如果是下拉加载数据
    if ([dragg isEqualToString:DRAG_DOWN]) {

        NSMutableDictionary *dic = [self dicWithVType:_type];
        [dic setObject:@"0" forKey:@"articleId"];
        NSArray *caches = [SqliteBase readbase:TABLE_HD query:dic count:10];
        // 如果数据源不为空时
        if (self.dataSoureArr.count) {
            // 此时比对请求的数据和数据源的数据。如果数据源中的最新的数据要与请求的数据（表明此时请求到新的数据）
            if ([[caches lastObject] articleId] > ([[self.dataSoureArr lastObject] articleId]+1)) {
                // 则把数据源中久的数据清空
                [self.dataSoureArr removeAllObjects];
            }
        }
        // 通过循环把请求的新的数据依次添加到数据源中
        for (int i = caches.count-1; i >= 0; i--)
        {
            VChatModel *model = [caches objectAtIndex:i];
            if (![self isInSelfDataSource:[model articleId] andisPlay:[[[model attachlist] firstObject] isRead]] ) {
                [self.dataSoureArr addObject:model];
            }
            
        }
    }
    // 下拉，激活上面
    else if ([dragg isEqualToString:DRAG_UP]){
        //加载更多数据
        
        // 从本地读出的数据
        // 设置相应地参数
        NSMutableDictionary *dic = [self dicWithVType:_type];
        [dic setObject:[NSString stringWithFormat:@"%d",[self getIndex]] forKey:@"articleId"];
        NSArray *drag_upCaches = [SqliteBase readbase:TABLE_HD query:dic count:15];
        
        for (int i = 0; i <drag_upCaches.count; i ++) {
            VChatModel *model = [drag_upCaches objectAtIndex:i];
            [self.dataSoureArr insertObject:model atIndex:0];
        }
    }
    [_tableView reloadData];
    if ([dragg isEqualToString:DRAG_DOWN] && self.dataSoureArr.count) {
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.dataSoureArr.count-1 inSection:0];
        [_tableView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}
// 给selfTypeDic赋值
- (NSMutableDictionary *)dicWithVType:(VChatType)type{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSLog(@"%@",dic);
    // 聊天广场
    if (type == VChatType_VC) {
        [dic setObject:@"9" forKey:@"typeId"];
        [dic setObject:@"0" forKey:@"isGroupArticle"];
        [dic setObject:@"0" forKey:@"recvId"];
    }
    // 个人聊天
    else if (type == VChatType_pChat){
        [dic setObject:@"10" forKey:@"typeId"];
        [dic setObject:@"0" forKey:@"isGroupArticle"];
        if (_recvId) {
            [dic setObject:_recvName forKey:@"recvName"];
            [dic setObject:_recvId forKey:@"recvId"];
        }
    }
    // 群组聊天
    else if (type == VChatType_pGroup){
        [dic setObject:@"0" forKey:@"typeId"];
        [dic setObject:@"1" forKey:@"isGroupArticle"];
        if (_recvId) {
            [dic setObject:_recvId forKey:@"recvId"];
        }
    }
    return dic;
}
@end
