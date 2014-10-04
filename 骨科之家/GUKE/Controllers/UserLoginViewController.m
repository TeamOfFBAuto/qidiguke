//
//  UserLoginViewController.m
//  登陆页面
//
//  Created by qidi on 14-6-23.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "UserLoginViewController.h"
#import "SqliteClass.h"
#import "SqliteFieldAndTable.h"
#import "Interface.h"
#define USERNAME_FIELD_TAG 101
#define PWD_FIELD_TAG 102
#define LOGIN_TAG 201
#define REMEMBER_PWD_TAG 401
#define AUTO_LOGIN_TAG 402
#define REGISTER_BTN_TAG 403

// 自定义一个UItextField
@interface NEWUITextField : UITextField

@end

@implementation NEWUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 10;
    return iconRect;
}
- (void)drawPlaceholderInRect:(CGRect)rect
{
    //CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetFillColorWithColor(context, [UIColor yellowColor].CGColor);
    [GETColor(149, 149, 149) setFill];
    
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:14.0f]];
}
-(CGRect)placeholderRectForBounds:(CGRect)bounds
{
    
    //return CGRectInset(bounds, 20, 0);
    if (IOS7_LATER) {
        CGRect inset = CGRectMake(25, 14, bounds.size.width, bounds.size.height);
        return inset;
    }else{
        CGRect inset = CGRectMake(25, 10, bounds.size.width, bounds.size.height);
        return inset;
    }

}

-(CGRect)editingRectForBounds:(CGRect)bounds
{
    //return CGRectInset( bounds, 10 , 0 );
    if (IOS7_LATER) {
        return [super editingRectForBounds:bounds];
    }else{
        CGRect inset = CGRectMake(bounds.origin.x+26, bounds.origin.y+8, bounds.size.width, bounds.size.height);
        return inset;
    }

}

-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 50, 0);
    if (IOS7_LATER) {
        return [super textRectForBounds:bounds];
    }else{
    CGRect inset = CGRectMake(bounds.origin.x+26, bounds.origin.y+8, bounds.size.width, bounds.size.height);
    return inset;
    }
    
}

@end

@interface UserLoginViewController ()
{
    MBProgressHUD *HUD;
    NEWUITextField *userName;
    NEWUITextField *pwd;
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
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo@2x" ofType:@"png"]]];
    
