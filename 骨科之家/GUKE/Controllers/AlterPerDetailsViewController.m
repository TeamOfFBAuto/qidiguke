//
//  AlterPerDetailsViewController.m
//  WeiTongShi
//
//  Created by qidi on 14-6-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AlterPerDetailsViewController.h"
#import "Interface.h"
#import "UserIfo.h"
#define RIGHTITEM_BTN_TAG 202
@interface AlterPerDetailsViewController ()
{
    UIScrollView *_scrollView;
    //UIView *_bgView;
    UIButton *nextBtn;
    UITextField *email;
    UITextField *trueName;
    UITextField *phoneNumber;
    UITextField *company;
    UITextView *memo;
    UITextField *position;
    UITextField *address;
    NSArray *fieldArr;//存放输入框
    RadioButton *manBtn;
    RadioButton *womanBtn;
    NSUInteger sexFlag;
    NSUInteger keyBoardHeight;
    UserIfo *userModel;
}
@end

@implementation AlterPerDetailsViewController

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
    [self navigetion];
    [self creatUI];
    [self getData];
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
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_unis_logo@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"setting_changIfo");
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
    
    UIButton * rightItem = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItem.frame = CGRectMake(281, 30, 59, 30);
    rightItem.tag =RIGHTITEM_BTN_TAG;
    rightItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *subMit = LOCALIZATION(@"button_submit");
    rightItem.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [rightItem setTitle:subMit forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"submit_bg_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = item2;
    
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
// UIButtonClick Action
- (void)btnClick:(UIButton *)sender
{
    if(sender.tag == RIGHTITEM_BTN_TAG){
        [self changInfo];
    }
    else{
        return;
    }
}

// 设置UI布局
- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    UserIfo *model = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
//    _bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, viewSize.width-10, 390)];
//    _bgView.layer.borderWidth = 1;
//    _bgView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    _bgView.layer.cornerRadius = 5;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, viewSize.height)];
 
    _scrollView.contentSize = CGSizeMake(viewSize.width, 568);
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 姓名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30, 50, 12)];
    nameLabel.text = LOCALIZATION(@"userinfo_firstname");
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.font = [UIFont systemFontOfSize:12.0f];
    
    trueName = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2, (560-150)/2, (235-175)/2)];
    trueName.text =model.firstname;
    //trueName.keyboardAppearance = UIKeyboardAppearanceDefault;
    //trueName.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    //trueName.returnKeyType = UIReturnKeyNext;
    [trueName setBorderStyle:UITextBorderStyleLine];
    trueName.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    trueName.layer.cornerRadius = 3;
    trueName.layer.borderWidth = 1;
    trueName.delegate = self;
    trueName.tag = 101;
    trueName.font = [UIFont systemFontOfSize:14.0f];
    trueName.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // 分割线1
    UIView *lineView1 = [[UIView alloc] init];
    lineView1.backgroundColor = GETColor(234, 234, 234);
    lineView1.frame = CGRectMake(0, (255-130)/2, viewSize.width, 1);
    
    //邮箱
    UILabel *emailLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2, 50, 12)];
    emailLabel.text = LOCALIZATION(@"userinfo_email_ch");
    emailLabel.textAlignment = NSTextAlignmentLeft;
    emailLabel.textColor = [UIColor blackColor];
    emailLabel.font = [UIFont systemFontOfSize:12.0f];
    
    email = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2, (560-150)/2, (235-175)/2)];
    email.text = model.email;
//    email.keyboardAppearance = UIKeyboardAppearanceDefault;
//    email.keyboardType = UIKeyboardTypeDefault;
//    email.returnKeyType = UIReturnKeyNext;
    [email setBorderStyle:UITextBorderStyleLine];
    email.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    email.layer.borderWidth = 1;
    email.layer.cornerRadius = 3;
    email.delegate = self;
    email.tag = 102;
    email.font = [UIFont systemFontOfSize:14.0f];
    email.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // 分割线2
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.backgroundColor = GETColor(234, 234, 234);
    lineView2.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2, viewSize.width, 1);
    
    
    // 手机
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*2, 50, 12)];
    phoneLabel.text = LOCALIZATION(@"userinfo_moblephone");
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor blackColor];
    phoneLabel.font = [UIFont systemFontOfSize:12.0f];
    
    phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2*2, (560-150)/2, (235-175)/2)];
    phoneNumber.text = model.mobile;
