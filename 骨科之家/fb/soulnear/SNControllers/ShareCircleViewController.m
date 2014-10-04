//
//  ShareCircleViewController.m
//  GUKE
//
//  Created by soulnear on 14-10-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "ShareCircleViewController.h"

@interface ShareCircleViewController ()

@end

@implementation ShareCircleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.aTitle = @"分享";
    
    self.title_label.text = self.share_content;
    
    CGSize content_size = [SNTools returnStringHeightWith:self.share_content WithWidth:300 WithFont:15];
    CGRect title_frame = self.title_label.frame;
    title_frame.size.height = content_size.height+20;
    self.title_label.frame = title_frame;
    
    [self.input_tf becomeFirstResponder];
    
    
    
    UIBarButtonItem * spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = IOS7_OR_LATER ? -5:5;
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(0,0,50,30);
    right_button.layer.cornerRadius = 5;
    right_button.backgroundColor = RGB(0,136,161);
    [right_button addTarget:self action:@selector(sendTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setTitle:@"发送" forState:UIControlStateNormal];
    right_button.titleLabel.font  = [UIFont systemFontOfSize:15];
    [right_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem * right_item = [[UIBarButtonItem alloc] initWithCustomView:right_button];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceButton,right_item,nil];
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 发送
-(void)sendTap:(UIButton *)sender
{
    __weak typeof(self)bself = self;
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"context":self.share_content,@"isShare":@"1",@"fromWeixin":self.type,@"sourceId":self.theId,@"shareComment":self.input_tf.text};
    
    [AFRequestService responseData:USER_ARTICEL_NEW andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dict -------  %@",dict);
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            [bself.navigationController popViewControllerAnimated:YES];
        }
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
