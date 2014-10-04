//
//  CreatMedicalViewController.m
//  GUKE
//  新建病历页面
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreatMedicalViewController.h"
#import "CreateMedicalCell.h"
#import "UIImage+fixOrientation.h"
#import "QiDiPopoverView.h"
#import "imgUploadModel.h"
#import "CreateMedicalFilesCell.h"
#import "ChooseCaseTypeViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VoicePlayCenter.h"


@interface PlayVoice ()

@end

@implementation PlayVoice
@synthesize aCell = _aCell;


@end


@interface CreatMedicalViewController ()<UITextViewDelegate,CreateMedicalFilesCellDelegate,UIActionSheetDelegate,VoicePlayCenterDelegate>
{
    ///存放条件数据
    NSMutableArray * content_array;
    ///治疗方案
    UITextView * treatment_case;
    ///治疗方案默认文字
    UILabel * placeHolder_treatment_case;
    
    UILabel * placeHolder_shuoming;
    
    ///存放所有textView
    NSMutableArray * textView_array;
    
    NSArray * _voiceLeftImageArr;
    ///弹出框
    QiDiPopoverView * popOver;
    
    UITextField * groupName;
    
    UIView * background ;
    UIImageView * imgSaveView;
    
    ///播放录音
    VoicePlayCenter * voicePlayCenter;
    
    ///删除文件的id
    NSMutableArray * delete_array;
    
    ///存放完成的数据（视频、图片、录音）
    NSMutableArray * data_array;
    
    MBProgressHUD * hud;
    ///播放本地视频
    MPMoviePlayerViewController * _moviePlayerController;
    
    ///判断当前是否有声音正在播放
    BOOL isAnimationVoice;
    
    //视频相关
    
    int _btnChoose;//用于在回调方法中判断是 选择视频 还是录制视频
    
    
    UIImagePickerControllerQualityType                  _qualityType;
    NSString*                                           _mp4Quality;
    
    NSURL*                                              _videoURL;
    NSString*                                           _mp4Path;
    
    UIAlertView*                                        _alert;
    NSDate*                                             _startDate;
    
    
    BOOL                                                _hasVideo;
    BOOL                                                _networkOpt;
    BOOL                                                _hasMp4;
    
    
    
    
    
}
// 自定义导航栏
- (void)loadNavigation;
@end

@implementation CreatMedicalViewController
@synthesize feed = _feed;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    view.backgroundColor = [UIColor whiteColor];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigation];
    
    textView_array = [NSMutableArray array];
    delete_array = [NSMutableArray array];
    
    for (int i = 0;i < 10;i++)
    {
        UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(65,15,150,25)];
        textView.font = [UIFont systemFontOfSize:15];
        textView.contentInset = UIEdgeInsetsZero;
        textView.textColor = [UIColor blackColor];
        textView.delegate = self;
        textView.tag = 100+i;
        [textView_array addObject:textView];
    }
    
    if (!_feed) {
        _feed = [[BingLiListFeed alloc] init];
        _feed.attach_array = [NSMutableArray array];
    }
    
    content_array = [NSMutableArray arrayWithObjects:@"姓名",@"性别",@"就诊时间",@"诊断",@"病人手机号",@"家属手机号",@"治疗方案",@"病历号",@"身份证号",@"标记编号",nil];
    data_array = [NSMutableArray array];
    
    _voiceLeftImageArr = [[NSArray alloc] initWithObjects:
                          [UIImage imageNamed:@"voice_L1.png"],
                          [UIImage imageNamed:@"voice_L2.png"],
                          [UIImage imageNamed:@"voice_L3.png"],nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadData:)
                                                 name:@"uploadData"
                                               object:nil];
    
    
    
    //视频相关
    _networkOpt = YES;
    _qualityType = UIImagePickerControllerQualityTypeLow;
    _mp4Quality = AVAssetExportPresetLowQuality;
    _hasVideo = NO;
    _hasMp4 = NO;
    _btnChoose = 0;
    
    
    
}

-(void)uploadData:(NSNotification *)notification
{
    NSLog(@"notification ---  %@",notification.userInfo);

    
}


#pragma mark-显示收回键盘

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    _mainTableView.contentSize = CGSizeMake(0,_mainTableView.contentSize.height+226);
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    _mainTableView.contentSize = CGSizeMake(0,_mainTableView.contentSize.height-226);
}


