//
//  GrouplistsTableViewCell.m
//  VColleagueChat
//
//  Created by lqy on 4/24/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#define group_margin 10.0f
#define group_default_side 45.0f

#import "GrouplistsTableViewCell.h"
#import "LatestListModel.h"
#import "VChatModel.h"
#import <QuartzCore/QuartzCore.h>
@interface GrouplistsTableViewCell(){
    UIImageView *imgView;
    UILabel *titleLab;
    UILabel *contentLab;
    UIButton *detailBtn;
    UILabel *groupTypeLab;
    UIView *new;
}

@property (nonatomic) BOOL type;
@end



@implementation GrouplistsTableViewCell

- (void)dealloc{
//    [detailBtn release];
    [new release];
    [contentLab release];
    [groupTypeLab release];
    [titleLab release];
    [imgView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier type:NO];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(BOOL)sys{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.type = sys;
        [self initialization];
    }
    return self;
}
//- (void)awakeFromNib
//{
//    // Initialization code
//}
- (void)prepareForReuse{
    [super prepareForReuse];
    imgView.image = nil;
    new.alpha = 0;
    titleLab.text = nil;
    contentLab.text = nil;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    titleLab.frame = CGRectMake(2*group_margin+group_default_side, group_margin, 100, 30);
    contentLab.frame = CGRectMake(titleLab.frame.origin.x, titleLab.frame.origin.y+25, 200, 20);
    detailBtn.frame = CGRectMake(250, group_margin, 50, 30);
    groupTypeLab.frame = CGRectMake(200, detailBtn.frame.origin.y+30, 100, 20);
}

- (void)initialization{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(group_margin, group_margin, group_default_side, group_default_side)];
    [self.contentView addSubview:imgView];
    
    titleLab = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLab.font = [UIFont systemFontOfSize:15];
    titleLab.textColor = [UIColor purpleColor];
    titleLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:titleLab];
    
    contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
    contentLab.font = [UIFont systemFontOfSize:12];
    contentLab.textColor = [UIColor grayColor];
    contentLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:contentLab];
    
    new = [[UIView alloc] initWithFrame:CGRectMake(group_default_side-5, -5, 10, 10)];
    new.backgroundColor = [UIColor redColor];
    new.layer.cornerRadius = 5;
    [imgView addSubview:new];
    
        detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailBtn setBackgroundImage:[UIImage imageNamed:@"button_bj.png"] forState:UIControlStateNormal];
        [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        detailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [detailBtn addTarget:self action:@selector(detailClick) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:detailBtn];
        
        groupTypeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        groupTypeLab.font = [UIFont systemFontOfSize:14];
        groupTypeLab.textColor = RGBA(110, 110, 110, 1);
        groupTypeLab.backgroundColor = [UIColor clearColor];
        groupTypeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:groupTypeLab];
    
    
}
+ (CGFloat)heightForViewWithObject:(id)object{
    CGFloat height = group_default_side + 2*group_margin;
    return height;
}
- (void)fillViewWithObject:(id)object{
#warning test
    imgView.image = [UIImage imageNamed:@"group_default.png"];
    titleLab.text = object;
    if (!_type) {
       groupTypeLab.text = @"普通群";
    }
}
- (void)fillViewWithObject:(id)object withObject:(NSInteger)obty withType:(BOOL)showType{
    imgView.image = [UIImage imageNamed:@"group_default.png"];
    NSString *cc = nil;
    NSString *group = nil;
    BOOL showDetail = NO;
    if (obty == 1) {
        titleLab.text = [object l_groupName];
        SEND_TYPE t = [[object latestArticleModel] sendType];
        
        if (t == SEND_Type_content) {
            cc = [[object latestArticleModel] context];
        }else if (t == SEND_Type_voice){
            cc = @"[语音]";
        }else if (t == SEND_Type_photo){
            cc = @"[图片]";
        }
        group = @"普通群";
        showDetail = YES;
    }else if (obty == 0){
        titleLab.text = @"V聊";
        group = nil;
        showDetail = NO;
        
        SEND_TYPE t = [[object latestArticleModel] sendType];
        
        if (t == SEND_Type_content) {
            cc = [[object latestArticleModel] context];
        }else if (t == SEND_Type_voice){
            cc = @"[语音]";
        }else if (t == SEND_Type_photo){
            cc = @"[图片]";
        }
    }else if (obty == 2){
        //最近聊天
        titleLab.text = [object c_contactName];
        SEND_TYPE t = [[object latestArticleModel] sendType];
        if (t == SEND_Type_content) {
            cc = [[object latestArticleModel] context];
        }else if (t == SEND_Type_voice){
            cc = @"[语音]";
        }else if (t == SEND_Type_photo){
            cc = @"[图片]";
        }
        
        if ([[object c_contactType] isEqualToString:@"6"]) {
            group = nil;
            showDetail = NO;
        }else{
            group = @"普通群";
            showDetail = YES;
        }
    }
    detailBtn.alpha = showDetail?1:0;
    groupTypeLab.text = group;
    contentLab.text = cc;
    
    
    if ([object isNewMsg]) {
        new.alpha = 1;
    }else{
        new.alpha = 0;
    }
}
- (void)detailClick{
    if (self.delegate && [self.delegate respondsToSelector:@selector(detailCell:)]) {
        [_delegate detailCell:self];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
