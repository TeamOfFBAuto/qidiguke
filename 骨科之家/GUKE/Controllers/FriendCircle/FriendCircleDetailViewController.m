//
//  FriendCircleDetailViewController.m
//  UNITOA
//
//  Created by ianMac on 14-7-28.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleDetailViewController.h"

#import "PostMoodViewController.h"
#import "ShareImageViewController.h"
#import "ShareUrlViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "SqliteFieldAndTable.h"
#import "UserLoginViewController.h"

#import "UserArticleList.h"
#import "contentAndGood.h"
#import "UserInfoDB.h"

#import "FriendCircleTableViewCell.h"
#import "FriendCircleDetailContentTableViewCell.h"
#import "CommentView.h"
#import "UserInfoDB.h"

#import "UIImageView+WebCache.h"
#import "CommentTableView.h"

#import "Interface.h"
#import "UIImage+UIImageScale.h"
#import "PECropViewController.h"
#import "FriendCircleDetailViewController.h"
#import "MJRefresh.h"
#import "dateAndContent.h"
#import "UserArticleListAttachListModel.h"

#define USER_ARTI_LIST @"user_article_list"
#define USER_ARTU_LIST_PERSONAL @"user_article_list_personal"
#define FAVORIT_DEFAULT_TAG 1024
#define COMMENT_DEFAULT_TAG 10240
#define COMMENT_ID_TAG 65535
#define ACTIONSHEET_BG_TAG 501
#define ACTIONSHEET_SHARE_TAG 502
#define IMG_TAG 99999

#define SHARE_BG_WIGHT 230
#define ICO_HEIGHT 30
#define ICO_WIGHT 30
#define SINGLE_GOOD_COUNT 5
#define SAME2_TAG 999999

// 每次请求刷新的条数
#define REFRESH_COUNT 10
static NSString *commentId = 0;


@interface FriendCircleDetailViewController ()
{
    MBProgressHUD *HUD;
    UserIfo *userModel;
    FriendCircleTableViewCell *cellofArticleBg;
    NSMutableArray *articleArray;
    NSInteger pageCount;
    UIImagePickerController *bgImagePicker;// 背景图片的Picker
    UIImagePickerController *shareImagePicker;// 分享图片的Picker
    
    UITextView *_textField;
    HPGrowingTextView *textFieldInput;
    UIView *customView;
    int imgTag;
    NSMutableArray *_shareImageEnlarge;
    UIView *background;
    int imgTagSave;
    
    NSString *_userId;
    
    NSInteger _refreshPage;
    BOOL _isRefresh;
    
    NSMutableArray *dicKeyArray;
    dateAndContent *tempModel;
    
}
@property (nonatomic,strong)NSString *isSame1;
@property (nonatomic,strong)NSString *isSame2;

@end

@implementation FriendCircleDetailViewController
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        articleArray = [[NSMutableArray alloc]init];
        pageCount = 0;
        userModel = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
        imgTag = IMG_TAG;
        _shareImageEnlarge = [[NSMutableArray alloc] init];
        _refreshPage = 1;
        _isSame2 = [NSString stringWithFormat:@"%d",SAME2_TAG];
        _isRefresh = NO;
        dicKeyArray = [[NSMutableArray alloc] init];
        tempModel = [[dateAndContent alloc] init];
    }
    return self;
}

- (instancetype)initWithModel:(NSString *)userId
{
    if (self = [super init]) {
        _userId = userId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //[self getArticleList];
    [self setExtraCellLineHidden:self.tableView];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self initTable];
    //    // 监听网络数据是否发生了变化
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataChange:) name:IS_DATACHANG object:nil];
}

// 初始化tableView
- (void)initTable{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 解决IOS7下tableview分割线左边短了一点
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    [self setupRefresh];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tableViewGesture];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _refreshPage = 1;
    _isSame2 = [NSString stringWithFormat:@"%d",SAME2_TAG];
    [self getArticleList];
    
    // 0.8秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if ((![_isSame2 isEqualToString:_isSame1])&&_isRefresh == YES) {
        _refreshPage++;
        //NSLog(@"测试测试--------------------------:%d",_refreshPage);
        //[self getArticleList];
        _isSame2 = _isSame1;
        [self getArticleList];
        
    }
    
    // 0.8秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


