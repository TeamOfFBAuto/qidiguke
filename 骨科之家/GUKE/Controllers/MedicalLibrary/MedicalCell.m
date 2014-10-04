//
//  MedicalCell.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "MedicalCell.h"

@implementation MedicalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setInfoWith:(BingLiListFeed *)info
{
    self.zhenduan_label.text = info.zhenduan;
    
    self.userName_label.text = info.psnname;
    
    self.bingzhengleixing.text = info.fenleiname;
    
}





@end
