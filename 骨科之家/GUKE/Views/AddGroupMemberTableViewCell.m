//
//  AddGroupMemberTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-7-10.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AddGroupMemberTableViewCell.h"

@implementation AddGroupMemberTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 40, 40)];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 15, 200, 20)];
        self.checkTitle = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkTitle.frame =CGRectMake(SCREEN_WIDTH - 32, 15, 20, 20);
        self.checkTitle.layer.cornerRadius = 3;
        self.checkTitle.layer.borderWidth = 1;
        self.checkTitle.layer.borderColor = [[UIColor grayColor] CGColor];
        [self.contentView addSubview:self.checkTitle];
        [self.contentView addSubview:self.imgView];
        [self.contentView addSubview:self.nameLabel];
    }
    return self;
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