- (void)navigation
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
    loginLabel.text = LOCALIZATION(@"friend_circle");
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

// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取文章列表
- (void)getArticleList
{
    [articleArray removeAllObjects];
    if (_refreshPage == 1) {
        [dicKeyArray removeAllObjects];
    }
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    [HUD show:YES];
    NSDictionary *parameters = @{@"userId": [NSString stringWithFormat:@"%@",GET_USER_ID],@"sid":GET_S_ID,@"articleType":[NSString stringWithFormat:@"%d",1],@"dstUserId":[NSString stringWithFormat:@"%@",_userId],@"pageSize":[NSString stringWithFormat:@"%d",REFRESH_COUNT],@"page":[NSString stringWithFormat:@"%d",_refreshPage]};
    [AFRequestService responseData:USER_ARTICLE_LIST andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *articleDict = (NSDictionary *)responseData;
        NSLog(@"articleDict -----   %@",articleDict);
        NSInteger codeNum = [[articleDict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
        NSArray *articleLists = [articleDict valueForKeyPath:@"articlelist"];
        _isSame1 =  [NSString stringWithFormat:@"%@",[articleLists lastObject]];
        if ([articleLists count]==REFRESH_COUNT) {
            _isRefresh = YES;
        }
        else{
            _isRefresh = NO;
        }
        for (NSDictionary *articleList in articleLists) {
            UserArticleList *userArticleModel = [[UserArticleList alloc]init];
            userArticleModel.articleId = [NSString _859ToUTF8:[articleList valueForKeyPath:@"articleId"]];
            userArticleModel.context = [NSString _859ToUTF8:[articleList valueForKeyPath:@"context"]];
            userArticleModel.createDate = [NSString _859ToUTF8:[articleList valueForKeyPath:@"createDate"]];
            userArticleModel.deleteFlag = [NSString _859ToUTF8:[articleList valueForKeyPath:@"deleteFlag"]];
            userArticleModel.isShare = [NSString _859ToUTF8:[articleList valueForKeyPath:@"isShare"]];// 0 非分享 1是分享
            userArticleModel.photo = [NSString _859ToUTF8:[articleList valueForKeyPath:@"photo"]];
            userArticleModel.shareUrl = [NSString _859ToUTF8:[articleList valueForKeyPath:@"shareUrl"]];
            userArticleModel.isGood = [NSString _859ToUTF8:[articleList valueForKeyPath:@"isGood"]];// 当前用户是够已点赞
            userArticleModel.fromWeixin = [NSString _859ToUTF8:[articleList valueForKeyPath:@"fromWeixin"]];// 分享来源；0：分享链接；1：分享微信；2：分享病历库；3：分享资料库"
            userArticleModel.shareComment = [NSString _859ToUTF8:[articleList valueForKeyPath:@"shareComment"]];
            // 分享链接时的评论
            userArticleModel.sourceId = [NSString _859ToUTF8:[articleList valueForKeyPath:@"sourceId"]];
            userArticleModel.userId = [NSString _859ToUTF8:[articleList valueForKeyPath:@"userId"]];
            userArticleModel.username = [NSString _859ToUTF8:[articleList valueForKeyPath:@"username"]];
            userArticleModel.imageHeight = [NSString _859ToUTF8:[articleList valueForKey:@"height"]];
            userArticleModel.imageWidth = [NSString _859ToUTF8:[articleList valueForKey:@"width"]];
            
            
            NSArray * attachlistarray = [articleList objectForKey:@"attachlist"];
            if ([attachlistarray isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dicc in attachlistarray)
                {
                    UserArticleListAttachListModel * aModel = [[UserArticleListAttachListModel alloc] initWithDic:dicc];
                    [userArticleModel.attachlistArray addObject:aModel];
                }
            }
            
            NSMutableArray *commentArray = [articleList valueForKeyPath:@"commentlist"];
            for (NSDictionary *commentlist in commentArray) {
                contentAndGood *commentModel = [[contentAndGood alloc]init];
                commentModel.articleId = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"articleId"]];
                commentModel.articleUserId = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"articleUserId"]];
                commentModel.commentId = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"commentId"]];
                commentModel.commentType = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"commentType"]];
                commentModel.context = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"context"]];
                commentModel.createDate = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"createDate"]];
                commentModel.deleteFlag = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"deleteFlag"]];
                commentModel.userId = [NSString _859ToUTF8:[commentlist valueForKeyPath:@"userId"]];
                commentModel.userName = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_U_ID anduserId:commentModel.userId];
                [userArticleModel.commentArray addObject:commentModel];
                commentModel = nil;
            }
            
            NSMutableArray *goodArray = [articleList valueForKeyPath:@"goodlist"];
            // userArticleModel.goodArray = [[NSMutableArray alloc]init];
            [userArticleModel.goodArray removeAllObjects];
            for (NSDictionary *goodlist in goodArray) {
                
                contentAndGood *goodModel = [[contentAndGood alloc]init];
                goodModel.articleId = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"articleId"]];
                goodModel.articleUserId = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"articleUserId"]];
                goodModel.commentId = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"commentId"]];
                goodModel.commentType = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"commentType"]];
                goodModel.context = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"context"]];
                goodModel.createDate = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"createDate"]];
                goodModel.deleteFlag = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"deleteFlag"]];
                goodModel.userId = [NSString _859ToUTF8:[goodlist valueForKeyPath:@"userId"]];
                goodModel.iconUrl = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:goodModel.userId];
                [userArticleModel.goodArray addObject:goodModel];
                goodModel = nil;
            }
            // 在本地获取图片连接和用户名
            userArticleModel.iconUrl = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:userArticleModel.userId];
            userArticleModel.username = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_U_ID anduserId:userArticleModel.userId];
            [articleArray addObject:userArticleModel];
            userArticleModel = nil;
        }
        NSString *tempDate = @" ";
        BOOL isFirst = YES;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (UserArticleList *userArticleModel in articleArray) {
            if (isFirst) {
                [array addObject:userArticleModel];
                isFirst = NO;
            }else{
                if ([tempDate isEqualToString:[SingleInstance handleDate:userArticleModel.createDate]]) {
                    [array addObject:userArticleModel];
                }else{
                    dateAndContent *model = [[dateAndContent alloc] init];
                    model.time = tempDate;
                    model.array = [NSMutableArray arrayWithArray:array];
                    [dicKeyArray addObject:model];
                    
                    [array removeAllObjects];
                    [array addObject:userArticleModel];
                }
            }
            tempDate = [SingleInstance handleDate:userArticleModel.createDate];
            
            
        }
        dateAndContent *model = [[dateAndContent alloc] init];
        model.time = tempDate;
        model.array = array;
        [dicKeyArray addObject:model];
        if (![_isSame1 isEqualToString:_isSame2]) {
            [self.tableView reloadData];
        }
        [HUD hide:YES];
            
        }
        else if(codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FriendCircleDetailViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self getArticleList];
                }
                else{
                    UserLoginViewController *login = [[UserLoginViewController alloc]init];
                    [_Self.navigationController pushViewController:login animated:YES];
                    login = nil;
                }
                
            }];

        }
    } ];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dicKeyArray.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        FriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellhead1"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendCircleTableViewCell" owner:self options:nil] lastObject];
        }
        cell.bgImageView.backgroundColor = [UIColor whiteColor];
        cell.userName.text = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:_userId];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[UserInfoDB selectFeildString:@"articleBg" andcuId:GET_U_ID anduserId:_userId]]]];
        [cell.icoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:_userId]]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 320, 0, 0)];
        }
        
        return cell;
    }
    
    else{
        static NSString *cellName = @"cellFriendDetail";
        //NSString *cellName = [NSString stringWithFormat:@"cell%d%d",indexPath.section,indexPath.row];
        FriendCircleDetailContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[FriendCircleDetailContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (dicKeyArray.count) {
            NSArray *array=[((dateAndContent *)[dicKeyArray objectAtIndex:indexPath.row-1]).time componentsSeparatedByString:@"月"];
            if (![((dateAndContent *)[dicKeyArray objectAtIndex:indexPath.row-1]).time isEqualToString:@" "]) {
                cell.reportTime.text = [(NSString *)[array firstObject] stringByAppendingString:@"月"];
            }
            cell.reportTime.frame = CGRectMake(18, 8, REPORT_TIME_WHDTH, REPORT_TIME_HEIGHT);
            cell.reportDate.text = (NSString *)[(NSArray *)[(NSString *)[array lastObject] componentsSeparatedByString:@"日"] firstObject];
            cell.reportDate.frame = CGRectMake(10, 2, 40, 20);
            
            cell.postArray = ((dateAndContent *)[dicKeyArray objectAtIndex:indexPath.row-1]).array;
            cell.fDContentView.delegate = self;
        }
        
        return cell;
    }
    
}

