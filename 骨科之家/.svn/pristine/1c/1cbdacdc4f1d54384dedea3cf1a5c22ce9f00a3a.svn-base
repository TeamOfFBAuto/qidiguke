//
//  FriendCircleDetailContentView.m
//  UNITOA
//  个人朋友圈的内容的View
//  Created by ianMac on 14-9-1.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "FriendCircleDetailContentView.h"
#import "UserArticleList.h"
#import "Interface.h"
#import "UIImageView+WebCache.h"
#define IMG_TAG 99999
@implementation FriendCircleDetailContentView
{
    int imgTag;
    NSMutableArray *_shareImageEnlarge;
    UIView *background;
    int imgTagSave;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        imgTag = IMG_TAG;
        _shareImageEnlarge = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)setContentDataArray:(NSMutableArray *)contentDataArray
{
    _contentDataArray = nil;
    _contentDataArray = contentDataArray;
    
    CGFloat height = 0.0;
    for (UserArticleList *model in _contentDataArray) {
        
        if ([model.photo isEqualToString:@""]||model.photo == nil) {
            NSString *temp = [NSString stringWithFormat:@"%@",model.shareUrl];
            NSLog(@"--------------%@",temp);
            if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
                height = height + [SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+20;
            }else{
                height = height + [SingleInstance customFontHeightFont:model.shareUrl andFontSize:15 andLineWidth:250]+20+30;
            }
            
        }
        else{
            double imgHeight = SHARE_IMAGE_HEIGHT;
            if (([model.imageWidth floatValue]/([model.imageHeight floatValue]+0.01))>1) {
                imgHeight = [model.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([model.imageWidth floatValue]+0.01));
            }else{
                imgHeight = SHARE_IMAGE_HEIGHT;
            }
            if (model.context == nil || model.context.length == 0 || [model.context isEqualToString:@" "] ) {
                height = height+imgHeight+40;
            }else{
                height = height+[SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+imgHeight+40;
            }
        }
    }
    self.tableView.frame = CGRectMake(0, 0, 235, height);
    [self.tableView reloadData];
}

#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentDataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"Fcell6";
    FriendCircleDetailContentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[FriendCircleDetailContentViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    UserArticleList *articleModel;
    if (_contentDataArray.count != 0) {
        articleModel = (UserArticleList *)_contentDataArray[indexPath.row];
    }
    // 判断分享的链接
    NSString *temp = [NSString stringWithFormat:@"%@",articleModel.shareUrl];
    NSLog(@"--------------%@",temp);
    if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
        
        // 发表的内容
        cell.contentShare.frame = CGRectZero;
        cell.content.text = articleModel.context;
        cell.content.lineBreakMode = NSLineBreakByWordWrapping;
        cell.content.numberOfLines = 0;
        cell.urlLabel.hidden = YES;
        cell.content.frame = CGRectMake(5, 2, 230,[SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10);
        cell.backView.frame = CGRectMake(0, 3, 232, [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10);
        
        // 设置分享的图片
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
            cell.shareImg.frame = CGRectZero;
        }
        else{
            
            if (([articleModel.imageWidth floatValue]/([articleModel.imageHeight floatValue]+0.01))>1) {
                if (articleModel.context == nil || articleModel.context.length == 0 || [articleModel.context isEqualToString:@" "] ) {
                    cell.shareImg.frame =  CGRectMake(5, 8,SHARE_IMAGE_WHDTH, [articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01)));
                    cell.backView.frame = CGRectMake(0, 3, 232, 5+[articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01))+5);
                }else{
                    cell.shareImg.frame =  CGRectMake(5, cell.content.frame.size.height + cell.content.frame.origin.y,SHARE_IMAGE_WHDTH, [articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01)));
                    cell.backView.frame = CGRectMake(0, 3, 232, cell.content.frame.size.height + cell.content.frame.origin.y+[articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01))+3);
                }

            }else{
                if (articleModel.context == nil || articleModel.context.length == 0 || [articleModel.context isEqualToString:@" "] ){
                    cell.shareImg.frame = CGRectMake(5, 8, [articleModel.imageWidth floatValue]*(SHARE_IMAGE_HEIGHT/([articleModel.imageHeight floatValue]+0.01)), SHARE_IMAGE_HEIGHT);
                    cell.backView.frame = CGRectMake(0, 3, 232, 5+SHARE_IMAGE_HEIGHT+5);
                }else{
                    cell.shareImg.frame = CGRectMake(5, cell.content.frame.size.height + cell.content.frame.origin.y,[articleModel.imageWidth floatValue]*(SHARE_IMAGE_HEIGHT/([articleModel.imageHeight floatValue]+0.01)), SHARE_IMAGE_HEIGHT);
                    cell.backView.frame = CGRectMake(0, 3, 232, cell.content.frame.size.height + cell.content.frame.origin.y+SHARE_IMAGE_HEIGHT+3);
                }

            }
            
            
