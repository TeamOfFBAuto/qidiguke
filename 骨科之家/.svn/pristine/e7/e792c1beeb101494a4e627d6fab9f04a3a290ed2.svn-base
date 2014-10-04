//
//  FriendCircleViewController.m
//  UNITOA
//
//  Created by qidi on 14-7-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleViewController.h"
#import "PostMoodViewController.h"
#import "ShareImageViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"

#import "UserArticleList.h"
#import "contentAndGood.h"

#import "FriendCircleTableViewCell.h"
#import "FriendCircleContentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"
#define USER_ARTI_LIST @"user_article_list"
#define FAVORIT_DEFAULT_TAG 1024
#define COMMENT_DEFAULT_TAG 10240
#define ACTIONSHEET_BG_TAG 501
#define ACTIONSHEET_SHARE_TAG 502

@interface FriendCircleViewController ()
{
    UITableView *_tableView;
    MBProgressHUD *HUD;
    UserIfo *userModel;
    FriendCircleTableViewCell *cellofArticleBg;
    NSMutableArray *articleArray;
    NSInteger pageCount;
    UIImagePickerController *bgImagePicker;
    UIImagePickerController *shareImagePicker;
}
@end

@implementation FriendCircleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       articleArray = [[NSMutableArray alloc]init];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    pageCount = 0;
    [self creatTable];
    [self getArticleList];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 监听网络数据是否发生了变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:IS_DATACHANG object:nil];
    [self navigation];
    
}
// 如果变化，则重新加载数据
- (void)dataChange:(NSNotification *)noti{
    [self creatTable];
    [self getArticleList];
}
- (void)creatTable
{
    NSString *alertText = LOCALIZATION(@"chat_loading");
    [self creatHUD:alertText];
    [HUD show:YES];
    if (currentDev) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height) style:UITableViewStylePlain];
    }
    else if (currentDev1)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, viewSize.width, viewSize.height) style:UITableViewStylePlain];
    }
    else{
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height-44) style:UITableViewStylePlain];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    // 解决IOS7下tableview分割线左边短了一点
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    [self setExtraCellLineHidden:_tableView];

    UIView *linebg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, 0)];
    [self.view addSubview:linebg];
    [self.view addSubview:_tableView];
    
}
- (void)navigation
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
    loginLabel.text = LOCALIZATION(@"friend_circle");
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
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 40)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(0, 5, 30, 30);
    [subMitBtn setBackgroundImage:[UIImage imageNamed:@"menuicon_cam"] forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    subMitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [subMitBtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:subMitBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getArticleList
{
    [articleArray removeAllObjects];
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    [HUD show:YES];
    userModel = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
    NSDictionary *parameters = @{@"userId": [NSString stringWithFormat:@"%@",userModel.userId],@"sid": userModel.sid,@"articleType":[NSString stringWithFormat:@"%d",0],@"pageSize":[NSString stringWithFormat:@"%d",INT32_MAX],@"page":[NSString stringWithFormat:@"%d",0]};
    [AFRequestService responseData:USER_ARTICLE_LIST andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *articleDict = (NSDictionary *)responseData;
        NSArray *articleLists = [articleDict valueForKeyPath:@"articlelist"];
        for (NSDictionary *articleList in articleLists) {
            UserArticleList *userArticleModel = [[UserArticleList alloc]init];
            userArticleModel.articleId = [articleList valueForKeyPath:@"articleId"];
            userArticleModel.context = [articleList valueForKeyPath:@"context"];
            userArticleModel.createDate = [articleList valueForKeyPath:@"createDate"];
            userArticleModel.deleteFlag = [articleList valueForKeyPath:@"deleteFlag"];
            userArticleModel.isShare = [articleList valueForKeyPath:@"isShare"];
            userArticleModel.photo = [articleList valueForKeyPath:@"photo"];
            userArticleModel.shareUrl = [articleList valueForKeyPath:@"shareUrl"];
            userArticleModel.userId = [articleList valueForKeyPath:@"userId"];
            userArticleModel.username = [articleList valueForKeyPath:@"username"];
            
            NSMutableArray *commentArray = [articleList valueForKeyPath:@"commentlist"];
            for (NSDictionary *commentlist in commentArray) {
                contentAndGood *commentModel = [[contentAndGood alloc]init];
                commentModel.articleId = [commentlist valueForKeyPath:@"articleId"];
                commentModel.articleUserId = [commentlist valueForKeyPath:@"articleUserId"];
                commentModel.commentId = [commentlist valueForKeyPath:@"commentId"];
                commentModel.commentType = [commentlist valueForKeyPath:@"commentType"];
                commentModel.context = [commentlist valueForKeyPath:@"context"];
                commentModel.createDate = [commentlist valueForKeyPath:@"createDate"];
                commentModel.deleteFlag = [commentlist valueForKeyPath:@"deleteFlag"];
                commentModel.userId = [commentlist valueForKeyPath:@"userId"];
                [userArticleModel.commentArray addObject:commentModel];
                commentModel = nil;
            }
            
            NSMutableArray *goodArray = [articleList valueForKeyPath:@"goodlist"];
            for (NSDictionary *goodlist in goodArray) {
                contentAndGood *goodModel = [[contentAndGood alloc]init];
                goodModel.articleId = [goodlist valueForKeyPath:@"articleId"];
                goodModel.articleUserId = [goodlist valueForKeyPath:@"articleUserId"];
                goodModel.commentId = [goodlist valueForKeyPath:@"commentId"];
                goodModel.commentType = [goodlist valueForKeyPath:@"commentType"];
                goodModel.context = [goodlist valueForKeyPath:@"context"];
                goodModel.createDate = [goodlist valueForKeyPath:@"createDate"];
                goodModel.deleteFlag = [goodlist valueForKeyPath:@"deleteFlag"];
                goodModel.userId = [goodlist valueForKeyPath:@"userId"];
                [userArticleModel.goodArray addObject:goodModel];
                
                goodModel = nil;
            }
            [articleArray addObject:userArticleModel];
            userArticleModel = nil;
            
        }
        [_tableView reloadData];
        [HUD hide:YES];
    } andCathtype:[userModel.userId intValue] andID:pageCount andtypeName:USER_ARTI_LIST];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    return [articleArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        FriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellhead"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendCircleTableViewCell" owner:self options:nil] lastObject];
        }
        
        cell.userName.text = userModel.firstname;
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,userModel.articleBg]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        [cell.icoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,userModel.icon]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [cell.icoImageView addGestureRecognizer:tap];
        cell.icoImageView.userInteractionEnabled = YES;
        
        tap = nil;
        return cell;
    }
    
    else{
        NSString *cellName = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
        FriendCircleContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[FriendCircleContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        UserArticleList *articleModel = (UserArticleList *)articleArray[indexPath.row - 1];
        // 用户的头像
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,userModel.articleBg]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
        // 用户名
        cell.userName.text = articleModel.username;
        // 发表的内容
        cell.content.text = articleModel.context;
        cell.content.frame = CGRectMake(USER_ICON_WHDTH + 5, USER_ICON_HEIGHT+5, 270,[SingleInstance customFontHeightFont:articleModel.context andFontSize:16 andLineWidth:250]+10);
        
        // 设置分享的图片
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
            cell.shareImg.alpha = 0;
            cell.shareImg.hidden = YES;
            cell.reportTime.frame = CGRectMake(USER_ICON_WHDTH + 5, cell.content.frame.size.height + cell.content.frame.origin.y+3, REPORT_TIME_WHDTH, REPORT_TIME_HEIGHT);
            cell.favorite.frame = CGRectMake(205, cell.content.frame.size.height + cell.content.frame.origin.y,FAVORITE_WHDTH, FAVORITE_HEIGHT);
            cell.comment.frame = CGRectMake(255, cell.content.frame.size.height + cell.content.frame.origin.y,COMMENT_WHDTH, COMMENT_HEIGHT);
        }
        else{
            [cell.shareImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,articleModel.photo]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
            NSLog(@"%@",articleModel.photo);
            cell.shareImg.frame =  CGRectMake(USER_ICON_WHDTH + 5, cell.content.frame.size.height + cell.content.frame.origin.y, SHARE_IMAGE_WHDTH, SHARE_IMAGE_HEIGHT);
            cell.reportTime.frame = CGRectMake(USER_ICON_WHDTH + 5, cell.shareImg.frame.size.height + cell.shareImg.frame.origin.y+3, REPORT_TIME_WHDTH, REPORT_TIME_HEIGHT);
            cell.favorite.frame = CGRectMake(205, cell.shareImg.frame.size.height + cell.shareImg.frame.origin.y,FAVORITE_WHDTH, FAVORITE_HEIGHT);
            cell.comment.frame = CGRectMake(255, cell.shareImg.frame.size.height + cell.shareImg.frame.origin.y,COMMENT_WHDTH, COMMENT_HEIGHT);
        }
        cell.favorite.tag = FAVORIT_DEFAULT_TAG +indexPath.row - 1;
        [cell.favorite addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];
        cell.comment.tag = COMMENT_DEFAULT_TAG +indexPath.row - 1;
        
        [cell.favorite addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
        // 设置日期
        cell.reportTime.text = [self handleDate:articleModel.createDate];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
// 时间处理函数
- (NSString *)handleDate:(NSString *)createDate
{
    NSString *subDate = [[createDate componentsSeparatedByString:@" "] firstObject];
    NSArray *mouthAndDay = [subDate componentsSeparatedByString:@"-"];
    NSString *mouth = mouthAndDay[1];
    NSString *day = mouthAndDay[2];
    if ([mouth hasPrefix:@"0"]) {
        mouth = [mouth substringWithRange:NSMakeRange(1, 1)];
    }
    if ([day hasPrefix:@"0"] ) {
        day = [day substringWithRange:NSMakeRange(1, 1)];
    }
    
    return [NSString stringWithFormat:@"%@月%@日",mouth,day];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 200;
    }
    else{
        UserArticleList *articleModel = (UserArticleList *)articleArray[indexPath.row - 1];
        CGFloat height = 0.0f;
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
            height = USER_ICON_WHDTH +[SingleInstance customFontHeightFont:articleModel.context andFontSize:16 andLineWidth:250]+REPORT_TIME_HEIGHT+40;
        }
        else{
            height = USER_ICON_WHDTH +[SingleInstance customFontHeightFont:articleModel.context andFontSize:16 andLineWidth:250]+SHARE_IMAGE_HEIGHT+REPORT_TIME_HEIGHT+40;
        }
        return height;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        cellofArticleBg = (FriendCircleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [self setICON];
        
    }
    else{
        
    }
}
// 添加赞的事件
- (void)addFavorite:(UIButton *)sender
{
   NSLog(@"%@",sender.titleLabel.text);
    //[self doFavoriteAndComment:GOOD_TYPE_CODE andBtnTag:sender.tag];
}
// 添加评论的事件
- (void)addComment:(UIButton *)sender
{

}
- (void)doFavoriteAndComment:(NSString *)type andBtnTag:(NSInteger)btnTag
{
    UserArticleList *model = nil;
    NSDictionary *parameters = nil;
    if ([type isEqualToString:GOOD_TYPE_CODE]) {
        model = (UserArticleList *)articleArray[btnTag-FAVORIT_DEFAULT_TAG];
        parameters = @{@"userId": [NSString stringWithFormat:@"%@",userModel.userId],@"sid": userModel.sid,@"articleId":model.articleId,@"commentType":type};
    }
    else if ([type isEqualToString:COMMENT_TYPE_CODE]){
        model = (UserArticleList *)articleArray[btnTag-COMMENT_DEFAULT_TAG];
        parameters = @{@"userId": [NSString stringWithFormat:@"%@",userModel.userId],@"sid": userModel.sid,@"articleId":model.articleId,@"commentType":type,@"context":@""};
    }
    else{
        return;
    }
    [AFRequestService responseData:USERE_ARTICEL_COMMENT_NEW andparameters:parameters andResponseData:^(NSData *responseData) {
        NSLog(@"%@",responseData);
    }];
    
}
// 获取图片
- (void)setICON
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:
                                  LOCALIZATION(@"dialog_cancel")  destructiveButtonTitle:LOCALIZATION(@"button_takePhoto") otherButtonTitles:LOCALIZATION(@"button_selectPhoto"), nil];
    actionSheet.tag = ACTIONSHEET_BG_TAG;
    
    [actionSheet showInView:self.view];
}
// 获取图片
- (void)setShareImage
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:
                                  LOCALIZATION(@"dialog_cancel")  destructiveButtonTitle:LOCALIZATION(@"button_takePhoto") otherButtonTitles:LOCALIZATION(@"button_selectPhoto"), nil];
    actionSheet.tag = ACTIONSHEET_SHARE_TAG;
    
    [actionSheet showInView:self.view];
}
#pragma mark ======UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerControllerSourceType soursceType;
    if (buttonIndex == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1){
        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 2){
        return;
    }
    if (actionSheet.tag == ACTIONSHEET_BG_TAG) {
        bgImagePicker = [[UIImagePickerController alloc]init];
        bgImagePicker.sourceType = soursceType;
        bgImagePicker.delegate = self;
        [self presentViewController:bgImagePicker animated:YES completion:nil];
    }
    else if(actionSheet.tag == ACTIONSHEET_SHARE_TAG){
        shareImagePicker = [[UIImagePickerController alloc]init];
        shareImagePicker.sourceType = soursceType;
        shareImagePicker.delegate = self;
        [self presentViewController:shareImagePicker animated:YES completion:nil];
    }
    
}
#pragma mark ====== UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(img, 0.5);
    [self dismissViewControllerAnimated:YES completion:nil];
    if([picker isEqual:shareImagePicker]){
        ShareImageViewController * shareImage = [[ShareImageViewController alloc]init];
        shareImage.img = img;
        shareImage.imgData = imgData;
        [self.navigationController pushViewController:shareImage animated:YES];
    }
    else if ([picker isEqual:bgImagePicker]){
        NSString *alertText = LOCALIZATION(@"setting_changebgimg_process");
        [self creatHUD:alertText];
        [HUD show:YES];
        NSDictionary *parameters = @{@"userId": [NSString stringWithFormat:@"%@",userModel.userId],@"sid": userModel.sid};
        [AFRequestService responseDataWithImage:CHANGE_ARTICLE_BG andparameters:parameters andImageData:imgData  andfieldType:@"articleBg" andfileName:@"articleBg.jpg" andResponseData:^(NSData *responseData) {
            NSDictionary *dict = (NSDictionary *)responseData;
            NSInteger codeNum = [[dict objectForKey:@"code"] intValue];
            if (codeNum == CODE_SUCCESS) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSDictionary *parameter = @{@"username":[user objectForKey:LOG_USER_NAME],@"password":[user objectForKey:LOG_USER_PSW]};
                [AFRequestService responseData:USER_LOGING_URL andparameters:parameter andResponseData:^(id responseData) {
                    NSDictionary * dict = (NSDictionary *)responseData;
                    [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userIfo"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
                    if (codeNum == CODE_SUCCESS) {
                        NSDictionary *userDetail = [dict objectForKey:@"user"];
                        userModel.articleBg = [userDetail valueForKey:@"articleBg"];
                        [HUD hide:YES];
                        [_tableView reloadData];
                        
                    }
                    else if (codeNum == CODE_ERROE){
                        
                    }
                    
                }];
                //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_success") delegate:self cancelButtonTitle:@"ok"otherButtonTitles:nil];
                //            [alert show];
            }
            else if (codeNum == CODE_ERROE){
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_error") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
                [alert show];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            else {
                return;
                
            }
            
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSDictionary *parameter = @{@"username":[user objectForKey:LOG_USER_NAME],@"password":[user objectForKey:LOG_USER_PSW]};
    [AFRequestService responseData:USER_LOGING_URL andparameters:parameter andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userIfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            userModel.articleBg = [userDetail valueForKey:@"articleBg"];
            [_tableView reloadData];
        }
        else if (codeNum == CODE_ERROE){
            
        }
        
    }];
}
// 点击头像进入个人的空间
- (void)bgTapAction
{
    NSLog(@"sdvsdf");
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
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
//-(void)showPopover:(id)sender
-(void)showPopover:(id)sender forEvent:(UIEvent*)event
{
    UITableViewController *tableViewController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    tableViewController.view.frame = CGRectMake(0,0, 320, 400);
    TSPopoverController *popoverController = [[TSPopoverController alloc] initWithContentViewController:tableViewController];
    
    popoverController.cornerRadius = 0;
    popoverController.titleText = @"change order";
    popoverController.popoverBaseColor = [UIColor lightGrayColor];
    popoverController.popoverGradient= NO;
    [popoverController showPopoverWithTouch:event];
    
}

-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    
    NSString *addNewtext = LOCALIZATION(@"userarticle_newtext");
    NSString *addNewfile = LOCALIZATION(@"userarticle_newfile");
    NSString *addNewshare = LOCALIZATION(@"userarticle_newshare");
    [actionSheet addButtonWithTitle:addNewtext icon:@"menuicon_edit" block:^{
        PostMoodViewController *post = [[PostMoodViewController alloc]init];
        [self.navigationController pushViewController:post animated:YES];
        
    }];
    
    [actionSheet addButtonWithTitle:addNewfile icon:@"menuicon_img" block:^{
        [self setShareImage];
    }];
    [actionSheet addButtonWithTitle:addNewshare icon:@"menuicon_link" block:^{
        
        
    }];
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
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
        _tableView = nil;
        HUD = nil;
        userModel = nil;
        cellofArticleBg = nil;
        articleArray = nil;
        bgImagePicker = nil;
        shareImagePicker = nil;
        self.view = nil;
    }

}

- (void)dealloc
{
    _tableView = nil;
    HUD = nil;
    userModel = nil;
    cellofArticleBg = nil;
    articleArray = nil;
    bgImagePicker = nil;
    shareImagePicker = nil;
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