- (void)myLabel:(MyLabel *)myLabel touchesWtihTag:(NSInteger)tag {
    if (myLabel.text.length>4) {
        NSString *string = [myLabel.text substringWithRange:NSMakeRange(0, 4)];
        if ([string isEqualToString:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myLabel.text]]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myLabel.text]]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 210;
    }
    else{
        CGFloat hegiht = 0.0;
        if (dicKeyArray) {
            hegiht = [FriendCircleDetailContentView heightForCellWithPost:((dateAndContent *)[dicKeyArray objectAtIndex:indexPath.row-1]).array];
        }
        return hegiht;
    }
}

//// 点击超链接调用的程序
//- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
//{
//    NSString *urlString = [NSString stringWithFormat:@"%@",url];
//    urlString = [[urlString componentsSeparatedByString:@"//"] lastObject];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",urlString]]];
//}


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

// 收键盘
- (void)commentTableViewTouchInSide
{
    [self resignTextView];
}

// 收键盘
-(void)resignTextView
{
    [textFieldInput resignFirstResponder];
    [_textField resignFirstResponder];
}


#pragma mark - HPGrowingTextViewDelegate -

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = customView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	customView.frame = r;
}

#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClick:(id)sender
{
    
    UITapGestureRecognizer *tapImg = (UITapGestureRecognizer *)sender;
    NSLog(@"测试:%d",tapImg.view.tag);
    
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    //imgView.image = ((FriendCircleDetailContentTableViewCell *)[_shareImageEnlarge objectAtIndex:tapImg.view.tag-99999]).shareImg.image;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = YES;
    [background addSubview:imgView];
    [self shakeToShow:imgView];//放大过程中的动画
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suoxiao)];
    tap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tap];
    imgView.tag = tapImg.view.tag;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [imgView addGestureRecognizer:longPressGestureRecognizer];
    
    [self.view.window.rootViewController.view addSubview:background];
}

-(void)suoxiao
{
    [background removeFromSuperview];
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)_longpress
{
    if (_longpress.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    imgTagSave = _longpress.view.tag;
    [self handleLongTouch];
    
}

//*************放大过程中出现的缓慢动画*************
- (void) shakeToShow:(UIView*)aView{
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
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
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
        HUD = nil;
        userModel = nil;
        cellofArticleBg = nil;
        articleArray = nil;
        bgImagePicker = nil;
        shareImagePicker = nil;
        _textField = nil;
        textFieldInput = nil;
        customView = nil;
        _shareImageEnlarge = nil;
        background = nil;
        self.view = nil;
    }
}


-(void)dealloc{
    //NSLog(@"调用了dealloc……！");
    
    HUD = nil;
    userModel = nil;
    cellofArticleBg  = nil;
    articleArray = nil;
    bgImagePicker = nil;
    shareImagePicker = nil;
    
    _textField = nil;
    textFieldInput = nil;
    customView = nil;
    _shareImageEnlarge = nil;
    background = nil;
    _userId = nil;
    
}
@end
