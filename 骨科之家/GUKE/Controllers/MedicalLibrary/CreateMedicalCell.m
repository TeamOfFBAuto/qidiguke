//
//  CreateMedicalCell.m
//  GUKE
//
//  Created by soulnear on 14-10-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreateMedicalCell.h"

@implementation CreateMedicalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.title_label = [[UILabel alloc] initWithFrame:CGRectMake(8,15,60,20)];
        self.title_label.textAlignment = NSTextAlignmentLeft;
        self.title_label.font = [UIFont systemFontOfSize:16];
        self.title_label.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.title_label];
        
        self.input_textView = [[UITextView alloc] initWithFrame:CGRectMake(65,15,150,25)];
        self.input_textView.font = [UIFont systemFontOfSize:15];
        self.input_textView.contentInset = UIEdgeInsetsZero;
        self.input_textView.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.input_textView];
        
        self.input_line_view = [[UIImageView alloc] initWithFrame:CGRectMake(60,30,160,4)];
        self.input_line_view.image = [UIImage imageNamed:@"searchbgline"];
        [self.contentView addSubview:self.input_line_view];
        
    }
    return self;

}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
