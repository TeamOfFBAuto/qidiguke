//
//  CreatNewInfoViewController.h
//  GUKE
//  新建资料库页面
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceRecorderBaseVC.h"
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"
@interface CreatNewInfoViewController : UIViewController<VoiceRecorderBaseVCDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (strong, nonatomic)  ChatVoiceRecorderVC *recorderVC;
@end
