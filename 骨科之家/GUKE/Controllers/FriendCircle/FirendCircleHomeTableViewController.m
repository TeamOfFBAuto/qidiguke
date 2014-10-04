//
//  FirendCircleHomeTableViewController.m
//  诊疗圈
//
//  Created by qidi on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FirendCircleHomeTableViewController.h"
#import "UserLoginViewController.h"
#import "PostMoodViewController.h"
#import "ShareImageViewController.h"
#import "ShareUrlViewController.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"

#import "UserArticleList.h"
#import "contentAndGood.h"
#import "SqliteFieldAndTable.h"
#import "UserInfoDB.h"

#import "CommentView.h"

#import "UIImageView+WebCache.h"
#import "CommentTableView.h"

#import "Interface.h"
#import "UIImage+UIImageScale.h"
#import "PECropViewController.h"
#import "FriendCircleDetailViewController.h"
#import "MJRefresh.h"
#import "FriendCircleHomeTableViewCell.h"
#import "UserArticleListAttachListModel.h"

#define USER_ARTI_LIST @"user_article_list"
#define FAVORIT_DEFAULT_TAG 1024
#define COMMENT_DEFAULT_TAG 10240
#define COMMENT_ID_TAG 65535
#define ACTIONSHEET_BG_TAG 501
#define ACTIONSHEET_SHARE_TAG 502
#define USER_ICON_CELL_TAG 999


#define SHARE_BG_WIGHT 256
#define ICO_HEIGHT 30
#define ICO_WIGHT 30
#define SINGLE_GOOD_COUNT 5
#define SAME2_TAG 999999
// 每次请求刷新的条数
#define REFRESH_COUNT 5

static NSString *commentId = 0;
@interface FirendCircleHomeTableViewController ()
{
    MBProgressHUD *HUD;
    UserIfo *userModel;
    FriendCircleTableViewCell *cellofArticleBg;
    NSMutableArray *articleArray;
    NSMutableArray *goodAndCommentArray;
    NSInteger pageCount;
    UIImagePickerController *bgImagePicker;// 背景图片的Picker
    UIImagePickerController *shareImagePicker;// 分享图片的Picker
    
    UITextView *_textField;
    HPGrowingTextView *textFieldInput;
    UIView *customView;
    NSInteger _refreshPage;
    BOOL _isRefresh;
    
    CommentView *commentView;// 赞的现实视图
    CommentTableView *commentTable;// 评论的现实视图
    
    // 创建一个字典保存cell坐标和indexpath
    NSMutableDictionary *cellDic;
    CGFloat tempCGFloat;
    CGFloat temp6CGFloat;
}

@property (nonatomic,strong)NSString *isSame1;
@property (nonatomic,strong)NSString *isSame2;

// "评论"键盘相关
- (void)loadCommentKeyBoardView:(NSInteger)tag;
@end

@implementation FirendCircleHomeTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        articleArray = [[NSMutableArray alloc]init];
        goodAndCommentArray = [[NSMutableArray alloc]init];
        pageCount = 0;
        userModel = (UserIfo *)[[SingleInstance shareManager].objecAarray firstObject];
        _refreshPage = 1;
        _isSame2 = [NSString stringWithFormat:@"%d",SAME2_TAG];
        _isRefresh = NO;
        cellDic = [[NSMutableDictionary alloc] init];
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_title_bg@2x" ofType:@"png"]] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    [self setExtraCellLineHidden:self.tableView];
    [self.tableView headerBeginRefreshing];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigation];
    [self initTable];
    [self keyBoardListener];
}

- (void)keyBoardListener
{
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
//    
//    //增加监听，当键退出时收出消息
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

// 初始化tableView
- (void)initTable{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.editing = NO;
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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
    [self.tableView beginUpdates];
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    
    if (editing) {
        
    }
    else {
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    [self.tableView endUpdates];
}


/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    
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
    __weak FirendCircleHomeTableViewController *friendView = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [friendView.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    if ((![_isSame2 isEqualToString:_isSame1])&&_isRefresh == YES) {
        _refreshPage++;
        _isSame2 = _isSame1;
        [self getArticleList];
        
    }
    
    // 0.8秒后刷新表格UI
    __weak FirendCircleHomeTableViewController *friendView = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        //[self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [friendView.tableView footerEndRefreshing];
    });
}

