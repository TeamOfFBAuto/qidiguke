//
//  LiuLanBingLiViewController.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "LiuLanBingLiViewController.h"
#import "LiuLanSectionView.h"
//#import "InfoFileTableViewCell.h"
#import "TagManagerViewController.h"
#import "TSActionSheet.h"
#import "PostMoodViewController.h"
#import "CreatMedicalViewController.h"
#import "ShareCircleViewController.h"
#import "SNGroupsViewController.h"

@interface LiuLanBingLiViewController ()

@end

@implementation LiuLanBingLiViewController
@synthesize myTableView = _myTableView;
@synthesize feed = _feed;
@synthesize myFeed = _myFeed;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.aTitle = @"浏览病历";
    
    if (_feed.bingliId.length && ![_feed.bingliId isKindOfClass:[NSNull class]])
    {
        self.theId = _feed.bingliId;
    }
    
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = IOS7_OR_LATER ? -5:5;
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(0,0,50,30);
    [right_button setImage:[UIImage imageNamed:@"guke_ic_write_right"] forState:UIControlStateNormal];
    [right_button addTarget:self action:@selector(showActionSheet:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * right_item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceButton,right_item,nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _myFeed = [[BingLiListFeed alloc] init];
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_myTableView];
    
    UIView * vvvv = [[UIView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,0)];
    _myTableView.tableFooterView = vvvv;
    
    
    [self loadBingliDetailData];
}

#pragma mark - 分享按钮
-(void) showActionSheet:(id)sender forEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
    __weak typeof(self)bself = self;
    TSActionSheet *actionSheet = [[TSActionSheet alloc] init];
    NSString *share1 = @"分享到诊疗圈";
    NSString *share2 = @"分享到讨论组";
    NSString *edit = @"编辑病历";
    NSString * delete = @"删除病历";
    [actionSheet addButtonWithTitle:share1 icon:@"guke_ic_share_article" block:^{
        ShareCircleViewController * share = [[ShareCircleViewController alloc] initWithNibName:@"ShareCircleViewController" bundle:nil];
        share.share_content = _feed.zhenduan;
        share.theId = _feed.bingliId;
        share.type = @"2";
        [bself.navigationController pushViewController:share animated:YES];
    }];
    [actionSheet addButtonWithTitle:share2 icon:@"guke_ic_share_group" block:^{
        
        SNGroupsViewController * list = [[SNGroupsViewController alloc] init];
        list.theId = _feed.bingliId;
        list.type = @"0";
        [bself.navigationController pushViewController:list animated:YES];
        
    }];
    [actionSheet addButtonWithTitle:edit icon:@"guke_ic_edit" block:^{
        
        CreatMedicalViewController * create = [[CreatMedicalViewController alloc] init];
        create.feed = _myFeed;
        [bself.navigationController pushViewController:create animated:YES];
        
    }];
    [actionSheet addButtonWithTitle:delete icon:@"guke_ic_delete" block:^{
        [bself deleteBingli];
    }];
    actionSheet.cornerRadius = 0;
    
    [actionSheet showWithTouch:event];
}

