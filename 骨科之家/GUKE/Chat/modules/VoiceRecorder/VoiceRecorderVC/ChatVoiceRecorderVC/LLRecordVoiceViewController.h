//
//  LLRecordVoiceViewController.h
//  Starway
//
//  Created by Ming Zhang on 13-12-31.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VoiceRecorderBaseVC.h"
@interface LLRecordVoiceViewController : VoiceRecorderBaseVC

//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;
- (void)end;
@end
