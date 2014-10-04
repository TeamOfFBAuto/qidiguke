//
//  FriendCircleHomeTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-8-6.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleHomeTableViewCell.h"
#import "UserArticleList.h"
#import "UIImageView+WebCache.h"
#import "Interface.h"
#import "contentAndGood.h"
#import "CommentView.h"
#import "SingleInstance.h"
#import "CommentTableView.h"
#import "ShowImagesViewController.h"
static const NSMutableArray *subjectArry;
@implementation FriendCircleHomeTableViewCell
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.userIcon = nil;
    self.userName = nil;
    self.goodView = nil;
    self.commentView = nil;
    self.ContentView = nil;
    self.reportTime = nil;
    self.comment = nil;
    self.favorite = nil;
    self.post = nil;
    self.PictureViews = nil;

}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        self.userIcon = [[UIImageView alloc]initWithFrame:CGRectZero];
        // 用户名
        self.userName = [[UILabel alloc]initWithFrame:CGRectZero];
        self.userName.textColor = [SingleInstance colorFromHexRGB:@"576b95"];
        self.userName.font = [UIFont boldSystemFontOfSize:14.0f];
        self.userName.backgroundColor = [UIColor clearColor];
        
        // "分享了一个链接"
        self.urlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.urlLabel.text = @"分享了一个链接";
        self.urlLabel.textAlignment = NSTextAlignmentLeft;
        self.urlLabel.backgroundColor = [UIColor clearColor];
        self.urlLabel.textColor = [UIColor blackColor];
        self.urlLabel.font = [UIFont systemFontOfSize:13.5f];
        self.urlLabel.hidden = YES;
        
        
        
        // 时间
        self.reportTime = [[UILabel alloc]init];
        self.reportTime.textColor = [UIColor grayColor];
        self.reportTime.font = [UIFont systemFontOfSize:13.0f];
        self.reportTime.backgroundColor = [UIColor clearColor];
        
        //删除按钮
        self.delete_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.delete_button setTitle:@"删除" forState:UIControlStateNormal];
        self.delete_button.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.delete_button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.delete_button addTarget:self action:@selector(deleteButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        // 赞
        self.favorite = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.favorite setImage:[UIImage imageNamed:@"userarticle_heart.png"] forState:UIControlStateNormal];
        self.favorite.backgroundColor = [UIColor clearColor];
        self.favorite.imageEdgeInsets = UIEdgeInsetsMake(7,5,8,40);
        
        [self.favorite setTitle:LOCALIZATION(@"userarticle_comment_good") forState:UIControlStateNormal];
        self.favorite.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.favorite.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.favorite setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.favorite setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.favorite.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        
        // 评论
        self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
        self.comment.backgroundColor = [UIColor clearColor];
        [self.comment setImage:[UIImage imageNamed:@"userarticle_chat.png"] forState:UIControlStateNormal];
        self.comment.imageEdgeInsets = UIEdgeInsetsMake(7,5,8,40);
        
        [self.comment setTitle:@"评论" forState:UIControlStateNormal];
        self.comment.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.comment.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.comment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.comment.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        
        // 发表的内容
        self.ContentView = [[FriendContentView alloc]initWithFrame:CGRectZero];
        
        // 显示赞
        self.goodView = [[CommentView alloc]initWithFrame:CGRectZero];
        self.goodView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
        __weak FriendCircleHomeTableViewCell *selfView = self;
        self.goodView.blockAction = ^(NSString *userId)
        {
            selfView.sendUserId(userId);
        };
        
        // 显示评论内容
        self.commentView = [[CommentTableView alloc]initWithFrame:CGRectZero];
        self.commentView.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
        __weak FriendCircleHomeTableViewCell *ownView = self;
        self.commentView.blockAction = ^(NSString *userId)
        {
            ownView.sendUserId(userId);
        };
        
        
        self.PictureViews = [[FBCirclePicturesViews alloc] initWithFrame:CGRectMake(60,0,240,0)];
        [self.contentView addSubview:self.PictureViews];
        
        _single_imageView = [[UIImageView alloc]  initWithFrame:CGRectZero];
        [self.contentView addSubview:_single_imageView];
        
        [self addSubview:self.ContentView];
        [self addSubview:self.goodView ];
        [self addSubview:self.commentView];
        
        [self addSubview:self.userIcon];
        [self addSubview:self.userName];
       
        [self addSubview:self.reportTime];
        [self addSubview:self.comment];
        [self addSubview:self.favorite];
        [self addSubview:self.urlLabel];
        [self addSubview:self.delete_button];
    }
    return self;
}
- (void)setPost:(UserArticleList *)post
{
    if (_post != post) {
        _post = post;
    }
    if (_post.fromWeixin.length == 0) {
        self.urlLabel.text = @"分享了一个链接";
    }
    else if([_post.fromWeixin isEqualToString:SOURCE_FROME_CASE]){
        self.urlLabel.text = @"分享了一个病例";
    }
    else if([_post.fromWeixin isEqualToString:SOURCE_FROME_MATERIAL]){
         self.urlLabel.text = @"分享了一个资料";
    }
    
    // 标注当前用户是否已进行评论
    BOOL flag = NO;
    if ([post.isGood isEqualToString:@"1"]) {
        flag = YES;
    }
    
    if (flag) {
        [self.favorite setTitle:LOCALIZATION(@"button_cancel")forState:UIControlStateNormal];
    }
    else{
        [self.favorite setTitle:LOCALIZATION(@"userarticle_comment_good") forState:UIControlStateNormal];
    }
    
    self.userIcon.backgroundColor = [UIColor whiteColor];
    // 用户的头像
    [self.userIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,_post.iconUrl]] placeholderImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"portrait_ico@2x" ofType:@"png"]]];
    
    // 用户名
    self.userName.text = _post.username;
    
    // 设置日期
    self.reportTime.text = [SingleInstance handleDate:_post.createDate];
    
    if ([_post.userId isEqualToString:GET_U_ID]) {
        self.delete_button.hidden = NO;
    }else
    {
        self.delete_button.hidden = YES;
    }
    
    // 设置发表的内容
    self.ContentView.articleModel = _post;
    
    // 显示赞
    if ([_post.goodArray count] > 0) {
        _goodView.goodArray = _post.goodArray;
    }
    else{
        _goodView.goodArray= nil;
    }
    // 显示评论
    if ([_post.commentArray count] > 0) {
        _commentView.commentArray = _post.commentArray;
    }
    else{
        _commentView.commentArray= nil;
    }
}