- (void)loadCommentKeyBoardView:(NSInteger)tag
{
    // 新建一个UITextField，隐藏掉
    _textField = [[UITextView alloc] initWithFrame:CGRectZero];
    _textField.backgroundColor = [UIColor grayColor];
    _textField.hidden = YES;
    [self.tableView addSubview:_textField];
    
    // 自定义的view
    customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    customView.backgroundColor = [UIColor colorWithRed:218/255.0 green:218/255.0 blue:218/255.0 alpha:1];
    _textField.inputAccessoryView = customView;
    
    // 在view上添加输入框
    textFieldInput = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(5, 5, 250, 30)];
    textFieldInput.font = [UIFont systemFontOfSize:13.0f];
    textFieldInput.backgroundColor = [UIColor whiteColor];
    textFieldInput.layer.borderColor = [UIColor grayColor].CGColor;
    textFieldInput.layer.borderWidth = 0.6f;
    textFieldInput.layer.cornerRadius = 5.0f;
    
    
    textFieldInput.isScrollable = NO;
    textFieldInput.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textFieldInput.minNumberOfLines = 1;
	textFieldInput.maxNumberOfLines = 6;
    
    textFieldInput.returnKeyType = UIReturnKeyGo; //just as an example
	textFieldInput.delegate = self;
    textFieldInput.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textFieldInput.placeholder = LOCALIZATION(@"userarticle_newtext_hint");
    textFieldInput.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [customView addSubview:textFieldInput];
    customView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    // 往自定义view中添加各种UI控件(以UIButton为例)
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5.5, 320-5-270+10, 31)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 0.6f;
    btn.layer.cornerRadius = 5.0f;
    btn.tag = tag;
    [btn setTitle:LOCALIZATION(@"send_chat") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [btn addTarget:self action:@selector(sendClicked:) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btn];
    
}
// 导航的设置
- (void)navigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 4, 36, 36);

    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"friend_circle");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(0, 0, 44, 44);
    [subMitBtn setImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_ic_write_right@2x" ofType:@"png"]] forState:UIControlStateNormal];
    
//    subMitBtn.imageEdgeInsets = UIEdgeInsetsMake(13.5, 22, 13.5, 1.5);
    [subMitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    subMitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [subMitBtn addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightitem = [[UIBarButtonItem alloc]initWithCustomView:subMitBtn];
    self.navigationItem.rightBarButtonItem = rightitem;
    
}

// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取文章列表
- (void)getArticleList
{
    if (_refreshPage == 1) {
        [articleArray removeAllObjects];
    }
    [self creatHUD:LOCALIZATION(@"chat_loading")];
    [HUD show:YES];
    NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"articleType":[NSString stringWithFormat:@"%d",0],@"pageSize":[NSString stringWithFormat:@"%d",REFRESH_COUNT],@"page":[NSString stringWithFormat:@"%d",_refreshPage]};
    __weak FirendCircleHomeTableViewController *friendCircleView = self;
    [AFRequestService responseData:USER_ARTICLE_LIST andparameters:parameters andResponseData:^(NSData *responseData) {
        NSDictionary *articleDict = (NSDictionary *)responseData;
        NSLog(@"zenme le ne ---  %@",articleDict);
        NSInteger codeNum = [[articleDict objectForKey:@"code"]integerValue];
        if(codeNum == CODE_SUCCESS){
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
                if (commentModel.userName.length <= 0) {
                    commentModel.userName = [commentlist valueForKeyPath:@"username"];
                }
                NSString *userID = [UserInfoDB selectFeildString:@"userId" andcuId:GET_U_ID anduserId:commentModel.userId];
                // 没有此用户，便提取写到数据库中
                if (userID == nil || [userID isEqualToString:@""] || commentModel.userId.length <= 0) {
                    [friendCircleView insertUserIfoToDataBase:commentModel.userId];
                }
                
                [userArticleModel.commentArray addObject:commentModel];
                commentModel = nil;
            }
            
            NSMutableArray *goodArray = [articleList valueForKeyPath:@"goodlist"];
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
                 NSString *userID  = [UserInfoDB selectFeildString:@"userId" andcuId:GET_U_ID anduserId:goodModel.userId];
                // 没有此用户，便提取写到数据库中
                if (userID == nil || [userID isEqualToString:@""] || userID.length <= 0) {
                    [friendCircleView insertUserIfoToDataBase:goodModel.userId];
                }
                [userArticleModel.goodArray addObject:goodModel];
                goodModel = nil;
            }
            // 在本地获取图片连接和用户名
            userArticleModel.iconUrl = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:userArticleModel.userId];
            userArticleModel.username = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_U_ID anduserId:userArticleModel.userId];
            [articleArray addObject:userArticleModel];
            userArticleModel = nil;
        }

        if (![_isSame1 isEqualToString:_isSame2]) {
            [friendCircleView.tableView reloadData];
        }
            [HUD hide:YES];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FirendCircleHomeTableViewController __weak *_Self = self;
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
        
    }];
}
- (void)insertUserIfoToDataBase:(NSString *)viewId
{
    [[NSUserDefaults standardUserDefaults] setObject:viewId forKey:@"viewId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *_viewId = [[NSUserDefaults standardUserDefaults] objectForKey:@"viewId"];
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"viewId":_viewId};
    [AFRequestService responseData:USER_INFO_BYID_URL andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        SqliteFieldAndTable *sqlAndTable = [[SqliteFieldAndTable alloc]init];
        NSInteger codeNum = [[dict objectForKey:@"code"]integerValue];
        if (codeNum == CODE_SUCCESS) {
            [sqlAndTable getFeildandValueById:dict];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FirendCircleHomeTableViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    [_Self insertUserIfoToDataBase:[[NSUserDefaults standardUserDefaults] objectForKey:@"viewId"]];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [articleArray count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        FriendCircleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellhead"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"FriendCircleTableViewCell" owner:self options:nil] lastObject];
        }
        cell.bgImageView.backgroundColor = [UIColor whiteColor];
        cell.userName.text = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_USER_ID anduserId:GET_USER_ID];
        [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[UserInfoDB selectFeildString:@"articleBg" andcuId:GET_USER_ID anduserId:GET_USER_ID]]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"frictr_bg@2x" ofType:@"png"]]  options:SDWebImageProgressiveDownload];
        [cell.icoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[UserInfoDB selectFeildString:@"icon" andcuId:GET_USER_ID anduserId:GET_USER_ID]]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (IOS7_LATER) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgTapAction)];
        tap.numberOfTapsRequired = 1;
        tap.numberOfTouchesRequired = 1;
        [cell.icoImageView addGestureRecognizer:tap];
        cell.icoImageView.userInteractionEnabled = YES;
        
        tap = nil;
        return cell;
    }
    
    else{
        static NSString *cellName = @"Fcell";
        FriendCircleHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            cell = [[FriendCircleHomeTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
        }
        
        for (int i = 0;i < cell.PictureViews.subviews.count;i++)
        {
            id view = [cell.PictureViews.subviews objectAtIndex:i];
            if ([view isKindOfClass:[UIImageView class]]) {
                [(UIImageView *)view setImage:nil];
            }
            [view removeFromSuperview];
        }
        
        cell.delegate = self;
        cell.single_imageView.image = nil;
        cell.PictureViews.frame = CGRectZero;
        cell.single_imageView.frame = CGRectZero;
//        cell.PictureViews.backgroundColor = [UIColor redColor];
//        cell.single_imageView.backgroundColor = [UIColor orangeColor];
        // 保存cell
        [cellDic setObject:cell forKey:[NSString stringWithFormat:@"%d",indexPath.row-1]];
        
        cell.favorite.tag = FAVORIT_DEFAULT_TAG +indexPath.row - 1;
        [cell.favorite addTarget:self action:@selector(addFavorite:) forControlEvents:UIControlEventTouchUpInside];
        // 赞的图标点击事件
        __weak FirendCircleHomeTableViewController *vierController = self;
        cell.sendUserId = ^(NSString *userId){
        [vierController pushView:userId];
        };
        
        cell.comment.tag = COMMENT_DEFAULT_TAG + indexPath.row - 1;
        [cell.comment addTarget:self action:@selector(addComment:) forControlEvents:UIControlEventTouchUpInside];
        
        // 评论的点击事件
        __weak FirendCircleHomeTableViewController *commentController = self;
                    cell.sendUserId = ^(NSString *userId){
                        [commentController pushView:userId];
        
                    };
        cell.userIcon.tag = USER_ICON_CELL_TAG+indexPath.row-1;
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userIconTap:)];
         tap.numberOfTapsRequired = 1;
         tap.numberOfTouchesRequired = 1;
        [cell.userIcon addGestureRecognizer:tap];
        cell.userIcon.userInteractionEnabled = YES;
        
        cell.index = indexPath.row-1;
        if (articleArray.count) {
            cell.post = (UserArticleList *)articleArray[indexPath.row - 1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}
- (void)pushView:(NSString *)userId
{
    FriendCircleDetailViewController *fdvc = [[FriendCircleDetailViewController alloc] initWithModel:userId];
    [self.navigationController pushViewController:fdvc animated:YES];
    fdvc = nil;
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
        UserArticleList *articleModel;
        if (articleArray.count != 0) {
            articleModel = (UserArticleList *)articleArray[indexPath.row - 1];
        }
        CGFloat shareHeight = 0.0;
        CGFloat commentHeight = 0.0;
        
        if ([articleModel.goodArray count]>0) {
            shareHeight = [SingleInstance customHeight:[articleModel.goodArray count] andcount:SINGLE_GOOD_COUNT andsingleHeight:45.0] ;
        }
        // 评论的高度设定
        if ([articleModel.commentArray count]>0) {
            for (contentAndGood *modle in articleModel.commentArray) {
                commentHeight = commentHeight + [SingleInstance customFontHeightFont:modle.context andFontSize:15 andLineWidth:SHARE_BG_WIGHT];
            }
            commentHeight = commentHeight + [articleModel.commentArray count] *4 + 0;
        }
        CGFloat height = 0.0f;
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
            
            float imgHeight = 0;
            
            if (articleModel.attachlistArray.count)
            {
                int i = articleModel.attachlistArray.count/3;
                
                int j = articleModel.attachlistArray.count%3?1:0;
                
                imgHeight = 75*(i+j)+2.5*(j + i - 1);
            }
            
            height = USER_ICON_WHDTH +[SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+REPORT_TIME_HEIGHT+40 + shareHeight + commentHeight + imgHeight;
        }else{
            double imgHeight = SHARE_IMAGE_HEIGHT;
            
            if (articleModel.context == nil || articleModel.context.length == 0 || [articleModel.context isEqualToString:@" "]){
                 height = USER_ICON_WHDTH+imgHeight+REPORT_TIME_HEIGHT+40 + shareHeight + commentHeight-16 ;
            }else{
                height = USER_ICON_WHDTH +[SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+imgHeight+REPORT_TIME_HEIGHT+40 + shareHeight + commentHeight ;
            }

        }
        return height+10;
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

#pragma mark - 删除微博
-(void)deleteBlogWithCell:(FriendCircleHomeTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    UserArticleList * model = [articleArray objectAtIndex:indexPath.row-1];
    MBProgressHUD * hud = [SNTools returnMBProgressWithText:@"正在删除..." addToView:self.view];
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"articleId":model.articleId};
    __weak typeof(self)bself = self;
    
    [AFRequestService responseData:DELETE_BLOG_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dic -----  %@",dict);
        if ([[dict objectForKey:@"code"] intValue] == 0)
        {
            [articleArray removeObjectAtIndex:indexPath.row-1];
            hud.labelText = @"删除成功";
            [hud hide:YES afterDelay:1.5];
            
            [bself.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationLeft];
        }else
        {
            hud.labelText = @"删除失败，请重试";
            [hud hide:YES afterDelay:1.5];
        }
    }];
    
    
}
// 添加赞的事件
- (void)addFavorite:(UIButton *)sender
{
    // 点赞
    if ([sender.titleLabel.text isEqualToString:LOCALIZATION(@"userarticle_comment_good")]) {
        //sender.userInteractionEnabled = NO;
        [self doFavoriteAndComment:GOOD_TYPE_CODE andBtn:sender andContext:nil];
        [sender setTitle:LOCALIZATION(@"button_cancel") forState:UIControlStateNormal];
        
        
    }
    //取消赞
    else if ([sender.titleLabel.text isEqualToString:LOCALIZATION(@"button_cancel")]){
        //sender.userInteractionEnabled = NO;
        [self doFavoriteAndComment:DEL_GOOD_TYPE_CODE andBtn:sender andContext:nil];
        [sender setTitle:LOCALIZATION(@"userarticle_comment_good") forState:UIControlStateNormal];
    }
    else{
        return;
    }
    
}
// 添加评论的事件
- (void)addComment:(UIButton *)sender
{
    FriendCircleHomeTableViewCell *cell = (FriendCircleHomeTableViewCell*)[cellDic objectForKey:[NSString stringWithFormat:@"%d",sender.tag - COMMENT_DEFAULT_TAG]];

    CGRect rect=[self.view.window  convertRect:cell.frame fromView:self.tableView];
    tempCGFloat = rect.origin.y+rect.size.height;
    temp6CGFloat = cell.frame.origin.y+cell.frame.size.height;
    [self loadCommentKeyBoardView:sender.tag];
    [_textField becomeFirstResponder];
    [textFieldInput becomeFirstResponder];
}
// 评论发送的事件
- (void)sendClicked:(UIButton *)sender
{

    if (textFieldInput.text == nil || [textFieldInput.text isEqualToString:@""]) {
        NSString *alertcontext = LOCALIZATION(@"userarticle_comment_empty");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                [alert show];
    }
    else{
    [self resignTextView];
    [self doFavoriteAndComment:COMMENT_TYPE_CODE andBtn:sender andContext:textFieldInput.text];
    }
    
}

- (void)doFavoriteAndComment:(NSString *)type andBtn:(UIButton *)sender andContext:(NSString *)context
{
    
    UserArticleList *model = nil;
    NSDictionary *parameters = nil;
    if (articleArray.count!=0) {
    if ([type isEqualToString:GOOD_TYPE_CODE]) {
           // 获取对应的文章
        model = (UserArticleList *)articleArray[sender.tag-FAVORIT_DEFAULT_TAG];
        // 写入数组中同时写入数据库
        [self insertLocalData:model.articleId andContext:nil anduserId:GET_USER_ID andTag:sender.tag-FAVORIT_DEFAULT_TAG andType:type];
            parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"articleId":model.articleId,@"commentType":type};
       
    }
    else if ([type isEqualToString:COMMENT_TYPE_CODE]){
            // 获取对应的文章
            model = (UserArticleList *)articleArray[sender.tag-COMMENT_DEFAULT_TAG];
            // 写入数组中同时写入数据库
            [self insertLocalData:model.articleId andContext:context anduserId:GET_USER_ID andTag:sender.tag-COMMENT_DEFAULT_TAG andType:type];
            parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"articleId":model.articleId,@"commentType":type,@"context":context};
    }
    else if ([type isEqualToString:DEL_GOOD_TYPE_CODE]){
            // 获取对应的文章
            model = (UserArticleList *)articleArray[sender.tag-FAVORIT_DEFAULT_TAG];
           // 删除数组中得元素
           [self insertLocalData:model.articleId andContext:nil anduserId:GET_USER_ID andTag:sender.tag-FAVORIT_DEFAULT_TAG andType:type];
        
            parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID,@"articleId":model.articleId,@"commentType":type};
    }
    else{
        return;
    }
    }
    else {
        return;
    }
    [AFRequestService responseData:USERE_ARTICEL_COMMENT_NEW andparameters:parameters andResponseData:^(NSData *responseData)
     {
         NSDictionary * dict = (NSDictionary *)responseData;
         NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
         if (codeNum == CODE_SUCCESS) {
             sender.userInteractionEnabled = YES;
         }
         else if (codeNum == CODE_ERROE){
             // 重新获取sid
             SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
             FirendCircleHomeTableViewController __weak *_Self = self;
             [sqliteAndtable repeatLogin:^(BOOL flag) {
                 if (flag) {
                     return;
                 }
                 else{
                     UserLoginViewController *login = [[UserLoginViewController alloc]init];
                     [_Self.navigationController pushViewController:login animated:YES];
                     login = nil;
                 }
                 
             }];
             NSString *alertcontext = LOCALIZATION(@"sub_error");
             NSString *alertText = LOCALIZATION(@"dialog_prompt");
             NSString *alertOk = LOCALIZATION(@"dialog_ok");
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
             [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.5];
             [alert show];
         }
         else if (codeNum == CODE_OTHER){
             NSString *alertcontext = LOCALIZATION(@"sub_error");
             NSString *alertText = LOCALIZATION(@"dialog_prompt");
             NSString *alertOk = LOCALIZATION(@"dialog_ok");
             UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
             [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.5];
             [alert show];
         }
     }];
}
// 将本地数据插入到数组中
- (void)insertLocalData:(NSString *)articleId
             andContext:(NSString *)context
            anduserId:(NSString *)userId
                 andTag:(NSUInteger)sender
                andType:(NSString *)type

