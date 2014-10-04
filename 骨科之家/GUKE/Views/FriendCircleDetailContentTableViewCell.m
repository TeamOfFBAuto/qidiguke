//
//  FriendCircleDetailContentTableViewCell.m
//  UNITOA
//
//  Created by ianMac on 14-7-28.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleDetailContentTableViewCell.h"

@implementation FriendCircleDetailContentTableViewCell

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
    self.reportDate = [[UILabel alloc] initWithFrame:CGRectZero];
    self.reportTime = [[UILabel alloc] initWithFrame:CGRectZero];
    self.fDContentView = [[FriendCircleDetailContentView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.reportTime];
    [self.contentView addSubview:self.reportDate];
    [self addSubview:self.fDContentView];
}

- (void)setPostArray:(NSMutableArray *)postArray
{
    if (_postArray != postArray) {
        _postArray = postArray;
    }
    _fDContentView.contentDataArray = _postArray;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.reportTime.font = [UIFont systemFontOfSize:13.0f];
    self.reportTime.textAlignment = NSTextAlignmentCenter;
    self.reportTime.backgroundColor = [UIColor clearColor];
    self.reportDate.font = [UIFont systemFontOfSize:26.0f];
    self.reportDate.textAlignment = NSTextAlignmentLeft;
    self.reportDate.backgroundColor = [UIColor clearColor];
    CGFloat contentHeight = [FriendCircleDetailContentView heightForCellWithPost:_postArray];
    _fDContentView.frame = CGRectMake(75, 0, SCREEN_WIDTH-70, contentHeight);
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