    logoView.frame = CGRectMake(3, 13, 35/2, 35/2);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"button_login");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16.0f];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor = [UIColor clearColor];

    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, (44-28)/2+1, 44, 28);
    rightBtn.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    rightBtn.layer.cornerRadius = 4;
    [rightBtn setTitle:@"注册" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.tag =REGISTER_BTN_TAG;
    
    [rightBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];

    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self keyBoardListener];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [self creatUI];
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
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, SCREEN_HEIGHT)];

    _scrollView.contentSize =_scrollView.frame.size;
    
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 放置紫光的logo
    UIImageView *logoView = [[UIImageView alloc] init];
    logoView.frame = CGRectMake((SCREEN_WIDTH-140/2)/2, 50, 140/2, 140/2);
    logoView.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_login_logo@2x" ofType:@"png"]];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = GETColor(19, 179, 93);
    loginBtn.layer.cornerRadius = 3.0f;
    
    loginBtn.frame = CGRectMake(10, SCREEN_HEIGHT-(1136-985)/2-64, (620-20)/2, (1055-985)/2);
    loginBtn.tag = LOGIN_TAG;
    NSString *title = LOCALIZATION(@"button_login");
    [loginBtn setTitle:title forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    // 下侧的登入页
    bgLoginView = [[UIView alloc]initWithFrame:CGRectMake(10, 420/2-64, 300, (600-420)/2)];
    bgLoginView.layer.borderWidth = 1;
    bgLoginView.layer.cornerRadius = 5;
    bgLoginView.layer.borderColor = [GETColor(203, 203, 203) CGColor];
    
    userName = [[NEWUITextField alloc]initWithFrame:CGRectMake(5, 5, 290, 35)];
    //userName.SecureTextEntry = YES;
    [userName setBorderStyle:UITextBorderStyleLine];
    userName.layer.borderColor = [GETColor(203, 203, 203) CGColor];
    userName.layer.borderWidth = 1;
    userName.layer.cornerRadius = 5;
    userName.placeholder = LOCALIZATION(@"login_username_input");
    userName.font = [UIFont systemFontOfSize:18];
    userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userName.keyboardAppearance = UIKeyboardAppearanceDefault;
    userName.keyboardType = UIKeyboardTypeDefault;
    userName.returnKeyType = UIReturnKeyGo;
    userName.tag = USERNAME_FIELD_TAG;
    userName.delegate = self;
    userName.backgroundColor = GETColor(248, 248,248);
    
    UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_user.png"]];
    userName.leftView=imgv;
    userName.leftViewMode = UITextFieldViewModeAlways;
    userName.font = [UIFont systemFontOfSize:15.0f];
    
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,45,300, 1)];
    lineView.backgroundColor = GETColor(203, 203, 203);
    
    pwd = [[NEWUITextField alloc]initWithFrame:CGRectMake(5, 50, 290, 35)];
    //pwd.SecureTextEntry = YES;
    [pwd setBorderStyle:UITextBorderStyleLine];
    pwd.layer.borderColor = [GETColor(203, 203, 203) CGColor];
    pwd.layer.borderWidth = 1;
    pwd.layer.cornerRadius = 5;
    pwd.placeholder = LOCALIZATION(@"login_username_pwd");
    pwd.autocapitalizationType = UITextAutocapitalizationTypeNone;
    pwd.font = [UIFont systemFontOfSize:18];
    pwd.keyboardAppearance = UIKeyboardAppearanceDefault;
    pwd.keyboardType = UIKeyboardTypeDefault;
    pwd.returnKeyType = UIReturnKeyGo;
    pwd.tag = PWD_FIELD_TAG;
    pwd.delegate = self;
    pwd.backgroundColor = GETColor(248, 248,248);
    pwd.font = [UIFont systemFontOfSize:15.0f];
    pwd.secureTextEntry = YES;
    UIImageView *imgv2=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_pwd.png"]];
    pwd.leftView=imgv2;
    pwd.leftViewMode = UITextFieldViewModeAlways;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_NAME] != NULL && [[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_PSW] != NULL) {
        userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_NAME];
        pwd.text = [[NSUserDefaults standardUserDefaults] objectForKey:LOG_USER_PSW];
    }
    
    // 添加手势收键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tableViewGesture];
    
    [bgLoginView addSubview:userName];
    [bgLoginView addSubview:pwd];
    [bgLoginView addSubview:lineView];
    [_scrollView addSubview:bgLoginView];
    [_scrollView addSubview:logoView];
    [_scrollView addSubview:loginBtn];
    [self.view addSubview:viewline];
    [self.view addSubview:_scrollView];
    
}

