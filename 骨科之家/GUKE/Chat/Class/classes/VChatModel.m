//
//  VChatModel.m
//  VColleagueChat
//
//  Created by lqy on 4/29/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "VChatModel.h"

@implementation VChatModel
- (void)dealloc{
    
    
    SSRCSafeRelease(_title);
    SSRCSafeRelease(_firstname);
    SSRCSafeRelease(_firstUsername);
    SSRCSafeRelease(_icon);
    SSRCSafeRelease(_iconUpdateTime);
    SSRCSafeRelease(_creatDate);
    
    SSRCSafeRelease(_uid);
    SSRCSafeRelease(_userId);
    
    SSRCSafeRelease(_context);
    SSRCSafeRelease(_attachlist);
    
    SSRCSafeRelease(_virtualVoiceurl);
    SSRCSafeRelease(_virtualVoicelength);
    SSRCSafeRelease(_virtualPicurl);
    
    SSRCSafeRelease(_voiceurl);
    SSRCSafeRelease(_voiceLength);
    SSRCSafeRelease(_picurl);
    
    SSRCSafeRelease(_typeId);
    SSRCSafeRelease(_isGroupArticle);
    SSRCSafeRelease(_recvId);
    
    SSRCSafeRelease(_statusModel);
    SSRCSuperDealloc;
}

- (id)init{
    self = [super init];
    if (self) {
        StatusModel *staus = [[StatusModel alloc] init];
        self.statusModel = staus;
        SSRCRelease(staus);
        
        self.attachlist = [NSMutableArray array];
        
    }
    return self;
}
+ (NSArray *)vChatMakeModel:(NSArray *)datas{
    
    NSMutableArray *arr = [NSMutableArray array];
    if (datas && datas.count) {
        for (id dic in datas) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@",dic);
                VChatModel *model = [[[self class] alloc] init];
                id articleId = [dic objectForKey:@"articleId"];
                
                model.articleId = [articleId integerValue];
                model.title = [dic objectForKey:@"title"];
                
                id userid = [dic objectForKey:@"userId"];
                if (userid) {
                    model.userId = [NSString stringWithFormat:@"%@",userid];
                }
                
                model.firstname = [dic objectForKey:@"firstname"];
                model.firstUsername = [dic objectForKey:@"firstUsername"];
                model.icon = [dic objectForKey:@"icon"];
                model.iconUpdateTime = [dic objectForKey:@"iconUpdateTime"];
                
                model.creatDate = [dic objectForKey:@"createDate"];
                model.typeId = [dic objectForKey:@"typeId"];
                model.isGroupArticle = [dic objectForKey:@"isGroupArticle"];
                model.recvId = [dic objectForKey:@"recvId"];
                // 分享标记
                model.shareSource = [dic objectForKey:@"shareSource"];
                model.shareId = [dic objectForKey:@"shareId"];
                
                id attachlist = [dic objectForKey:@"attachlist"];
                model.attachlist = [NSMutableArray array];
                
                if (attachlist && [attachlist isKindOfClass:[NSArray class]]) {
                    for (id att in attachlist) {
                        if ([att isKindOfClass:[NSDictionary class]]) {
                            NSLog(@"attt --%@",att);
                            VChatAttachModel *attmodel = [[VChatAttachModel alloc] init];
                            NSLog(@"%@",att);
                            attmodel.attachId = [att objectForKey:@"attachId"];
                            attmodel.filename = [att objectForKey:@"filename"];
                            attmodel.fileurl = [att objectForKey:@"fileurl"];
                            attmodel.voiceLength = [NSString stringWithFormat:@"%@",[att objectForKey:@"voiceLength"]];
                            
                            if (attmodel.filename && attmodel.fileurl) {
                                
                                [model.attachlist addObject:attmodel];
                            }
                            
                            SSRCRelease(attmodel);
                        }
                    }
                    

                }
                
                
                if ([model.attachlist count]) {
                    // 取第一个附件
                    VChatAttachModel *fir = [model.attachlist firstObject];
                    NSString *attach1 = fir.filename;
                    if (attach1) {
                        if ([attach1 hasSuffix:@".amr"]) {
                            model.sendType = SEND_Type_voice;
                            
                            
                        }else if([attach1 hasSuffix:@".mp4"]){
                            model.sendType = SEND_Type_video;
                        }
                        else{
                             model.sendType = SEND_Type_photo;
                        }
                    }else{
                        model.sendType = SEND_Type_other;
                    }
                }else{
                    
                    model.sendType = SEND_Type_content;
                }
                
                model.context = [dic objectForKey:@"context"];
                
                if (model.articleId && model.sendType != SEND_Type_other) {
                    [arr addObject:model];
                }
                
                SSRCRelease(model);
            }
        }
    }
    
    return arr;
}
@end


@implementation VChatAttachModel
- (void)dealloc{
    
    SSRCSafeRelease(_attachId)
    SSRCSafeRelease(_displayHtml)
    SSRCSafeRelease(_voiceLength)
    SSRCSafeRelease(_filename)
    SSRCSafeRelease(_fileurl)
    SSRCSuperDealloc
}

@end