//    phoneNumber.keyboardAppearance = UIKeyboardAppearanceDefault;
//    phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
//    phoneNumber.returnKeyType = UIReturnKeyNext;
    [phoneNumber setBorderStyle:UITextBorderStyleLine];
    phoneNumber.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    phoneNumber.layer.borderWidth = 1;
    phoneNumber.layer.cornerRadius = 3;
    phoneNumber.delegate = self;
    phoneNumber.tag = 103;
    phoneNumber.font = [UIFont systemFontOfSize:14.0f];
    phoneNumber.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    //分割线3
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.backgroundColor = GETColor(234, 234, 234);
    lineView3.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2*2, viewSize.width, 1);
    
    // 性别
    sexFlag = [model.sex integerValue];
    UILabel *sexLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*3, 50, 12)];
    sexLabel.text = LOCALIZATION(@"userinfo_sex");
    sexLabel.textAlignment = NSTextAlignmentLeft;
    sexLabel.textColor = [UIColor blackColor];
    sexLabel.font = [UIFont systemFontOfSize:12.0f];
    
    manBtn = [[RadioButton alloc] initWithDelegate:self groupId:@"sex"];
    manBtn.frame = CGRectMake(75, (480-135)/2, 60, 30);
    [manBtn setTitle:LOCALIZATION(@"userinfo_man") forState:UIControlStateNormal];
    manBtn.tag = 301;
    [manBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [manBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    
    womanBtn = [[RadioButton alloc] initWithDelegate:self groupId:@"sex"];
    womanBtn.frame = CGRectMake(130, (480-135)/2, 60, 30);
    womanBtn.tag = 302;
    [womanBtn setTitle:LOCALIZATION(@"userinfo_woman") forState:UIControlStateNormal];
    [womanBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [womanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:13.0f]];
    if (sexFlag == 0) {
        [manBtn setChecked:YES];
    }
    else{
        [womanBtn setChecked:YES];
    }
    // 分割线4
    UIView *lineView4 = [[UIView alloc] init];
    lineView4.backgroundColor = GETColor(234, 234, 234);
    lineView4.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2*3, viewSize.width, 1);
    
    // 单位
    UILabel *companyLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*4-3, 50, 12)];
    companyLabel.text = LOCALIZATION(@"userinfo_company");
    companyLabel.textAlignment = NSTextAlignmentLeft;
    companyLabel.textColor = [UIColor blackColor];
    companyLabel.font = [UIFont systemFontOfSize:12.0f];
    
    company = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2*4-3, (560-150)/2, (235-175)/2)];
    company.text = model.company;
//    company.keyboardAppearance = UIKeyboardAppearanceDefault;
//    company.keyboardType = UIKeyboardTypeDefault;
//    company.returnKeyType = UIReturnKeyNext;
    [company setBorderStyle:UITextBorderStyleLine];
    company.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    company.layer.borderWidth = 1;
    company.layer.cornerRadius = 3;
    company.delegate = self;
    company.tag = 104;
    company.font = [UIFont systemFontOfSize:14.0f];
    company.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    // 分割线5
    UIView *lineView5 = [[UIView alloc] init];
    lineView5.backgroundColor = GETColor(234, 234, 234);
    lineView5.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2*4, viewSize.width, 1);
    
    // 职位
    UILabel *positionLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*5-4, 50, 12)];
    positionLabel.text = LOCALIZATION(@"userinfo_work");
    positionLabel.textAlignment = NSTextAlignmentLeft;
    positionLabel.textColor = [UIColor blackColor];
    positionLabel.font = [UIFont systemFontOfSize:12.0f];
    
    position = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2*5-4, (560-150)/2, (235-175)/2)];
    position.text = model.position;
//    position.keyboardAppearance = UIKeyboardAppearanceDefault;
//    position.keyboardType = UIKeyboardTypeDefault;
//    position.returnKeyType = UIReturnKeyNext;
    [position setBorderStyle:UITextBorderStyleLine];
    position.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    position.layer.borderWidth = 1;
    position.delegate = self;
    position.tag = 105;
    position.font = [UIFont systemFontOfSize:14.0f];
    position.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    // 分割线6
    UIView *lineView6 = [[UIView alloc] init];
    lineView6.backgroundColor = GETColor(234, 234, 234);
    lineView6.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2*5, viewSize.width, 1);
    
    // 地址
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*6-5, 50, 12)];
    addressLabel.text = LOCALIZATION(@"userinfo_address");
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.textColor = [UIColor blackColor];
    addressLabel.font = [UIFont systemFontOfSize:12.0f];
    
    address = [[UITextField alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2*6-5, (560-150)/2, (235-175)/2)];
    address.text = model.address;
