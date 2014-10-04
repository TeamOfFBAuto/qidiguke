//
//  CreatMedicalViewController.h
//  GUKE
//  新建病历页面
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatVoiceRecorderVC.h"
#import "VoiceConverter.h"
#import "BingLiListFeed.h"
#import "CreateMedicalFilesCell.h"

@interface PlayVoice : AVAudioPlayer
{
    
}

@property(nonatomic,strong)CreateMedicalFilesCell * aCell;

@end



@interface CreatMedicalViewController : SNViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,AVAudioSessionDelegate>{



}

@property(nonatomic,strong)UITableView *mainTableView;

@property(nonatomic,strong)ChatVoiceRecorderVC * recorderVC;

@property(nonatomic,strong)BingLiListFeed * feed;

@property(nonatomic,strong)PlayVoice *player;

@end
