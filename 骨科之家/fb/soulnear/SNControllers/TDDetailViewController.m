//
//  TDDetailViewController.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "TDDetailViewController.h"
#import "ReplyListModel.h"
#import "Toolbar.h"
#import "TDDetailCell.h"
#import "VoiceConverter.h"
#import "UUID.h"
#import "UIImage+fixOrientation.h"
#import "UIImage+UIImageExt.h"

@interface TDDetailViewController ()<ToolbarDelegate>
{
    NSMutableArray * data_array;
    int currentPage;
    Toolbar * toolBar;
}

@end

@implementation TDDetailViewController
@synthesize info = _info;
@synthesize myTableVIEW = _myTableVIEW;
@synthesize recorderVC = _recorderVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.aTitle = @"主题讨论";
    self.view.backgroundColor = [UIColor whiteColor];
    data_array = [NSMutableArray array];
    currentPage = 1;
    
    _myTableVIEW = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-44) style:UITableViewStylePlain];
    _myTableVIEW.delegate = self;
    _myTableVIEW.dataSource = self;
    if (IOS7_LATER) {
        _myTableVIEW.separatorInset = UIEdgeInsetsZero;
    }
    
    [self.view addSubview:_myTableVIEW];
    
    _myTableVIEW.tableHeaderView = [self loadSectionView];
    
    [self getCommentData];
    
    
    toolBar = [[Toolbar alloc] initWithFrame:CGRectMake(0,DEVICE_HEIGHT, 0, 0)];
    toolBar.delegate = self;
    [toolBar showInView:self.view withValidHeight:DEVICE_HEIGHT];
}

#pragma mark - 获取评论数据
-(void)getCommentData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"pageSize":@"20",@"page":[NSString stringWithFormat:@"%d",currentPage],@"zhutiId":_info.zhutiId};
    
    [AFRequestService responseData:TOPIC_DISCUSS_COMMENT_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict -------  %@",dict);
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            if (data_array.count == [[dict objectForKey:@"recordCount"] intValue])
            {
                [SNTools showMBProgressWithText:@"没有更多数据了" addToView:self.view];
                return ;
            }
            
            NSArray * array = [dict objectForKey:@"replylist"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array)
                {
                    ReplyListModel * model = [[ReplyListModel alloc] initWithDic:dic];
                    [data_array addObject:model];
                }
            }
            [_myTableVIEW reloadData];
        }
    }];
}
///发送消息
- (void)sureUpload:(id)object withType:(COMMENT_TYPE)type
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    //common
    [dic setObject:_info.zhutiId forKey:@"zhutiId"];
    [dic setObject:GET_U_ID forKey:@"userId"];
    [dic setObject:GET_S_ID forKey:@"sid"];

    NSMutableData * data = nil;
    NSString * filename;
    
    ASIFormDataRequest * upLoad_request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,TOPIC_DISCUSS_COMMIT_URL]]];
//    ASIFormDataRequest * upLoad_request = [HttpRequsetFactory getRequestKeys:dic subUrl:TOPIC_DISCUSS_COMMIT_URL userCommon:YES];
    [upLoad_request setTimeOutSeconds:30.0f];
    [upLoad_request setShouldAttemptPersistentConnection:NO];
    
    [upLoad_request setPostValue:GET_S_ID forKey:@"sid"];
    [upLoad_request setPostValue:[NSString stringWithFormat:@"%@",GET_U_ID] forKey:@"userId"];
    [upLoad_request setPostValue:_info.zhutiId forKey:@"zhutiId"];
    
    if (type == SEND_Type_voice)
    {
        data = [NSMutableData dataWithContentsOfFile:[VoiceRecorderBaseVC getPathByFileName:[[(NSDictionary *)object objectForKey:@"fid"] stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
//        [dic setObject:[object objectForKey:@"length"] forKey:@"voiceLength1"];
        filename = [NSString stringWithFormat:@"%@.amr",[object objectForKey:@"fid"]];
        [upLoad_request setPostValue:[object objectForKey:@"length"] forKey:@"voiceLength1"];
        [upLoad_request addData:data withFileName:filename andContentType:nil forKey:@"attach1"];
        
    }else if (type == SEND_Type_content)
    {
        [dic setObject:object forKey:@"context"];
        [upLoad_request setPostValue:object forKey:@"context"];
        [upLoad_request setPostValue:@"" forKey:@"voiceLength1"];
    }else if (type == SEND_Type_photo)
    {
        UIImage *image = [object imageByScalingOrgSize:CGSIZE_SCALE_MAX];
        NSData * aData = UIImageJPEGRepresentation(image, 1);
        
        filename = [NSString stringWithFormat:@"%@.jpg",[UUID createUUID]];
        [upLoad_request addData:aData withFileName:filename andContentType:nil forKey:@"attach1"];
    }
    

    __block typeof(upLoad_request) request = upLoad_request;
    
    __weak typeof(self) bself = self;
    
    [request setCompletionBlock:^{
        
        NSDictionary * allDic = [upLoad_request.responseString objectFromJSONString];
        
        NSLog(@"aldii ---  %@",allDic);
        
        [bself getCommentData];
        
    }];
    
    [request setFailedBlock:^{
        
        
        
    }];
    
    [upLoad_request startAsynchronous];
}


#pragma mark - 加载headerView
-(UIView *)loadSectionView
{
    float height = 0.0f;
    
    UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    aView.backgroundColor = [UIColor whiteColor];
    
    CGRect rectr = [self.info.title boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,20,DEVICE_WIDTH-30,rectr.size.height)];
    titleLabel.numberOfLines = 0;
    titleLabel.text = _info.title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [aView addSubview:titleLabel];
    
    height += 20 + rectr.size.height;
    
    if (![_info.bigPic isKindOfClass:[NSNull class]])
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,height + 30,250,150)];
        [imageView sd_setImageWithURL:[SNTools returnUrl:_info.bigPic] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
        
        [aView addSubview:imageView];
        
        height += 30 + 150;
    }
    
    CGRect rectr1 = [self.info.content boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    
    UILabel * contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,height+20,DEVICE_WIDTH-30,rectr1.size.height)];
    contentLabel.numberOfLines = 0;
    contentLabel.text = _info.content;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.textColor = [UIColor grayColor];
    contentLabel.font = [UIFont systemFontOfSize:14];
    [aView addSubview:contentLabel];
    
    height += 30 + rectr1.size.height + 20;
    
    aView.frame = CGRectMake(0,0,DEVICE_WIDTH-30,height);
    
    
    return aView;
}

