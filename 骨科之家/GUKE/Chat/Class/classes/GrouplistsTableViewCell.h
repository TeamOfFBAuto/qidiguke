//
//  GrouplistsTableViewCell.h
//  VColleagueChat
//
//  Created by lqy on 4/24/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GrouplistsTableViewCellDelegate;
@interface GrouplistsTableViewCell : UITableViewCell{

}
+ (CGFloat)heightForViewWithObject:(id)object;
- (void)fillViewWithObject:(id)object;
- (void)fillViewWithObject:(id)object withObject:(NSInteger)obty withType:(BOOL)showType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier type:(BOOL)sys;

#if ! __has_feature(objc_arc)
@property (nonatomic,assign) id <GrouplistsTableViewCellDelegate> delegate;
#else
@property (nonatomic,unsafe_unretained) id <GrouplistsTableViewCellDelegate> delegate;
#endif

@end

@protocol GrouplistsTableViewCellDelegate <NSObject>

- (void)detailCell:(GrouplistsTableViewCell *)cell;

@end