// 导航的设置
- (void)loadNavigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 4, 36, 36);
    
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 7, 160, 30)];
    loginLabel.text = @"新建病历库";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    rightView.backgroundColor = [UIColor clearColor];
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightBtn.frame = CGRectMake(0, (44-28)/2+1, 44, 28);
    rightBtn.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.2f];
    rightBtn.layer.cornerRadius = 4;
    [rightBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //主tableview
    
    _mainTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT) style:UITableViewStylePlain];
    _mainTableView.delegate=self;
    _mainTableView.dataSource=self;
    _mainTableView.tableHeaderView = [self loadSectionView];
    [self.view addSubview:_mainTableView];
}

// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 提交按钮方法
/// "提交"的点击事件
- (void)btnClick
{
    NSLog(@"点击提交按钮");
    ChooseCaseTypeViewController * chooseType = [[ChooseCaseTypeViewController alloc] init];
    chooseType.feed = _feed;
    chooseType.delete_array = [NSMutableArray arrayWithArray:delete_array];
//    [delete_array removeAllObjects];
    [self.navigationController pushViewController:chooseType animated:YES];
}


#pragma mark - 加载头视图
-(UIView *)loadSectionView
{
    CGRect viewFrame = CGRectMake(0,0,DEVICE_WIDTH,120);
    UIView * view = [[UIView alloc] initWithFrame:viewFrame];
    UITextView * text_view = [[UITextView alloc] initWithFrame:CGRectMake(10,10,DEVICE_WIDTH-20,60)];
    text_view.tag = 1000;
    text_view.delegate = self;
    text_view.textAlignment = NSTextAlignmentLeft;
    text_view.textColor = [UIColor lightGrayColor];
    text_view.font = [UIFont systemFontOfSize:14];
    text_view.layer.borderColor = [UIColor blueColor].CGColor;
    text_view.layer.borderWidth = 0.5;
    [view addSubview:text_view];
    
    placeHolder_shuoming = [[UILabel alloc] initWithFrame:CGRectMake(10,5,200,20)];
    placeHolder_shuoming.text = @"病历说明";
    placeHolder_shuoming.font = [UIFont systemFontOfSize:15];
    placeHolder_shuoming.textAlignment = NSTextAlignmentLeft;
    placeHolder_shuoming.textColor = [UIColor blackColor];
    [text_view addSubview:placeHolder_shuoming];
    
    if (_feed.memo.length > 0)
    {
        text_view.text = _feed.memo;
        placeHolder_shuoming.text = @"";
    }
    
    
    NSArray * image_array = [NSArray arrayWithObjects:@"guke_ic_addcamera",@"guke_ic_addvoice.png",@"guke_ic_addvideo.png",@"guke_ic_addphoto.png",nil];
    
    for (int i = 0;i < 4;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((DEVICE_WIDTH-150)+37*i,80,27,28);
        button.tag = 1000+i;
        [button addTarget:self action:@selector(doButton:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(doButtonEnd:) forControlEvents:UIControlEventTouchCancel];
        [button setImage:[UIImage imageNamed:[image_array objectAtIndex:i]] forState:UIControlStateNormal];
        [view addSubview:button];
    }
    return view;
}

#pragma makr - button点击方法
-(void)doButton:(UIButton *)sender
{
    switch (sender.tag - 1000) {
        case 0:///拍照
        {
            [self takePotoPicture:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case 1:///录音
        {
            [self recordStartQiDi];
        }
            break;
        case 2:///视频
        {
            _btnChoose = 11;
            if (_hasVideo)
            {
                _mp4Path = nil;
                _videoURL = nil;
                _startDate = nil;
                
            }
            UIImagePickerController* pickerView = [[UIImagePickerController alloc] init];
            
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                pickerView.sourceType = UIImagePickerControllerSourceTypeCamera;
                NSArray* availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
                pickerView.mediaTypes = [NSArray arrayWithObject:availableMedia[1]];
                [self presentViewController:pickerView animated:YES completion:^{
                    
                }];
                pickerView.videoMaximumDuration = 30;
                pickerView.delegate = self;
                
                
                
                
            }else{
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"相机不可用" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [al show];
            }
        }
            break;
        case 3:///相册
        {
            [self takePotoPicture:UIImagePickerControllerSourceTypePhotoLibrary];
        }
            break;
            
        default:
            break;
    }
    
}

-(void)doButtonEnd:(UIButton *)sender
{
    if (sender.tag == 101) {
        [self recordEndQiDi];
    }
}

#pragma mark - 选择完文件后，输入介绍
-(void)inputIntroduce
{
    popOver = [[QiDiPopoverView alloc] init];
    [popOver showPopoverAtPoint:CGPointMake(viewSize.width, 0) inView:self.view withContentView:[self creatGroupView]];
    
}

- (UIView *)creatGroupView{
    UIView *contaiterView = [[UIView alloc]initWithFrame:CGRectMake(30, 64, viewSize.width-60, 170)];
    contaiterView.backgroundColor = [UIColor blackColor];
    
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 150, 40)];
    groupNameLabel.text = @"文件描述";
    groupNameLabel.textColor = [UIColor whiteColor];
    groupNameLabel.backgroundColor = [UIColor clearColor];
    groupNameLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:groupNameLabel];
    
    UIImageView *lineBg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 45, contaiterView.frame.size.width, 2)];
    lineBg1.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg1];
    
    groupName = [[UITextField alloc]initWithFrame:CGRectMake(5, 60, contaiterView.frame.size.width-10, 30)];
    [groupName setBorderStyle:UITextBorderStyleLine];
    groupName.layer.borderColor = [[UIColor orangeColor]CGColor];
    groupName.font = [UIFont systemFontOfSize:16];
    groupName.textColor = [UIColor whiteColor];
    groupName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    groupName.keyboardAppearance = UIKeyboardAppearanceDefault;
    groupName.keyboardType = UIKeyboardTypeDefault;
    groupName.returnKeyType = UIReturnKeyGo;
    [groupName becomeFirstResponder];
    groupName.tag = 10000;
    groupName.delegate = self;
    [contaiterView addSubview:groupName];
    
    UIImageView *lineBg2 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 90, contaiterView.frame.size.width-10, 4)];
    lineBg2.image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"searchbglinered@2x" ofType:@"png"]];
    
    [contaiterView addSubview:lineBg2];
    
    UIButton *dialogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dialogBtn.frame = CGRectMake(30, 120, 70, 40);
    dialogBtn.backgroundColor = [UIColor clearColor];
    dialogBtn.tag = DIALOG_Btn_TAG;
    [dialogBtn setTitle:LOCALIZATION(@"dialog_cancel") forState:UIControlStateNormal];
    [dialogBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [dialogBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    dialogBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    dialogBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    
    UIButton *subMitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    subMitBtn.frame = CGRectMake(150, 120, 70, 40);
    subMitBtn.backgroundColor = [UIColor clearColor];
    subMitBtn.tag = SUBMIT_BTN_TAG;
    [subMitBtn setTitle:LOCALIZATION(@"button_submit") forState:UIControlStateNormal];
    [subMitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [subMitBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    subMitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    subMitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [contaiterView addSubview:dialogBtn];
    [contaiterView addSubview:subMitBtn];
    
    return contaiterView;
}

-(void)btnClick:(UIButton *)sender
{
    switch (sender.tag) {
        case DIALOG_Btn_TAG:///取消
        {
            [popOver dismiss];
            [_feed.attach_array removeLastObject];
        }
            
            break;
        case SUBMIT_BTN_TAG:///完成
        {
            
            id object = [_feed.attach_array lastObject];
            if ([object isKindOfClass:[NSMutableDictionary class]])///语音
            {
                [(NSMutableDictionary *)object setObject:groupName.text forKey:@"content"];
                
            }else if ([object isKindOfClass:[imgUploadModel class]])
            {
                ((imgUploadModel *)object).imageName = groupName.text;
            }else if ([object isKindOfClass:[VideoUploadModel class]])
            {
                ((VideoUploadModel *)object).fileName = groupName.text;
            }
            
            
//            NSMutableDictionary * dic = [_feed.attach_array lastObject];
//            [dic setObject:groupName.text forKey:@"content"];
            [_mainTableView reloadData];
            [popOver dismiss];
        }
            
            break;
            
        default:
            break;
    }
}


// 触发录音事件
- (void)recordStartQiDi
{
    NSString *originWav = [VoiceRecorderBaseVC getCurrentTimeString];
    if (!self.recorderVC) {
        self.recorderVC = [[ChatVoiceRecorderVC alloc]init];
        _recorderVC.vrbDelegate = (id)self;
    }
    [self.recorderVC beginRecordByFileName:originWav];
}

// 结束录音事件
- (void)recordEndQiDi
{
    [self.recorderVC end];
    
}

#pragma mark - 录音方法
#pragma mark record 开始录音
#pragma mark ---------record delegate
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString *)_fileName withVoiceLenth:(CGFloat)length
{
    
    int a =(int) length;
    if (a > 0) {
        [self wavToAmr:_filePath with:_fileName length:length];
    }
}
-(void)wavToAmr:(NSString *)_filePath  with:(NSString *)_fileName length:(CGFloat)length{
    [VoiceConverter wavToAmr:_filePath amrSavePath:[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_fileName,@"fid",_filePath,@"fileName",[NSNumber numberWithInt:(int)length],@"length", nil];
    
    NSMutableData * data = [NSMutableData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
    [dic setObject:data forKey:@"fileData"];
    [_feed.attach_array addObject:dic];
    
    NSLog(@"%@==%@",_filePath,_fileName);
    [self inputIntroduce];
}


#pragma mark imagepicker delegate
-(void)takePotoPicture:(UIImagePickerControllerSourceType)sourceType{
    //指定图片来源
    //    UIImagePickerControllerSourceType sourceType=UIImagePickerControllerSourceTypeCamera;
    //判断如果摄像机不能用图片来源与图片库
    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"不能使用相机" message:@"本地图片" delegate:self cancelButtonTitle:LOCALIZATION(@"dialog_ok") otherButtonTitles: nil];
            [alertView show];
            return;
        }
    }
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    //[[TabBarView sharedTabBarView] hideTabbar:YES animated:YES];
    [self presentViewController:picker animated:YES completion:^{}];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    
    if (_btnChoose == 11) {//录制视频
        _videoURL = info[UIImagePickerControllerMediaURL];
        _hasVideo = YES;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self convertVideo];
            _btnChoose = 0;
        }];
    }else{
        UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
        [picker dismissViewControllerAnimated:YES completion:^{
            
            imgUploadModel * imageModel = [[imgUploadModel alloc] init];
            UIImage *newImage = [image imageByScalingOrgSize:CGSIZE_SCALE_MAX];
            NSData * aData = UIImageJPEGRepresentation(newImage, 1);
            imageModel.imageName = [NSString stringWithFormat:@"%@.jpg",[UUID createUUID]];
            imageModel.imageData = aData;
            
//            NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UUID createUUID],@"fid",[NSNumber numberWithFloat:aData.length/1024],@"length",imageModel,@"fileData",@"image",@"type",nil];
            
            [_feed.attach_array addObject:imageModel];
            
            [self inputIntroduce];
        }];
        // 发送图片
        //    [self sureUpload:image withType:SEND_Type_photo];
    }
    
}


