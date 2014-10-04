//
//  GcalendarViewController.m
//  GUKE
//
//  Created by gaomeng on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "GcalendarViewController.h"

#import "ITTBaseDataSourceImp.h"

#import "GcalendarDetailViewController.h"

#import "GeventSingleModel.h"

@interface GcalendarViewController ()
{
    ITTCalendarView *_calendarView;
}
@end

@implementation GcalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self loadNavigation];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *ldateStr = [[NSString stringWithFormat:@"%@",localeDate]substringToIndex:10];
    
    NSLog(@"===============%@",ldateStr);
    
    [self networkWithDate:ldateStr];
    
    
    
    
    
    
    
    
}







//请求网络数据
-(void)networkWithDate:(NSString *)theDate{
    
    
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"eventDate":theDate};
    
    
    [AFRequestService responseData:CALENDAR_ACTIVITIES andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSString * code = [dict objectForKey:@"code"];
        if ([code intValue]==0)//说明请求数据成功
        {
            NSLog(@"loadSuccess");
            
            NSLog(@"%@",dict);
            
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray *dataArray = [dict objectForKey:@"eventlist"];
                NSMutableArray *dicArray = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *dic in dataArray) {
                    [dicArray addObject:dic];
                }
                
                GeventSingleModel *singelModel = [GeventSingleModel sharedManager];
                singelModel.eventDateDicArray = dicArray;

                
                NSLog(@"%d",singelModel.eventDateDicArray.count);
                
            }
            
            
            _calendarView = [ITTCalendarView viewFromNib];
            ITTBaseDataSourceImp *dataSource = [[ITTBaseDataSourceImp alloc] init];
            //    _calendarView.date = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
            _calendarView.date = [NSDate date];
            _calendarView.dataSource = dataSource;
            _calendarView.delegate = self;
            _calendarView.frame = CGRectMake(0, 64, 320, 0);
            _calendarView.allowsMultipleSelection = TRUE;
            [_calendarView showInView:self.view];
            
            
            
            
        }else{
            NSLog(@"%d",[code intValue]);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendarViewDidSelectDay:(ITTCalendarView*)calendarView calDay:(ITTCalDay*)calDay{
    
    NSLog(@"--------- %@",calDay);
    NSLog(@"%d",[calDay getDay]);
    NSLog(@"%d",[calDay getMonth]);
    NSLog(@"%d",[calDay getYear]);
    
    NSString *calDayStr = [NSString stringWithFormat:@"%d-%d-%d",[calDay getYear],[calDay getMonth],[calDay getDay]];
    
    
    
    
    for (NSDictionary *dic in [GeventSingleModel sharedManager].eventDateDicArray) {
        
        NSLog(@"%@",dic);
        NSString *dateStr = [dic objectForKey:@"eventDate"];
        
        NSLog(@"%@",dateStr);
        
        if ([calDayStr isEqualToString:dateStr]) {
            GcalendarDetailViewController *gdvc = [[GcalendarDetailViewController alloc]init];
            gdvc.calDay = calDay;
            [self.navigationController pushViewController:gdvc animated:YES];
        }
        
        
        
    }
    
    
    
}

//- (void)calendarViewDidSelectPeriodType:(ITTCalendarView*)calendarView periodType:(PeriodType)periodType{
//    NSLog(@"%s",__FUNCTION__);
//}






// 导航的设置
- (void)loadNavigation
{
    UIView *bgNavi = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 190, 44)];
    bgNavi.backgroundColor = [UIColor clearColor];
    bgNavi.userInteractionEnabled = YES;
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"guke_top_logo_arrow@2x" ofType:@"png"]]];
    
    logoView.backgroundColor = [UIColor clearColor];
    logoView.frame = CGRectMake(0, 4, 36, 36);
    
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.userInteractionEnabled = YES;
    
    UILabel *loginLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 7, 160, 30)];
    loginLabel.text = @"会议日程";
    loginLabel.textColor = [UIColor whiteColor];
    loginLabel.backgroundColor = [UIColor clearColor];
    loginLabel.font = [UIFont systemFontOfSize:16];
    [bgNavi addSubview:logoView];
    [bgNavi addSubview:loginLabel];
    loginLabel = nil;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gPoPu)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [logoView addGestureRecognizer:tap];
    tap = nil;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:bgNavi];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)gPoPu{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
