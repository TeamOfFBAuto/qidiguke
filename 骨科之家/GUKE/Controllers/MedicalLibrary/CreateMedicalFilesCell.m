//
//  CreateMedicalFilesCell.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreateMedicalFilesCell.h"

@implementation CreateMedicalFilesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)deleteButtonTap:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(deleteFilesTap:)]) {
        [_delegate deleteFilesTap:self];
    }
    
}

- (IBAction)filesImageViewTap:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(filesImageViewTap:)]) {
        [_delegate filesImageViewTap:self];
    }
    
}


@end
