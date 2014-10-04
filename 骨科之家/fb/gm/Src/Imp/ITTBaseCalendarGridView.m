//
//  BaseCalendarGridView.m
//  ZHJCalendar
//
//  Created by huajian zhou on 12-4-12.
//  Copyright (c) 2012年 itotemstudio. All rights reserved.
//

#import "ITTBaseCalendarGridView.h"
#import "GeventSingleModel.h"

@interface ITTBaseCalendarGridView()

@property (retain, nonatomic) IBOutlet UIButton *gridButton;

@end

@implementation ITTBaseCalendarGridView

@synthesize gridButton;

- (IBAction)onGridButtonTouched:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(calendarGridViewDidSelectGrid:)]) {
        [_delegate ittCalendarGridViewDidSelectGrid:self];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)select
{
    self.selected = TRUE;
    self.gridButton.selected = TRUE; 
    self.gridButton.userInteractionEnabled = FALSE;
}

- (void)deselect
{
    self.selected = FALSE;
    self.gridButton.selected = FALSE;
    self.gridButton.userInteractionEnabled = TRUE;    
}

- (void)layoutSubviews
{
#pragma mark - 给每天的btn赋值
    NSString *title = [NSString stringWithFormat:@"%d", [_calDay getDay]];
    
    //还原btn标记 (今日)
    [self.gridButton setBackgroundImage:[UIImage imageNamed:@"btn_grid.png"] forState:UIControlStateNormal];
    [self.gridButton setBackgroundImage:[UIImage imageNamed:@"btn_grid.png"] forState:UIControlStateSelected];
    
    //活动
    [self.gridButton setBackgroundColor:[UIColor clearColor]];
    //触摸跳转
    self.gridButton.userInteractionEnabled = YES;
    
    
    NSString *daystr = nil;
    //转日
    if ([title intValue]<10) {
        daystr = [NSString stringWithFormat:@"%@%@",@"0",title];
        NSLog(@"%@",daystr);
    }else{
        daystr = [NSString stringWithFormat:@"%@",title];
    }
    //转月
    NSString *monthStr = [NSString stringWithFormat:@"%d",[_calDay getMonth]];
    if ([monthStr intValue]<10) {
        monthStr = [NSString stringWithFormat:@"%@%@",@"0",monthStr];
    }else{
        
    }
    NSString *yearStr = [NSString stringWithFormat:@"%d",[_calDay getYear]];
    
    NSString *btnStr = [NSString stringWithFormat:@"%@%@%@",yearStr,monthStr,daystr];
    NSLog(@"每个btn的日期:------%@",btnStr);
    
    NSDate *date = [NSDate date];
    NSString *lDateStr = [[[NSString stringWithFormat:@"%@",date]substringToIndex:10]stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"本地时间:-----%@",lDateStr);
    
    
    if (_selectedEanable) {
//        self.gridButton.selected = self.selected;
        [self.gridButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
        
    }
    else {
//        self.gridButton.selected = FALSE;
        [self.gridButton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        
    }
    
    
    if ([btnStr isEqualToString:lDateStr]) {
        
        [self.gridButton setBackgroundImage:[UIImage imageNamed:@"btn_grid_cell_highlight.png"] forState:UIControlStateNormal];
        [self.gridButton setBackgroundImage:[UIImage imageNamed:@"btn_grid_cell_highlight.png"] forState:UIControlStateSelected];
        
        
    }
    
    GeventSingleModel *singelModel = [GeventSingleModel sharedManager];
    
    for (NSDictionary *dic in singelModel.eventDateDicArray) {
        
        NSString *dateStr = [dic objectForKey:@"eventDate"];
        NSString *dateStrDelete_ = [dateStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        NSLog(@",,,,%@",dateStrDelete_);
        
        
        if ([dateStrDelete_ isEqualToString:btnStr]) {
            
            NSLog(@"???????????%@",btnStr);
            self.gridButton.userInteractionEnabled = NO;
            
            if ([[dic objectForKey:@"eventStatus"]intValue]) {//1为已报名
                [self.gridButton setBackgroundColor:[UIColor greenColor]];
            }else{
                [self.gridButton setBackgroundColor:[UIColor redColor]];
                break;
            }
            
            
        }else{
            self.gridButton.userInteractionEnabled = YES;
        }
    }

    
    
    [self.gridButton setTitle:title forState:UIControlStateNormal];
    
    
    
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsLayout];
}

- (void)dealloc 
{
    [gridButton release];
    [super dealloc];
}
@end
