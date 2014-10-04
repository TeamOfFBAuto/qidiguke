//
//  VChatViewController.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
	VChatType_VC = 0,
	VChatType_pChat,
    VChatType_pGroup,
} VChatType;
typedef enum{
	SEND_Type_content = 0,
	SEND_Type_photo,
	SEND_Type_voice,
    SEND_Type_other,
} SEND_TYPE;

@interface VChatViewController : UIViewController<UIActionSheetDelegate>

@property (nonatomic,retain) NSNumber *recvId;
@property (nonatomic,retain) NSString *recvName;
@property (nonatomic,retain) NSString *recvFirstName;
@property (nonatomic) VChatType type;

@end
