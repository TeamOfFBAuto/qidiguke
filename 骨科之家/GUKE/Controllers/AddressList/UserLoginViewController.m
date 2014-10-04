//
//  UserLoginViewController.m
//  leliao
//
//  Created by qidi on 14-6-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserLoginViewController.h"
#import "FriendListViewController.h"
#import "Interface.h"
@interface UserLoginViewController ()
{
    UITextField *userName;
    UITextField *pwd;
    UIView *bgView;
    UIView *bgLoginView;
    UISwitch *swh;
    CheckBox *rememberPWD;
    CheckBox *autoLogin;
    UIScrollView *_scrollView;
}
@end

@implementation UserLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [SingleInstance colorFromHexRGB:@"f5f5f5"];
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 40)];
    bgNavi.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_logo"]];
    logoView.frame = CGRectMake(5, 7, 25, 25);
    
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 5, 160, 30)];
    loginLabel.text = LOCALIZATION(@"button_login");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:18];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self keyBoardListener];
    [self creatUI];
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue]) {
//        [self userLogin];
//        return;
//    }
    [self memoryUI];
    
}
- (void)keyBoardListener
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
// 设置登录上侧的布局
- (void)creatUI{
    // 设置一个整体的背景
    UIView *viewline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0)];
    if (currentDev) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
        
    }
    else if (currentDev1){
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 230)];
    }
    else{
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 230)];
    }
    _scrollView.contentSize =_scrollView.frame.size;
    
    bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 320, 70)];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    UILabel *loginLabel = [[UILabel alloc]init];
    loginLabel.frame = CGRectMake(5, 5, 150, 50);
    loginLabel.text = LOCALIZATION(@"login_back");
    loginLabel.textColor = [UIColor purpleColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"task_btn"] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake(200, 5, 90, 45);
    loginBtn.tag = 201;
    NSString *title = LOCALIZATION(@"button_login");
    [loginBtn setTitle:title forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    // 下侧的登入页
    CGFloat height = bgView.frame.size.height + bgView.frame.origin.y;
    bgLoginView = [[UIView alloc]initWithFrame:CGRectMake(5, height, 310, 85)];
    bgLoginView.layer.borderWidth = 1;
    bgLoginView.layer.cornerRadius = 5;
    bgLoginView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    userName = [[UITextField alloc]initWithFrame:CGRectMake(2, 5, 306, 30)];
    //userName.SecureTextEntry = YES;
    [userName setBorderStyle:UITextBorderStyleLine];
    userName.layer.borderColor = [[UIColor orangeColor]CGColor];
    userName.layer.borderWidth = 1;
    userName.layer.cornerRadius = 5;
    userName.font = [UIFont systemFontOfSize:18];
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userName.keyboardAppearance = UIKeyboardAppearanceDefault;
    userName.keyboardType = UIKeyboardTypeDefault;
    userName.returnKeyType = UIReturnKeyGo;
    userName.tag = 101;
    userName.delegate = self;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,42,310, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"task_line"]];
    
    pwd = [[UITextField alloc]initWithFrame:CGRectMake(2, 50, 306, 30)];
    //pwd.SecureTextEntry = YES;
    [pwd setBorderStyle:UITextBorderStyleLine];
    pwd.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    pwd.layer.borderWidth = 1;
    pwd.layer.cornerRadius = 5;
    pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwd.font = [UIFont systemFontOfSize:18];
    pwd.keyboardAppearance = UIKeyboardAppearanceDefault;
    pwd.keyboardType = UIKeyboardTypeDefault;
    pwd.returnKeyType = UIReturnKeyGo;
    pwd.tag = 102;
    pwd.delegate = self;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"username"] != NULL && [[NSUserDefaults standardUserDefaults] objectForKey:@"password"] != NULL) {
        userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
        pwd.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    }
    
    
    [bgLoginView addSubview:userName];
    [bgLoginView addSubview:pwd];
    [bgLoginView addSubview:lineView];
    [_scrollView addSubview:bgLoginView];
    
    [bgView addSubview:loginLabel];
    [bgView addSubview:loginBtn];
    [_scrollView addSubview:bgView];
    [self.view addSubview:viewline];
    [self.view addSubview:_scrollView];
    
}

