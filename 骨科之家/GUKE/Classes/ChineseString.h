//
//  ChineseString.h
//  ChineseSort
//
//  Created by Bill on 12-8-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendIfo.h"
@interface ChineseString : NSObject

@property(nonatomic, strong)NSString *string;
@property(nonatomic, strong)NSString *pinYin;
@property(nonatomic, strong)FriendIfo *friendModel;
@end
