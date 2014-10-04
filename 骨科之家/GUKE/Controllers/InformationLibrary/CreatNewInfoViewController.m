//
//  CreatNewInfoViewController.m
//  GUKE
//  新建资料库页面
//  Created by ianMac on 14-9-24.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CreatNewInfoViewController.h"
#import "BlockButton.h"
#import "MyLabel.h"
#import "imgUploadModel.h"
#import "UIImage+UIImageScale.h"
#import "SolveReasonCell.h"
#import "interface.h"

@interface CreatNewInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    // 标题视图
    UIView *_titleView;
    UITextField *_titleField;
    // 附件视图
    UIView *_fileView;
    
    // 附件列表视图
    UITableView *_tableView;
    NSMutableArray *_dataArray;// 数据源
    UIImagePickerController *shareImagePicker;// 图片的Picker
    
    UIView *bgView;
    
    // 文本内容视图
    UITextView *_AddContentView;
    
    
    
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
    
    
    NSString * _videoDuration;//视频持续时间
    NSString *_videoSize;//视频文件大小
    
    
}
// 自定义导航栏
- (void)loadNavigation;
// 标题视图
- (void)loadTitleView;
// 附件视图
- (void)loadFileView;
// "附件"的列表
- (void)loadFileTableView;
// 文本内容视图
- (void)loadAddContentView;

@end

@implementation CreatNewInfoViewController

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
    
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadNavigation];
    [self loadTitleView];
    [self loadFileView];
    [self loadFileTableView];
    [self loadAddContentView];
    
    
    
    _networkOpt = YES;
    
    
    _qualityType = UIImagePickerControllerQualityTypeLow;
    _mp4Quality = AVAssetExportPresetLowQuality;
    _hasVideo = NO;
    _hasMp4 = NO;
    
    _btnChoose = 0;
    
    
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
    loginLabel.text = @"资料库";
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

}
// 标题视图
- (void)loadTitleView
{
    _titleView = [[UIView alloc] init];
    _titleView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    _titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_titleView];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.frame = CGRectMake(10, 10, 40, 30);
    titleLabel.backgroundColor = [UIColor whiteColor];
    titleLabel.text = @"标题: ";
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [_titleView addSubview:titleLabel];
    
    _titleField = [[UITextField alloc] init];
    _titleField.frame = CGRectMake(60, 10, SCREEN_WIDTH-60-10, 30);
    _titleField.backgroundColor = [UIColor whiteColor];
    _titleField.font = [UIFont systemFontOfSize:13.5f];
    [_titleView addSubview:_titleField];
    
    UIImageView *line = [[UIImageView alloc] init];
    line.frame = CGRectMake(60-1, _titleField.frame.origin.y+_titleField.frame.size.height-10, SCREEN_WIDTH-60-10+2, 5);
    line.backgroundColor = [UIColor clearColor];
    line.image = [UIImage imageNamed:@"guke_searchbglinered.png"];
    [_titleView addSubview:line];
}

- (void)loadFileView
{
    _fileView = [[UIView alloc] init];
    _fileView.frame = CGRectMake(0, _titleView.frame.origin.y+_titleView.frame.size.height, SCREEN_WIDTH, 40);
    
    [self.view addSubview:_fileView];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, 200, 40);
    label.text = @"附件: （图片、语音)";
    [_fileView addSubview:label];
    
    BlockButton *btn = [[BlockButton alloc] init];
    btn.frame = CGRectMake(170, 5, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"task_attach"] forState:UIControlStateNormal];
    btn.block = ^(BlockButton *btn){
        
        NSLog(@"上传文件");
        [self setICON];
    };
    
    [_fileView addSubview:btn];
}

- (void)loadFileTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.alwaysBounceVertical = NO;
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.view addSubview:_tableView];
}

