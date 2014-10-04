//
//  CommentTableViewCell.m
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.nameBtn.backgroundColor = [UIColor clearColor];
        
        self.commentLabel = [[UILabel alloc]init];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        _rtLabel = [[RTLabel alloc] init];
        [_rtLabel setParagraphReplacement:@""];
        [self.contentView addSubview:_rtLabel];
        [self.contentView addSubview:self.commentLabel];
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
