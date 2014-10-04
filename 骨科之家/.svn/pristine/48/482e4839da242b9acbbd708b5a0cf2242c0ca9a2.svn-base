//
//  InviteColleagueViewController.m
//  WeiTongShi
//
//  Created by qidi on 14-6-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "InviteColleagueViewController.h"
#import "Interface.h"
@interface InviteColleagueViewController ()
{
    RadioButton * time_one;
    RadioButton *time_tow;
    UITextField *codeField;
    NSInteger timeFlag;
    
}
@end

@implementation InviteColleagueViewController

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
    if (currentDev) {
        UILabel *naviLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
        naviLabel.text = @"邀请同事";
        naviLabel.textColor = [UIColor whiteColor];
        naviLabel.font = [UIFont boldSystemFontOfSize:20];
        self.navigationItem.titleView = naviLabel;
    }
    else{
        self.navigationItem.title = @"邀请同事";
    }
    UIButton * leftItem = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItem.frame = CGRectMake(280, 30, 40, 30);
    leftItem.tag =201;
    [leftItem setTitle:@"返回" forState:UIControlStateNormal];
    [leftItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftItem setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_bj@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [leftItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc]initWithCustomView:leftItem];
    self.navigationItem.leftBarButtonItem = item1;
    [self creatUI];
}
// UIButtonClick Action
- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 201) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (sender.tag == 202){
        [self getInviteCode];
    }
    else if (sender.tag == 203){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = codeField.text;
    }
    else if (sender.tag == 204){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://8008808888"]];
    }
    else{
        return;
    }
}
- (void)creatUI
{
    UILabel *warnLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, viewSize.width-10, 100)];
    warnLabel.text = @"复制下方的邀请码，通过QQ、微信、邮箱、短信发送给您已确认身份的一位同事，他/她通过点击链接即可进入邮箱注册流程，一个邀请码最多只能邀请200个用户注册。";
    warnLabel.textColor = [UIColor orangeColor];
    warnLabel.numberOfLines = 0;
    warnLabel.lineBreakMode = NSLineBreakByWordWrapping;
    warnLabel.font = [UIFont systemFontOfSize:14];
    
    codeField = [[UITextField alloc]initWithFrame:CGRectMake(5, warnLabel.frame.origin.y+warnLabel.frame.size.height, viewSize.width-10, 30)];
    codeField.keyboardAppearance = UIKeyboardAppearanceDefault;
    codeField.keyboardType = UIKeyboardTypeDefault;
    codeField.returnKeyType = UIReturnKeyNext;
    [codeField setEnabled:NO];
    codeField.layer.borderColor = [[UIColor orangeColor] CGColor];
    codeField.layer.borderWidth = 2;
    
    time_one = [[RadioButton alloc] initWithDelegate:self groupId:@"sex"];
    time_one.frame = CGRectMake(30, codeField.frame.origin.y+codeField.frame.size.height+10, 120, 40);
    [time_one setTitle:@"30分钟内有效" forState:UIControlStateNormal];
    time_one.tag = 301;
    [time_one setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [time_one.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    
    
    time_tow = [[RadioButton alloc] initWithDelegate:self groupId:@"sex"];
    time_tow.frame = CGRectMake(160,codeField.frame.origin.y+codeField.frame.size.height+10, 120, 40);
    time_tow.tag = 302;
    [time_tow setTitle:@"24小时内有效" forState:UIControlStateNormal];
    [time_tow setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [time_tow.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [time_tow setChecked:YES];
    timeFlag = 1;
    
   UIButton *getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getCodeBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_bj@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    getCodeBtn.frame = CGRectMake(180, time_tow.frame.origin.y+codeField.frame.size.height+10, 100, 40);
    [getCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
    [getCodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    getCodeBtn.tag = 202;
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIButton *copyCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyCodeBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_bj@2x" ofType:@"png"]] forState:UIControlStateNormal];
    copyCodeBtn.frame = CGRectMake(40, getCodeBtn.frame.origin.y+getCodeBtn.frame.size.height+10, 100, 40);
    [copyCodeBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyCodeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    copyCodeBtn.tag = 203;
    [copyCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    copyCodeBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    UIButton *inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [inviteBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"button_bj@2x" ofType:@"png"]] forState:UIControlStateNormal];
    inviteBtn.frame = CGRectMake(180, getCodeBtn.frame.origin.y+getCodeBtn.frame.size.height+10, 100, 40);
    [inviteBtn setTitle:@"邀请" forState:UIControlStateNormal];
    [inviteBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    inviteBtn.tag = 204;
    [inviteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    inviteBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [self.view addSubview:time_one];
    [self.view addSubview:time_tow];
    [self.view addSubview:getCodeBtn];
    [self.view addSubview:copyCodeBtn];
    [self.view addSubview:inviteBtn];
    [self.view addSubview:warnLabel];
    [self.view addSubview:codeField];
}
#pragma mark ====== RadioButtonDelegate
- (void)didSelectedRadioButton:(RadioButton *)radio groupId:(NSString *)groupId
{
    if (radio.tag == 301) {
        timeFlag = 0;
    }
    else if (radio.tag == 302){
        timeFlag = 1;
    }
    else{
        timeFlag = 2;
    }
}
// 获取邀请码
- (void)getInviteCode
{
    NSDictionary *parameters = @{@"userId":[NSString stringWithFormat:@"%@",GET_USER_ID],@"sid": GET_U_ID,@"validTime": [NSString stringWithFormat:@"%d",timeFlag]};
    [AFRequestService responseData:NEW_INVITECODE_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == 0) {
             NSString *inviteCode = [dict objectForKey:@"inviteCode"];
            codeField.text = inviteCode;
            
        }
        else if (codeNum == 1){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取失败" message:@"用户id错误" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
        else if (codeNum == 2){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"获取失败" message:@"没有邀请权限" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
    }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){

        codeField = nil;
        self.view = nil;
        
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    codeField = nil;
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