- (void)loadAddContentView
{
    _AddContentView = [[UITextView alloc] init];
    _AddContentView.frame = CGRectMake(5, _tableView.frame.origin.y+_tableView.frame.size.height, 310, 100);
    _AddContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    _AddContentView.font = [UIFont systemFontOfSize:14.0f];
    
    // 画边框
    _AddContentView.layer.borderColor = [UIColor grayColor].CGColor;
    _AddContentView.layer.borderWidth =1.0;
    _AddContentView.layer.cornerRadius =5.0;
    
    [self.view addSubview:_AddContentView];
    
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tableViewGesture];
}

- (void)commentTableViewTouchInSide{
    // 动画
    [UIView beginAnimations:nil context:nil];
    // 设置动画的执行时间
    [UIView setAnimationDuration:0.35];
    
    [_AddContentView resignFirstResponder];
    //_DetailsView.frame = CGRectMake(0, 64, 320, 250);
    
    //    _SolveReasonView.center = SolvePoint;
    
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, _ConfirmBtn.frame.origin.y+_ConfirmBtn.frame.size.height);
    // 尾部
    [UIView commitAnimations];
    
}  


// 手势事件
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

// "提交"的点击事件
- (void)btnClick
{
    NSLog(@"点击提交按钮");
    NSDictionary *parameters = @{@"userId":GET_USER_ID,@"sid":GET_S_ID,@"infoId":@"0",@"title":[NSString stringWithFormat:@"%@",_titleField.text],@"content":[NSString stringWithFormat:@"%@",_AddContentView.text]};
    
    [AFRequestService responseDataWithImage:@"infonew.php" andparameters:parameters andDataArray:_dataArray andfieldType:@"attach1" andfileName:@"attach1.jpg" andResponseData:^(NSData *responseData){
        NSDictionary *dict =(NSDictionary *)responseData;
        NSString *list = [dict objectForKey:@"code"];
        if ([list intValue] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            // 显示
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            // 显示
            [alert show];
        }
        
    }];
}

