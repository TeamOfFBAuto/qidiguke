//
//  FriendContentView.m
//  UNITOA
//
//  Created by qidi on 14-8-7.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendContentView.h"
#define IMG_TAG 99999
@implementation FriendContentView
{
    int imgTag;
    NSMutableArray *_shareImageEnlarge;
    UIView *background;
    int imgTagSave;
}
- (void)dealloc
{
    _shareImageEnlarge= nil;
    background = nil;
    self.contact = nil;
    self.shareImg = nil;
    self.articleModel = nil;;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.borderWidth = 0;
        self.layer.borderColor = [[UIColor clearColor] CGColor];
        imgTag = IMG_TAG;
        _shareImageEnlarge = [[NSMutableArray alloc] init];
        // 说说内容
        _contact = [[UILabel alloc]initWithFrame:CGRectZero];
        _contact.font = [UIFont systemFontOfSize:13.5f];
        _contact.backgroundColor = [UIColor clearColor];
        _contact.userInteractionEnabled = YES;
        
        _contact.layer.borderWidth = 0;
        _contact.layer.borderColor = [[UIColor clearColor] CGColor];
        
        _shareComment = [[UILabel alloc]initWithFrame:CGRectZero];
        _shareComment.font = [UIFont systemFontOfSize:13.5f];
        _shareComment.backgroundColor = [UIColor clearColor];
        
        _shareComment.layer.borderWidth = 0;
        _shareComment.layer.borderColor = [[UIColor clearColor] CGColor];
        
        _shareContext = [[MyLabel alloc]initWithFrame:CGRectZero];
        _shareContext.font = [UIFont systemFontOfSize:13.5f];
        _shareContext.backgroundColor = [UIColor clearColor];
        
        _shareContext.layer.borderWidth = 0;
        _shareContext.layer.borderColor = [[UIColor clearColor] CGColor];
        
        
        [_contact addSubview:_shareComment];
        [_contact addSubview:_shareContext];
        [self addSubview:_contact];
        
        _tempView = [[UIView alloc] initWithFrame:CGRectMake(52, 4, SCREEN_WIDTH, 2)];
        _tempView.backgroundColor = [UIColor whiteColor];
        [_contact addSubview:_tempView];
    }
    return self;
}
- (void)setArticleModel:(UserArticleList *)articleModel
{
    self.shareImg.image = nil;
    _articleModel = nil;
    _articleModel = articleModel;
    // 内容不是分享
    if ([_articleModel.isShare isEqualToString:ISNOT_SHARE_CODE]) {
        self.isShareLabel = NO;
        // 发表的内容
        [self.shareContext setText:_articleModel.context];
        self.shareContext.textColor = [UIColor blackColor];
        self.shareContext.backgroundColor = [UIColor clearColor];
        self.shareContext.userInteractionEnabled = NO;
         self.contact.userInteractionEnabled = NO;
    }
    // 是分享的来源
    else if([_articleModel.isShare isEqualToString:IS_SHARE_CODE]){
        self.isShareLabel = YES;
        NSString *shareUrl = @"";
        NSString *temp = [NSString stringWithFormat:@"%@",_articleModel.shareUrl];
        if (_articleModel.fromWeixin.length == 0 && temp.length >0) {
            NSError *error;
            NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSArray *arrayOfAllMatches = [regex matchesInString:temp options:0 range:NSMakeRange(0, [temp length])];
            
            for (NSTextCheckingResult *match in arrayOfAllMatches)
            {
                NSString* substringForMatch = [temp substringWithRange:match.range];
                shareUrl = [NSString stringWithFormat:@"%@",substringForMatch];
            }
        }
        else if([_articleModel.fromWeixin isEqualToString:SOURCE_FROME_CASE]){
            shareUrl = _articleModel.context;
        }
        else if ([_articleModel.fromWeixin isEqualToString:SOURCE_FROME_MATERIAL]){
            shareUrl = _articleModel.context;
        }
        self.shareComment.text = _articleModel.shareComment;
        [self.shareContext setText:shareUrl];
        self.shareContext.textAlignment = NSTextAlignmentLeft;
        self.shareContext.delegate = self;
        [self.shareContext setVerticalAlignment:VerticalAlignmentMiddle];
        self.shareContext.textColor = GETColor(149, 149, 149);
        self.shareContext.backgroundColor = GETColor(238, 238, 238);
        self.shareContext.userInteractionEnabled = YES;
    }
    else{
        return;
    }

}
// 跳转到
- (void)skipToCasePage:(UITapGestureRecognizer *)gester{
    NSLog(@"%d",gester.view.tag);
}
- (void)myLabel:(MyLabel *)myLabel touchesWtihTag:(NSInteger)tag {
    
    
    
    if (myLabel.text.length>4) {
        NSString *string = [myLabel.text substringWithRange:NSMakeRange(0, 4)];
        if ([string isEqualToString:@"http"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",myLabel.text]]];
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",myLabel.text]]];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 判断分享的链接
    if ([_articleModel.isShare isEqualToString:ISNOT_SHARE_CODE]) {
        // 发表的内容
        self.shareComment.frame =CGRectZero;
        self.shareContext.frame = CGRectMake(0, self.shareComment.frame.origin.y + self.shareComment.frame.size.height, 250,[SingleInstance customFontHeightFont:_articleModel.context andFontSize:15 andLineWidth:250]);
        self.contact.frame = CGRectMake(USER_ICON_WHDTH + 15, 5, 250,self.shareContext.frame.size.height + self.shareContext.frame.origin.y);
       

    }
    else if([_articleModel.isShare isEqualToString:IS_SHARE_CODE]){
          NSString *temp = [NSString stringWithFormat:@"%@",_articleModel.shareUrl];
        if (_articleModel.fromWeixin.length == 0 && temp.length >0) {
           
            // 发表的内容
            self.shareComment.frame = CGRectZero;
            self.shareContext.frame = CGRectMake(0, self.shareComment.frame.origin.y + self.shareComment.frame.size.height, 250,[SingleInstance customFontHeightFont:_articleModel.context andFontSize:15 andLineWidth:250] + 5);
            self.tempView.frame = CGRectMake(0, self.shareContext.frame.origin.y - 1, SCREEN_WIDTH, 3);
            self.contact.frame = CGRectMake(USER_ICON_WHDTH + 15, 5, 250,self.shareContext.frame.size.height + self.shareContext.frame.origin.y + 5);
        }
        else {
            // 发表的内容
            self.shareComment.frame = CGRectMake(0, 0, 250,[SingleInstance customFontHeightFont:_articleModel.shareComment andFontSize:15 andLineWidth:250] );
            self.shareContext.frame = CGRectMake(0, self.shareComment.frame.origin.y + self.shareComment.frame.size.height + 5, 250,[SingleInstance customFontHeightFont:_articleModel.context andFontSize:15 andLineWidth:250] + 5 );
            self.tempView.frame = CGRectMake(0, self.shareContext.frame.origin.y - 1, SCREEN_WIDTH, 3);
            self.contact.frame = CGRectMake(USER_ICON_WHDTH + 15, 5, 250,self.shareContext.frame.size.height + self.shareContext.frame.origin.y + 5);
        }
        
    }
    
    
}
+ (CGFloat)heightForCellWithPost:(UserArticleList *)articleModel
{
    CGFloat contentHeight = 0.0;
    CGFloat imgHeight = 0.0;
    // 判断分享的链接
    if ([articleModel.isShare isEqualToString:ISNOT_SHARE_CODE]) {
        // 发表的内容
        if (articleModel.context == nil || articleModel.context.length == 0 || [articleModel.context isEqualToString:@" "]){
            contentHeight = 0;
        }else{
            contentHeight = [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10;
        }
        // 如果不含图片在内
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
            imgHeight = 0;
        }
        // 包含图片
        else{
            if (([articleModel.imageWidth floatValue]/([articleModel.imageHeight floatValue]+0.01))>1) {
                imgHeight = [articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01));
            }else{
                imgHeight = SHARE_IMAGE_HEIGHT;
            }

        }
    }
    else if([articleModel.isShare isEqualToString:IS_SHARE_CODE]){
        contentHeight = [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10;
    }
    
    return contentHeight + imgHeight ;
}

#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClick:(id)sender
{
    
    UITapGestureRecognizer *tapImg = (UITapGestureRecognizer *)sender;
    //NSLog(@"测试:%d",tapImg.view.tag);
    
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgView.image = ((UIImageView *)[_shareImageEnlarge objectAtIndex:tapImg.view.tag-99999]).image;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = YES;
    [background addSubview:imgView];
    [self shakeToShow:imgView];//放大过程中的动画
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(suoxiao)];
    tap.numberOfTapsRequired = 1;
    [imgView addGestureRecognizer:tap];
    imgView.tag = tapImg.view.tag;
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] init];
    [longPressGestureRecognizer addTarget:self action:@selector(gestureRecognizerHandle:)];
    [longPressGestureRecognizer setMinimumPressDuration:1.0f];
    [longPressGestureRecognizer setAllowableMovement:50.0];
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    [imgView addGestureRecognizer:longPressGestureRecognizer];
    
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
    imgTagSave = _longpress.view.tag;
    [self handleLongTouch];
    
}

//*************放大过程中出现的缓慢动画*************
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    //    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 1.0)]];
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
        UIImageWriteToSavedPhotosAlbum(((UIImageView *)[_shareImageEnlarge objectAtIndex:imgTagSave-99999]).image, nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
