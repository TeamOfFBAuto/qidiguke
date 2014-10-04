//
//  RecordsTableViewCell.m
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//


#import "RecordsTableViewCell.h"


@implementation RecordsTableViewCell


- (void)awakeFromNib {
    
    // Initialization code
    
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
        _inputField=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 320, 15)];
        _inputField.delegate=self;
        [self addSubview:_inputField];
        
        // _sendVerficationButton.backgroundColor=[UIColor whiteColor];
        
    }
    return self;
}








- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
