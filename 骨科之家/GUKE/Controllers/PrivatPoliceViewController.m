//
//  PrivatPoliceViewController.m
//  UNITOA
//
//  Created by qidi on 14-9-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "PrivatPoliceViewController.h"

#import "SingleInstance.h"
@interface PrivatPoliceViewController ()

@end

@implementation PrivatPoliceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self navigetion];
    [self layoutView];
    
}
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"private_police");
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [logoView addSubview:loginLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}
- (void)tapAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)layoutView{
    NSString *content = [NSString  stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"private" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    scrollView.scrollEnabled = YES;
    CGRect frame = CGRectMake(5, 10, viewSize.width - 10, [SingleInstance customFontHeightFont:content andFontSize:18 andLineWidth:viewSize.width - 10]);
    RTLabel *privateLable = [[RTLabel alloc]initWithFrame:frame];
    privateLable.text = content;
    privateLable.delegate = self;
    privateLable.font = [UIFont systemFontOfSize:16];
    privateLable.lineSpacing = 4;
    scrollView.contentSize = CGSizeMake(viewSize.width - 10, frame.size.height);
    
    [scrollView addSubview:privateLable];
    [self.view addSubview:view];
    [self.view addSubview:scrollView];
    
}
//// 点击超链接调用的程序
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString = [NSString stringWithFormat:@"%@",url];
    urlString = [[urlString componentsSeparatedByString:@"//"] lastObject];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",urlString]]];
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
