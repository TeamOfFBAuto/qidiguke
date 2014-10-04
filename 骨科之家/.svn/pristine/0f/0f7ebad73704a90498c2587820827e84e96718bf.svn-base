//
//  FriendDetailViewController.m
//  UNITOA
//
//  Created by qidi on 14-6-26.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"
@interface FriendDetailViewController ()
{
    UserIfo *userModel;
}
@end

@implementation FriendDetailViewController

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
    [self navigetion];
    [self getFriendDetail];
    [self creatUI];
    // Do any additional setup after loading the view.
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo_arrow"]];
    logoView.frame = CGRectMake(0, 0, 40, 40);
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 5, 140, 30)];
    loginLabel.text = LOCALIZATION(@"friend_detail_ifo");
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
    
}
- (void)creatUI
{
    UIView *bgView = nil;
    if (currentDev) {
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-64)];
    }
    else if (currentDev1){
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height-64)];
    }
    
    else{
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-44)];
    }
    UIView *firstBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 0, viewSize.width+2, 100)];
    firstBgView.layer.borderWidth = 1;
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
   [imgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,userModel.icon]] placeholderImage:[UIImage imageNamed:@"user_default_small_96"]];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 30, 150, 20)];
    nameLabel.text = userModel.firstname;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:16];
    [firstBgView addSubview:imgView];
    [firstBgView addSubview:nameLabel];
    
    UIView *secondBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 100, viewSize.width+2, 30)];
    secondBgView.layer.borderWidth = 1;
    UILabel *callLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    callLabel.text = LOCALIZATION(@"userinfo_phone");
    callLabel.textColor = [UIColor blackColor];
    callLabel.backgroundColor = [UIColor clearColor];
    callLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *call = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 180, 20)];
    call.text = userModel.telephone;
    call.textColor = [UIColor grayColor];
    callLabel.backgroundColor = [UIColor clearColor];
    call.font = [UIFont systemFontOfSize:13];
    
    UIButton *callBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [callBtn setBackgroundImage:[UIImage imageNamed:@"ic_call"] forState:UIControlStateNormal];
    callBtn.frame = CGRectMake(260, 2, 20, 20);
    callBtn.tag = 201;
    [callBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [callBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    callBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"ic_msg"] forState:UIControlStateNormal];
    msgBtn.frame = CGRectMake(290, 5, 20, 20);
    msgBtn.tag = 202;
    [msgBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    msgBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [secondBgView addSubview:callLabel];
    [secondBgView addSubview:call];
    [secondBgView addSubview:callBtn];
    [secondBgView addSubview:msgBtn];
    
    UIView *thirdBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 130, viewSize.width, 30)];
    //thirdBgView.layer.borderWidth = 1;
    UILabel *telLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    telLabel.text = LOCALIZATION(@"userinfo_mobile");
    telLabel.textColor = [UIColor blackColor];
    telLabel.backgroundColor = [UIColor clearColor];
    telLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *tel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 170, 20)];
    tel.text = userModel.mobile;
    tel.textColor = [UIColor grayColor];
    tel.backgroundColor = [UIColor clearColor];
    tel.font = [UIFont systemFontOfSize:13];
    
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [telBtn setBackgroundImage:[UIImage imageNamed:@"ic_call"] forState:UIControlStateNormal];
    telBtn.frame = CGRectMake(260, 5, 20, 20);
    telBtn.tag = 203;
    [telBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [telBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    telBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UIButton *msgBtn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [msgBtn1 setBackgroundImage:[UIImage imageNamed:@"ic_msg"] forState:UIControlStateNormal];
    msgBtn1.frame = CGRectMake(290, 5, 20, 20);
    msgBtn1.tag = 204;
    [msgBtn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [msgBtn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    msgBtn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    [thirdBgView addSubview:telLabel];
    [thirdBgView addSubview:tel];
    [thirdBgView addSubview:telBtn];
    [thirdBgView addSubview:msgBtn1];
    
    UIView *fourBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 160, viewSize.width+2, 30)];
    fourBgView.layer.borderWidth = 1;
    UILabel *mailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    mailLabel.text = LOCALIZATION(@"userinfo_email");
    mailLabel.textColor = [UIColor blackColor];
    mailLabel.backgroundColor = [UIColor clearColor];
    mailLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *mail = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 170, 20)];
    mail.text = userModel.email;
    mail.textColor = [UIColor grayColor];
    mail.backgroundColor = [UIColor clearColor];
    mail.font = [UIFont systemFontOfSize:13];
    
    UIButton *mailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mailBtn setBackgroundImage:[UIImage imageNamed:@"ic_mail"] forState:UIControlStateNormal];
    mailBtn.frame = CGRectMake(290, 5, 20, 20);
    mailBtn.tag = 205;
    [mailBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [mailBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    mailBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [fourBgView addSubview:mailLabel];
    [fourBgView addSubview:mail];
    [fourBgView addSubview:mailBtn];
    
    UIView *fiveBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 189, viewSize.width+2, 30)];
    fiveBgView.layer.borderWidth = 1;
    UILabel *cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    cityLabel.text = LOCALIZATION(@"userinfo_city");
    cityLabel.textColor = [UIColor blackColor];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *cityName = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 170, 20)];
    cityName.text = userModel.cityName;
    cityName.textColor = [UIColor grayColor];
    cityName.backgroundColor = [UIColor clearColor];
    cityName.font = [UIFont systemFontOfSize:13];
    [fiveBgView addSubview:cityLabel];
    [fiveBgView addSubview:cityName];
    
    UIView *sixBgView = [[UIView alloc]initWithFrame:CGRectMake(-1, 230, viewSize.width+2, 30)];
    sixBgView.layer.borderWidth = 1;
    sixBgView.userInteractionEnabled = YES;
    UILabel *parentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 20)];
    parentLabel.text = LOCALIZATION(@"userinfo_parent");
    parentLabel.textColor = [UIColor blackColor];
    parentLabel.backgroundColor = [UIColor clearColor];
    parentLabel.font = [UIFont systemFontOfSize:16];
    
    UILabel *parentDetail = [[UILabel alloc]initWithFrame:CGRectMake(245, 5, 55, 20)];
    parentDetail.text = LOCALIZATION(@"userinfo_viewdetail");
    parentDetail.textColor = [UIColor grayColor];
    parentDetail.backgroundColor = [UIColor clearColor];
    parentDetail.font = [UIFont systemFontOfSize:13];
    
    UIImageView *arrowView = [[UIImageView alloc]initWithFrame:CGRectMake(300, 10, 10, 10)];
    arrowView.image = [UIImage imageNamed:@"task_arrow"];
    [sixBgView addSubview:parentLabel];
    [sixBgView addSubview:parentDetail];
    [sixBgView addSubview:arrowView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestrueAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [sixBgView addGestureRecognizer:tap];
    tap = nil;
    
    NSString *sendTitle = nil;
    UIButton *senderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [senderBtn setBackgroundImage:[UIImage imageNamed:@"task_btn_reject_big"] forState:UIControlStateNormal];
    senderBtn.frame = CGRectMake(30, 270, viewSize.width-60, 30);
    if ([userModel.isFriend isEqualToString:@"1"]) {
       sendTitle  = LOCALIZATION(@"userinfo_chat");
        senderBtn.tag = 206;
    }
    else{
        sendTitle  = LOCALIZATION(@"userinfo_addaddress");
        senderBtn.tag = 207;
    }
    [senderBtn setTitle:sendTitle forState:UIControlStateNormal];
    [senderBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [senderBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    senderBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    senderBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    [bgView addSubview:firstBgView];
    [bgView addSubview:secondBgView];
    [bgView addSubview:thirdBgView];
    [bgView addSubview:fourBgView];
    [bgView addSubview:fiveBgView];
    [bgView addSubview:sixBgView];
    [bgView addSubview:senderBtn];
    [self.view addSubview:bgView];
}
- (void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case 201:
            
            break;
        case 202:
            
            break;
        case 203:
            
            break;
        case 204:
            
            break;
        case 205:
            
            break;
        case 206:
        {
            // 发送消息
            NSLog(@"%d",sender.tag);
            
        }
            
            break;
        case 207:{
            UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
            NSDictionary *parameter = @{@"userId":model.userId,@"sid":model.sid,@"dstUserId": userModel.userId};
            [AFRequestService responseData:FRIEND_ADD_URL andparameters:parameter andResponseData:^(NSData *responseData) {
                NSDictionary *dict = (NSDictionary *)responseData;
                NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                if (codeNum == 0) {
                    NSString *alertcontext = LOCALIZATION(@"friend_verify_success");
                    NSString *alertText = LOCALIZATION(@"dialog_prompt");
                    NSString *alertOk = LOCALIZATION(@"dialog_ok");
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    NSString *alertcontext = LOCALIZATION(@"friend_verify_error");
                    NSString *alertText = LOCALIZATION(@"dialog_prompt");
                    NSString *alertOk = LOCALIZATION(@"dialog_ok");
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                    [alert show];
                }
            }];
    
        }
            break;
        default:
            break;
    }
}
- (void)tapGestrueAction
{
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)getFriendDetail
{
    UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
    NSLog(@"%@",self.friendModel.dstUserId);
    NSDictionary *parameters = @{@"userId":model.userId,@"sid":model.sid,@"viewId":self.friendModel.dstUserId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSLog(@"%@",dict);
        
        if ([self getUserIfo:dict]) {
            [self creatUI];
        }
        
    } andCathtype:2 andID:3];
}
//解析登入数据
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == 0) {
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        userModel = [[UserIfo alloc]init];
        userModel.address = [userDetail valueForKey:@"address"];
        userModel.allowPosition = [userDetail valueForKey:@"allowPosition"];
        userModel.articleBg = [userDetail valueForKey:@"articleBg"];
        userModel.bgUpdateTime = [userDetail valueForKey:@"bgUpdateTime"];
        userModel.chkATime = [userDetail valueForKey:@"chkATime"];
        userModel.cityName = [userDetail valueForKey:@"cityName"];
        userModel.companyId = [userDetail valueForKey:@"companyId"];
        userModel.createDate = [userDetail valueForKey:@"createDate"];
        userModel.deletePerm = [userDetail valueForKey:@"deletePerm"];
        userModel.district = [userDetail valueForKey:@"district"];
        userModel.email = [userDetail valueForKey:@"email"];
        userModel.firstname = [userDetail valueForKey:@"firstname"];
        userModel.firstnameen = [userDetail valueForKey:@"firstnameen"];
        userModel.icon = [userDetail valueForKey:@"icon"];
        userModel.iconUpdateTime = [userDetail valueForKey:@"iconUpdateTime"];
        userModel.inviteCodeId = [userDetail valueForKey:@"inviteCodeId"];
        userModel.invitePerm = [userDetail valueForKey:@"invitePerm"];
        userModel.itcode = [userDetail valueForKey:@"itcode"];
        userModel.isFriend = [userDetail valueForKey:@"isFriend"];
        userModel.lastChkETime = [userDetail valueForKey:@"lastChkETime"];
        userModel.lastLogin = [userDetail valueForKey:@"lastLogin"];
        userModel.lastLoginIP = [userDetail valueForKey:@"lastLoginIP"];
        userModel.latitude = [userDetail valueForKey:@"latitude"];
        userModel.loginCount = [userDetail valueForKey:@"loginCount"];
        userModel.longitude = [userDetail valueForKey:@"longitude"];
        userModel.mailStatus = [userDetail valueForKey:@"mailStatus"];
        userModel.memo = [userDetail valueForKey:@"memo"];
        userModel.mobile = [userDetail valueForKey:@"mobile"];
        userModel.organization = [userDetail valueForKey:@"organization"];
        userModel.organizationen = [userDetail valueForKey:@"organizationen"];
        userModel.parentCode = [userDetail valueForKey:@"parentCode"];
        userModel.parentId = [userDetail valueForKey:@"parentId"];
        userModel.position = [userDetail valueForKey:@"position"];
        userModel.positionen = [userDetail valueForKey:@"positionen"];
        userModel.province = [userDetail valueForKey:@"province"];
        userModel.sex = [userDetail valueForKey:@"sex"];
        userModel.showMobile = [userDetail valueForKey:@"showMobile"];
        userModel.sid = [userDetail valueForKey:@"sid"];
        userModel.status = [userDetail valueForKey:@"status"];
        userModel.street = [userDetail valueForKey:@"street"];
        userModel.street_number = [userDetail valueForKey:@"street_number"];
        userModel.sysAdmin = [userDetail valueForKey:@"sysAdmin"];
        userModel.telephone = [userDetail valueForKey:@"telephone"];
        userModel.userId = [userDetail valueForKey:@"userId"];
        userModel.userType = [userDetail valueForKey:@"userType"];
        userModel.username = [userDetail valueForKey:@"username"];
        userModel.versionName = [userDetail valueForKey:@"versionName"];
        
        return YES;
    }
    else if (codeNum == 1){
        
        NSString *alertcontext = LOCALIZATION(@"login_error_pwd");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else{
        return NO;
    }
    
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
