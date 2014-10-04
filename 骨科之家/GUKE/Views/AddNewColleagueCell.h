//
//  AddNewColleagueCell.h
//  UNITOA
//  添加新同事
//  Created by ianMac on 14-7-22.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FriendIfo;
typedef void(^PushBlock)();
@interface AddNewColleagueCell : UITableViewCell
{
@private
    // 头像
    UIImageView *_icon;
    // 名字
    UILabel *_name;
    // 按钮
    UIButton *_btn;
}
@property (nonatomic, strong) FriendIfo *model;
@property (nonatomic, copy) PushBlock block;
@end
