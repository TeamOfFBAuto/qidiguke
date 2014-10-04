//
//  TDListCell.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TDListCell.h"

@implementation TDListCell

- (void)awakeFromNib
{
    // Initialization code
    [self.contentView sendSubviewToBack:self.back_view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setInfoWith:(TDListModel *)model
{
    _date_label.text = model.createDate;
    [_head_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.smallPic]] placeholderImage:[UIImage imageNamed:@"user_default_ico"]];
    _title_label.text = model.title;
    _content_label.text = model.content;
}



@end
