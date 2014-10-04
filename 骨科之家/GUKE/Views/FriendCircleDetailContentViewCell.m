//
//  FriendCircleDetailContentViewCell.m
//  UNITOA
//  个人朋友圈的内容的Cell
//  Created by ianMac on 14-9-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleDetailContentViewCell.h"

@implementation FriendCircleDetailContentViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    self.content = [[UILabel alloc] initWithFrame:CGRectZero];
    self.shareImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.contentShare = [[MyLabel alloc] initWithFrame:CGRectZero];
    
    // "分享了一个链接"
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.urlLabel.text = @"分享了一个链接";
    self.urlLabel.textAlignment = NSTextAlignmentLeft;
    self.urlLabel.backgroundColor = [UIColor whiteColor];
    self.urlLabel.textColor = [UIColor blackColor];
    self.urlLabel.font = [UIFont systemFontOfSize:13.0f];
    self.urlLabel.hidden = YES;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectZero];
    self.backView.backgroundColor = RGB(238, 238, 238);
    
    self.PictureViews = [[FBCirclePicturesViews alloc] init];
    
    [self.backView addSubview:self.PictureViews];
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.content];
    [self.contentView addSubview:self.shareImg];
    [self.contentView addSubview:self.contentShare];
    [self.contentView addSubview:self.urlLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.content.font = [UIFont systemFontOfSize:13.0f];
    self.urlLabel.frame = CGRectMake(0, 0, 255, 25);
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
