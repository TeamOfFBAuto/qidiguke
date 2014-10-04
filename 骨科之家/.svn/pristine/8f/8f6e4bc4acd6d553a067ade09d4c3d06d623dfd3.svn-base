//
//  CommentTableView.m
//  UNITOA
//
//  Created by qidi on 14-7-18.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "CommentTableView.h"
#import "contentAndGood.h"
#import "Interface.h"
@implementation CommentTableView
-(void)dealloc{
    self.tableView = nil;
    self.commentArray = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor clearColor];
        self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView registerClass:[CommentTableViewCell class] forCellReuseIdentifier:@"cell1"];
        self.tableView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}
- (void)setCommentArray:(NSMutableArray *)commentArray
{
    _commentArray = nil;
    _commentArray = commentArray;
    CGFloat commentHeight = 0.0;
    for (contentAndGood *modle in _commentArray) {
        commentHeight = commentHeight + [SingleInstance customFontHeightFont:modle.context andFontSize:14 andLineWidth:245] ;
    }
    commentHeight = commentHeight + [commentArray count] *4 + 15;
    self.tableView.frame = CGRectMake(3, 2,250, commentHeight);
    [self.tableView reloadData];
}
#pragma mark ====== TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.commentArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
    contentAndGood *commentModel = (contentAndGood *)self.commentArray[indexPath.row];
    cell.nameBtn.frame = CGRectMake(0, 0, 40, 20);
    [cell.nameBtn setTitle:commentModel.userId forState:UIControlStateNormal];   
    // 评论的内容
    NSString *contactString =[NSString stringWithFormat:@"<font size=13 color='#576b95'><a href='%@' style=text-decoration:none>%@: </a></font>%@",commentModel.userId,commentModel.userName,commentModel.context];
    NSLog(@"%@",commentModel.userName);
    [cell.rtLabel setFont:[UIFont systemFontOfSize:13]];
    cell.rtLabel.frame = CGRectMake(0, 0, self.frame.size.width-5, [SingleInstance customFontHeightFont:commentModel.context andFontSize:15 andLineWidth:245]);
    cell.rtLabel.delegate = self;
    [cell.rtLabel setText:contactString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    contentAndGood *commentModel = (contentAndGood *)self.commentArray[indexPath.row];
    return [SingleInstance customFontHeightFont:commentModel.context andFontSize:14 andLineWidth:245] + 4;
}
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL *)url
{
    NSString *userId = [NSString stringWithFormat:@"%@",url];
    self.blockAction(userId);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
