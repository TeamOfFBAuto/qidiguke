//
//  FriendCircleContentTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-7-14.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleContentTableViewCell.h"

@implementation FriendCircleContentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 头像
        self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, USER_ICON_WHDTH, USER_ICON_HEIGHT)];
        // 用户名
        self.userName = [[UILabel alloc]initWithFrame:CGRectMake(USER_ICON_WHDTH + 10 + 10, 25, USER_NAME_WHDTH, USER_NAME_HEIGHT)];
        self.userName.textColor =  [UIColor colorWithRed:0/255.0 green:102/255.0 blue:153/255.0 alpha:1];
        self.userName.font = [UIFont boldSystemFontOfSize:14.0f];
        self.userName.backgroundColor = [UIColor clearColor];
        // "分享了一个链接"
        self.urlLabel = [[UILabel alloc] init];
        self.urlLabel.frame = CGRectMake(USER_ICON_WHDTH + USER_NAME_WHDTH+3, 26, URL_LABEL_WHDTH, URL_LABEL_HEIGHT);
        
        self.urlLabel.text = @"分享了一个链接";
        self.urlLabel.textAlignment = NSTextAlignmentLeft;
        self.urlLabel.backgroundColor = [UIColor clearColor];
        self.urlLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.8];
        self.urlLabel.font = [UIFont systemFontOfSize:13.5f];
        self.urlLabel.hidden = YES;
        // 说说内容
        self.content = [[UILabel alloc]initWithFrame:CGRectZero];
        self.content.numberOfLines = 0;
        self.content.font = [UIFont systemFontOfSize:13.5f];
        self.content.backgroundColor = [UIColor clearColor];
        
        // 说说内容
        _contact = [[RTLabel alloc]initWithFrame:CGRectZero];
        [_contact setParagraphReplacement:@""];
        _contact.font = [UIFont systemFontOfSize:13.5f];
        _contact.backgroundColor = [UIColor clearColor];
        
        // 说说图片
        self.shareImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        // 时间
        self.reportTime = [[UILabel alloc]initWithFrame:CGRectZero];
        self.reportTime.textColor = [UIColor grayColor];
        self.reportTime.font = [UIFont systemFontOfSize:13.0f];
        self.reportTime.backgroundColor = [UIColor clearColor];
        // 赞
        self.favorite = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.favorite.frame = CGRectMake(200, self.shareImg.frame.size.height + self.shareImg.frame.origin.y,FAVORITE_WHDTH, FAVORITE_HEIGHT);
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
//        self.comment.frame = CGRectMake(230, self.shareImg.frame.size.height + self.shareImg.frame.origin.y,COMMENT_WHDTH, COMMENT_HEIGHT);
        self.comment.backgroundColor = [UIColor clearColor];
        [self.comment setImage:[UIImage imageNamed:@"userarticle_chat.png"] forState:UIControlStateNormal];
        self.comment.imageEdgeInsets = UIEdgeInsetsMake(7,5,8,40);
        
        [self.comment setTitle:@"评论" forState:UIControlStateNormal];
        self.comment.titleLabel.font = [UIFont systemFontOfSize:13.0f];
        self.comment.titleLabel.textAlignment = NSTextAlignmentLeft;
        [self.comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.comment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        self.comment.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 5);
        // 显示赞
        self.showFavoritor = [[UIView alloc]initWithFrame:CGRectZero];
        self.showFavoritor.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
        // 显示评论内容
        self.showComment = [[UIView alloc]initWithFrame:CGRectZero];
        self.showComment.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
        
        
        [self addSubview:self.showComment];
        [self addSubview:self.showFavoritor];
        [self addSubview:self.userIcon];
        [self addSubview:self.userName];
        [self addSubview:self.content];
        [self addSubview:self.contact];
        [self addSubview:self.shareImg];
        [self addSubview:self.reportTime];
        [self addSubview:self.comment];
        [self addSubview:self.favorite];
        [self addSubview:self.urlLabel];
        
    }
    return self;
}
- (void)layoutView
{
    // 头像
    self.userIcon = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, USER_ICON_WHDTH, USER_ICON_HEIGHT)];
    // 用户名
    self.userName = [[UILabel alloc]initWithFrame:CGRectMake(USER_ICON_WHDTH + 10, 5, USER_NAME_WHDTH, USER_NAME_HEIGHT)];
    self.userName.textColor =  [UIColor colorWithRed:0/255.0 green:102/255.0 blue:153/255.0 alpha:1];
    self.userName.font = [UIFont boldSystemFontOfSize:15.0f];
    self.userName.backgroundColor = [UIColor clearColor];
    // 说说内容
    self.content = [[UILabel alloc]init];
    self.content.numberOfLines = 0;
    self.content.font = [UIFont systemFontOfSize:14];
    self.content.backgroundColor = [UIColor clearColor];
    // 说说图片
    self.shareImg = [[UIImageView alloc]init];
    // 时间
    self.reportTime = [[UILabel alloc]init];
    self.reportTime.textColor = [UIColor grayColor];
    self.reportTime.font = [UIFont systemFontOfSize:14];
    self.reportTime.backgroundColor = [UIColor clearColor];
    // 赞
    self.favorite = [UIButton buttonWithType:UIButtonTypeCustom];
    self.favorite.frame = CGRectMake(150, self.shareImg.frame.size.height + self.shareImg.frame.origin.y,FAVORITE_WHDTH, FAVORITE_HEIGHT);
    self.favorite.backgroundColor = [UIColor clearColor];
    [self.favorite setImage:[UIImage imageNamed:@"userarticle_heart.png"] forState:UIControlStateNormal];
    self.favorite.imageEdgeInsets = UIEdgeInsetsMake(7,10,8,55);
    
   [self.favorite setTitle:LOCALIZATION(@"userarticle_comment_good") forState:UIControlStateNormal];
    self.favorite.titleLabel.font = [UIFont systemFontOfSize:14];
    self.favorite.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.favorite setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.favorite setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.favorite.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 20);
    
    // 评论
    self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.comment.frame = CGRectMake(230, self.shareImg.frame.size.height + self.shareImg.frame.origin.y,COMMENT_WHDTH, COMMENT_HEIGHT);
    self.comment.backgroundColor = [UIColor clearColor];
    [self.comment setImage:[UIImage imageNamed:@"userarticle_chat.png"] forState:UIControlStateNormal];
    self.comment.imageEdgeInsets = UIEdgeInsetsMake(7,10,8,35);
    
    [self.comment setTitle:@"评论" forState:UIControlStateNormal];
    self.comment.titleLabel.font = [UIFont systemFontOfSize:14];
    self.comment.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.comment setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    self.comment.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 0);
    // 显示赞
    self.showFavoritor = [[UIView alloc]init];
    self.showFavoritor.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.2];
    // 显示评论内容
    self.showComment = [[UIView alloc]init];
    self.showComment.backgroundColor = [UIColor grayColor];
    
    
    [self addSubview:self.showComment];
    [self addSubview:self.showFavoritor];
    [self addSubview:self.userIcon];
    [self addSubview:self.userName];
    [self addSubview:self.content];
    [self addSubview:self.shareImg];
    [self addSubview:self.reportTime];
    [self addSubview:self.comment];
    [self addSubview:self.favorite];
    self.showFavoritor = nil;
    
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
