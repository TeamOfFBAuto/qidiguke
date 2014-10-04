//
//  AboutProduceViewController.m
//  UNITOA
//
//  Created by qidi on 14-9-16.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "AboutProduceViewController.h"
#import "SingleInstance.h"
@interface AboutProduceViewController ()

@end

@implementation AboutProduceViewController

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
    [self navigetion];
    self.view.backgroundColor = [UIColor whiteColor];
    [self layoutView];
}
- (void)layoutView{
    NSString *content = [NSString  stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"produce" ofType:@"txt"] encoding:NSUTF8StringEncoding error:nil];
    CGFloat height = [SingleInstance customFontHeightFont:content andFontSize:19 andLineWidth:viewSize.width - 10];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pruduce_logo@2x"]];
    CGRect frame = CGRectMake((viewSize.width - 80)/2, 10, 80, 80);
    imageView.frame = frame;
    
    CGRect frame1 = CGRectMake((viewSize.width - 90)/2, frame.origin.y+frame.size.height, 90, 22);
    UILabel *regLabel = [[UILabel alloc]initWithFrame:frame1];
    regLabel.text = LOCALIZATION(@"version_num");
    regLabel.textAlignment = NSTextAlignmentCenter;
    regLabel.textColor = [SingleInstance colorFromHexRGB:@"#666666"];
    regLabel.font = [UIFont boldSystemFontOfSize:16];
    
    CGRect frame2 = CGRectMake(5, frame1.origin.y+frame1.size.height +5, viewSize.width - 10, height);
    RTLabel *productLable = [[RTLabel alloc]initWithFrame:frame2];
    productLable.text = content;
    productLable.delegate = self;
    productLable.font = [UIFont systemFontOfSize:16];
    productLable.lineSpacing = 4;
    scrollView.contentSize = CGSizeMake(viewSize.width - 10, frame.size.height);
    
    scrollView.contentSize = CGSizeMake(frame2.origin.x, frame2.origin.y + frame2.size.height);
    [scrollView addSubview:imageView];
    [scrollView addSubview:regLabel];
    [scrollView addSubview:productLable];
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
- (void)navigetion
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"return_unis_logo@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 0, 44, 44);
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 7, 160, 30)];
    loginLabel.text = LOCALIZATION(@"about_produce");
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