- (void)prepareForReuse{
    [super prepareForReuse];
    [self.favorite setTitle:nil forState:UIControlStateNormal];
    _ContentView.shareImg.image = nil;
    _ContentView.frame = CGRectZero;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.userIcon.frame = CGRectMake(10, 15, USER_ICON_WHDTH, USER_ICON_HEIGHT);
    self.userName.frame = CGRectMake(USER_ICON_WHDTH + 20, 20, USER_NAME_WHDTH, USER_NAME_HEIGHT);
    self.urlLabel.frame = CGRectMake(USER_ICON_WHDTH + USER_NAME_WHDTH+5, 26, URL_LABEL_WHDTH, URL_LABEL_HEIGHT);
    
    CGFloat contentHeight = [FriendContentView heightForCellWithPost:_post];
    _ContentView.frame = CGRectMake(0,45, 320,contentHeight);
    if (_ContentView.isShareLabel) {
        self.urlLabel.hidden = NO;
    }else{
        self.urlLabel.hidden = YES;
    }
    
    ///判断图片大小位置
    
    CGFloat content_height;
    if (_post.context == nil || _post.context.length == 0 || [_post.context isEqualToString:@" "]) {
        content_height = 0;
    }else
    {
        content_height = [SingleInstance customFontHeightFont:_post.context andFontSize:15 andLineWidth:250] +10;
    }
    
    if (_post.photo.length > 0 && ![_post.photo isKindOfClass:[NSNull class]])
    {
        _single_imageView.frame = CGRectMake(64,content_height+50,SHARE_IMAGE_WHDTH,SHARE_IMAGE_HEIGHT);
        [_single_imageView sd_setImageWithURL:[SNTools returnUrl:_post.photo] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
    }else
    {
        if (_post.attachlistArray.count)
        {
            int i = _post.attachlistArray.count/3;
            
            int j = _post.attachlistArray.count%3?1:0;
            
            float height = 75*(i+j)+2.5*(j + i - 1);
            
            _PictureViews.frame = CGRectMake(64,contentHeight+50+10,231,height);
            
            [_PictureViews setimageArr:_post.attachlistArray withSize:75 isjuzhong:NO];
            [_PictureViews setthebloc:^(NSInteger index) {
                
                ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
                showBigVC.allImagesUrlArray=_post.attachlistArray;

                showBigVC.currentPage = index-1;
                showBigVC.hidesBottomBarWhenPushed = YES;
                UIViewController *VCtest=(UIViewController *)self.delegate;
                [VCtest.navigationController pushViewController:showBigVC animated:YES];
            }];
        }
    }
    
    float img_height = _PictureViews.frame.size.height + 10;
    
    self.reportTime.frame = CGRectMake(USER_ICON_WHDTH + 10 + 10,img_height+ _ContentView.frame.size.height + _ContentView.frame.origin.y+13, REPORT_TIME_WHDTH, REPORT_TIME_HEIGHT);
    self.delete_button.frame = CGRectMake(REPORT_TIME_WHDTH+20,img_height+ _ContentView.frame.size.height + _ContentView.frame.origin.y+13,30,REPORT_TIME_HEIGHT);
    
    self.favorite.frame = CGRectMake(195,img_height+ _ContentView.frame.size.height + _ContentView.frame.origin.y+4,FAVORITE_WHDTH, FAVORITE_HEIGHT);
    self.comment.frame = CGRectMake(260,img_height+ _ContentView.frame.size.height + _ContentView.frame.origin.y+4,COMMENT_WHDTH, COMMENT_HEIGHT);

    // 设置咱得位置
    self.goodView.frame = CGRectMake(60,self.comment.frame.size.height + self.comment.frame.origin.y, 250,[SingleInstance customHeight:[_post.goodArray count] andcount:5 andsingleHeight:35.0]);
    // 设置评论的位置
    CGFloat commentHeight = 0.0;
    for (contentAndGood *modle in _post.commentArray) {
        commentHeight = commentHeight + [SingleInstance customFontHeightFont:modle.context andFontSize:14 andLineWidth:245] ;
    }
    commentHeight = commentHeight + [_post.commentArray count] *4;
    self.commentView.frame = CGRectMake(60,self.goodView.frame.size.height + self.goodView.frame.origin.y + 2, 250,commentHeight);
    
}
+ (CGFloat)heightForCellWithPost:(UserArticleList *)post
{
    CGFloat shareHeight = 0.0;
    CGFloat commentHeight = 0.0;
    // 赞的高度
    if ([post.goodArray count]>0) {
        shareHeight = [SingleInstance customHeight:[post.goodArray count] andcount:5 andsingleHeight:35.0] +5;
    }
    // 评论的高度设定
    if ([post.commentArray count]>0) {
        shareHeight = [SingleInstance customHeight:[post.goodArray count] andcount:5 andsingleHeight:35.0];
        for (contentAndGood *modle in post.commentArray) {
            commentHeight = commentHeight + [SingleInstance customFontHeightFont:modle.context andFontSize:14 andLineWidth:245];
        }
        commentHeight = commentHeight + [post.commentArray count] *4 + 15;
    }
    else{
        commentHeight = 0.0;
    }
    CGFloat height = SHARE_IMAGE_HEIGHT;
    height = 70 + [FriendContentView heightForCellWithPost:post] + REPORT_TIME_HEIGHT + shareHeight + commentHeight;
    
    return height;
}

#pragma mark - 删除操作
-(void)deleteButtonTap:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(deleteBlogWithCell:)]) {
        [_delegate deleteBlogWithCell:self];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
