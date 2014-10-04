//
//  CommentTableViewCell.h
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@interface CommentTableViewCell : UITableViewCell
@property(nonatomic, strong)UIButton *nameBtn;
@property(nonatomic, strong)UILabel *commentLabel;
@property (nonatomic, strong) RTLabel *rtLabel;
//+ (RTLabel*)textLabel;
@end