#pragma mark - 压缩刚拍摄的视频
- (void)convertVideo
{
    if (!_hasVideo)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                         message:@"Please record a video first"
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:_videoURL options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:_mp4Quality])
        
    {
//        _alert = [[UIAlertView alloc] init];
//        [_alert setTitle:@"Waiting.."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(_alert.frame),
                                    CGRectGetHeight(_alert.frame));
        [_alert addSubview:activity];
        [activity startAnimating];
//        [_alert show];
        
        hud = [SNTools returnMBProgressWithText:@"正在压缩..." addToView:self.view];
        
        _startDate = [NSDate date];
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:_mp4Quality];
        NSDateFormatter* formater = [[NSDateFormatter alloc] init];
        [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        _mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]];
        
        exportSession.outputURL = [NSURL fileURLWithPath: _mp4Path];
        exportSession.shouldOptimizeForNetworkUse = _networkOpt;
        exportSession.outputFileType = AVFileTypeMPEG4;
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed:
                {
                    [_alert dismissWithClickedButtonIndex:0 animated:NO];
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:[[exportSession error] localizedDescription]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
                    [alert show];
                    break;
                }
                    
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"Export canceled");
                    [_alert dismissWithClickedButtonIndex:0
                                                 animated:YES];
                    break;
                case AVAssetExportSessionStatusCompleted:
                    NSLog(@"Successful!");
                    [self performSelectorOnMainThread:@selector(convertFinish) withObject:nil waitUntilDone:NO];
                    break;
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"AVAsset doesn't support mp4 quality"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}






