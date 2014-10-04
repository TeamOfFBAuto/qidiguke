//
//  ShareImageViewController.h
//  UNITOA
//
//  Created by qidi on 14-7-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SendPostsImageScrollView.h"
@interface ShareImageViewController : UIViewController<UITextViewDelegate,MBProgressHUDDelegate>
{
    SendPostsImageScrollView * imageScrollView;
}
@property(nonatomic, strong)UIImage *img;
@property(nonatomic, strong)NSData *imgData;

@property(nonatomic,strong)NSMutableArray * data_array;
@end