#pragma mark - 删除改病历
-(void)deleteBingli
{
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"bingliId":_feed.bingliId};
    
    __weak typeof(self)wself=self;
    
    [AFRequestService responseData:BINGLI_DELETE_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict ------  %@",dict);
        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        
        if ([code intValue]==0)//说明请求数据成功
        {
            [wself.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

#pragma mark - 获取病历详细信息
-(void)loadBingliDetailData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"bingliId":_theId};
    
    __weak typeof(self)wself=self;
    
    [AFRequestService responseData:BINGLI_DETAIL_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict ------  %@",dict);
        NSString * code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        
        if ([code intValue]==0)//说明请求数据成功
        {
            [wself.myFeed setBingLiListFeedDic:[dict objectForKey:@"bingli"]];
            [wself.myTableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5 + _myFeed.attach_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 80;
    }else if (indexPath.row == 1)
    {
        return 50;
    }else if (indexPath.row == 2)
    {
        CGSize bl_height = [SNTools returnStringHeightWith:[NSString stringWithFormat:@"病历号：%@",self.feed.binglihao] WithWidth:240 WithFont:14];
        
        CGSize zd_height = [SNTools returnStringHeightWith:[NSString stringWithFormat:@"诊断：%@",self.feed.zhenduan] WithWidth:240 WithFont:14];
        
        return bl_height.height+zd_height.height+30;
    }else if (indexPath.row == 3)
    {
        CGSize size = [SNTools returnStringHeightWith:self.feed.fangan WithWidth:240 WithFont:14];
        return size.height+20;
    }else if (indexPath.row == 4)
    {
        CGSize size = [SNTools returnStringHeightWith:self.feed.memo WithWidth:240 WithFont:14];
        return size.height + 20;
    }else
    {
        return 70;
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row  < 5) {
        static NSString * identifier = @"identifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.row == 0) {
            LiuLanSectionView * aView = [[[NSBundle mainBundle] loadNibNamed:@"LiuLanSectionView" owner:self options:nil] objectAtIndex:0];
            [aView setContentWithFenLei:_feed.fenleiname Date:_feed.jiuzhen UserName:_feed.psnname Sex:_feed.sex];
            [cell.contentView addSubview:aView];
        }else if (indexPath.row == 1)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSString * tag_string = @"";
            for (TagListFeed * model in _myFeed.tag_array)
            {
                tag_string = [tag_string stringByAppendingString:[NSString stringWithFormat:@"/%@",model.tag]];
            }
            
            UILabel * tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,DEVICE_WIDTH-40,50)];
            tagLabel.text = [NSString stringWithFormat:@"标签：%@",tag_string];
            tagLabel.textAlignment = NSTextAlignmentLeft;
            tagLabel.textColor = [UIColor blackColor];
            tagLabel.font = [UIFont systemFontOfSize:15];
            [cell.contentView addSubview:tagLabel];
            
        }else if (indexPath.row == 2)
        {
            CGSize bl_height = [SNTools returnStringHeightWith:self.feed.binglihao WithWidth:240 WithFont:14];
            CGSize zd_height = [SNTools returnStringHeightWith:self.feed.zhenduan WithWidth:240 WithFont:14];
            
            UILabel * binglihao = [[UILabel alloc] initWithFrame:CGRectMake(10,10,DEVICE_WIDTH-20,bl_height.height)];
            binglihao.text = [NSString stringWithFormat:@"病历号：%@",_feed.binglihao];
            binglihao.textAlignment = NSTextAlignmentLeft;
            binglihao.textColor = [UIColor blackColor];
            binglihao.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:binglihao];
            
            UILabel * zhenduan = [[UILabel alloc] initWithFrame:CGRectMake(10,20+bl_height.height,DEVICE_WIDTH-20,zd_height.height)];
            zhenduan.text = [NSString stringWithFormat:@"诊断：%@",_feed.zhenduan];
            zhenduan.textAlignment = NSTextAlignmentLeft;
            zhenduan.textColor = [UIColor blackColor];
            zhenduan.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:zhenduan];
            
        }else if (indexPath.row == 3)
        {
            CGSize size = [SNTools returnStringHeightWith:self.feed.fangan WithWidth:240 WithFont:14];
            
            UILabel * zhiliaofangan = [[UILabel alloc] initWithFrame:CGRectMake(10,10,DEVICE_WIDTH-20,size.height)];
            zhiliaofangan.text = [NSString stringWithFormat:@"治疗方案：%@",_feed.fangan];
            zhiliaofangan.textAlignment = NSTextAlignmentLeft;
            zhiliaofangan.textColor = [UIColor blackColor];
            zhiliaofangan.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:zhiliaofangan];
            
        }else if (indexPath.row == 4)
        {
            CGSize size = [SNTools returnStringHeightWith:self.feed.memo WithWidth:240 WithFont:14];
            
            UILabel * binglishuoming = [[UILabel alloc] initWithFrame:CGRectMake(10,10,DEVICE_WIDTH-20,size.height)];
            binglishuoming.text = [NSString stringWithFormat:@"病例说明：%@",_feed.fangan];
            binglishuoming.textAlignment = NSTextAlignmentLeft;
            binglishuoming.textColor = [UIColor blackColor];
            binglishuoming.font = [UIFont systemFontOfSize:14];
            [cell.contentView addSubview:binglishuoming];
        }
        
        return cell;
    }else
    {
        static NSString *cellName = @"infoFileCell";
        __weak typeof(self)wself=self;

        InfoFileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if (cell == nil) {
            
            
            cell = [[InfoFileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName thebloc:^(NSString *playfilepath) {
                [wself playVideWithString:playfilepath];
                
            }];
            
            cell.delegate=self;

            
            
        }
        
        
        
        
        
        

        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.fileDic = [_myFeed.attach_array objectAtIndex:indexPath.row-5];
        return cell;
    }
    
    return nil;
}


#pragma mark---播放视频

-(void)playVideWithString:(NSString *)thestrUrl{

         NSURL *videoUrl=[NSURL URLWithString:thestrUrl];
        MPMoviePlayerViewController *movieVc=[[MPMoviePlayerViewController alloc]initWithContentURL:videoUrl];
        //弹出播放器
      [self presentMoviePlayerViewControllerAnimated:movieVc];
    

}



#pragma mark--播放视频方法结束
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1)
    {
        TagManagerViewController * manager = [[TagManagerViewController alloc] init];
        manager.myFeed = _myFeed;
        [self.navigationController pushViewController:manager animated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
