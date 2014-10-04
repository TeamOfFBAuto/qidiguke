//
//  GeventSingleModel.h
//  GUKE
//
//  Created by gaomeng on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeventSingleModel : NSObject


@property(nonatomic,strong)NSMutableArray *eventDateDicArray;

+ (GeventSingleModel *)sharedManager;

@end
