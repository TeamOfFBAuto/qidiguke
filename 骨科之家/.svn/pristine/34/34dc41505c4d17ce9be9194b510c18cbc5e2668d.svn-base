//
//  AppDelegate.h
//  UNITOA
//
//  Created by qidi on 14-6-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
// 页面的跳转
typedef enum{
	Root_login = 0,
	Root_home,
    Root_contact,
    Root_friend
} ROOTVC_TYPE;
#import <UIKit/UIKit.h>
#import "WindowCustom.h"
#import <AVFoundation/AVFoundation.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AVAudioPlayer *avAudioPlayer;   //播放器player
}
@property (strong, nonatomic) WindowCustom *window;

- (void)showControlView:(ROOTVC_TYPE)type;
@end