//压缩完成
- (void) convertFinish
{
//    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    [hud hide:YES];

    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    _alert = [[UIAlertView alloc] initWithTitle:@"干的漂亮"
                                        message:[NSString stringWithFormat:@"压缩成功 消耗%.2f秒 路径 :%@ ", duration,_mp4Path]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
    
    NSLog(@"压缩文件输出路径 :%@",_mp4Path);
    
    
   // [_alert show];
    
    _hasMp4 = YES;
    

    NSMutableData * data = [NSMutableData dataWithContentsOfFile:_mp4Path];
    
    VideoUploadModel * model = [[VideoUploadModel alloc] init];
    model.fileData = data;
    model.filePath = _mp4Path;
    
//     NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[UUID createUUID],@"fid",[NSNumber numberWithFloat:data.length/1024],@"length",model,@"fileData",@"video",@"type",nil];
    
    [_feed.attach_array addObject:model];
    
    [self inputIntroduce];
}




- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-tableviewdelegateAndDatesource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10 + _feed.attach_array.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < _feed.attach_array.count)
    {
        NSDictionary * dic = [_feed.attach_array objectAtIndex:indexPath.row];
        
        static NSString * cell1 = @"cell1";
        CreateMedicalFilesCell * cell = [tableView dequeueReusableCellWithIdentifier:cell1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"CreateMedicalFilesCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        
        id object = [_feed.attach_array objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[NSDictionary class]])///语音
        {
            NSDictionary * aDic = (NSDictionary *)object;
            
            if ([aDic objectForKey:@"fileurl"])
            {
                NSString * url = [aDic objectForKey:@"fileurl"];
                if([SNTools judgeFileSuffixVoice:url])///声音
                {
                    cell.voiceIcon.frame = CGRectMake(38,25, 20,33/27*20);
                    cell.voiceIcon.image = [UIImage imageNamed:@"voice_L0.png"];
                    cell.Files_imageView.frame = CGRectMake(30,20, 60, 30);
                    [cell.Files_imageView setImage:[UIImage imageNamed:@"task_voice"]];
                    
                    cell.content_textView.text = [NSString _859ToUTF8:[aDic objectForKey:@"filename"]];
                    cell.filesSize_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
                    
                }else if ([SNTools judgeFileSuffixImage:url])
                {
                    [cell.Files_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[aDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
                    
                    cell.content_textView.text = [NSString _859ToUTF8:[aDic objectForKey:@"filename"]];
                    cell.filesSize_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
                    
                }else///视频
                {
                    [cell.Files_imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[aDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
                    cell.content_textView.text = [NSString _859ToUTF8:[aDic objectForKey:@"filename"]];
                    cell.filesSize_label.text = [NSString stringWithFormat:@"%.2f k",[[aDic objectForKey:@"filesize"] intValue]/1024.00];
                }
                
            }else
            {
                cell.voiceIcon.frame = CGRectMake(38, 25, 20,33/27*20);
                cell.voiceIcon.image = [UIImage imageNamed:@"voice_L0.png"];
                cell.Files_imageView.frame = CGRectMake(30,20, 60, 30);
                [cell.Files_imageView setImage:[UIImage imageNamed:@"task_voice"]];
                
                cell.content_textView.text = [(NSMutableDictionary *)object objectForKey:@"content"];
                cell.filesSize_label.text = [NSString stringWithFormat:@"%@ k",[(NSMutableDictionary *)object objectForKey:@"length"]];
            }
            
        }else if ([object isKindOfClass:[imgUploadModel class]])///图片
        {
            imgUploadModel * model = (imgUploadModel*)object;
            UIImage * image = [UIImage imageWithData:model.imageData];
            
            cell.Files_imageView.image = image;
            
            cell.content_textView.text = model.imageName;
            cell.filesSize_label.text = [NSString stringWithFormat:@"%d k",model.imageData.length/1024];
            
        }else if ([object isKindOfClass:[VideoUploadModel class]])///视频
        {
            cell.Files_imageView.image = [UIImage imageNamed:@"guke_type_btn_zhantie_press"];
            
            cell.content_textView.text = ((VideoUploadModel *)object).fileName;
            cell.filesSize_label.text = [NSString stringWithFormat:@"%d k",((VideoUploadModel *)object).fileData.length/1024];
        }
        
        return cell;
        
    }else if (indexPath.row == 6+_feed.attach_array.count)
    {
        static NSString * identifier = @"identifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
//        if (!treatment_case)
//        {
//            treatment_case = [[UITextView alloc] initWithFrame:CGRectMake(10,5,DEVICE_WIDTH-20,60)];
//            treatment_case.tag = 100 + indexPath.row;
//            treatment_case.text = _feed.fangan;
//            treatment_case.textAlignment = NSTextAlignmentLeft;
//            treatment_case.layer.cornerRadius = 5;
//            treatment_case.font = [UIFont systemFontOfSize:15];
//            treatment_case.delegate = self;
//            treatment_case.layer.masksToBounds = YES;
//            treatment_case.layer.borderColor = [UIColor grayColor].CGColor;
//            treatment_case.layer.borderWidth = 0.5;
//            [cell.contentView addSubview:treatment_case];
//            
//            
//            placeHolder_treatment_case = [[UILabel alloc] initWithFrame:CGRectMake(10,5,200,20)];
//            placeHolder_treatment_case.text = @"治疗方案";
//            placeHolder_treatment_case.font = [UIFont systemFontOfSize:15];
//            placeHolder_treatment_case.textAlignment = NSTextAlignmentLeft;
//            placeHolder_treatment_case.textColor = [UIColor blackColor];
//            [treatment_case addSubview:placeHolder_treatment_case];
//        }
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        
        UITextView * textView = [textView_array objectAtIndex:indexPath.row - _feed.attach_array.count];
        textView.frame = CGRectMake(10,5,DEVICE_WIDTH-20,60);
        textView.layer.masksToBounds = YES;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.borderWidth = 0.5;
        
        if (!placeHolder_treatment_case)
        {
            placeHolder_treatment_case = [[UILabel alloc] initWithFrame:CGRectMake(10,5,200,20)];
            placeHolder_treatment_case.text = @"治疗方案";
            placeHolder_treatment_case.font = [UIFont systemFontOfSize:15];
            placeHolder_treatment_case.textAlignment = NSTextAlignmentLeft;
            placeHolder_treatment_case.textColor = [UIColor blackColor];
            [textView addSubview:placeHolder_treatment_case];
        }
        
        if (_feed.fangan.length)
        {
            textView.text = _feed.fangan;
            placeHolder_treatment_case.text = @"";
        }
        
        [cell.contentView addSubview:textView];
        
        
        return cell;
    }else
    {
        static NSString * identifier = @"cell";
        CreateMedicalCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (!cell)
        {
            cell = [[CreateMedicalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        
        for (UIView * view in cell.contentView.subviews)
        {
            if ([view isKindOfClass:[UITextView class]]) {
                [view removeFromSuperview];
            }
        }
        
        UITextView * textView = [textView_array objectAtIndex:indexPath.row - _feed.attach_array.count];
        [cell.contentView addSubview:textView];
        
        NSString * title = [content_array objectAtIndex:indexPath.row-_feed.attach_array.count];
        cell.title_label.text = title;
//        cell.input_textView.tag = indexPath.row + 100;
//        cell.input_textView.delegate = self;
        
        CGSize aSize = [title sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
        
        CGRect titleFrame = cell.title_label.frame;
        
        titleFrame.size.width = aSize.width;
        cell.title_label.frame = titleFrame;
        
        float input_widht = DEVICE_WIDTH - 20 - aSize.width -10;
        
        CGRect textViewFrame = CGRectMake(aSize.width+10,10,input_widht,25);
        textView.frame = textViewFrame;
        
        cell.input_line_view.frame = CGRectMake(aSize.width+10,textViewFrame.origin.y+textViewFrame.size.height+2.5,input_widht+5,4);
        
        switch (indexPath.row-_feed.attach_array.count)
        {
            case 0:///姓名
            {
                textView.text = _feed.psnname;
            }
                break;
            case 1:///性别
            {
                textView.text = _feed.sex;
            }
                break;
            case 2:///就诊时间
            {
                textView.text = _feed.jiuzhen;
            }
                break;
            case 3:///诊断
            {
                textView.text = _feed.zhenduan;
            }
                break;
            case 4:///病人手机号
            {
                textView.text = _feed.mobile;
            }
                break;
            case 5:///家属手机号
            {
                textView.text = _feed.relateMobile;
            }
                break;
            case 6:///治疗方案
            {
                textView.text = _feed.fangan;
            }
                break;
            case 7:///病历号
            {
                textView.text = _feed.binglihao;
            }
                break;
            case 8:///身份证号
            {
                textView.text = _feed.idno;
            }
                break;
            case 9:///标记编号
            {
                textView.text = _feed.bianma;
            }
                break;
                
            default:
                break;
        }
        
        return cell;
    }
    
    return nil;

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < _feed.attach_array.count)
    {
        return 80;
    }else if (indexPath.row == 6+_feed.attach_array.count)
    {
        return 90;
    }else
    {
        return 50;
    }

}

#pragma mark - CreateMedicalFileCellDelegate
#pragma mark - 删除操作
-(void)deleteFilesTap:(CreateMedicalFilesCell *)cell
{
    NSIndexPath * indexPath = [_mainTableView indexPathForCell:cell];
    
    if (indexPath.row < _feed.attach_array.count)
    {
        id object = [_feed.attach_array objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[NSDictionary class]])///语音
        {
            NSDictionary * aDic = (NSDictionary *)object;
            
            if ([aDic.allKeys containsObject:@"fileurl"])
            {
                
                [delete_array addObject:[aDic objectForKey:@"attachId"]];
            }
        }
        
        [_feed.attach_array removeObjectAtIndex:indexPath.row];
        [_mainTableView reloadData];
    }
    
}
#pragma mark - 查看文件操作
-(void)filesImageViewTap:(CreateMedicalFilesCell *)cell
{
    NSIndexPath * indexPath = [_mainTableView indexPathForCell:cell];
    
    if (indexPath.row < _feed.attach_array.count)
    {
        id object = [_feed.attach_array objectAtIndex:indexPath.row];
        
        if ([object isKindOfClass:[NSDictionary class]])///语音
        {
            NSDictionary * aDic = (NSDictionary *)object;
            
            if ([aDic objectForKey:@"fileurl"])
            {
                NSString * url = [aDic objectForKey:@"fileurl"];
                if([SNTools judgeFileSuffixVoice:url])///声音
                {
                    PlayerModel * model = [[PlayerModel alloc] init];
                    model.fileId = url;
                    [self playNetWorkVoiceWith:model WithCell:cell];
                    
                }else if ([SNTools judgeFileSuffixImage:url])
                {

                    [self playNetworkPhotoWith:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
                }else///视频
                {
                    [self playVideWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,url]];
                }
            }else///本地声音
            {
                [self playLocalVoiceWithPath:[(NSMutableDictionary *)object objectForKey:@"fileName"] WithCell:cell];
            }
        }else if ([object isKindOfClass:[imgUploadModel class]])///图片
        {
            imgUploadModel * model = (imgUploadModel*)object;
            UIImage * image = [UIImage imageWithData:model.imageData];
            
            [self playLoacalPhotoWithData:image];
            
        }else if ([object isKindOfClass:[VideoUploadModel class]])///视频
        {
            VideoUploadModel * model = (VideoUploadModel *)object;
            [self playButtonTappedWihtPath:model.filePath];
        }
    }
}

#pragma mark - 播放声音
///播放网络语音
-(void)playNetWorkVoiceWith:(PlayerModel *)model WithCell:(CreateMedicalFilesCell*)cell
{
    if (isAnimationVoice) {
        return;
    }
    
    NSLog(@"点击播放录音的按钮！");
    [self startVoicePlayWithCell:cell];
    
    __weak typeof(self)bself = self;
    
    voicePlayCenter = [[VoicePlayCenter alloc] init];
    voicePlayCenter.playDelegate = self;// 播放声音的代理方法
    [voicePlayCenter downloadPlayVoice:model];
    voicePlayCenter.block = ^()
    {
        [bself stopVocicePlayWithCell:cell];
    };
}
///播放本地语音
-(void)playLocalVoiceWithPath:(NSString *)path WithCell:(CreateMedicalFilesCell*)cell
{
    if (isAnimationVoice) {
        return;
    }
    
    [self startVoicePlayWithCell:cell];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    self.player = [[PlayVoice alloc] initWithData:data error:nil];
    self.player.delegate = self;
    self.player.aCell = cell;
    [self.player prepareToPlay];
    [self.player play];
    self.player.volume = 1;
}

#pragma mark player delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (player == self.player) {
        [self.player.aCell.voiceIcon stopAnimating];
    }
   self.player = nil;
}
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    if (player == self.player) {
        [self.player.aCell.voiceIcon stopAnimating];
    }
    self.player = nil;
}

#pragma mark - 查看图片
///查看本地图片
-(void)playLoacalPhotoWithData:(UIImage *)data
{
    [self TapImageClickWith:data];
}

///查看网络图片
-(void)playNetworkPhotoWith:(NSString *)imageUrl
{
    [self TapImageClickWith:imageUrl];
}

#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClickWith:(id)image_url
{
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    imgSaveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    
    if ([image_url isKindOfClass:[NSString class]])
    {
        [imgSaveView sd_setImageWithURL:[NSURL URLWithString:(NSString *)image_url]];
    }else
    {
        imgSaveView.image = (UIImage *)image_url;
    }
    
    
    imgSaveView.contentMode = UIViewContentModeScaleAspectFit;
    imgSaveView.userInteractionEnabled = YES;
    [background addSubview:imgSaveView];
    [self shakeToShow:imgSaveView];//放大过程中的动画
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suoxiao)];
    tap.numberOfTapsRequired = 1;
    [imgSaveView addGestureRecognizer:tap];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [imgSaveView addGestureRecognizer:longPressGestureRecognizer];
    
    [self.view.window.rootViewController.view addSubview:background];
}

