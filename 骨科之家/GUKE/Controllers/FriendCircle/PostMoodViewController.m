//
//  PostMoodViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-15.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "PostMoodViewController.h"
#import "Interface.h"
@interface PostMoodViewController ()
{
    MBProgressHUD *HUD;
    UIView *head_bg;
    UITextView *moodContent;
    UITableView *_tableView;
    NSMutableArray *frindsArray;
    NSMutableArray *userArray;
    NSInteger index;
    UIImageView *line;
}
@end

@implementation PostMoodViewController

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
    if (IOS7_LATER) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self navigetion];
    [self creatUI];
    
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
    loginLabel.text = LOCALIZATION(@"userarticle_newtext");
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
    rightItem.tag =202;
    rightItem.titleLabel.textAlignment = NSTextAlignmentCenter;
    NSString *subMit = LOCALIZATION(@"button_send");
    rightItem.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [rightItem setTitle:subMit forState:UIControlStateNormal];
    [rightItem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightItem setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"submit_bg_ico@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    [rightItem addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc]initWithCustomView:rightItem];
    self.navigationItem.rightBarButtonItem = item2;
}
- (void)creatUI
{
    head_bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 40)];
    [head_bg setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"home_head"]]];
    
    UIButton *right_searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [right_searchBtn setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"search_icon@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
    right_searchBtn.frame = CGRectMake(0, 0, 25, 25);
    [right_searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    right_searchBtn.tag = 301;
    
    moodContent = [[UITextView alloc]init];
    moodContent.text = LOCALIZATION(@"userarticle_newtext_hint");
    moodContent.backgroundColor = [UIColor clearColor];
    moodContent.textColor = [UIColor grayColor];
    moodContent.keyboardType = UIKeyboardTypeDefault;
    moodContent.font = [UIFont systemFontOfSize:16];
    moodContent.returnKeyType = UIReturnKeyDefault;
    [moodContent becomeFirstResponder];
    moodContent.frame = CGRectMake(10, 5, viewSize.width-20, [self suggestContentHeight]+5);
    moodContent.autocapitalizationType = UITextAutocapitalizationTypeNone;
    moodContent.delegate = self;
    
    line = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]]];
    
    line.frame = CGRectMake(5, moodContent.frame.size.height+moodContent.frame.origin.y+5, viewSize.width-10, 4);
    [head_bg addSubview:line];
    [head_bg addSubview:moodContent];
    [self.view addSubview:head_bg];
    
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnClick:(UIButton *)sender{
    [moodContent resignFirstResponder];
    [self subMit];
}
// 点击收起键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [moodContent resignFirstResponder];
}
- (void)subMit
{
    if ([moodContent.text isEqualToString:@""] || moodContent.text == nil ) {
        NSString *alertcontext = LOCALIZATION(@"userarticle_newtext_empty");
        NSString *alertText = LOCALIZATION(@"dialog_prompt");
        NSString *alertOk = LOCALIZATION(@"dialog_ok");
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
        alert.tag = 403;
        [alert show];
    }else{
        [self creatHUD:LOCALIZATION(@"userarticle_newtext_sending")];
        [HUD show:YES];
        NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"context":moodContent.text,@"isShare":ISNOT_SHARE_CODE};
        [AFRequestService responseData:USER_ARTICEL_NEW andparameters:parameters andResponseData:^(id responseData) {
            NSDictionary * dict = (NSDictionary *)responseData;
            NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
            if (codeNum == CODE_SUCCESS) {
                [HUD hide:YES];
                NSString *alertcontext = LOCALIZATION(@"userarticle_newtext_success");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 401;
                [alert show];
            }
            else if (codeNum == CODE_ERROE){
                NSString *alertcontext = LOCALIZATION(@"userarticle_newtext_error");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                alert.tag = 402;
                [alert show];
            }
            
        }];
    }
    
}
#pragma mark ========= UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    moodContent.text = @"";
    moodContent.textColor = [UIColor blackColor];
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""] || textView.text == nil) {
        moodContent.text = LOCALIZATION(@"userarticle_newtext_hint");
    }
    
}
- (void)textViewDidChange:(UITextView *)textView
{
    moodContent.frame = CGRectMake(10, 5, viewSize.width-20, [self suggestContentHeight]);
    line.frame = CGRectMake(5, moodContent.frame.size.height+moodContent.frame.origin.y+5, viewSize.width-10, 4);
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 401) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    else{
        return;
    }
}
- (CGFloat)suggestContentHeight
{
    CGSize sizeText = CGSizeMake(0, 0);
    UIFont *font = [UIFont fontWithName:@"Arial" size:20];
    if (IOS7_LATER) {
        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
        sizeText = [moodContent.text boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
    else{
        CGSize size = CGSizeMake(320,1000);
        sizeText = [moodContent.text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    return sizeText.height;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if(self.isViewLoaded && !self.view.window){
        HUD = nil;
        head_bg = nil;
        moodContent = nil;
        _tableView = nil;
        frindsArray = nil;
        userArray = nil;
        line = nil;
        self.view = nil;
    }
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    HUD = nil;
    head_bg = nil;
    moodContent = nil;
    _tableView = nil;
    frindsArray = nil;
    userArray = nil;
    line = nil;
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