{
     UserArticleList * model = (UserArticleList *)articleArray[sender];
    if (model == nil || [model isEqual:[NSNull null]]) {
        return;
    }
    // 如果是赞
    if ([type isEqualToString:GOOD_TYPE_CODE]) {
        contentAndGood *good = [[contentAndGood alloc]init];
        good.userId = userId;
        good.articleId = articleId;
        good.iconUrl = [UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:userId];
        if (good == nil || [good isEqual:[NSNull null]]) {
            return;
        }
        [model.goodArray insertObject:good atIndex:0];
        good = nil;
    }
    // 如果是评论
    else if ([type isEqualToString:COMMENT_TYPE_CODE]){
        contentAndGood *comment = [[contentAndGood alloc]init];
        comment.userId = userId;
        comment.context = context;
        comment.articleId = articleId;
        comment.userName = [UserInfoDB selectFeildString:@"firstname" andcuId:GET_U_ID anduserId:userId];
        if (comment == nil || [comment isEqual:[NSNull null]]) {
            return;
        }
        [model.commentArray insertObject:comment atIndex:0];
        comment = nil;
    }
    else if([type isEqualToString:DEL_GOOD_TYPE_CODE]){
        for (int i = 0; i < [model.goodArray count]; ++i)
        {
            contentAndGood *goodModel = (contentAndGood *)model.goodArray[i];
            if ([goodModel.userId isEqualToString:userId]) {
                [model.goodArray removeObjectAtIndex:i];
            }
        }
        
    }
    else{
        return;
    }
    CGPoint p = self.tableView.contentOffset;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender+1 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    //[self.tableView reloadData];
    self.tableView.contentOffset = p;
//    [self performSelector:@selector(goScroll) withObject:nil afterDelay:0.5f];
}
- (void)dismissAlertView:(UIAlertView *)alertView
{
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}
// 获取背景图片
- (void)setICON
{
    if (![self menu1]) {
        
        NSArray *titles = @[LOCALIZATION(@"button_takePhoto"),
                            LOCALIZATION(@"button_selectPhoto"),
                            LOCALIZATION(@"button_cancel")];
        _menu1 = [[MBButtonMenuViewController alloc] initWithButtonTitles:titles];
        _menu1.backgroundColor = [UIColor blackColor];
        [_menu1 setDelegate:self];
        [_menu1 setCancelButtonIndex:[[_menu1 buttonTitles]count]-1];
    }
    self.menu1.view.tag = ACTIONSHEET_BG_TAG;
    
    [[self menu1] showInView:[self view]];
    
}
// 获取图片
- (void)setShareImage
{
    if (![self menu2]) {
        
        NSArray *titles = @[LOCALIZATION(@"button_takePhoto"),
                            LOCALIZATION(@"button_selectPhoto"),
                            LOCALIZATION(@"button_cancel")];
        _menu2 = [[MBButtonMenuViewController alloc] initWithButtonTitles:titles];
        _menu2.backgroundColor = [UIColor blackColor];
        [_menu2 setDelegate:self];
        [_menu2 setCancelButtonIndex:[[_menu2 buttonTitles]count]-1];
    }
    self.menu2.view.tag = ACTIONSHEET_SHARE_TAG;
    
    [[self menu2] showInView:[self view]];
}