-(void)suoxiao
{
    [background removeFromSuperview];
}

-(void)gestureRecognizerHandle:(UILongPressGestureRecognizer *)_longpress
{
    if (_longpress.state == UIGestureRecognizerStateCancelled) {
        return;
    }
    [self handleLongTouch];
    
}

//*************放大过程中出现的缓慢动画*************
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)handleLongTouch {
    UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存图片", nil];
    sheet.cancelButtonIndex = sheet.numberOfButtons - 1;
    [sheet showInView:background];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.numberOfButtons - 1 == buttonIndex) {
        return;
    }
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"保存图片"]) {
        UIImageWriteToSavedPhotosAlbum(imgSaveView.image, nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
}



#pragma mark - 播放视频
///播放本地视频
-(void)playButtonTappedWihtPath:(NSString *)path
{
    NSURL *url = [NSURL fileURLWithPath:path];
    //视频播放对象
    MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:url];
    //        //弹出播放器
    [self presentMoviePlayerViewControllerAnimated:movieVc];
}

///播放网络视频
-(void)playVideWithString:(NSString *)thestrUrl{
    NSLog(@"url --------   %@",thestrUrl);
    NSURL *videoUrl=[NSURL URLWithString:thestrUrl];
    MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
    //弹出播放器
    [self presentMoviePlayerViewControllerAnimated:movieVc];
}



