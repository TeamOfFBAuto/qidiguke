//
//  LoadToLocal.m
//  UNITOA
//
//  Created by qidi on 14-9-4.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import "LoadToLocal.h"

@implementation LoadToLocal
- (void)setURL:(NSString *)URL
{
    if(URL != _URL){
        _URL = URL;
    }
    
    if(self.URL)
    {
        //确定图片的缓存地址
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        // 沙盒路径下地AsyImage
        NSString *tmpPath=[docDir stringByAppendingPathComponent:@"AsynFile"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *lineArray = [self.URL componentsSeparatedByString:@"/"];
        self.fileName = [NSString stringWithFormat:@"%@/%@", tmpPath, [lineArray objectAtIndex:[lineArray count] - 1]];
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
        {
            //下载图片，保存到本地缓存中
            NSLog(@"%@",[lineArray objectAtIndex:[lineArray count] - 1]);
            //图片已经成功下载到本地缓存，指定图片
            if([loadData writeToFile:_fileName atomically:YES])
            {
                //self.image = [UIImage imageWithContentsOfFile:_fileName];
            }
            
            
        }
        else
        {
            
        }
    }

    
}
- (NSString *)getFileUrl:(NSString *)URL andfile:(NSData *)fileData
{
    if(URL != _URL){
        _URL = URL;
    }
    
    if(_URL)
    {
        //确定图片的缓存地址
        NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
        NSString *docDir=[path objectAtIndex:0];
        // 沙盒路径下地AsyImage
        NSString *tmpPath=[docDir stringByAppendingPathComponent:@"AsynFile"];
        
        NSFileManager *fm = [NSFileManager defaultManager];
        if(![fm fileExistsAtPath:tmpPath])
        {
            [fm createDirectoryAtPath:tmpPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        NSArray *lineArray = [self.URL componentsSeparatedByString:@"/"];
        _fileName = [NSString stringWithFormat:@"%@/%@", tmpPath, [lineArray lastObject]];
        //判断图片是否已经下载过，如果已经下载到本地缓存，则不用重新下载。如果没有，请求网络进行下载。
        if(![[NSFileManager defaultManager] fileExistsAtPath:_fileName])
        {
            //下载图片，保存到本地缓存中
            NSLog(@"%@",[lineArray objectAtIndex:[lineArray count] - 1]);
            //图片已经成功下载到本地缓存，指定图片
            if([fileData writeToFile:_fileName atomically:YES])
            {
                return _fileName;
            }
            
            
        }
        else
        {
            return _fileName;
        }
        
    }
    return nil;

}
-(void)dealloc
{
    
    

}
@end
