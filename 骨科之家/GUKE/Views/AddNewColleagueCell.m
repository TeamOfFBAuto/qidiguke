//
//  AddNewColleagueCell.m
//  UNITOA
//  添加新同事
//  Created by ianMac on 14-7-22.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AddNewColleagueCell.h"
#import "UIImageView+WebCache.h"
#import "FriendIfo.h"
#import "Interface.h"
#import "AddNewColleagueViewController.h"

@implementation AddNewColleagueCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews
{
    _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    _name = [[UILabel alloc] initWithFrame:CGRectZero];
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (IOS7_LATER) {
        self.separatorInset = UIEdgeInsetsMake(0,-10,0,0);
    }
    [self.contentView addSubview:_icon];
    [self.contentView addSubview:_name];
    [self.contentView addSubview:_btn];
}

- (void)layoutSubviews
{
    _icon.frame = CGRectMake(7.5, 7.5, 35, 35);
    [_icon sd_setImageWithURL:[NSURL URLWithString:[IMAGE_BASE_URL stringByAppendingString:[NSString stringWithFormat:@"%@",self.model.icon]]] placeholderImage:[UIImage imageNamed:@"newfri_ico"]];
    
    _name.frame = CGRectMake(50, 15, 80, 20);
    _name.text = self.model.dstUserName;
    _name.font = [UIFont systemFontOfSize:16.0f];
    _name.textAlignment = NSTextAlignmentLeft;
    _name.textColor = [UIColor blackColor];
    
    _btn.frame = CGRectMake(270, 13, 40, 25);
    _btn.backgroundColor = [UIColor whiteColor];
    _btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [_btn.layer setMasksToBounds:YES];
    _btn.layer.cornerRadius = 5;
    [_btn.layer setBorderWidth:1.0];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 128/255.0, 128/255.0, 128/255.0, 1 });
    [_btn.layer setBorderColor:colorref];//边框颜色
    [_btn setTitle:LOCALIZATION(@"add_cn") forState:UIControlStateNormal];
    [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_btn addTarget:self action:@selector(Click) forControlEvents:UIControlEventTouchUpInside];
}

- (void)Click
{
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"dstUserId":self.model.dstUserId,@"verifyType":@"0"};
    [AFRequestService responseData:@"friendverify.php" andparameters:parameters andResponseData:^(id responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSString *data = [dict objectForKey:@"code"];
        if ([data intValue]==0) {
            NSString *alertcontext = LOCALIZATION(@"friend_verify_ok");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }else{
            NSString *alertcontext = LOCALIZATION(@"friend_verify_no");
            NSString *alertText = LOCALIZATION(@"dialog_prompt");
            NSString *alertOk = LOCALIZATION(@"dialog_ok");
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:alertText message:alertcontext delegate:self cancelButtonTitle:alertOk otherButtonTitles:nil];
            [alert show];
        }
    }];
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        self.block();
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    
//    //上分割线，
//    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:@"ffffff"].CGColor);
//    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    
    //下分割线
    CGContextSetStrokeColorWithColor(context, GETColor(199, 199, 199).CGColor);
    CGContextStrokeRect(context, CGRectMake(5, rect.size.height, rect.size.width - 10, 1));
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