//            cell.shareImg.frame =  CGRectMake(0, cell.content.frame.size.height + cell.content.frame.origin.y, SHARE_IMAGE_WHDTH, SHARE_IMAGE_HEIGHT);
            [cell.shareImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,articleModel.photo]] placeholderImage:[UIImage imageNamed:@"imgError.png"]];
            cell.shareImg.tag = imgTag;
            [_shareImageEnlarge addObject:cell];
            imgTag ++;

            cell.shareImg.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapImageClick:)];
            tap.numberOfTapsRequired = 1;
            [cell.shareImg addGestureRecognizer:tap];
            
            cell.shareImg.backgroundColor = [UIColor clearColor];
            cell.shareImg.contentMode = UIViewContentModeScaleAspectFit;
            cell.shareImg.clipsToBounds = YES;
            
            
        }
    }
    else{
        cell.contentShare.frame = CGRectMake(0, 23, 232, 28);
        cell.backView.frame = CGRectMake(0, 3, 232, 48);
        //cell.contentShare.numberOfLines = 0;
        NSString *shareUrl = @"";
        NSString *temp = [NSString stringWithFormat:@"%@",articleModel.shareUrl];
        cell.contentShare.text = temp;
        NSLog(@"--------------%@",temp);
        if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
            shareUrl = @"此连接错误";
        }
        else{
            
            NSError *error;
            NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
            NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                                   options:NSRegularExpressionCaseInsensitive
                                                                                     error:&error];
            NSArray *arrayOfAllMatches = [regex matchesInString:temp options:0 range:NSMakeRange(0, [temp length])];
            
            for (NSTextCheckingResult *match in arrayOfAllMatches)
            {
                NSString* substringForMatch = [temp substringWithRange:match.range];
                //                    shareUrl = [NSString stringWithFormat:@"<a href='%@'>%@</a>",substringForMatch,temp];
                shareUrl = [NSString stringWithFormat:@"%@",substringForMatch];
            }
            
        }
        cell.contentShare.delegate = self;
        [cell.contentShare setText:shareUrl];
        cell.contentShare.textAlignment = NSTextAlignmentLeft;
        [cell.contentShare setVerticalAlignment:VerticalAlignmentMiddle];
        cell.content.frame = CGRectZero;
        cell.shareImg.frame = CGRectZero;
        cell.contentShare.textColor = GETColor(149, 149, 149);
        cell.contentShare.backgroundColor = GETColor(238, 238, 238);
        cell.urlLabel.hidden = NO;
        cell.contentShare.userInteractionEnabled = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserArticleList *articleModel;
    if (_contentDataArray.count != 0) {
        articleModel = (UserArticleList *)_contentDataArray[indexPath.row];
    }
    
    CGFloat height = 0.0f;
    if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil) {
        NSString *temp = [NSString stringWithFormat:@"%@",articleModel.shareUrl];
        NSLog(@"--------------%@",temp);
        if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
            height = height + [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+15;
        }else{
            height = height + [SingleInstance customFontHeightFont:articleModel.shareUrl andFontSize:15 andLineWidth:250]+20+15;
        }
    }else{
        double imgHeight = SHARE_IMAGE_HEIGHT;
        
        if (([articleModel.imageWidth floatValue]/([articleModel.imageHeight floatValue]+0.01))>1) {
            imgHeight = [articleModel.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([articleModel.imageWidth floatValue]+0.01));
        }else{
            imgHeight = SHARE_IMAGE_HEIGHT;
        }

        
        if (articleModel.context == nil || articleModel.context.length == 0 || [articleModel.context isEqualToString:@" "] ) {
            height = height+imgHeight+20;
        }else{
            height = height+[SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+imgHeight+20;
        }
        
    }
    return height;
    
}
+ (CGFloat)heightForCellWithPost:(NSMutableArray *)dataArray
{
    CGFloat height = 0.0;
    for (UserArticleList *model in dataArray) {
        
        if ([model.photo isEqualToString:@""]||model.photo == nil) {
            NSString *temp = [NSString stringWithFormat:@"%@",model.shareUrl];
            NSLog(@"--------------%@",temp);
            if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
                height = height + [SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+15;
            }else{
                height = height + [SingleInstance customFontHeightFont:model.shareUrl andFontSize:15 andLineWidth:250]+20+15;
            }
        }
        else{
            double imgHeight = SHARE_IMAGE_HEIGHT;
            if (([model.imageWidth floatValue]/([model.imageHeight floatValue]+0.01))>1) {
                imgHeight = [model.imageHeight floatValue]*(SHARE_IMAGE_WHDTH/([model.imageWidth floatValue]+0.01));
            }else{
                imgHeight = SHARE_IMAGE_HEIGHT;
            }
            if (model.context == nil || model.context.length == 0 || [model.context isEqualToString:@" "] ) {
                height = height+imgHeight+20;
            }else{
                height = height+[SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+imgHeight+20;
            }
        }
    }
    return height+10;
}

#pragma mark - "分享图片"的放大以及保存 -
- (void)TapImageClick:(id)sender
{
    
    UITapGestureRecognizer *tapImg = (UITapGestureRecognizer *)sender;
    NSLog(@"测试:%d",tapImg.view.tag);
    
    //创建灰色透明背景，使其背后内容不可操作
    background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    [background setBackgroundColor:[UIColor blackColor]];
    
    //创建显示图像视图
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2-[UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    imgView.image = ((FriendCircleDetailContentViewCell *)[_shareImageEnlarge objectAtIndex:tapImg.view.tag-99999]).shareImg.image;
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
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:background];
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
        UIImageWriteToSavedPhotosAlbum(((FriendCircleDetailContentViewCell *)[_shareImageEnlarge objectAtIndex:imgTagSave-99999]).shareImg.image, nil, nil,nil);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"存储图片成功"
                                                        message:@"您已将图片存储于照片库中，打开照片程序即可查看。"
                                                       delegate:self
                                              cancelButtonTitle:LOCALIZATION(@"dialog_ok")
                                              otherButtonTitles:nil];
        [alert show];
    }
}



@end