#pragma mark - 录音方法
#pragma mark record 开始录音
#pragma mark ---------record delegate
- (void)VoiceRecorderBaseVCRecordFinish:(NSString *)_filePath fileName:(NSString *)_fileName withVoiceLenth:(CGFloat)length{
    int a =(int) length;
    if (a > 0) {
        [self wavToAmr:_filePath with:_fileName length:length];
    }
}
-(void)wavToAmr:(NSString *)_filePath  with:(NSString *)_fileName length:(CGFloat)length{
    [VoiceConverter wavToAmr:_filePath amrSavePath:[VoiceRecorderBaseVC getPathByFileName:[_fileName stringByAppendingString:@"wavToAmr"] ofType:@"amr"]];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_fileName,@"fid",_filePath,@"fileName",[NSNumber numberWithInt:(int)length],@"length", nil];
    NSLog(@"%@==%@",_filePath,_fileName);
    [self sureUpload:dic withType:SEND_Type_voice];
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyListModel * info = [data_array objectAtIndex:indexPath.row];
    float height = 110;
    if (info.theType == SEND_Type_content)
    {
        CGRect rectr = [info.context boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        
        if (rectr.size.height+20+26 > 110)
        {
            height = rectr.size.height+20+26;
        }
    }else if (info.theType == SEND_Type_photo)
    {
        height = 130;
        
    }else if (info.theType == SEND_Type_voice)
    {
        
    }else if (info.theType == SEND_Type_other)
    {
        
    }
    
    return height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    TDDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TDDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setInfoWith:[data_array objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - ToolBarDelegate
- (BOOL)placeTextViewShouldReturn:(HPGrowingTextView *)textView
{
    
    
    return YES;
}
- (void)toolBarPicture
{
    
}

- (void)toolView:(Toolbar *)textView index:(NSInteger)index
{
    if (index == 1){
        [self takePotoPicture:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    // 启用相册
    else if (index == 2){
        [self takePotoPicture:UIImagePickerControllerSourceTypeCamera];
    }
    // 发送按钮
    else if (index == 5){
        HPGrowingTextView *textViewWithTag = (HPGrowingTextView *)[textView viewWithTag:textView_tag_toolbar];
        NSString *temp = [textViewWithTag.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (temp.length>0) {
            [self sureUpload:textViewWithTag.text withType:SEND_Type_content];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:LOCALIZATION(@"msg_newtext_empty") message:nil delegate:nil cancelButtonTitle:LOCALIZATION(@"known") otherButtonTitles: nil];
            [alertView show];
            SSRCRelease(alertView)
        }
        textViewWithTag.text = nil;
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

//should change frame
- (void)toolViewDidChangeFrame:(Toolbar *)textView
{
    
    
    
}
- (void)changeFrame
{
    
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
    
    UIImage *image = [[info objectForKey:UIImagePickerControllerOriginalImage] fixOrientation];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 发送图片
    [self sureUpload:image withType:SEND_Type_photo];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
