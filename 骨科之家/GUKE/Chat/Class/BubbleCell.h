//
//  BubbleCell.h
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

typedef enum{
	SEND_Type_content_cell = 0,//文本
	SEND_Type_photo_cell,//图片
	SEND_Type_voice_cell,//语音发送
} SEND_TYPE_cell;

typedef enum{
	IndicatorTypeNormal = 0,//菊花停止
	IndicatorTypeSending,//菊花转动
} IndicatorType;
typedef enum{
	FaildViewTypeNormal = 0,//
	FaildViewTypeFaild,//发送失败
} FaildViewType;

#import <UIKit/UIKit.h>
@protocol BubbleCellDelegate;
typedef void(^PhotoTapBlock)(NSString *);

@interface BubbleCell : UITableViewCell{
    UILabel *_idateLable;
    UILabel *_unameLable;
    UIImageView *_uphotoImageView;
    UIButton *_bubbleImageView;
    UIActivityIndicatorView *_activityIndicatorView;
    UIButton *_senderFaildImageView;
    id <BubbleCellDelegate> _delegate;
    @public BOOL _isSelfSendGlo;
    BOOL _isShowDate;
}
#if !__has_feature(objc_arc)
@property (nonatomic,assign) id <BubbleCellDelegate> delegate;
@property (nonatomic,assign) BOOL isSelfSendGlo;
@property (nonatomic,assign) BOOL isShowDate;
@property (nonatomic,assign) IndicatorType indicatorType;
@property (nonatomic,assign) FaildViewType faildViewType;

@property (nonatomic,retain) id object;

#else
#warning ----
@property (nonatomic) id <BubbleCellDelegate> delegate;
@property (nonatomic) BOOL isSelfSendGlo;
@property (nonatomic) BOOL isShowDate;
@property (nonatomic) IndicatorType indicatorType;
@property (nonatomic) FaildViewType faildViewType;
@property (nonatomic,strong) id object;

#endif

@property (nonatomic,copy) PhotoTapBlock block;
+ (CGFloat)heightForViewWithObject:(id)object;

+ (CGFloat)heightForIdateMarginUpOffset:(BOOL)isshowdate;//up margin

- (void)fillViewWithObject:(id)object;
- (void)layoutSuperBefor;

@end

#pragma mark----------------context---------------
@interface BubbleSubTextCell : BubbleCell
@end

#pragma mark-----------------voice---------------

@interface BubbleSubVoiceCell : BubbleCell
- (void)restoreDisplayWithIsSelfSend:(BOOL)isSelfSend;
//还原录音图
- (void)updateVoiceImage:(NSInteger)index withSender:(BOOL)isSelfSend;
-(void)startVoicePlaybalck;
-(void)stopVocicePlaybalck;
@end

#pragma mark----------------picture-------------
@interface BubbleSubImageCell : BubbleCell{
    UIImageView *_pictureImageView;
}
@property (nonatomic,strong)UIImageView *pictureImageView;
@end
#pragma mark----------------shareSource-------------
@interface BubbleSubShareCell : BubbleCell{
    UIImageView *_pictureImageView;
}
@property (nonatomic,strong)UIImageView *pictureImageView;
@end
//代理协议 回调
@protocol BubbleCellDelegate <NSObject>
@optional
// 对文字进行操作的代理方法
- (void)pageExcBubbleClickText:(id)cell with:(id)object;
// 对图片点击触发事件的代理方法
- (void)pageExcBubbleClickImage:(id)cell;
// 对图片长按触发的点击事件
- (void)longPageExcBubbClickImage:(id)object;
//点击cell触发voice播放文件
- (void)pageExcBubble:(id)cell with:(id)content;
// 对voice的cell长按触发重发事件
- (void)longPageExcBubb:(id)object;

@end