// 创建记住的视图
- (void)memoryUI{
    UIView * bgSwitch = [[UIView alloc]initWithFrame:CGRectMake(0, bgLoginView.frame.origin.y+bgLoginView.frame.size.height,self.view.frame.size.width, 40)];
    
    rememberPWD = [[CheckBox alloc] initWithDelegate:self];
    rememberPWD.frame = CGRectMake(15, 0, 80, 40);
    rememberPWD.tag = REMEMBER_PWD_TAG;
    NSString *pwdtitle = LOCALIZATION(@"chk_remember_pwd");
    [rememberPWD setTitle:pwdtitle forState:UIControlStateNormal];
    [rememberPWD setTitleColor:GETColor(149, 149, 149) forState:UIControlStateNormal];
    [rememberPWD.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [rememberPWD setChecked:YES];
    [rememberPWD setChecked:[[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberPWD"] boolValue]];
    [bgSwitch addSubview:rememberPWD];
    
    
    autoLogin = [[CheckBox alloc] initWithDelegate:self];
    autoLogin.frame = CGRectMake(120, 0, 80, 40);
    autoLogin.tag = AUTO_LOGIN_TAG;
    NSString *autoLogintitle = LOCALIZATION(@"chk_auto_login");
    [autoLogin setTitle:autoLogintitle forState:UIControlStateNormal];
    [autoLogin setTitleColor:GETColor(149, 149, 149) forState:UIControlStateNormal];
    [autoLogin.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [autoLogin setChecked:YES];
    [bgSwitch addSubview:autoLogin];
    [autoLogin setChecked:[[[NSUserDefaults standardUserDefaults] objectForKey:@"autoLogin"] boolValue]];
    [_scrollView addSubview:bgSwitch];
}
#pragma mark ====== CheckBox Delegate
- (void)didSelectedCheckBox:(CheckBox *)checkbox checked:(BOOL)checked
{
    if (checkbox.tag == REMEMBER_PWD_TAG) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checked] forKey:@"rememberPWD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if (checkbox.tag == AUTO_LOGIN_TAG){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:checked] forKey:@"autoLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

// 键盘收起
- (void)commentTableViewTouchInSide{
    [userName resignFirstResponder];
    [pwd resignFirstResponder];
}
#pragma mark ====== CheckBox Delegate
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"Curl1"context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_scrollView cache:YES];
    if (SCREEN_HEIGHT<568) {
        _scrollView.frame = CGRectMake(0, -100, SCREEN_WIDTH, SCREEN_HEIGHT);
    }else{
        _scrollView.frame = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    [UIView commitAnimations];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"Curl1"context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_scrollView cache:YES];
    _scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
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
        
    }
    if ([pwd isFirstResponder]) {
        [textField resignFirstResponder];
        [self userLogin];
    }
    return YES;
}
#pragma mark ====== button action
- (void)btnClick:(UIButton *)sender{
    if (sender.tag == REGISTER_BTN_TAG) {
        NSLog(@"注册用户");
    }else{
        NSString *alertText = LOCALIZATION(@"login_process");
        [self creatHUD:alertText];
        [HUD show:YES];
        [self userLogin];
    }
}

// 用户登入
- (void)userLogin
{
    // （通过选择是否记住密码）将用户名和密码存到plist文件中
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"rememberPWD"] boolValue]) {
        [[NSUserDefaults standardUserDefaults] setObject:userName.text forKey:LOG_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:pwd.text forKey:LOG_USER_PSW];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else{
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:LOG_USER_NAME];
        [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:LOG_USER_PSW];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    if ([pwd.text isEqualToString:@""] || pwd.text == nil) {
        [HUD hide:YES];
        NSString *alertText = LOCALIZATION(@"login_empty_password");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
        [alert show];
        [HUD hide:YES];
        return;
    }
    if ([userName.text isEqualToString:@""] || userName.text == nil) {
        [HUD hide:YES];
        NSString *alertText = LOCALIZATION(@"login_empty_username");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary *parameters = @{@"username":userName.text,@"password":pwd.text};
    
    [AFRequestService responseData:USER_LOGING_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        
        if ([self getUserIfo:dict]) {
            //  后台执行加载数据：
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                [sqliteAndtable getAllInfo];
                sqliteAndtable = nil;
            dispatch_sync(dispatch_get_main_queue(), ^{
                
            });
           });
            // 跳转到主界面
            AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [appDelegate showControlView:Root_contact];
        }
        
    }];
    
}

//解析登入数据
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
   
    //[[SingleInstance shareManager].objecAarray removeAllObjects];
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        [HUD hide:YES];
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        //UserIfo *model = [[UserIfo alloc]init];
        //存储登入信息
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:userName.text forKey:LOG_USER_NAME];
        [user setObject:pwd.text forKey:LOG_USER_PSW];
        
        [user setObject:[NSString _859ToUTF8:[userDetail objectForKey:@"userId"]] forKey:U_ID];
        [user setObject:[NSString _859ToUTF8:[userDetail objectForKey:@"firstname"]] forKey:U_NAME];
        [user setObject:[NSString _859ToUTF8:[userDetail objectForKey:@"sid"]] forKey:ACCESS_TOKEN_K];
        [user synchronize];
       
        return YES;
    }
    else if (codeNum == CODE_ERROE){
        [HUD hide:YES];
        NSString *alertcontext = LOCALIZATION(@"login_error_pwd");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else{
        [HUD hide:YES];
        return NO;
    }
 
}
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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        HUD = nil;
        userName = nil;
        pwd = nil;
        bgLoginView = nil;
        swh = nil;
        rememberPWD = nil;
        autoLogin = nil;
        _scrollView = nil;
        self.view = nil;
    }
    
}

-(void)dealloc{
    HUD = nil;
    userName = nil;
    pwd = nil;
    bgLoginView = nil;
    swh = nil;
    rememberPWD = nil;
    autoLogin = nil;
    _scrollView = nil;
}

@end
