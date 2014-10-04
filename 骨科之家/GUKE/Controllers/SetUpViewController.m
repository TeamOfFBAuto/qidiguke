//
//  SetUpViewController.m
//  WeiTongShi
//
//  Created by qidi on 14-6-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "SetUpViewController.h"
#import "SetUpTableViewCell.h"
#import "SetUpTableViewCellOne.h"
#import "FriendDetailViewController.h"
#import "FriendIfo.h"
#import "UserLoginViewController.h"
#import "ApkVersion.h"
#import "AlterPerDetailsViewController.h"
#import "ChangPWDViewController.h"
#import "SuggestionViewController.h"
#import "RemindViewController.h"
#import "SqliteFieldAndTable.h"
#import "UserLoginViewController.h"
#import "UIImage+UIImageScale.h"
#import "AboutProduceViewController.h"
#import "UserInfoDB.h"
#import "Interface.h"
@interface SetUpViewController ()
{
    ApkVersion *apkModel;
    NSArray *dataArry;
    NSArray *locatonArray;
    NSArray *imgArray;
    UITableView *_tableView;
    UIImage *img;
    CGFloat volume;
}
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@end

@implementation SetUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
        // 控制状态显现
        [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    volume = 0.0;
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigetion];
    // 初始化数据源
    NSString *account = LOCALIZATION(@"setting_account");
    NSString *setting_icon = LOCALIZATION(@"setting_icon");
    NSString *setting_changIfo = LOCALIZATION(@"setting_changIfo");
    NSString *setting_changepwd = LOCALIZATION(@"setting_changepwd");
    NSString *setting_notify = LOCALIZATION(@"setting_notify");
    NSString *setting_feedback = LOCALIZATION(@"setting_feedback");
    NSString *setting_checknewversion = LOCALIZATION(@"setting_checknewversion");
    NSString *versionstr = LOCALIZATION(@"versionstr");
    NSString *setting_switch = LOCALIZATION(@"setting_switch");
    NSString *private_police = LOCALIZATION(@"private_police");
    NSString *about_produce = LOCALIZATION(@"about_produce");
    
        dataArry = @[account, setting_icon, setting_changIfo, setting_changepwd, setting_notify , setting_feedback, setting_checknewversion,versionstr,setting_switch,private_police,about_produce];
        imgArray = @[@"set_username",@"set_userphone",@"set_changeinfo",@"set_changepwd",@"set_usermsg",@"set_feedback",@"set_usercheck",@"set_userfile",@"set_switch_account",@"privacy@2x",@"produce@2x"];
    [self creatTable];
    //通知中心监听媒体音量值得变化
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(volumeChanged:)
     
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
     
                                               object:nil];
}
// 导航布局
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"friend_detail_ifo");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
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
- (void)creatTable
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.scrollEnabled = YES;
    _tableView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:_tableView];
    _tableView.separatorColor = GETColor(228, 228, 228);
    [self.view addSubview:_tableView];
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
    if (indexPath.row == 0) {
        static NSString *cellName = @"cell1";
        SetUpTableViewCellOne *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"SetUpTableViewCellOne" owner:self options:nil]lastObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.imgView.image = [UIImage imageNamed:imgArray[indexPath.row]];
        cell.nameLabel.text = dataArry[indexPath.row];
        cell.userNameLogo.text = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:GET_USER_ID];
        if (cell.userNameLogo.text.length == 0) {
            NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":GET_USER_ID};
            [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
                NSDictionary *dict =(NSDictionary *)responseData;
                SqliteFieldAndTable *sqlAndTable = [[SqliteFieldAndTable alloc]init];
                NSInteger codeNum = [[dict objectForKey:@"code"]integerValue];
                if (codeNum == CODE_SUCCESS) {
                    [sqlAndTable getFeildandValueById:dict];
                    cell.userNameLogo.text = [UserInfoDB selectFeildString:@"username" andcuId:GET_USER_ID anduserId:GET_USER_ID];
                }
                else if (codeNum == CODE_ERROE){
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    SetUpViewController *_Self = self;
                    [sqliteAndtable repeatLogin:^(BOOL flag) {
                        if (flag){
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
        [cell.userNameLogo setTextColor:GETColor(140, 79, 157)];
        return cell;
    }
    else{
    static NSString *cellName = @"cell2";
    SetUpTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SetUpTableViewCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imgView.image = [UIImage imageNamed:imgArray[indexPath.row]];
    cell.nameLabel.text = dataArry[indexPath.row];
        cell.userNameLogo.alpha = 0;
        
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 50;
    }else{
        return 45;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlterPerDetailsViewController *alterPerDetails = [[AlterPerDetailsViewController alloc]init];
    
   
        switch (indexPath.row) {
            case 0:
            {
                // 账号
                FriendIfo *friendModel = [[FriendIfo alloc]init];
                friendModel.dstUserId =[UserInfoDB selectFeildString:@"userId" andcuId:GET_USER_ID anduserId:GET_USER_ID];
                FriendDetailViewController *friendDetail = [[FriendDetailViewController alloc]init];
                friendDetail.friendModel = friendModel;
                [self.navigationController pushViewController:friendDetail animated:YES];
            }
                 break;
            case 1:{
                //设置头像
                [self setICON];
            }
                break;
            case 2:{
                // 修改个人信息
                [self.navigationController pushViewController:alterPerDetails animated:YES];
            }
                break;
            case 3:{
                // 修改密码
                    ChangPWDViewController *changPWD = [[ChangPWDViewController alloc]init];
                    [self.navigationController pushViewController:changPWD animated:YES];
            }
                break;
            case 4:{
                //新消息提醒
                RemindViewController *inviteColleague = [[RemindViewController alloc]init];
                [self.navigationController pushViewController:inviteColleague animated:YES];
              
            }
                break;
            
            case 5:{
                // 意见与反馈
                SuggestionViewController *suggest = [[SuggestionViewController alloc]init];
                [self.navigationController pushViewController:suggest animated:YES];
    
            }
                break;
            case 6:{
                // 检查新版本
                NSString *versionLabel = dataArry[indexPath.row+1];
                NSString *versionNum = [versionLabel substringWithRange:NSMakeRange(4, versionLabel.length-4)];
                NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid": GET_S_ID,@"version": versionNum};
                [AFRequestService responseData:CHECK_UPDATE_URL andparameters:parameters andResponseData:^(NSData *responseData) {
                    NSDictionary * dict = (NSDictionary *)responseData;
                    NSInteger codeNum = [[dict objectForKey:@"code"] intValue];
                    
                    if (codeNum == 0) {
                        NSUInteger statusNum = [[dict objectForKey:@"status"] intValue];
                        apkModel = [[ApkVersion alloc]init];
                        apkModel.status = [dict objectForKey:@"status"];
                        apkModel.url = [dict objectForKey:@"url"];
                        apkModel.version = [dict objectForKey:@"version"];
                        apkModel.versiondesc = [dict objectForKey:@"versiondesc"];
                        apkModel.versionsize = [dict objectForKey:@"status"];
                        apkModel.versionsize = [dict objectForKey:@"versionsizestr"];
                        if (statusNum == 0) {
                            NSString *alertcontext = LOCALIZATION(@"update_recent");
                            NSString *alertText = LOCALIZATION(@"dialog_prompt");
                            NSString *alertOk = LOCALIZATION(@"dialog_ok");
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                            alert.tag = 401;
                            [alert show];

                        }
                        else if (statusNum == 1){
                            NSString *alertcontext = LOCALIZATION(@"update_new");
                            NSString *update_new_text = [NSString stringWithFormat:@"%@%@",alertcontext,[dict objectForKey:@"versionsizestr"]];
                            NSString *alertText = LOCALIZATION(@"dialog_prompt");
                            NSString *alertOk = LOCALIZATION(@"dialog_ok");
                            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:update_new_text delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                            alert.tag = 401;
                            [alert show];

                        }
                    }
                    else if (codeNum == 1){
                        NSString *alertcontext = LOCALIZATION(@"userinfo_notexists");
                        NSString *alertText = LOCALIZATION(@"dialog_prompt");
                        NSString *alertOk = LOCALIZATION(@"dialog_ok");
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                        alert.tag = 401;
                        [alert show];
                    }
                    else if (codeNum == 2){
                        NSString *alertcontext = LOCALIZATION(@"setting_version_form_error");
                        NSString *alertText = LOCALIZATION(@"dialog_prompt");
                        NSString *alertOk = LOCALIZATION(@"dialog_ok");
                        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                        alert.tag = 401;
                        [alert show];
                    }
                    
                }];
                
            }
                break;
            case 7:{
                // 当前版本
                
            }
                break;
            case 8:{
                // 切换用户
                UserLoginViewController *userLogin = [[UserLoginViewController alloc]init];
                [self.navigationController pushViewController:userLogin animated:YES];
                
            }
                break;
            case 9:{
                PrivatPoliceViewController *private = [[PrivatPoliceViewController alloc]init];
                [self.navigationController pushViewController:private animated:YES];
   
            }
                break;
            case 10:{
                AboutProduceViewController *produce = [[AboutProduceViewController alloc]init];
                [self.navigationController pushViewController:produce animated:YES];
                
            }
                break;
            default:
                break;
        }
    
    
}
// 音量的控制
- (void)setSystemVolume:(float)systemVolume {
    MPMusicPlayerController *musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    musicPlayer.volume = systemVolume;
}
-(void)volumeChanged:(NSNotification *)noti

{
    float volume1 =
    
    [[[noti userInfo]
      
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     
     floatValue];
    volume = volume1;
    
}
- (void)setICON
{
    if (![self menu1]) {
        
        NSArray *titles = @[LOCALIZATION(@"button_takePhoto"),
                            LOCALIZATION(@"button_selectPhoto"),
                            LOCALIZATION(@"button_cancel")];
        _menu1 = [[MBButtonMenuViewController alloc] initWithButtonTitles:titles];
        [_menu1 setDelegate:self];
        [_menu1 setCancelButtonIndex:[[_menu1 buttonTitles]count]-1];
    }
    [[self menu1] showInView:[self view]];

}
#pragma mark - MBButtonMenuViewControllerDelegate
- (void)buttonMenuViewController:(MBButtonMenuViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index
{
    [buttonMenu hide];
    UIImagePickerControllerSourceType soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (index == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (index == 1){
        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (index == 2){
        return;
    }
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = soursceType;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)buttonMenuViewControllerDidCancel:(MBButtonMenuViewController *)buttonMenu
{
    [buttonMenu hide];
}


#pragma mark ====== UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    if (img.size.width>800) {
        UIImage *imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
        imgData = UIImageJPEGRepresentation(imgScale, 0.3);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID};
    [AFRequestService responseDataWithImage:CHANG_ICON_URL andparameters:parameters andImageData:imgData  andfieldType:@"icon" andfileName:@"icon.jpg" andResponseData:^(NSData *responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSInteger codeNum = [[dict objectForKey:@"code"] intValue];
        if (codeNum == 0) {
            //  后台执行加载数据,更新头像，刷新数据库
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 网络请求用户信息
                NSDictionary  *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID};
                [AFRequestService responseData:USER_LIST_URL andparameters:parameters andResponseData:^(NSData *responseData) {
                    NSDictionary * dict = (NSDictionary *)responseData;
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    [sqliteAndtable getFeildandValue:dict];
                    sqliteAndtable = nil;
                }];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    
                });
            });
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_success") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
        else if (codeNum == 1){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_error") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
        else {
            return;
        }
    }];
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
         apkModel = nil;
         dataArry = nil;
         locatonArray = nil;
         imgArray = nil;
         _tableView = nil;
         img = nil;
         self.view = nil;
    }

}

-(void)dealloc{
    
    apkModel = nil;
    dataArry = nil;
    locatonArray = nil;
    imgArray = nil;
    _tableView = nil;
    img = nil;

}

@end
