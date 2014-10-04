//
//  TDListCell.h
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDListModel.h"

@interface TDListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *date_label;


@property (strong, nonatomic) IBOutlet UIImageView *head_imageView;

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property (strong, nonatomic) IBOutlet UILabel *content_label;

@property (strong, nonatomic) IBOutlet UIImageView *back_view;






-(void)setInfoWith:(TDListModel *)model;










@end