#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


#pragma mark - UITextViewDelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //碰到换行，键盘消失
    if ([@"\n" isEqualToString:text] == YES)
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    if (textView.tag == 106) {
        if (textView.text.length > 0)
        {
            placeHolder_treatment_case.text = @"";
        }else
        {
            placeHolder_treatment_case.text = @"治疗方案";
        }
    }
    
    if (textView.tag == 1000) {
        if (textView.text.length > 0) {
            placeHolder_shuoming.text = @"";
        }else
        {
            placeHolder_shuoming.text = @"病历说明";
        }
    }
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView
{
    
    if (textView.tag == 1000)///病例说明
    {
        _feed.memo = textView.text;
        
        return;
    }
    
    switch (textView.tag-100) {
        case 0:///姓名
        {
            _feed.psnname = textView.text;
        }
            break;
        case 1:///性别
        {
            _feed.sex = textView.text;
        }
            break;
        case 2:///就诊时间
        {
            _feed.jiuzhen = textView.text;
        }
            break;
        case 3:///诊断
        {
            _feed.zhenduan = textView.text;
        }
            break;
        case 4:///病人手机号
        {
            _feed.mobile = textView.text;
        }
            break;
        case 5:///家属手机号
        {
            _feed.relateMobile = textView.text;
        }
            break;
        case 6:///治疗方案
        {
            _feed.fangan = textView.text;
        }
            break;
        case 7:///病历号
        {
            _feed.binglihao = textView.text;
        }
            break;
        case 8:///身份证号
        {
            _feed.idno = textView.text;
        }
            break;
        case 9:///标记编号
        {
            _feed.bianma = textView.text;
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 播放录音动画
// 开始播放背景（动画）
-(void)startVoicePlayWithCell:(CreateMedicalFilesCell*)cell
{
    
    cell.voiceIcon.animationImages = _voiceLeftImageArr;
    cell.voiceIcon.animationDuration = 1;
    isAnimationVoice = YES;
    [cell.voiceIcon startAnimating];
}

// 停止播放背景
-(void)stopVocicePlayWithCell:(CreateMedicalFilesCell*)cell
{
    isAnimationVoice = NO;
    [cell.voiceIcon stopAnimating];
    cell.voiceIcon.image = [UIImage imageNamed:@"voice_L0.png"];
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"uploadData" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
