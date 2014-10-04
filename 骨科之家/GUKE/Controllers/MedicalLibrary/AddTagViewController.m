//
//  AddTagViewController.m
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AddTagViewController.h"

#import "FbRegistCell.h"

@interface AddTagViewController ()
{
    NSMutableArray * data_array;
    
    int total_num;
}

@end

@implementation AddTagViewController
@synthesize myTableView = _myTableView;
@synthesize feed = _feed;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    total_num = 3;
    
    self.dataArray=[NSMutableArray array];
    for (int i=0; i<3; i++) {
        NSString *_string=[NSString stringWithFormat:@"标签%d",i+1];
        
        [self.dataArray addObject:_string];
    }

    
    self.aTitle = @"添加标签";
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-88) style:UITableViewStylePlain];
    _myTableView.separatorColor=[UIColor clearColor];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    if (IOS7_LATER) {
        _myTableView.separatorInset = UIEdgeInsetsZero;
    }
    [self.view addSubview:_myTableView];
    
    [self setBingliBottomView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier=@"identifier";
    
  FbRegistCell *  cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[FbRegistCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    __weak typeof(self) _weakself=self;
    
    
   [ cell setFbRegistCellType:FbRegistCellTypeNormal placeHolderText:[self.dataArray objectAtIndex:indexPath.row]  str_img:@"" fbregistbloc:^(int tag, NSInteger indexpathofrow, NSString *stringtext) {
       
         [_weakself changewordwithstr:stringtext indexpathrow:indexpathofrow];
       
   } row:indexPath.row];
    
    cell.backgroundColor=[UIColor whiteColor];
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 44;

}
#pragma mark--赋值

-(void)changewordwithstr:(NSString *)str indexpathrow:(NSInteger)rowww{

    [self.dataArray replaceObjectAtIndex:rowww withObject:str];

}





-(void)setBingliBottomView{

//1 bgView
    UIView *aview=[[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT-88, 320, 88)];
    aview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:aview];
    
 //2 更多标签button
    
    UIButton *MoreButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 1, 310, 30)];
//    MoreButton.backgroundColor=RGBCOLOR(28, 168, 73);
    [MoreButton setTitleColor:RGBCOLOR(28, 168, 73)forState:UIControlStateNormal];

    [MoreButton setTitle:@"更多标签" forState:UIControlStateNormal];
    
    CALayer *l = [MoreButton layer];   //获取ImageView的层
    [l setMasksToBounds:YES];
    [l setCornerRadius:2.0f];
    l.borderColor=[RGBCOLOR(28, 168, 73) CGColor];
    l.borderWidth=1;
    [MoreButton addTarget:self action:@selector(doMoreButton) forControlEvents:UIControlEventTouchUpInside];
    [aview addSubview:MoreButton];
    
    //提交button
    
    
    UIButton *commitButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 40, 310, 30)];
    commitButton.backgroundColor=RGBCOLOR(28, 168, 73);
    [commitButton setTitle:@"提交" forState:UIControlStateNormal];
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [commitButton addTarget:self action:@selector(doCommitButton) forControlEvents:UIControlEventTouchUpInside];
    
    CALayer *ls = [commitButton layer];   //获取ImageView的层
    [ls setMasksToBounds:YES];
    [ls setCornerRadius:2.0f];
    
    [aview addSubview:commitButton];

    
    
    



}

#pragma mark----更多标签响应方法

-(void)doMoreButton{

    NSLog(@"点击更多标签");
    
    for (int i=0; i<3; i++) {
        NSString *tempstr=[NSString stringWithFormat:@"标签%d",self.dataArray.count+1];
        [self.dataArray addObject:tempstr];
    }
    
    [_myTableView reloadData];

}

#pragma mark---提交的button

-(void)doCommitButton{

    
    NSLog(@"点击提交按钮");

    
    NSLog(@"给soulnear的数组%@",self.dataArray);
    
    NSString * tag_string = [self.dataArray componentsJoinedByString:@","];
  

    __weak typeof(self)bself = self;
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"bingliId":_feed.bingliId,@"tag":tag_string};
    
    MBProgressHUD * hud = [SNTools returnMBProgressWithText:@"正在添加..." addToView:self.view];
    hud.mode = MBProgressHUDModeDeterminate;
    [AFRequestService responseData:BINGLI_TAG_ADD_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            hud.labelText = @"添加标签成功";
            [hud hide:YES afterDelay:1.5];
            
            NSDictionary *dic_userinfo=@{@"BiaoqianArray":bself.dataArray};
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BiaoqianUpLoad" object:self userInfo:dic_userinfo];
            [bself.navigationController popViewControllerAnimated:YES];
        }
    }];
}



- (void)didReceiveMemoryWarning {
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
