//
//  InformationTableViewCell.h
//  GUKE
//  资料库的Cell
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;

@end
