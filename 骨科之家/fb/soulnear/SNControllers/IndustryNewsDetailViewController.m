//
//  IndustryNewsDetailViewController.m
//  GUKE
//
//  Created by soulnear on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "IndustryNewsDetailViewController.h"
#import "NewsDetailCell.h"

@interface NewsDetailModel ()

@end

@implementation NewsDetailModel
@synthesize attachId = _attachId;
@synthesize dongtaiId = _dongtaiId;
@synthesize filename = _filename;
@synthesize filesize = _filesize;
@synthesize fileurl = _fileurl;

-(id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _attachId = [dic objectForKey:@"attachId"];
        _dongtaiId = [dic objectForKey:@"dongtaiId"];
        _filename = [dic objectForKey:@"filename"];
        _filesize = [dic objectForKey:@"filesize"];
        _fileurl = [dic objectForKey:@"fileurl"];
    }
    return self;
}



@end


@interface IndustryNewsDetailViewController ()
{
    ///存放数据（包括标题图片）
    NSMutableArray * data_array;
    ///文章标题
    NSString * my_title;
    ///文章内容
    NSString * my_content;
    ///视图
    UITableView * myTableView;
}

@end

@implementation IndustryNewsDetailViewController
@synthesize theId = _theId;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.aTitle = @"业界动态";
    self.view.backgroundColor = [UIColor whiteColor];
    data_array = [NSMutableArray array];
    
    myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    if (IOS7_LATER) {
        myTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    
    [self loadNewsDetailData];
}


#pragma mark - 数据请求
-(void)loadNewsDetailData
{
    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"dongtaiId":_theId};
    
    [AFRequestService responseData:INDUSTRY_NEWS_DETAIL_URL andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        NSLog(@"dic -----  %@",dict);
        if ([[dict objectForKey:@"code"] intValue] == 0)
        {
            NSArray * array = [[dict objectForKey:@"dongtai"] objectForKey:@"attachlist"];
            if (![array isKindOfClass:[NSNull class]]) {
                for (NSDictionary * dic in array) {
                    NewsDetailModel * model = [[NewsDetailModel alloc] initWithDic:dic];
                    [data_array addObject:model];
                }
            }
            
            my_content = [[dict objectForKey:@"dongtai"] objectForKey:@"content"];
            my_title = [[dict objectForKey:@"dongtai"] objectForKey:@"title"];
            
            if (my_content.length >0 && ![my_content isKindOfClass:[NSNull class]]) {
                [data_array addObject:my_content];
            }
            if (my_title.length >0 && ![my_title isKindOfClass:[NSNull class]]) {
                [data_array insertObject:my_title atIndex:0];
            }
            [myTableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data_array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (data_array.count &&[[data_array objectAtIndex:indexPath.row] isKindOfClass:[NewsDetailModel class]])
    {
        NewsDetailModel * model = [data_array objectAtIndex:indexPath.row];
        
        float image_height = 0;
        
        if (model.filename.length > 0 && ![model.filename isKindOfClass:[NSNull class]])
        {
            CGRect rectr = [model.filename boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
            image_height = rectr.size.height+20;
        }
        
        if (model.fileurl.length > 0 && ![model.fileurl isKindOfClass:[NSNull class]])
        {
            image_height += 150 + 20;
        }
        
        return image_height;
    }else
    {
        if (data_array.count > indexPath.row && [[data_array objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
        {
            NSString * string = [data_array objectAtIndex:indexPath.row];
            CGRect rectr = [string boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
            return rectr.size.height+20;
        }else
        {
            return 0;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    NewsDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NewsDetailCell" owner:self options:nil] objectAtIndex:0];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.myImageView.center = CGPointMake(DEVICE_WIDTH/2,cell.myImageView.center.y);
    cell.image_name_label.center = CGPointMake(DEVICE_WIDTH/2,cell.image_name_label.center.y);
    
    if (data_array.count > indexPath.row && [[data_array objectAtIndex:indexPath.row] isKindOfClass:[NewsDetailModel class]])
    {
        NewsDetailModel * model = [data_array objectAtIndex:indexPath.row];
        [cell.myImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGE_BASE_URL,model.fileurl]] placeholderImage:[UIImage imageNamed:@"guke_image_loading"]];
        cell.image_name_label.text = [NSString _859ToUTF8:model.filename];
        
        CGRect rectr = [model.filename boundingRectWithSize:CGSizeMake(DEVICE_WIDTH-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15]} context:nil];
        cell.image_name_label.numberOfLines = 0;
        CGRect lableFrame = cell.image_name_label.frame;
        lableFrame.size.height = rectr.size.height;
        cell.image_name_label.frame = lableFrame;
    }
    
    if (data_array.count > indexPath.row && [[data_array objectAtIndex:indexPath.row] isKindOfClass:[NSString class]])
    {
        cell.imageView.image = nil;
        cell.image_name_label.text = @"";
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.text = [NSString _859ToUTF8:[data_array objectAtIndex:indexPath.row]];
        
    }
    
    return cell;
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
