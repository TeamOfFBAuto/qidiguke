//
//  MedicalCell.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BingLiListFeed.h"

@interface MedicalCell : UITableViewCell


///诊断信息
@property (strong, nonatomic) IBOutlet UILabel *zhenduan_label;

///患者姓名
@property (strong, nonatomic) IBOutlet UILabel *userName_label;


@property (strong, nonatomic) IBOutlet UILabel *bingzhengleixing;





-(void)setInfoWith:(BingLiListFeed *)info;









@end
