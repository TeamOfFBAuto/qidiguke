//
//  ChangPWDViewController.m
//  WeiTongShi
//
//  Created by qidi on 14-6-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ChangPWDViewController.h"
#import "Interface.h"
@interface ChangPWDViewController ()
{
    //UIView *_bgView;
    UITextField *oldPWD;
    UITextField *newPWD;
    UITextField *repeatPWD;
    NSArray *fieldArr;//存放输入框
}
@end

@implementation ChangPWDViewController

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
    [self creatUI];
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"setting_changepwd");
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
    rightItem.frame = CGRectMake(280, 30, 60, 30);
    rightItem.tag =202;
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
- (void)btnClick:(UIButton *)sender
{
    if (sender.tag == 201) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if(sender.tag == 202){
        [self changPWD];
    }
    else{
        return;
    }
}
- (void)creatUI{
//    _bgView = [[UIView alloc]initWithFrame:CGRectMake(5, 5, 310, 142)];
//    _bgView.layer.borderWidth = 1;
//    _bgView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
//    _bgView.layer.cornerRadius = 5;
    
    // 旧密码
    UILabel *oldPWDLabel = [[UILabel alloc]initWithFrame:CGRectMake(66/2, 190/2-64, (166-66)/2, (220-190)/2)];
    oldPWDLabel.text = LOCALIZATION(@"setting_old_pwd");
    oldPWDLabel.textAlignment = NSTextAlignmentLeft;
    oldPWDLabel.textColor = [UIColor blackColor];
    oldPWDLabel.font = [UIFont systemFontOfSize:13.0f];
    
    oldPWD = [[UITextField alloc]initWithFrame:CGRectMake(170/2, 175/2-64, (580-170)/2, (235-175)/2)];
    oldPWD.keyboardAppearance = UIKeyboardAppearanceDefault;
    oldPWD.keyboardType = UIKeyboardTypeDefault;
    oldPWD.returnKeyType = UIReturnKeyNext;
    [oldPWD setBorderStyle:UITextBorderStyleLine];
    oldPWD.layer.borderColor = [GETColor(183, 183, 183) CGColor];
    oldPWD.layer.borderWidth = 1;
    oldPWD.layer.cornerRadius = 4.0f;
    oldPWD.delegate = self;
    oldPWD.tag = 101;

    UIView *lineView1 = [[UIView alloc] init];
    lineView1.frame = CGRectMake(0, 254/2-64, SCREEN_WIDTH, 1);
    lineView1.backgroundColor = GETColor(234, 234, 234);
    
    // 新密码
    UILabel *newPWDLabel = [[UILabel alloc]initWithFrame:CGRectMake(66/2, 290/2-64, (166-66)/2, (220-190)/2)];
    newPWDLabel.text = LOCALIZATION(@"setting_new_pwd");
    newPWDLabel.textAlignment = NSTextAlignmentLeft;
    newPWDLabel.textColor = [UIColor blackColor];
    newPWDLabel.font = [UIFont systemFontOfSize:13.0f];
    
    newPWD = [[UITextField alloc]initWithFrame:CGRectMake(170/2, 274/2-64, (580-170)/2, (235-175)/2)];
    newPWD.keyboardAppearance = UIKeyboardAppearanceDefault;
    newPWD.keyboardType = UIKeyboardTypeDefault;
    newPWD.returnKeyType = UIReturnKeyNext;
    [newPWD setBorderStyle:UITextBorderStyleLine];
    newPWD.layer.borderColor = [GETColor(183, 183, 183) CGColor];
    newPWD.layer.borderWidth = 1;
    newPWD.layer.cornerRadius = 4.0f;
    newPWD.delegate = self;
    newPWD.tag = 102;
    
    UIView *lineView2 = [[UIView alloc] init];
    lineView2.frame = CGRectMake(0, 354/2-64, SCREEN_WIDTH, 1);
    lineView2.backgroundColor = GETColor(234, 234, 234);
    
    // 确认密码
    UILabel *repeatPWDLabel = [[UILabel alloc]initWithFrame:CGRectMake(40/2, 384/2-64, 60, (220-190)/2)];
    repeatPWDLabel.text = LOCALIZATION(@"setting_repeat_pwd");
    repeatPWDLabel.textAlignment = NSTextAlignmentLeft;
    repeatPWDLabel.textColor = [UIColor blackColor];
    repeatPWDLabel.font = [UIFont systemFontOfSize:13.0f];
    
    repeatPWD = [[UITextField alloc]initWithFrame:CGRectMake(170/2, 374/2-64, (580-170)/2, (235-175)/2)];
    repeatPWD.keyboardAppearance = UIKeyboardAppearanceDefault;
    repeatPWD.keyboardType = UIKeyboardTypeDefault;
    repeatPWD.returnKeyType = UIReturnKeyNext;
    //PWD.secureTextEntry = YES;
    [repeatPWD setBorderStyle:UITextBorderStyleLine];
    repeatPWD.layer.borderColor = [GETColor(183, 183, 183) CGColor];
    repeatPWD.layer.borderWidth = 1;
    repeatPWD.layer.cornerRadius = 4.0f;
    repeatPWD.delegate = self;
    repeatPWD.tag = 103;
    
    UIView *lineView3 = [[UIView alloc] init];
    lineView3.frame = CGRectMake(0, 454/2-64, SCREEN_WIDTH, 1);
    lineView3.backgroundColor = GETColor(234, 234, 234);
    
    //加载试图
    [self.view addSubview:oldPWDLabel];
    [self.view addSubview:oldPWD];
    
    [self.view addSubview:newPWDLabel];
    [self.view addSubview:newPWD];
    
    [self.view addSubview:repeatPWDLabel];
    [self.view addSubview:repeatPWD];
    
    [self.view addSubview:lineView1];
    [self.view addSubview:lineView2];
    [self.view addSubview:lineView3];
    // 将四个输入框存放到数组中
    fieldArr = @[oldPWD,newPWD,repeatPWD];
}
- (void)changPWD
{
    // 旧密码为空
    if ([oldPWD.text isEqualToString:@""] || oldPWD.text == nil ) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"旧密码不能为空" message:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
        [alert show];
        return;
    }
    // 新密密码为空
    if ([newPWD.text isEqualToString:@""] || newPWD.text == nil ) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"旧密码不能为空" message:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
        [alert show];
        return;
    }
    // 新密码和确认密码是否一致
    if (![newPWD.text isEqualToString:repeatPWD.text]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"新密码和验证密码不一致" message:@"请重新输入" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSDictionary * parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"oldpassword": oldPWD.text,@"newpassword": newPWD.text};
    [AFRequestService responseData:USER_CHANGPWD_URL andparameters:parameters andResponseData:^(id responseData) {
        NSDictionary *dict = (NSDictionary *)responseData;
        NSUInteger codeNum = [[dict valueForKey:@"code"] integerValue];
        if (codeNum == 0) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改成功！" message:@"" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
        else if (codeNum == 1){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:@"用户id有误！" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles:nil];
            [alert show];
        }
        else if (codeNum == 2){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"修改失败" message:@"旧密码输入错误，请重新输入！" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
            [alert show];
        }
        
    }];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:{
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 1:{
            
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
// 键盘收起
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [oldPWD resignFirstResponder];
    [newPWD resignFirstResponder];
    [repeatPWD resignFirstResponder];
     
}
#pragma mark ======= UITextFieldDelegate
//// 改变输入边框的形状和颜色
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){

        //_bgView = nil;
        oldPWD = nil;
        newPWD = nil;
        repeatPWD = nil;
        fieldArr = nil;
        self.view = nil;
        
    }
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    //_bgView = nil;
    oldPWD = nil;
    newPWD = nil;
    repeatPWD = nil;
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