// 创建记住的视图
- (void)memoryUI{
    UIView * bgSwitch = [[UIView alloc]initWithFrame:CGRectMake(0, bgLoginView.frame.origin.y+bgLoginView.frame.size.height,self.view.frame.size.width, 40)];
    
    rememberPWD = [[CheckBox alloc] initWithDelegate:self];
    rememberPWD.frame = CGRectMake(20, 0, 80, 40);
    rememberPWD.tag = 401;
    NSString *pwdtitle = LOCALIZATION(@"chk_remember_pwd");
    [rememberPWD setTitle:pwdtitle forState:UIControlStateNormal];
    [rememberPWD setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [rememberPWD.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [rememberPWD setChecked:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberPWD"] boolValue]];
    [bgSwitch addSubview:rememberPWD];
    
    
    autoLogin = [[CheckBox alloc] initWithDelegate:self];
    autoLogin.frame = CGRectMake(120, 0, 80, 40);
    autoLogin.tag = 402;
    NSString *autoLogintitle = LOCALIZATION(@"chk_auto_login");
    [autoLogin setTitle:autoLogintitle forState:UIControlStateNormal];
    [autoLogin setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [autoLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [bgSwitch addSubview:autoLogin];
    [autoLogin setChecked:[[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue]];
    [_scrollView addSubview:bgSwitch];
}
#pragma mark ====== CheckBox Delegate
- (void)didSelectedCheckBox:(CheckBox *)checkbox checked:(BOOL)checked
{
    if (checkbox.tag == 401) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checked] forKey:@"rememberPWD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (checkbox.tag == 402){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checked] forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}
#pragma mark ====== CheckBox Delegate
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, self.view.frame.size.height - height);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"Curl1"context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_scrollView cache:YES];
    _scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [userName resignFirstResponder];
    [pwd resignFirstResponder];
}
// 点击return健需要处理的事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([userName isFirstResponder]) {
        [pwd becomeFirstResponder];
        pwd.layer.borderColor = [[UIColor orangeColor]CGColor];
        userName.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        // [self viewAnimation:216];
    }
    if ([pwd isFirstResponder]) {
        [textField resignFirstResponder];
        [self userLogin];
    }
    return YES;
}
#pragma mark ====== button action
- (void)btnClick:(UIButton *)sender{
    [self userLogin];
}
//
#pragma mark ===== UITextFieldDelegate method
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // 判断改变输入框的border的颜色
    if (textField.tag == 101) {
        
        userName.layer.borderColor = [[UIColor orangeColor]CGColor];
        pwd.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        
    }
    if (textField.tag == 102) {
        pwd.layer.borderColor = [[UIColor orangeColor]CGColor];
        userName.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }
    return YES;
}
// 用户登入
- (void)userLogin
{
    // （通过选择是否记住密码）将用户名和密码存到plist文件中
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberPWD"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:pwd.text forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"username"];
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"password"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    if ([userName.text isEqualToString:@""] || [pwd.text isEqualToString:@""] || userName.text == nil || pwd.text == nil) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请填写完整的登入信息" message:@"" delegate:self cancelButtonTitle:@"ok"otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *parameters = @{@"username":userName.text,@"password":pwd.text};
    [AFRequestService responseData:USER_LOGING_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        //NSLog(@"%@",responseData);
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userIfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self getUserIfo:dict]) {
            FriendListViewController *friendList = [[FriendListViewController alloc]init];
            [self.navigationController pushViewController:friendList animated:YES];
        }
        
    }];
    
}


//解析登入数据
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
    NSLog(@"%@",userIfo);
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == 0) {
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        UserIfo *model = [[UserIfo alloc]init];
        model.address = [userDetail valueForKey:@"address"];
        model.allowPosition = [userDetail valueForKey:@"allowPosition"];
        model.articleBg = [userDetail valueForKey:@"articleBg"];
        model.bgUpdateTime = [userDetail valueForKey:@"bgUpdateTime"];
        model.chkATime = [userDetail valueForKey:@"chkATime"];
        model.cityName = [userDetail valueForKey:@"cityName"];
        model.companyId = [userDetail valueForKey:@"companyId"];
        model.createDate = [userDetail valueForKey:@"createDate"];
        model.deletePerm = [userDetail valueForKey:@"deletePerm"];
        model.district = [userDetail valueForKey:@"district"];
        model.email = [userDetail valueForKey:@"email"];
        model.firstname = [userDetail valueForKey:@"firstname"];
        model.firstnameen = [userDetail valueForKey:@"firstnameen"];
        model.icon = [userDetail valueForKey:@"icon"];
        model.iconUpdateTime = [userDetail valueForKey:@"iconUpdateTime"];
        model.inviteCodeId = [userDetail valueForKey:@"inviteCodeId"];
        model.invitePerm = [userDetail valueForKey:@"invitePerm"];
        model.itcode = [userDetail valueForKey:@"itcode"];
        model.lastChkETime = [userDetail valueForKey:@"lastChkETime"];
        model.lastLogin = [userDetail valueForKey:@"lastLogin"];
        model.lastLoginIP = [userDetail valueForKey:@"lastLoginIP"];
        model.latitude = [userDetail valueForKey:@"latitude"];
        model.loginCount = [userDetail valueForKey:@"loginCount"];
        model.longitude = [userDetail valueForKey:@"longitude"];
        model.mailStatus = [userDetail valueForKey:@"mailStatus"];
        model.memo = [userDetail valueForKey:@"memo"];
        model.mobile = [userDetail valueForKey:@"mobile"];
        model.organization = [userDetail valueForKey:@"organization"];
        model.organizationen = [userDetail valueForKey:@"organizationen"];
        model.parentCode = [userDetail valueForKey:@"parentCode"];
        model.parentId = [userDetail valueForKey:@"parentId"];
        model.position = [userDetail valueForKey:@"position"];
        model.positionen = [userDetail valueForKey:@"positionen"];
        model.province = [userDetail valueForKey:@"province"];
        model.sex = [userDetail valueForKey:@"sex"];
        model.showMobile = [userDetail valueForKey:@"showMobile"];
        model.sid = [userDetail valueForKey:@"sid"];
        model.status = [userDetail valueForKey:@"status"];
        model.street = [userDetail valueForKey:@"street"];
        model.street_number = [userDetail valueForKey:@"street_number"];
        model.sysAdmin = [userDetail valueForKey:@"sysAdmin"];
        model.telephone = [userDetail valueForKey:@"telephone"];
        model.userId = [userDetail valueForKey:@"userId"];
        model.userType = [userDetail valueForKey:@"userType"];
        model.username = [userDetail valueForKey:@"username"];
        model.versionName = [userDetail valueForKey:@"versionName"];
        [[SingleInstance shareManager].objecAarray addObject:model];
        model = nil;
       
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
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