- (void)setICON
{
    bgView = [[UIView alloc] init];
    bgView.frame = self.view.window.bounds;
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [self.view.window addSubview:bgView];
    
    UIView *sendView = [[UIView alloc] init];
    sendView.frame = CGRectMake(SCREEN_WIDTH/2-200/2, SCREEN_HEIGHT/2-205/2-20, 200, 290);
    sendView.backgroundColor = [UIColor whiteColor];
    sendView.clipsToBounds = YES;
    sendView.layer.cornerRadius = 5.0f;
    [bgView addSubview:sendView];
    
    MyLabel *titile = [[MyLabel alloc] init];
    titile.frame = CGRectMake(0, 0, sendView.frame.size.width, 45);
    titile.backgroundColor = [UIColor blackColor];
    titile.text = @"发送文件";
    titile.textAlignment = NSTextAlignmentLeft;
    titile.textColor = [UIColor whiteColor];
    titile.font = [UIFont systemFontOfSize:18.0f];
    [sendView addSubview:titile];
    
    BlockButton *savePhoto = [[BlockButton alloc] init];
    savePhoto.frame = CGRectMake(0, titile.frame.origin.y+titile.frame.size.height, sendView.frame.size.width, 40);
    savePhoto.backgroundColor = [UIColor clearColor];
    [savePhoto setTitle:@"图片库" forState:UIControlStateNormal];
    [savePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [savePhoto setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    savePhoto.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    savePhoto.block = ^(BlockButton *btn){
        NSLog(@"选择图片库");
        [self setIcon:1];
        [bgView removeFromSuperview];
    };
    [sendView addSubview:savePhoto];
    
    UIView *line1 = [[UIView alloc] init];
    line1.frame = CGRectMake(0, savePhoto.frame.origin.y+savePhoto.frame.size.height, sendView.frame.size.width, 0.5);
    line1.backgroundColor = [UIColor grayColor];
    [sendView addSubview:line1];
    
    BlockButton *takePhoto = [[BlockButton alloc] init];
    takePhoto.frame = CGRectMake(0, line1.frame.origin.y+line1.frame.size.height, sendView.frame.size.width, 40);
    takePhoto.backgroundColor = [UIColor clearColor];
    [takePhoto setTitle:@"拍照" forState:UIControlStateNormal];
    [takePhoto setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [takePhoto setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    takePhoto.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    takePhoto.block = ^(BlockButton *btn){
        NSLog(@"点击拍照");
        [self setIcon:0];
        [bgView removeFromSuperview];
    };
    [sendView addSubview:takePhoto];
    
    
    UIView *line2 = [[UIView alloc] init];
    line2.frame = CGRectMake(0, takePhoto.frame.origin.y+takePhoto.frame.size.height, sendView.frame.size.width, 0.5);
    line2.backgroundColor = [UIColor grayColor];
    [sendView addSubview:line2];
    
    
#pragma mark - gm start
    
    //拍视频
    BlockButton *takeVieo = [[BlockButton alloc] init];
    takeVieo.frame = CGRectMake(0, line2.frame.origin.y+line2.frame.size.height, sendView.frame.size.width, 40);
    takeVieo.backgroundColor = [UIColor clearColor];
    [takeVieo setTitle:@"拍摄视频" forState:UIControlStateNormal];
    [takeVieo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [takeVieo setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    takeVieo.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    takeVieo.block = ^(BlockButton *btn){
        NSLog(@"点击拍摄视频");
        [self createVideo];
        [bgView removeFromSuperview];
    };
    [sendView addSubview:takeVieo];
    
    UIView *line3 = [[UIView alloc] init];
    line3.frame = CGRectMake(0, takeVieo.frame.origin.y+takeVieo.frame.size.height, sendView.frame.size.width, 0.5);
    line3.backgroundColor = [UIColor grayColor];
    [sendView addSubview:line3];
    
    
    //选择视频
    BlockButton *chooseVieo = [[BlockButton alloc] init];
    chooseVieo.frame = CGRectMake(0, line3.frame.origin.y+line3.frame.size.height, sendView.frame.size.width, 40);
    chooseVieo.backgroundColor = [UIColor clearColor];
    [chooseVieo setTitle:@"选择视频" forState:UIControlStateNormal];
    [chooseVieo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [chooseVieo setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    chooseVieo.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    chooseVieo.block = ^(BlockButton *btn){
        NSLog(@"点击选择视频");
        [self chooseVideo];
        [bgView removeFromSuperview];
    };
    [sendView addSubview:chooseVieo];
    
    UIView *line4 = [[UIView alloc] init];
    line4.frame = CGRectMake(0, chooseVieo.frame.origin.y+chooseVieo.frame.size.height, sendView.frame.size.width, 0.5);
    line4.backgroundColor = [UIColor grayColor];
    [sendView addSubview:line4];
#pragma mark - gm end
    
    UILabel *voiceLabel = [[UILabel alloc] init];
    voiceLabel.frame = CGRectMake(0, line4.frame.origin.y+line4.frame.size.height, sendView.frame.size.width, 40);
    voiceLabel.backgroundColor = [UIColor clearColor];
    voiceLabel.text = @"按住说话";
    voiceLabel.userInteractionEnabled = YES;
    voiceLabel.textAlignment = NSTextAlignmentCenter;
    voiceLabel.font = [UIFont systemFontOfSize:15.0f];
    voiceLabel.textColor = [UIColor blackColor];
    [sendView addSubview:voiceLabel];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.1;
    [voiceLabel addGestureRecognizer:longPressGestureRecognizer];
    
    UIView *line5 = [[UIView alloc] init];
    line5.frame = CGRectMake(0, voiceLabel.frame.origin.y+voiceLabel.frame.size.height, sendView.frame.size.width, 0.5);
    line5.backgroundColor = [UIColor grayColor];
    [sendView addSubview:line5];
    
    BlockButton *cancel = [[BlockButton alloc] init];
    cancel.frame = CGRectMake(0, line5.frame.origin.y+line5.frame.size.height, sendView.frame.size.width, 40);
    cancel.backgroundColor = [UIColor clearColor];
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancel setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    cancel.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    cancel.block = ^(BlockButton *btn){
        NSLog(@"取消");
        [bgView removeFromSuperview];
    };
    
    [sendView addSubview:cancel];
}

#pragma mark - 选择视频 拍摄视频点击方法 start
-(void)chooseVideo{
    _btnChoose = 10;//选择视频
    if (_hasVideo)
    {
        _mp4Path = nil;
        _videoURL = nil;
        _startDate = nil;
        
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    //    NSArray *array = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    //    picker.mediaTypes = array;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    picker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)createVideo{
    _btnChoose = 11;//拍摄视频
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



#pragma mark - 选择视频 拍摄视频点击方法 end


- (void)gestureRecognizerHandle:(id)sender
{
    UILongPressGestureRecognizer *tap = (UILongPressGestureRecognizer *)sender;
    if (tap.state == UIGestureRecognizerStateBegan) {
        [self recordStartQiDi];
        bgView.hidden = YES;
    }
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        [self recordEndQiDi];
        [bgView removeFromSuperview];
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

#pragma mark ---------record delegate
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString *)_fileName withVoiceLenth:(CGFloat)length{
    int a =(int) length;
    if (a > 0) {
        [self wavToAmr:_filePath with:_fileName length:length];
    }
}
-(void)wavToAmr:(NSString *)_filePath  with:(NSString *)_fileName length:(CGFloat)length{
    [VoiceConverter wavToAmr:_filePath amrSavePath:[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_fileName,@"fid",[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"],@"fileName",[NSNumber numberWithInt:(int)length],@"length", nil];
    [_dataArray addObject:dic];
    
    if (SCREEN_HEIGHT<568) {
        if (_dataArray.count*50<210) {
            _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, _dataArray.count*50);
        }else{
            _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, 210);
        }
    }else{
        if (_dataArray.count*50<300) {
            _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, _dataArray.count*50);
        }else{
            _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, 210+88);
        }
    }
    
    
    _AddContentView.frame = CGRectMake(5, _tableView.frame.origin.y+_tableView.frame.size.height+2, 310, 100);
    [_tableView reloadData];
    [self tableViewSlide];
 
}

#pragma mark -- 拍照与图片库 --

- (void)setIcon:(NSUInteger)index
{
    UIImagePickerControllerSourceType soursceType;
    if (index == 0) {
        BOOL isCamera = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
        if (!isCamera) {
            return;
        }
        soursceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (index == 1){
        soursceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (index == 2){
        return;
    }
    
    shareImagePicker = [[UIImagePickerController alloc]init];
    shareImagePicker.sourceType = soursceType;
    shareImagePicker.delegate = self;
    [self presentViewController:shareImagePicker animated:YES completion:nil];
    
}
#pragma mark ====== UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if (_btnChoose == 10) {//选择视频
        _videoURL = info[UIImagePickerControllerMediaURL];
        _hasVideo = YES;
        [picker dismissViewControllerAnimated:YES completion:^{
            [self convertVideo];
            _btnChoose = 0;
        }];
        
        
    }else if (_btnChoose == 11){//录制视频
        
        _videoURL = info[UIImagePickerControllerMediaURL];
        _hasVideo = YES;
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [self convertVideo];
            _btnChoose = 0;
        }];
        
    }else{
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *imgScale = img;
        NSData *imgData = UIImageJPEGRepresentation(img, 0.3);
        if (img.size.width>800) {
            imgScale = [img scaleToSize:CGSizeMake(800, img.size.height*(800.0/img.size.width))];
            imgData = UIImageJPEGRepresentation(imgScale, 0.3);
        }
        if([picker isEqual:shareImagePicker]){
            
            // 将图片数据名称和数据data保存为model对象保存到数组中去
            
            // 获取系统当前时间
            NSDate *senddate=[NSDate date];
            NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
            [dateformatter setDateFormat:@"YYYYMMddhhmmss"];
            NSString *locationString=[dateformatter stringFromDate:senddate];
            
            
            imgUploadModel *model = [[imgUploadModel alloc] init];
            model.imageName = [locationString stringByAppendingString:@".jpg"];
            model.imageData = imgData;
            [_dataArray addObject:model];
            if (SCREEN_HEIGHT<568) {
                if (_dataArray.count*50<210) {
                    _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, _dataArray.count*50);
                }else{
                    _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, 210);
                }
            }else{
                if (_dataArray.count*50<210+88) {
                    _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, _dataArray.count*50);
                }else{
                    _tableView.frame = CGRectMake(0, _fileView.frame.origin.y+_fileView.frame.size.height, SCREEN_WIDTH, 210+88);
                }
            }
            _AddContentView.frame = CGRectMake(5, _tableView.frame.origin.y+_tableView.frame.size.height+2, 310, 100);
            [_tableView reloadData];
            [self tableViewSlide];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
        _alert = [[UIAlertView alloc] init];
        [_alert setTitle:@"Waiting.."];
        
        UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activity.frame = CGRectMake(140,
                                    80,
                                    CGRectGetWidth(_alert.frame),
                                    CGRectGetHeight(_alert.frame));
        [_alert addSubview:activity];
        [activity startAnimating];
        [_alert show];
        
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






#pragma mark - 压缩完成
- (void) convertFinish
{
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    CGFloat duration = [[NSDate date] timeIntervalSinceDate:_startDate];
    _alert = [[UIAlertView alloc] initWithTitle:@"干的漂亮"
                                        message:[NSString stringWithFormat:@"压缩成功 消耗%.2f秒 路径 :%@ ", duration,_mp4Path]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles: nil];
    
    NSLog(@"压缩文件输出路径 :%@",_mp4Path);
    
    
    [_alert show];
    
    
    _videoDuration = [NSString stringWithFormat:@"%.2f s", duration];
    _videoSize = [NSString stringWithFormat:@"%d kb", [self getFileSize:_mp4Path]];
    _hasMp4 = YES;
    
}

#pragma mark - 计算视频压缩文件大小
- (NSInteger) getFileSize:(NSString*) path
{
    NSFileManager * filemanager = [NSFileManager defaultManager];
    if([filemanager fileExistsAtPath:path]){
        NSDictionary * attributes = [filemanager attributesOfItemAtPath:path error:nil];
        NSNumber *theFileSize;
        if ( (theFileSize = [attributes objectForKey:NSFileSize]) )
            return  [theFileSize intValue]/1024;
        else
            return -1;
    }
    else
    {
        return -1;
    }
}






- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = [NSString stringWithFormat:@"FileCell%d%d",indexPath.section,indexPath.row];
    SolveReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SolveReasonCell" owner:self options:nil]lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    id object = [_dataArray objectAtIndex:indexPath.row];
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        cell.videoImage.image = [UIImage imageNamed:@"icon_menu_volume.png"];
        NSDictionary *dic = (NSDictionary *)object;
        NSString *tempVoice = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fid"]];
        cell.videoName.text = [tempVoice stringByAppendingString:@".amr"];
    }else{
        cell.videoImage.image = [UIImage imageNamed:@"icon_word.png"];
        cell.videoName.text = [NSString stringWithFormat:@"%@",((imgUploadModel *)object).imageName];
    }
    return cell;
}

// tableView滑到最后一行
- (void)tableViewSlide
{
    if (_tableView.contentSize.height > _tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableView.contentSize.height - _tableView.frame.size.height);
        [_tableView setContentOffset:offset animated:YES];
    }
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
