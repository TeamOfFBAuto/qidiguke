//
//  ShareCircleViewController.h
//  GUKE
//
//  Created by soulnear on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareCircleViewController : SNViewController<UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UITextField *input_tf;

@property (strong, nonatomic) IBOutlet UIImageView *line_imageView;

@property (strong, nonatomic) IBOutlet UILabel *title_label;

@property(nonatomic,strong)NSString * share_content;

///分享类型0：分享链接 1：分享微信 2.分享病历库 3.分享资料库
@property(nonatomic,strong)NSString * type;
///分享文章的id
@property(nonatomic,strong)NSString * theId;


@end
