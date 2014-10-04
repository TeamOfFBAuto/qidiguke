//
//  LLRecordVoiceViewController.m
//  Starway
//
//  Created by Ming Zhang on 13-12-31.
//  Copyright (c) 2013年 laimark.com. All rights reserved.
//

#import "LLRecordVoiceViewController.h"
#import "ChatRecorderView.h"
#import <AudioToolbox/AudioToolbox.h>
@interface LLRecordVoiceViewController ()<AVAudioRecorderDelegate>{
    CGFloat                 curCount;           //当前计数,初始为0
    ChatRecorderView        *recorderView;      //录音界面
    CGPoint                 curTouchPoint;      //触摸点
    BOOL                    canNotSend;         //不能发送
    NSTimer                 *timer;
}
@property (retain, nonatomic)   AVAudioRecorder     *recorder;
@end

@implementation LLRecordVoiceViewController

@synthesize recorder = _recorder;
- (void)dealloc{
    SSRCSafeRelease(recorderView);
    SSRCSafeRelease(self.recorder);
    SSRCSuperDealloc;
//    [super dealloc];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - 开始录音
- (void)beginRecordByFileName:(NSString*)_fileName{
    
    //设置文件名和录音路径
    self.recordFileName = _fileName;
    self.recordFilePath = [VoiceRecorderBaseVC getPathByFileName:recordFileName ofType:@"wav"];
    /*
    self.recorder = [[[AVAudioRecorder alloc]initWithURL:[[[NSURL alloc] initFileURLWithPath:self.recordFilePath] autorelease]
                                                settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                   error:nil] autorelease];
     */
    NSURL *url = SSRCAutorelease([[NSURL alloc] initFileURLWithPath:self.recordFilePath]);
    self.recorder = SSRCAutorelease([[AVAudioRecorder alloc]initWithURL:url
                                                                  settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                                  error:nil]);
    
    
    
    //    self.recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:recordFilePath]
    //                                                settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
    //                                                   error:nil];
    _recorder.delegate = self;
    _recorder.meteringEnabled = YES;
    
    [_recorder prepareToRecord];
    
    //还原计数
    curCount = 0;
    //还原发送
    canNotSend = NO;
    
    //开始录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    /***新添加的两行代码**/
    UInt32 audioRouteOverride = kAudioSessionProperty_OverrideCategoryDefaultToSpeaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(audioRouteOverride), &audioRouteOverride);
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [_recorder record];
    
    //启动计时器
    [self startTimer];
    
    //显示录音界面
    [self initRecordView];
    /*
    [UIView showView:recorderView
         animateType:AnimateTypeOfPopping
           finalRect:kRecorderViewRect
          completion:^(BOOL finish){
              if (finish){
                  //注册nScreenTouch事件
                  [self addScreenTouchObserver];
              }
          }];
    //设置遮罩背景不可触摸
    [UIView setTopMaskViewCanTouch:NO];
     */
}

#pragma mark - 初始化录音界面
- (void)initRecordView{
    if (recorderView == nil)
        recorderView = (ChatRecorderView*)[[[[NSBundle mainBundle]loadNibNamed:@"ChatRecorderView" owner:self options:nil]lastObject]retain];
    //还原界面显示
    [recorderView restoreDisplay];
}

#pragma mark - 启动定时器
- (void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

#pragma mark - 停止定时器
- (void)stopTimer{
    if (timer && timer.isValid){
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark - 更新音频峰值
- (void)updateMeters{
    if (_recorder.isRecording){
        //更新峰值
        [_recorder updateMeters];
        [recorderView updateMetersByAvgPower:[_recorder averagePowerForChannel:0]];
        //倒计时
        if (curCount >= maxRecordTime - 10 && curCount < maxRecordTime) {
            //剩下10秒
            recorderView.countDownLabel.text = [NSString stringWithFormat:@"录音剩下:%d秒",(int)(maxRecordTime-curCount)];
        }else if (curCount >= maxRecordTime){
            //时间到
            [self touchEnded:curTouchPoint];
        }
        curCount += 0.1f;
    }
}

#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音停止");
    [self stopTimer];
    curCount = 0;
}
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音开始");
    [self stopTimer];
    curCount = 0;
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
    [self stopTimer];
    curCount = 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