//    address.keyboardAppearance = UIKeyboardAppearanceDefault;
//    address.keyboardType = UIKeyboardTypeDefault;
//    address.returnKeyType = UIReturnKeyNext;
    //[address setBorderStyle:UITextBorderStyleLine];
    address.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    address.layer.borderWidth = 1;
    address.layer.cornerRadius = 3;
    address.delegate = self;
    address.tag = 106;
    address.font = [UIFont systemFontOfSize:14.0f];
    address.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
//    // 分割线7
    UIView *lineView7 = [[UIView alloc] init];
    lineView7.backgroundColor = GETColor(234, 234, 234);
    lineView7.frame = CGRectMake(0, (255-130)/2+(270-175+4)/2*6, viewSize.width, 1);
    
    // 备注
    UILabel *remark = [[UILabel alloc]initWithFrame:CGRectMake(35, 30+(270-175+5)/2*7-7, 50, 12)];
    remark.text = LOCALIZATION(@"userinfo_remark");
    remark.textAlignment = NSTextAlignmentLeft;
    remark.textColor = [UIColor blackColor];
    remark.font = [UIFont systemFontOfSize:12.0f];
    
    memo = [[UITextView alloc]initWithFrame:CGRectMake(75, 45/2+(270-175+5)/2*7-5, (560-150)/2, (1050-860)/2)];
    memo.text = model.memo;
//    memo.keyboardAppearance = UIKeyboardAppearanceDefault;
//    memo.keyboardType = UIKeyboardTypeDefault;
//    memo.returnKeyType = UIReturnKeyNext;
    //[memo setBorderStyle:UITextBorderStyleLine];
    memo.layer.borderColor = [GETColor(234, 234, 234) CGColor];
    memo.layer.borderWidth = 1;
    memo.layer.cornerRadius = 3;
    memo.delegate = self;
    memo.tag = 107;
    memo.font = [UIFont systemFontOfSize:14.0f];
    
    // 添加手势收键盘
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_scrollView addGestureRecognizer:tableViewGesture];
    
    //加载试图
    [_scrollView addSubview:nameLabel];
    [_scrollView addSubview:trueName];
    
    [_scrollView addSubview:emailLabel];
    [_scrollView addSubview:email];
    
    [_scrollView addSubview:phoneLabel];
    [_scrollView addSubview:phoneNumber];
    
    [_scrollView addSubview:sexLabel];
    [_scrollView addSubview:manBtn];
    [_scrollView addSubview:womanBtn];
    
    [_scrollView addSubview:companyLabel];
    [_scrollView addSubview:company];
    
    [_scrollView addSubview:positionLabel];
    [_scrollView addSubview:position];
    
    [_scrollView addSubview:addressLabel];
    [_scrollView addSubview:address];
    
    [_scrollView addSubview:remark];
    [_scrollView addSubview:memo];
    
    [_scrollView addSubview:lineView1];
    [_scrollView addSubview:lineView2];
    [_scrollView addSubview:lineView3];
    [_scrollView addSubview:lineView4];
    [_scrollView addSubview:lineView5];
    [_scrollView addSubview:lineView6];
    [_scrollView addSubview:lineView7];
    [self.view addSubview:_scrollView];
    // 将四个输入框存放到数组中
    fieldArr = @[trueName,email,phoneNumber,company,position,address,memo];
}

