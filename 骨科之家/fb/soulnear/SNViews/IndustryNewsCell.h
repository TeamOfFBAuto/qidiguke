//
//  IndustryNewsCell.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndustryNewsModel.h"

@interface IndustryNewsCell : UITableViewCell



@property (strong, nonatomic) IBOutlet UIImageView *head_imageView;


@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (strong, nonatomic) IBOutlet UILabel *content_label;

@property (strong, nonatomic) IBOutlet UILabel *date_label;




-(void)setInfoWith:(IndustryNewsModel *)info;













@end
