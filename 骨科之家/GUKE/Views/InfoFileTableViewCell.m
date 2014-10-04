//
//  InfoFileTableViewCell.m
//  GUKE
//
//  Created by ianMac on 14-9-25.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "InfoFileTableViewCell.h"
#import "Interface.h"
#import "UIImageView+WebCache.h"
@implementation InfoFileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier thebloc:(InfoFileTableViewCellBloc)habloc{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    _mybloc=habloc;

    if (self) {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    _imgFileImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    _videoFileImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _imageVoiceIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    
    _fileTypeName = [[UILabel alloc] initWithFrame:CGRectZero];
    _fileSize = [[UILabel alloc] initWithFrame:CGRectZero];

    [_imageVoiceIcon addSubview:voiceImageView];
    
    [self.contentView addSubview:_imgFileImage];
    [self.contentView addSubview:_videoFileImage];
    [self.contentView addSubview:_fileTypeName];
    [self.contentView addSubview:_fileSize];
    [self.contentView addSubview:_imageVoiceIcon];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _fileTypeName.frame = CGRectMake(120, 10,150, 15);
    _fileTypeName.backgroundColor = [UIColor whiteColor];
    _fileTypeName.font = [UIFont systemFontOfSize:14.0f];
    _fileTypeName.textAlignment = NSTextAlignmentLeft;
    
    _fileSize.frame = CGRectMake(120, 40, 80, 15);
    _fileSize.backgroundColor = [UIColor whiteColor];
    _fileSize.font = [UIFont systemFontOfSize:14.0f];
    _fileSize.text = [NSString stringWithFormat:@"%.2fK",[((NSString *)[self.fileDic objectForKey:@"filesize"]) floatValue]/1024.0];
    _fileSize.textAlignment = NSTextAlignmentLeft;
    
//
    if ([self judgeFileSuffixVoice]) {
        _fileTypeName.text = [NSString _859ToUTF8:[self.fileDic objectForKey:@"filename"]];
        voiceImageView.frame = CGRectMake(8, 5, 20, 33/27*20);
        voiceImageView.image = [UIImage imageNamed:@"voice_L0.png"];
        _voiceLeftImageArr = [[NSArray alloc] initWithObjects:
                              [UIImage imageNamed:@"voice_L1.png"],
                              [UIImage imageNamed:@"voice_L2.png"],
                              [UIImage imageNamed:@"voice_L3.png"],nil];
        _imageVoiceIcon.frame = CGRectMake(30, 22.5, 60, 30);
        [_imageVoiceIcon setBackgroundImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"task_voice@2x" ofType:@"png"]] forState:UIControlStateNormal];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(VoiceTouchUpInside)];
        tap.numberOfTapsRequired = 1;
        [_imageVoiceIcon addGestureRecognizer:tap];
    }else if ([self judgeFileSuffixImage]){
        _fileTypeName.text = [NSString _859ToUTF8:[self.fileDic objectForKey:@"filename"]];
        _imgFileImage.frame = CGRectMake(30, 5, 60, 60);
        _imgFileImage.userInteractionEnabled = YES;
        _imgFileImage.contentMode = UIViewContentModeScaleAspectFit;
        [_imgFileImage sd_setImageWithURL:[NSURL URLWithString: [IMAGE_BASE_URL stringByAppendingString:[self.fileDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading.png"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageBigClick)];
        tap.numberOfTapsRequired = 1;
        [_imgFileImage addGestureRecognizer:tap];
    }else{
        _fileTypeName.text = [NSString _859ToUTF8:[self.fileDic objectForKey:@"filename"]];
        _videoFileImage.frame = CGRectMake(30, 5, 60, 60);
        _videoFileImage.userInteractionEnabled = YES;
        _videoFileImage.contentMode = UIViewContentModeScaleAspectFit;
        [_videoFileImage sd_setImageWithURL:[NSURL URLWithString: [IMAGE_BASE_URL stringByAppendingString:[self.fileDic objectForKey:@"previewurl"]]] placeholderImage:[UIImage imageNamed:@"guke_image_loading.png"]];
        UIButton *playVideoImg = [UIButton buttonWithType:UIButtonTypeCustom];
        playVideoImg.frame = CGRectMake(0, 0, 60, 60);
        playVideoImg.backgroundColor = [UIColor clearColor];
        [playVideoImg setImage:[UIImage imageNamed:@"guke_ic_playvideo.png"] forState:UIControlStateNormal];
        playVideoImg.imageEdgeInsets = UIEdgeInsetsMake(30/2,30/2,30/2,30/2);
        [_videoFileImage addSubview:playVideoImg];
        [playVideoImg addTarget:self action:@selector(playVideoClick) forControlEvents:UIControlEventTouchUpInside];
    }

}

// 播放视频
-(void)setInfoFileTableViewCellBloc:(InfoFileTableViewCellBloc)thebloc{
    
    
    

    _mybloc=thebloc;

}


- (void)playVideoClick
{
    
    
   
    NSLog(@"播放视频withdic====%@",self.fileDic);
    
    
    
    
    
    NSString *thestr=[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,[self.fileDic objectForKey:@"fileurl"]] ;
    
    
    NSLog(@"url==%@",thestr);
//    _mybloc(thestr);
    
    [self.delegate playVideWithString:thestr];
    

    
    
}




// 查看图片
- (void)imageBigClick
{
    [self TapImageClick];
}


// 播放音频
- (void)VoiceTouchUpInside
{
    NSLog(@"点击播放录音的按钮！");
    [self startVoicePlaybalck];
    
    NSString *content = [self.fileDic objectForKey:@"fileurl"];
    voicePlayCenter = [[VoicePlayCenter alloc] init];
    voicePlayCenter.playDelegate = self;// 播放声音的代理方法
    PlayerModel *model = [[PlayerModel alloc] init];
    model.fileId = content;
    [voicePlayCenter downloadPlayVoice:[model autorelease]];
    _imageVoiceIcon.userInteractionEnabled = NO;
    voicePlayCenter.block = ^(){
        [self stopVocicePlaybalck];
        _imageVoiceIcon.userInteractionEnabled = YES;
    };
}

// 开始播放背景（动画）
-(void)startVoicePlaybalck{
    
    voiceImageView.animationImages = _voiceLeftImageArr;
    voiceImageView.animationDuration = 1;
    isAnimationVoice = YES;
    [voiceImageView startAnimating];
}

// 停止播放背景
-(void)stopVocicePlaybalck{
    isAnimationVoice = NO;
    [voiceImageView stopAnimating];
    voiceImageView.image = [UIImage imageNamed:@"voice_L0.png"];
}


// 判断文件的后缀名是否是图片文件
- (BOOL)judgeFileSuffixImage
{
    if ([[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"jpg"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"JPG"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"png"] || [[[self.fileDic objectForKey:@"fileurl"]pathExtension]isEqualToString:@"PNG"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"gif"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"GIF"]) {
        return YES;
    }else{
        return NO;
    }
}

// 判断文件的后缀名是否是声音文件
- (BOOL)judgeFileSuffixVoice
{
    if ([[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"amr"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"wma"] || [[[self.fileDic objectForKey:@"fileurl"] pathExtension]isEqualToString:@"mp3"]){
        return YES;
    }else{
        return NO;
    }
}


#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClick
{
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    imgSaveView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [imgSaveView sd_setImageWithURL:[NSURL URLWithString:[IMAGE_BASE_URL stringByAppendingString:[self.fileDic objectForKey:@"fileurl"]]]];
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
    
    [self.window.rootViewController.view addSubview:background];
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
