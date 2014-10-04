//
//  BinglilistModel.m
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "BinglilistModels.h"

#import "BingLiListFeed.h"


@implementation BinglilistModels





-(void)setBinglilistModelDatawithBloc:(BinglilistModelsBloc)theBloc{
    
    if (!self.feedArr) {
        self.feedArr=[NSMutableArray array];
    }
    self.mybloc=theBloc;

    NSDictionary *parameters = @{@"userId":GET_U_ID,@"sid":GET_S_ID,@"pageSize":@"20",@"page":@"1"};
    
    __weak typeof(self)wself=self;
    
    
    [AFRequestService responseData:BINGLI_LIST andparameters:parameters andResponseData:^(id responseData) {
        
        NSDictionary * dict = (NSDictionary *)responseData;
        
        wself.code=[NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        wself.page=[NSString stringWithFormat:@"%@",[dict objectForKey:@"page"]];
        wself.pageCount=[NSString stringWithFormat:@"%@",[dict objectForKey:@"pageCount"]];
        wself.recordCount=[NSString stringWithFormat:@"%@",[dict objectForKey:@"recordCount"]];

        
        NSString * code = [dict objectForKey:@"code"];
        
        NSLog(@"xxxxx======%@",dict);

        
        if ([code intValue]==0)//说明请求数据成功
        {
            NSArray * array = [dict objectForKey:@"binglilist"];
            
            for (NSDictionary * dic in array) {
                
                BingLiListFeed *feed=[[BingLiListFeed alloc]init];
                
                [feed setBingLiListFeedDic:dic];
                
                [wself.feedArr addObject:feed];
                
            }
            
            
        }
        
    }];
}


@end
