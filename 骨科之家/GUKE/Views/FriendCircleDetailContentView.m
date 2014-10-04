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
#import "ShowImagesViewController.h"
#import "LiuLanBingLiViewController.h"
#import "InfoDetailViewController.h"


#define IMG_TAG 99999
@implementation FriendCircleDetailContentView
{
    int imgTag;
    NSMutableArray *_shareImageEnlarge;
    UIView *background;
    int imgTagSave;
    NSMutableArray * temp_array;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        temp_array = [NSMutableArray array];
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
        [temp_array removeAllObjects];
        if ([model.photo isEqualToString:@""]||model.photo == nil) {
            NSString *temp = [NSString stringWithFormat:@"%@",model.shareUrl];
            //            NSLog(@"--------------%@",temp);
            if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
                height = height + [SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+15;
            }else{
                height = height + [SingleInstance customFontHeightFont:model.shareUrl andFontSize:15 andLineWidth:250]+20+15;
            }
            temp_array = [NSMutableArray arrayWithArray:model.attachlistArray];
        }
        else{
            [temp_array addObject:model.photo];
            
            if (model.context == nil || model.context.length == 0 || [model.context isEqualToString:@" "] ) {
                height = height+20;
            }else{
                height = height+[SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+20;
            }
        }
        
        float imgHeight = 0;
        
        if (temp_array.count)
        {
            int i = temp_array.count/3;
            
            int j = temp_array.count%3?1:0;
            
            imgHeight = 75*(i+j)+2.5*(j + i - 1)+20;
        }
        
        height+= imgHeight;
    }

    self.tableView.frame = CGRectMake(0, 0, 235, height+20);
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
    // 不是分享的链接
    //if ([temp isEqualToString:@"0"] ||temp == nil || [temp isEqualToString: @""]){
        if ([articleModel.isShare isEqualToString:ISNOT_SHARE_CODE] ){
        // 发表的内容
        cell.contentShare.frame = CGRectZero;
        cell.content.text = articleModel.context;
        cell.content.userInteractionEnabled = YES;
        cell.content.lineBreakMode = NSLineBreakByWordWrapping;
        cell.content.numberOfLines = 0;
        cell.urlLabel.hidden = YES;
        cell.content.frame = CGRectMake(5, 2, 255,[SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10);
        cell.backView.frame = CGRectMake(0, 3, 255, [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+10);
        

        [temp_array removeAllObjects];
        
        // 设置分享的图片
        if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil)
        {
            cell.shareImg.frame = CGRectZero;
            
            temp_array = [NSMutableArray arrayWithArray:articleModel.attachlistArray];
        }
        else{
            
            [temp_array addObject:articleModel.photo];
        }
        
        float imgHeight = 0.0f;
        
        if (temp_array.count)
        {
            int i = temp_array.count/3;
            
            int j = temp_array.count%3?1:0;
            
            imgHeight = 75*(i+j)+2.5*(j + i - 1);
            
            cell.PictureViews.frame = CGRectMake(5,cell.content.frame.size.height+cell.content.frame.origin.y+10,231,imgHeight);
            
            [cell.PictureViews setimageArr:articleModel.attachlistArray withSize:75 isjuzhong:NO];
            [cell.PictureViews setthebloc:^(NSInteger index) {
                
                ShowImagesViewController *showBigVC=[[ShowImagesViewController alloc]init];
                showBigVC.allImagesUrlArray=articleModel.attachlistArray;
                showBigVC.currentPage = index-1;
                UIViewController *VCtest=(UIViewController *)self.delegate;
                [VCtest.navigationController pushViewController:showBigVC animated:YES];
            }];
            imgHeight += 20;
        }
        
        cell.backView.frame = CGRectMake(0, 3, 255,cell.content.frame.size.height + cell.content.frame.origin.y+imgHeight);
    }
    // 是分享
    else{
        cell.contentShare.frame = CGRectMake(0, 23, 232, 28);
        cell.backView.frame = CGRectMake(0, 3, 255, 48);
        NSString *shareUrl = @"";
        NSString *temp = [NSString stringWithFormat:@"%@",articleModel.shareUrl];
        cell.contentShare.text = temp;
        if (articleModel.fromWeixin.length == 0  &&temp.length >0 ) {
            cell.urlLabel.text = @"分享了一个链接";
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
             cell.contentShare.delegate = self;
        }
        else if([articleModel.fromWeixin isEqualToString:SOURCE_FROME_CASE]){
            cell.urlLabel.text = @"分享了一个病例";
            cell.contentShare.tag = [articleModel.sourceId integerValue];
            shareUrl = articleModel.context;
            UITapGestureRecognizer *tapCase = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToCase:)];
            tapCase.view.tag = [articleModel.sourceId integerValue];
            [cell.contentShare addGestureRecognizer:tapCase];
        }
        else if([articleModel.fromWeixin isEqualToString:SOURCE_FROME_MATERIAL]){
            cell.urlLabel.text = @"分享了一个资料";
            cell.contentShare.tag = [articleModel.sourceId integerValue];
            shareUrl = articleModel.context;
            UITapGestureRecognizer *tapCase = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipToMaterial:)];
            tapCase.view.tag = [articleModel.sourceId integerValue];
            [cell.contentShare addGestureRecognizer:tapCase];
        }
       
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
// 跳转到病例页面
- (void)skipToCase:(UITapGestureRecognizer *)gesture{
        LiuLanBingLiViewController *bingli = [[LiuLanBingLiViewController alloc]init];
        bingli.theId = [NSString stringWithFormat:@"%d",gesture.view.tag];
        UIViewController *VCtest=(UIViewController *)self.delegate;
        [VCtest.navigationController pushViewController:bingli animated:YES];
}
// 跳转到资料库页面
- (void)skipToMaterial:(UITapGestureRecognizer *)gesture{
    
    InformationModel *model = [[InformationModel alloc]init];
    model.infoId = [NSString stringWithFormat:@"%d",gesture.view.tag];
    InfoDetailViewController *ziliao = [[InfoDetailViewController alloc]initWithModel:model];
    UIViewController *VCtest=(UIViewController *)self.delegate;
    [VCtest.navigationController pushViewController:ziliao animated:YES];
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
    
    [temp_array removeAllObjects];
    
    CGFloat height = 0.0f;
    if ([articleModel.photo isEqualToString:@""]||articleModel.photo == nil)
    {
        temp_array = [NSMutableArray arrayWithArray:articleModel.attachlistArray];
                
    }else
    {
        [temp_array addObject:articleModel.photo];
    }
    
    
    //NSString *temp = [NSString stringWithFormat:@"%@",articleModel.shareUrl];
    if ([articleModel.isShare isEqualToString:ISNOT_SHARE_CODE] ){
        height = height + [SingleInstance customFontHeightFont:articleModel.context andFontSize:15 andLineWidth:250]+15;
    }else{
        height = height + [SingleInstance customFontHeightFont:articleModel.shareUrl andFontSize:15 andLineWidth:250]+20+15;
    }
    
    float imgHeight = 0;
    
    if (temp_array.count)
    {
        int i = temp_array.count/3;
        
        int j = temp_array.count%3?1:0;
        
        imgHeight = 75*(i+j)+2.5*(j + i - 1) + 30;
    }
    return height + imgHeight;
}
+ (CGFloat)heightForCellWithPost:(NSMutableArray *)dataArray
{
    CGFloat height = 0.0;
    NSMutableArray * tempArray = [NSMutableArray array];
    for (UserArticleList *model in dataArray) {
        [tempArray removeAllObjects];
        if ([model.photo isEqualToString:@""]||model.photo == nil) {
            NSString *temp = [NSString stringWithFormat:@"%@",model.shareUrl];
            if ([model.isShare isEqualToString:ISNOT_SHARE_CODE]){
                height = height + [SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+15;
            }else{
                height = height + [SingleInstance customFontHeightFont:model.shareUrl andFontSize:15 andLineWidth:250]+20+15;
            }
            tempArray = [NSMutableArray arrayWithArray:model.attachlistArray];
        }
        else{
            
            [tempArray addObject:model.photo];
    
            if (model.context == nil || model.context.length == 0 || [model.context isEqualToString:@" "] ) {
                height = height+20;
            }else{
                height = height+[SingleInstance customFontHeightFont:model.context andFontSize:15 andLineWidth:250]+20;
            }
        }
        
        float imgHeight = 0;
        
        if (tempArray.count)
        {
            int i = tempArray.count/3;
            
            int j = tempArray.count%3?1:0;
            
            imgHeight = 75*(i+j)+2.5*(j + i - 1)+20;
        }
        
        height+= imgHeight;
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