#pragma mark - MBButtonMenuViewControllerDelegate
- (void)buttonMenuViewController:(MBButtonMenuViewController *)buttonMenu buttonTappedAtIndex:(NSUInteger)index
{
    [buttonMenu hide];
    UIImagePickerControllerSourceType soursceType;
    if (index == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (index == 1){
//        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self chooseMorePhoto];
        
        return;
    }
    else if (index == 2){
        return;
    }
    if (buttonMenu.view.tag == ACTIONSHEET_BG_TAG) {
        bgImagePicker = [[UIImagePickerController alloc]init];
        bgImagePicker.sourceType = soursceType;
        bgImagePicker.delegate = self;
        //bgImagePicker.allowsEditing = YES;
        [self presentViewController:bgImagePicker animated:YES completion:nil];
    }
    else if(buttonMenu.view.tag == ACTIONSHEET_SHARE_TAG){
        shareImagePicker = [[UIImagePickerController alloc]init];
        shareImagePicker.sourceType = soursceType;
        shareImagePicker.delegate = self;
        [self presentViewController:shareImagePicker animated:YES completion:nil];
    }
}

#pragma mark - 多图选择
-(void)chooseMorePhoto
{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] init];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.maximumImagesCount = 9;
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSLog(@"info -------  %@",info);
    NSMutableArray * img_array = [NSMutableArray array];
    
    for (NSDictionary * dic in info)
    {
        UIImage *img = [dic objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *imgScale = img;
        NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
        if (img.size.width>800) {
            imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
            imgData = UIImageJPEGRepresentation(imgScale, 0.3);
        }
        
        [img_array addObject:imgScale];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        ShareImageViewController * shareImage = [[ShareImageViewController alloc]init];
        shareImage.data_array = img_array;
        [self.navigationController pushViewController:shareImage animated:YES];
    }];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ====== UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImage *imgScale = img;
    NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
    if (img.size.width>800) {
        imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
        imgData = UIImageJPEGRepresentation(imgScale, 0.3);
    }
    if([picker isEqual:shareImagePicker]){
        [self dismissViewControllerAnimated:YES completion:nil];
        ShareImageViewController * shareImage = [[ShareImageViewController alloc]init];
        shareImage.img = imgScale;
        shareImage.imgData = imgData;
        shareImage.data_array = [NSMutableArray arrayWithObjects:imgScale, nil];
        [self.navigationController pushViewController:shareImage animated:YES];
    }
    else if ([picker isEqual:bgImagePicker]){
        __weak FirendCircleHomeTableViewController *friendCircleView = self;
        [picker dismissViewControllerAnimated:YES completion:^{
            [friendCircleView openEditor:imgScale];
            
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
    __weak FirendCircleHomeTableViewController *friendCircleView = self;
    [AFRequestService responseData:USER_LOGING_URL andparameters:parameter andResponseData:^(id responseData) {
        NSDictionary * dict = (NSDictionary *)responseData;
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userIfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSUInteger codeNum = [[dict objectForKey:@"code"] integerValue];
        if (codeNum == CODE_SUCCESS) {
            NSDictionary *userDetail = [dict objectForKey:@"user"];
            userModel.articleBg = [userDetail valueForKey:@"articleBg"];
            [friendCircleView.tableView reloadData];
        }
        else if (codeNum == CODE_ERROE){
            SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
            FirendCircleHomeTableViewController __weak *_Self = self;
            [sqliteAndtable repeatLogin:^(BOOL flag) {
                if (flag) {
                    return;
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

// 点击头像进入个人的空间
- (void)bgTapAction
{
    FriendCircleDetailViewController *fdvc = [[FriendCircleDetailViewController alloc] initWithModel:GET_USER_ID];
    [self.navigationController pushViewController:fdvc animated:YES];
}


// 点击进入头像的个人空间
- (void)userIconTap:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    UserArticleList *articleModel = (UserArticleList *)articleArray[tap.view.tag-USER_ICON_CELL_TAG];
    FriendCircleDetailViewController *fdvc = [[FriendCircleDetailViewController alloc] initWithModel:articleModel.userId];
    [self.navigationController pushViewController:fdvc animated:YES];
}


- (void)buttonMenuViewControllerDidCancel:(MBButtonMenuViewController *)buttonMenu
{
    [buttonMenu hide];
}


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
    [self resignTextView];
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    NSString *addNewtext = LOCALIZATION(@"userarticle_newtext");
    NSString *addNewfile = LOCALIZATION(@"userarticle_newfile");
    NSString *addNewshare = LOCALIZATION(@"userarticle_newshare");
    [actionSheet addButtonWithTitle:addNewtext icon:@"menuicon_edit" block:^{
        PostMoodViewController *post = [[PostMoodViewController alloc]init];
        [self.navigationController pushViewController:post animated:YES];
        
    }];
    __weak FirendCircleHomeTableViewController *friendCircleView = self;
    [actionSheet addButtonWithTitle:addNewfile icon:@"menuicon_img" block:^{
        [friendCircleView setShareImage];
    }];
    [actionSheet addButtonWithTitle:addNewshare icon:@"menuicon_link" block:^{
        ShareUrlViewController *shareUrl = [[ShareUrlViewController alloc]init];
        [friendCircleView.navigationController pushViewController:shareUrl animated:YES];
        
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
    CGPoint p = self.tableView.contentOffset;

    [textFieldInput resignFirstResponder];
    [_textField resignFirstResponder];

    self.tableView.contentOffset = p;
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
#pragma mark --背景图片大小控制--

- (void)openEditor:(UIImage *)img
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = img;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
    navigationController = nil;
}

#pragma mark -

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    NSData *imgData = UIImageJPEGRepresentation(croppedImage, 0.3);
    NSString *alertText = LOCALIZATION(@"setting_changebgimg_process");
    [self creatHUD:alertText];
    [HUD show:YES];
    NSDictionary *parameters = @{@"userId": GET_USER_ID,@"sid": GET_S_ID};
    __weak FirendCircleHomeTableViewController *friendCircleView = self;
    [AFRequestService responseDataWithImage:CHANGE_ARTICLE_BG andparameters:parameters andImageData:imgData
                               andfieldType:@"articleBg" andfileName:@"articleBg.jpg" andResponseData:^(NSData *responseData) {
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
                    [UserInfoDB updateUserInfo:nil andkeyValue:[userDetail valueForKey:@"articleBg"] andkey:@"articleBg" andWhereKey:GET_USER_ID];
                    [HUD hide:YES];
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                    [friendCircleView.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                    
                
                }
                else if (codeNum == CODE_ERROE){
                    SqliteFieldAndTable *sqliteAndtable = [[SqliteFieldAndTable alloc]init];
                    FirendCircleHomeTableViewController __weak *_Self = self;
                    [sqliteAndtable repeatLogin:^(BOOL flag) {
                        if (flag) {
                            return;
                        }
                        else{
                            UserLoginViewController *login = [[UserLoginViewController alloc]init];
                            [_Self.navigationController pushViewController:login animated:YES];
                            login = nil;
                        }
                        
                    }];
                }
                NSString *alertcontext = LOCALIZATION(@"sub_error");
                NSString *alertText = LOCALIZATION(@"dialog_prompt");
                NSString *alertOk = LOCALIZATION(@"dialog_ok");
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
                [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:0.5];
                [alert show];
                [friendCircleView dismissViewControllerAnimated:YES completion:nil];
                
            }];
        }
        else if (codeNum == CODE_OTHER){
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:LOCALIZATION(@"dialog_prompt") message:LOCALIZATION(@"setting_changeicon_error") delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok")otherButtonTitles:nil];
            [alert show];
            [friendCircleView dismissViewControllerAnimated:YES completion:nil];
        }
        else {
            return;
            
        }
        
    }];
}
- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
    view = nil;
}

//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    if (SCREEN_HEIGHT < 568) {
        _textField.frame = CGRectMake(0, temp6CGFloat-height+38+64, 0, 0);
    }else{
        _textField.frame = CGRectMake(0, temp6CGFloat-height+13, 0, 0);
    }
    [UIView beginAnimations:@"Curl1"context:nil];//动画开始
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    CGPoint p = self.tableView.contentOffset;
    if (SCREEN_HEIGHT < 568) {
        p.y += tempCGFloat - height + 33;
    }else{
        p.y += tempCGFloat - 64 - height + 10;
    }
    self.tableView.contentOffset = p;
    [UIView commitAnimations];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    UIViewController* n=self.navigationController;
    UIViewController* s=n.tabBarController.selectedViewController;
    UIViewController* t=self.navigationController.topViewController;
    UIViewController* v=self.presentedViewController;
    
    if(t==self
       && (s==n || !s)
       && ([v isKindOfClass:[UIImagePickerController class]]))
    {
        NSLog(@"ignore didReceiveMemoryWarning %@",self.description);
        return;
    }
    
    NSString* systemVersion = [[UIDevice currentDevice] systemVersion];
    CGFloat sysVersion = [systemVersion floatValue];
    if (sysVersion >= 6.0)
    {
        if(self.isViewLoaded && !self.view.window){
            HUD = nil;
            userModel = nil;
            cellofArticleBg = nil;
            articleArray = nil;
            goodAndCommentArray = nil;
            bgImagePicker = nil;// 背景图片的Picker
            shareImagePicker = nil;// 分享图片的Picker
            _textField = nil;
            textFieldInput = nil;
            customView = nil;
            commentView = nil;
            cellDic = nil;
            self.tableView = nil;
            self.view = nil;
        }
    }
    
}
-(void)dealloc{
    NSLog(@"调用了dealloc……！");
    HUD = nil;
    userModel = nil;
    cellofArticleBg = nil;
    articleArray = nil;
    goodAndCommentArray = nil;
    bgImagePicker = nil;// 背景图片的Picker
    shareImagePicker = nil;// 分享图片的Picker
    _textField = nil;
    textFieldInput = nil;
    customView = nil;
    commentView = nil;
    cellDic = nil;
    self.tableView = nil;
}


@end