#pragma mark ====== keyboardAction
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    _scrollView.frame = CGRectMake(_scrollView.frame.origin.x, _scrollView.frame.origin.y, _scrollView.frame.size.width, self.view.frame.size.height - height);
    _scrollView.contentOffset = CGPointMake(0, height);
    keyBoardHeight = height;
}
//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [UIView beginAnimations:@"Curl1"context:nil];//动画开始
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:_scrollView cache:YES];
    _scrollView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    _scrollView.contentSize = CGSizeMake(viewSize.width, 568);
    _scrollView.contentOffset = CGPointMake(0, 0);
    [UIView commitAnimations];

    
}
// 键盘收起
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
// 键盘收起
- (void)commentTableViewTouchInSide{
    [trueName resignFirstResponder];
    [email resignFirstResponder];
    [phoneNumber resignFirstResponder];
    [company resignFirstResponder];
    [position resignFirstResponder];
    [address resignFirstResponder];
    [memo resignFirstResponder];
}
#pragma mark ======= UITextFieldDelegate
//// 改变输入边框的形状和颜色
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if ((self.view.frame.size.height - keyBoardHeight)<(textField.frame.origin.y+textField.frame.size.height)) {
//        _scrollView.contentOffset = CGPointMake(0,(textField.frame.origin.y+textField.frame.size.height)-(self.view.frame.size.height - keyBoardHeight));// (self.view.frame.size.height - 216)-(textField.bounds.origin.y+textField.bounds.size.height);
//    }
//    
//    for (UITextField *field in fieldArr) {
//        if (textField.tag == field.tag) {
//            field.layer.borderColor = [[UIColor orangeColor]CGColor];
//            field.layer.borderWidth = 2;
//        }
//        else{
//            field.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//            field.layer.borderWidth = 1;
//        }
//    }
//}
#pragma mark ====== RadioButtonDelegate
- (void)didSelectedRadioButton:(RadioButton *)radio groupId:(NSString *)groupId
{
    if (radio.tag == 301) {
        sexFlag = 0;
    }
    else if (radio.tag == 302){
        sexFlag = 1;
    }
    else{
        return;
    }
    
}
- (void)changInfo
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"firstname":trueName.text,@"email":email.text,@"mobile":phoneNumber.text,@"sex":[NSString stringWithFormat:@"%d",sexFlag],@"company":company.text,@"position":position.text,@"address":address.text,@"memo":memo.text};
    [AFRequestService responseData:USER_CHANGIFO_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict valueForKeyPath:@"code"] integerValue];
        if (codeNum == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"信息修改成功" message:@"" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alert show];
        }
        else if (codeNum == 1){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:@"是否继续修改" delegate:self cancelButtonTitle:@"否"otherButtonTitles:@"是",nil];
            [alert show];
        }
        else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"其他的信息错误" message:@"" delegate:self cancelButtonTitle:@"确定"otherButtonTitles:nil];
            [alert show];
            return;
        }
        NSLog(@"%@",dict);
        
    }];
}

// 获取服务器上原数据
- (void)getData
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":GET_USER_ID};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        if ([self getUserIfo:dict]) {
            [self updateData];
        }

    }];
}
//获取用户详细信息
- (BOOL)getUserIfo:(NSDictionary *)userIfo
{
    NSUInteger codeNum = [[userIfo objectForKey:@"code"] integerValue];
    if (codeNum == CODE_SUCCESS) {
        NSDictionary *userDetail = [userIfo objectForKey:@"user"];
        NSLog(@"测试测试测试测试123%@",userDetail);
        userModel = [[UserIfo alloc]init];
        userModel.address = [userDetail valueForKey:@"address"];
        userModel.allowPosition = [userDetail valueForKey:@"allowPosition"];
        userModel.articleBg = [userDetail valueForKey:@"articleBg"];
        userModel.bgUpdateTime = [userDetail valueForKey:@"bgUpdateTime"];
        userModel.chkATime = [userDetail valueForKey:@"chkATime"];
        userModel.cityName = [userDetail valueForKey:@"cityName"];
        userModel.company = [userDetail valueForKey:@"company"];
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
    else if (codeNum == CODE_ERROE){
        
        NSString *alertcontext = LOCALIZATION(@"alter_error_me");
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

// 更新请求完毕后的网络数据
- (void)updateData
{
    trueName.text = userModel.firstname;
    email.text = userModel.email;
    phoneNumber.text = userModel.mobile;
    company.text = userModel.company;
    position.text = userModel.position;
    address.text = userModel.address;
    memo.text = userModel.memo;
    if ([userModel.sex isEqualToString:@"0"]) {
        [manBtn setChecked:YES];
    }else{
        [womanBtn setChecked:YES];
    }

}


#pragma mark ====== UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            //修改头像
        }
            break;
        default:
            break;
    }
    if (buttonIndex == 0) {
        
    }
    
    else{
        return;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        
        _scrollView = nil;
        //_bgView = nil;
        email = nil;
        trueName = nil;
        phoneNumber = nil;
        company = nil;
        memo = nil;
        position = nil;
        address = nil;
        fieldArr = nil;
        self.view = nil;
        
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    _scrollView = nil;
    //_bgView = nil;
    email = nil;
    trueName = nil;
    phoneNumber = nil;
    company = nil;
    memo = nil;
    position = nil;
    address = nil;
    fieldArr = nil;
    
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
