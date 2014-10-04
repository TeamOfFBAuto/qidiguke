//
//  ContactsItem.m
//  VColleagueChat
//
//  Created by lqy on 4/27/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "ContactsItem.h"

@implementation ContactsItem
@synthesize fullName = _fullName,indexKey = _indexKey;

- (void)dealloc{
    SSRCSafeRelease(_fullName)
    SSRCSafeRelease(_indexKey)
    SSRCSafeRelease(_icon)
    
    SSRCSafeRelease(_userId)
    
    SSRCSafeRelease(_username)
    SSRCSuperDealloc
}

- (NSString *)getItemIndexKeyForKeyName{
    //get fullname key for index
    if ([_fullName canBeConvertedToEncoding: NSASCIIStringEncoding]) {
        //english encoding
        return _fullName;
    }else{
        //if china code return pinyin.. else return #
        return @"#";
    }
}
// 获取用户的信息
+ (NSArray *)contactsItemMake:(NSArray *)datas{
    NSMutableArray *itemArr = [NSMutableArray array];
    for (id obj in datas) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            ContactsItem *item = [[ContactsItem alloc] init];
            
            item.fullName = [obj objectForKey:@"firstname"];
            item.icon = [obj objectForKey:@"icon"];
            item.userId = [obj objectForKey:@"userId"]?[NSString stringWithFormat:@"%@",[obj objectForKey:@"userId"]]:nil;
            item.username = [obj objectForKey:@"username"]?[NSString stringWithFormat:@"%@",[obj objectForKey:@"username"]]:nil;
            [itemArr addObject:item];
            SSRCRelease(item);
        }
    }
    
    return itemArr;
}
@end
