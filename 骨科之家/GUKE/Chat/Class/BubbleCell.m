//
//  BubbleCell.m
//  VColleagueChat
//
//  Created by Ming Zhang on 14-4-20.
//  Copyright (c) 2014年 laimark.com. All rights reserved.
//

#define BUBBLE_LABLE_WIGHT 160  //最长横条字的长度
#define FORTSIZE 16  //字体
//头像宽度
#define  HEAD_WIDTH  50.0f
//左右间隔
#define  SPACE_LEFT  10.0f

//bubble下移高度 这个是相对的
#define THEBUBLLE_FOLLOWINGOFFSET  0.0f

//头像在Cell中上下的间距 包括 bubble的下间距
#define HEAD_CELL_SPACE  5.0f
#define HEAD_CELL_SPACE_DOWN 2.0f
//图片底部带有的阴影
#define SPACE_IMAGE_BUBBLE_SHADOW 2.0f



//图片发送
//图片展示的宽高 max 最大化的
#define PHOTO_GALLERY_SIZE_WIDTH 80.0f
#define PHOTO_GALLERY_SIZE_HEIGHT 80.0f

//姓名字体大小
#define NAME_FONT FONT_ARIAL(13)

//尖角长度
#define ANGLE_LENTH  5.0f
//图片右带有的阴影所占
#define SPACE_IMAGE_BUBBLE_SHADOW_RIGHT 0.0f

//字体在输入框靠近尖角的距离和远离尖角的距离
#define THEFONT_NEAR_OFFSET  25.0f
#define THEFONT_FAR_OFFSET 15.0f

#define NAMELABLE_HEIGHT 14

#define NAMELABLE_HEIGHT02 14//放在名字下面的
/**
 & THE_IDATELABLE_HEIGHT总高度*/
#define THE_IDATE_HEIGHT 30.0f//总高度
#define IDATE_LBLE_MARGIN 1.0f
/**
 & idatelable 的高度
 */
#define THE_IDATELABLE_HEIGHT (THE_IDATE_HEIGHT-IDATE_LBLE_MARGIN)/2.0f

#define THE_IDATELABLE_WIDTH_MAX 140.0f
#define THE_IDATELABLE_WIDTH_MIN 60.0f

#define THE_IDATELABLE_DOWN 5.0f //下移一点 这个最好包含在自己的高度里面

#define BUBBLE_MIN_HEIGHT 45 //汽泡 最小高度

#define HEADER_BUBBLE_DIS 0.0f// 冒泡和头像之间的距离

#define TYPE_CELL 1

#define TEST_IDATE YES

#define UPIMAHE_TAG 10343

#import "BubbleCell.h"

#import "VChatModel.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImageView+WebCache.h"
#import "UserInfoDB.h"
#import "VChatViewController.h"
#import "SqliteBase.h"
#import "SingleInstance.h"

@implementation BubbleCell

#if !__has_feature(objc_arc)
- (void)dealloc{
    self.object = nil;
    [super dealloc];
}
#endif

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildMCell];
    }
    return self;
}

- (void)layoutSuperBefor{
    
    //子类只需要直接调用 self layoutSuperBefor
#warning faild frame 需要再子类重复定义 因为此时相对对象的位置不确定
    if (self.faildViewType == FaildViewTypeFaild && _isSelfSendGlo) {
        _senderFaildImageView.frame = CGRectMake(_bubbleImageView.frame.origin.x-30, _uphotoImageView.frame.origin.y+5, 20, 20);
        _senderFaildImageView.alpha = 1.0f;
    }else{
        _senderFaildImageView.frame = CGRectZero;
        _senderFaildImageView.alpha = 0.0f;
    }
#warning indicator frame 需要再子类重复定义 因为此时相对对象的位置不确定
    if (self.indicatorType == IndicatorTypeSending) {
        [_activityIndicatorView startAnimating];
        _activityIndicatorView.frame = CGRectMake(_bubbleImageView.frame.origin.x-30, _uphotoImageView.frame.origin.y+5, 20, 20);
        _activityIndicatorView.alpha = 1;
    }else{
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.frame = CGRectZero;
        _activityIndicatorView.alpha = 0;
    }
    
}
-(void)prepareForReuse{
    [super prepareForReuse];
    
    self.indicatorType = IndicatorTypeNormal;
    self.faildViewType = FaildViewTypeNormal;

    self.isSelfSendGlo = NO;
    _uphotoImageView.image = nil;//重置头像
#warning cache view need
    [_bubbleImageView setBackgroundImage:nil forState:UIControlStateNormal];
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.alpha = 0.0f;
    _senderFaildImageView.alpha = 0.0f;
    _senderFaildImageView.frame = CGRectZero;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (_isShowDate) {
        _idateLable.frame = CGRectMake((320-THE_IDATELABLE_WIDTH_MAX)/2.0f, IDATE_LBLE_MARGIN+10, THE_IDATELABLE_WIDTH_MAX, THE_IDATELABLE_HEIGHT);
    }else{
        _idateLable.frame = CGRectZero;
    }
    
    CGFloat upMargin  = [BubbleCell heightForIdateMarginUpOffset:_isShowDate];
    
    _uphotoImageView.frame = CGRectMake(SPACE_LEFT , upMargin, HEAD_WIDTH, HEAD_WIDTH);
    
    if (_isSelfSendGlo) {
        _uphotoImageView.frame = CGRectMake(320 - SPACE_LEFT - HEAD_WIDTH,HEAD_CELL_SPACE + (_isShowDate?THE_IDATE_HEIGHT:0), HEAD_WIDTH, HEAD_WIDTH);
        _unameLable.frame = CGRectZero;
    }else{
        _unameLable.frame = CGRectMake(0, _uphotoImageView.frame.origin.y+HEAD_WIDTH, HEAD_WIDTH+2*SPACE_LEFT, NAMELABLE_HEIGHT02);
    }
#warning testdata
    _uphotoImageView.backgroundColor = [UIColor grayColor];
}
-(void)buildMCell{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _uphotoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _uphotoImageView.layer.borderWidth = 1.5f;
    _uphotoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _uphotoImageView.layer.shadowRadius = 2;
    _uphotoImageView.layer.shadowOpacity = 1;
    //_uphotoImageView.layer.shadowColor = [UIColor grayColor].CGColor;
    
    _uphotoImageView.layer.masksToBounds = YES;
    _uphotoImageView.layer.backgroundColor = [[UIColor colorWithRed:.8 green:.8 blue:.8 alpha:1] CGColor];
    _uphotoImageView.userInteractionEnabled = YES;
    
    [self.contentView addSubview:_uphotoImageView];
    [_uphotoImageView release];
    
    
    _unameLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _unameLable.backgroundColor = [UIColor clearColor];
    _unameLable.textColor = [UIColor blackColor];
    _unameLable.font = NAME_FONT;
    _unameLable.textAlignment = NSTextAlignmentCenter;
    _unameLable.lineBreakMode = NSLineBreakByCharWrapping;
    [self.contentView addSubview:_unameLable];
    [_unameLable release];
    
    _bubbleImageView = [[UIButton alloc] initWithFrame:CGRectZero];
    _bubbleImageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_bubbleImageView];
    [_bubbleImageView release];
    
    _idateLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _idateLable.font = [UIFont systemFontOfSize:12.0f];
    _idateLable.layer.cornerRadius = 2.0f;
    _idateLable.layer.masksToBounds = YES;
    _idateLable.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    _idateLable.textAlignment = NSTextAlignmentCenter;
    _idateLable.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
    [self.contentView addSubview:_idateLable];
    [_idateLable release];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.frame = CGRectZero;
    _activityIndicatorView.alpha = 0.0f;
    [self.contentView addSubview:_activityIndicatorView];
    [_activityIndicatorView release];
    
    _senderFaildImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_senderFaildImageView setImage:[UIImage imageNamed:@"send_fail@2x"] forState:UIControlStateNormal];
    _senderFaildImageView.backgroundColor = [UIColor greenColor];
    //    _senderFaildImageView.contentEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    _senderFaildImageView.alpha = 0.0f;
    _senderFaildImageView.layer.cornerRadius = 10.0f;
    _senderFaildImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_senderFaildImageView];
    [_senderFaildImageView release];
}
// 父类的方法，共子类继承重载
- (void)fillViewWithObject:(id)object{
    self.object = object;
    
#warning testdata setter idate isself
    _isSelfSendGlo = [[object userId] isEqualToString:[NSString stringWithFormat:@"%@",GET_U_ID]] && [object userId];
    _isShowDate = TEST_IDATE;
    _idateLable.text = [object creatDate];
    
    
    UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:!_isSelfSendGlo?@"chatfrom_bg_voice_playing.9":@"chatto_bg_voice_playing.9" ofType:@"png"]];
    
    if (_isSelfSendGlo) {
        [_bubbleImageView setBackgroundImage:[bubble stretchableImageWithLeftCapWidth:8 topCapHeight:26] forState:UIControlStateNormal];
    }else{
        [_bubbleImageView setBackgroundImage:[bubble stretchableImageWithLeftCapWidth:12 topCapHeight:22] forState:UIControlStateNormal];
    }
    
    
    _unameLable.text = [object firstname];
    [_uphotoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GLOBAL_URL_FILEGET,[UserInfoDB selectFeildString:@"icon" andcuId:GET_U_ID anduserId:[object userId]]]] placeholderImage:[UIImage imageNamed:@"portrait_ico"]];
    _uphotoImageView.tag = UPIMAHE_TAG+[[object userId] intValue];
    // 添加手势
    UITapGestureRecognizer *photoTap = [[UITapGestureRecognizer alloc
                                         ] initWithTarget:self action:@selector(photoGesture:)];
    [_uphotoImageView addGestureRecognizer:photoTap];
    [photoTap release];
    
    ModelType modeltype = [[(VChatModel *)object statusModel] sendType];
    if (modeltype == Sending) {
        self.indicatorType = IndicatorTypeSending;
    }else{
        self.indicatorType = IndicatorTypeNormal;
    }
    if (modeltype == SendFailed || [[object isSend] isEqualToString:ISNOSENT]) {
        self.faildViewType = FaildViewTypeFaild;
    }else{
        self.faildViewType = FaildViewTypeNormal;
    }
}

- (void)photoGesture:(id)sender
{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSString *str = [NSString stringWithFormat:@"%d",tap.view.tag-UPIMAHE_TAG];
    self.block(str);
}


+ (CGFloat)heightForViewWithObject:(id)object{
    return 0.0f;
}

+ (CGFloat)heightForIdateMarginUpOffset:(BOOL)isshowdate{
    CGFloat height = HEAD_CELL_SPACE;
    if (isshowdate) {
        height += THE_IDATE_HEIGHT;
    }
    return height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end




@interface BubbleSubTextCell(){
    UILabel *_contentLable;
}
@end

@implementation BubbleSubTextCell

#if !__has_feature(objc_arc)
-(void)dealloc{
    [_contentLable release];
    [super dealloc];
}
#endif

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self buildCell];
    }
    return self;
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _contentLable.text = @"";
    _uphotoImageView.image = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
#warning self layout
    [self bubble];
}
#define CONTENT_FONT [UIFont systemFontOfSize:FORTSIZE]
-(void)buildCell{
    _contentLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _contentLable.font = [UIFont systemFontOfSize:FORTSIZE];
    _contentLable.lineBreakMode = NSLineBreakByCharWrapping;
    _contentLable.numberOfLines = 0;
    _contentLable.userInteractionEnabled = YES;

    _contentLable.backgroundColor = [UIColor clearColor];
    [_bubbleImageView addSubview:_contentLable];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(clickText:)];
    longPress.allowableMovement = 0.6;
    [self.contentView addGestureRecognizer:longPress];
}

#define SIZE_TEXT_HEIGTH [@"text" sizeWithFont:[UIFont systemFontOfSize:FORTSIZE] constrainedToSize:CGSizeMake(BUBBLE_LABLE_WIGHT,INT_MAX) lineBreakMode:NSLineBreakByCharWrapping]
#define THEFONTUPDOWNOFFSET (HEAD_WIDTH - SIZE_TEXT_HEIGTH.height)/2.0f

//#define THEFONTUPDOWNOFFSET 10
-(void)bubble{
    NSString *string = _contentLable.text;
    CGSize resultSize=[string?string:@" " sizeWithFont:[UIFont systemFontOfSize:FORTSIZE] constrainedToSize:CGSizeMake(BUBBLE_LABLE_WIGHT,INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];

    
    
    CGRect content_r = CGRectMake(THEFONT_NEAR_OFFSET, THEFONTUPDOWNOFFSET-3, resultSize.width, resultSize.height);
    
    CGFloat upMargin = [BubbleCell heightForIdateMarginUpOffset:_isShowDate];
    CGFloat bu_h =(resultSize.height+THEFONTUPDOWNOFFSET*2) - 5;
    CGFloat bubble_h = bu_h>BUBBLE_MIN_HEIGHT?bu_h:BUBBLE_MIN_HEIGHT;
    
    /**&名字在bubble上面的显示
    CGRect bubble_r = CGRectMake(SPACE_LEFT  + HEAD_WIDTH + HEADER_BUBBLE_DIS, HEAD_CELL_SPACE+ NAMELABLE_HEIGHT + THEBUBLLE_FOLLOWINGOFFSET+_idateLable.bounds.size.height, resultSize.width + THEFONT_NEAR_OFFSET + THEFONT_FAR_OFFSET, bubble_h);
     */
    CGRect bubble_r = CGRectMake(SPACE_LEFT  + HEAD_WIDTH + HEADER_BUBBLE_DIS, upMargin + THEBUBLLE_FOLLOWINGOFFSET, resultSize.width + THEFONT_NEAR_OFFSET + THEFONT_FAR_OFFSET, bubble_h);
    
    if (_isSelfSendGlo) {
        //        _contentLable.frame = CGRectMake(THEFONT_FAR_OFFSET, THEFONTUPDOWNOFFSET, _contentLable.frame.size.width, _contentLable.frame.size.height);
        content_r.origin.x = THEFONT_FAR_OFFSET;
        
        //        _bubbleImageView.frame = CGRectMake(320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) -_bubbleImageView.frame.size.width, HEAD_CELL_SPACE + THEBUBLLE_FOLLOWINGOFFSET + _idateLable.bounds.size.height, _bubbleImageView.frame.size.width, _bubbleImageView.frame.size.height);
        bubble_r.origin.x = 320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) -bubble_r.size.width;
//        bubble_r.origin.y = HEAD_CELL_SPACE + THEFONTUPDOWNOFFSET ;
    }
    _contentLable.frame = content_r;
    _bubbleImageView.frame = bubble_r;
    
    [self layoutSuperBefor];
}

#define teststr @"点击忘记密码怎么没有收到变更密码的段性呢?"
#pragma mark------ super fun
-(void)fillViewWithObject:(id)object{
    [super fillViewWithObject:object];
    _contentLable.text = [object context] ;
    
}
+ (CGFloat)heightForViewWithObject:(id)object{
#warning
    BOOL isShowdates = TEST_IDATE;
    
    NSString *str = [object context];
    CGFloat height = 0.0f;
    CGFloat height_min = [BubbleCell heightForIdateMarginUpOffset:isShowdates] + HEAD_CELL_SPACE_DOWN + HEAD_WIDTH + NAMELABLE_HEIGHT02;
    CGSize resultSize = [str sizeWithFont:[UIFont systemFontOfSize:FORTSIZE] constrainedToSize:CGSizeMake(BUBBLE_LABLE_WIGHT,INT_MAX) lineBreakMode:NSLineBreakByCharWrapping];
    
    CGFloat height1 = (resultSize.height + THEFONTUPDOWNOFFSET*2 +SPACE_IMAGE_BUBBLE_SHADOW ) +([BubbleCell heightForIdateMarginUpOffset:isShowdates] + HEAD_CELL_SPACE_DOWN + THEBUBLLE_FOLLOWINGOFFSET);
    height = height1>height_min?height1:height_min;
    
    
    return height ;
}

- (void)clickText:(UILongPressGestureRecognizer *)gesture{
        if(UIGestureRecognizerStateBegan == gesture.state) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(pageExcBubbleClickText:with:)]) {
                [self.delegate pageExcBubbleClickText:self with:[self object]];
            }
        }
        if(UIGestureRecognizerStateChanged == gesture.state) {
            return;
        }
        if(UIGestureRecognizerStateEnded == gesture.state) {
            return;
        }
}
@end




#pragma mark ----------------------------------语音----------------------------------
#pragma mark ----------------------------------语音----------------------------------
@interface BubbleSubVoiceCell(){
    UIImageView *_voiceImageView;
    
    UILabel *_lengthLable;
    UIView *_redLogo;
    
    NSArray *_voiceLeftImageArr;
    NSArray *_voiceRightImageArr;
    
    BOOL isAnimationVoice;
}
@end

@implementation BubbleSubVoiceCell

#if !__has_feature(objc_arc)
-(void)dealloc{
    [_voiceLeftImageArr release];
    [_voiceRightImageArr release];
    [_voiceImageView release];
    [_lengthLable release];
    [_redLogo release];
    [super dealloc];
}
#endif

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildCell];
        [self initilization];
    }
    return self;
}
////////播放动画的制作
#warning 图片需要自己设置--不能为nil 对象
-(void)initilization{
    _voiceLeftImageArr = [[NSArray alloc] initWithObjects:
                          [UIImage imageNamed:@"voice_L1.png"],
                          [UIImage imageNamed:@"voice_L2.png"],
                          [UIImage imageNamed:@"voice_L3.png"],nil];
    _voiceRightImageArr = [[NSArray alloc] initWithObjects:
                           [UIImage imageNamed:@"voice_R1.png"],
                           [UIImage imageNamed:@"voice_R2.png"],
                           [UIImage imageNamed:@"voice_R3.png"],nil];
}
- (void)restoreDisplayWithIsSelfSend:(BOOL)isSelfSend{
    //还原录音图
    if (isSelfSend) {
        _voiceImageView.image = [UIImage imageNamed:@"voice_R0.png"];
    }else{
        _voiceImageView.image = [UIImage imageNamed:@"voice_L0.png"];
    }
}
// 更新声音图片
-(void)updateVoiceImage:(NSInteger)index withSender:(BOOL)isSelfSend{
    NSAssert(index>_voiceLeftImageArr.count, @"-----弹出");
    if (index>_voiceLeftImageArr.count) {
        index = _voiceLeftImageArr.count-1;
    }
    if (isSelfSend) {
        _voiceImageView.image = [_voiceRightImageArr objectAtIndex:index];
    }else{
        _voiceImageView.image = [_voiceLeftImageArr objectAtIndex:index];
    }
}
// 开始播放背景（动画）
-(void)startVoicePlaybalck{
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.frame = CGRectZero;
    _activityIndicatorView.alpha = 0;
    // 点击播放声音，将声音播放字段设为已播放
    [SqliteBase updateInbase:nil withData:self.object];
    [[[self.object attachlist] firstObject] setIsRead:1];
    
    if (_isSelfSendGlo) {
        _voiceImageView.animationImages = _voiceRightImageArr;
    }else{
        _voiceImageView.animationImages = _voiceLeftImageArr;
    }
    _voiceImageView.animationDuration = 1;
    isAnimationVoice = YES;
    [_voiceImageView startAnimating];
}
// 停止播放背景
-(void)stopVocicePlaybalck{
    [_activityIndicatorView stopAnimating];
    _activityIndicatorView.frame = CGRectZero;
    _activityIndicatorView.alpha = 0;
    isAnimationVoice = NO;
    [_voiceImageView stopAnimating];
    if (_isSelfSendGlo) {
        _voiceImageView.image = [UIImage imageNamed:@"voice_R0.png"];
    }else{
        _voiceImageView.image = [UIImage imageNamed:@"voice_L0.png"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}
-(void)prepareForReuse{
    [super prepareForReuse];
    [_voiceImageView stopAnimating];
    _voiceImageView.image = nil;//复用时候去掉原来得
    _voiceImageView.animationImages = nil;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self bubble];
    [self layoutSuperBefor];
}
-(void)buildCell{
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.userInteractionEnabled = NO;
    _bubbleImageView.userInteractionEnabled = YES;
    [_bubbleImageView addSubview:_voiceImageView];
    
    _lengthLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _lengthLable.backgroundColor = [UIColor clearColor];
    _lengthLable.font = [UIFont systemFontOfSize:13];
    _lengthLable.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_lengthLable];
    
    _redLogo = [[UIView alloc]initWithFrame:CGRectZero];
    _redLogo.backgroundColor = [UIColor redColor];
    _redLogo.layer.cornerRadius = 4;
    _redLogo.hidden = YES;
    _redLogo.tag = 101;
    [self.contentView addSubview:_redLogo];
    [_redLogo release];
    
//[_bubbleImageView addTarget:self action:@selector(clilkVoice:) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clilkVoice:)];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClickVoice:)];
    longPress.allowableMovement = 0.6;
    [_bubbleImageView addGestureRecognizer:tap];
    [_bubbleImageView addGestureRecognizer:longPress];
    [tap release];
    [longPress release];
    [_senderFaildImageView addTarget:self action:@selector(resendTheVoiceMessege:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)bubble{
    CGFloat voiceLenth = 60;//最短
    
    NSString *len = _lengthLable.text;
    voiceLenth += ((float)[len intValue]>10?10:(float)[len intValue])/10.0f*100;
    
    //    _uphotoImageView.frame = CGRectMake(SPACE_LEFT , HEAD_CELL_SPACE + _idateLable.bounds.size.height, HEAD_WIDTH, HEAD_WIDTH);
    CGRect bubble_r = CGRectMake(SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS, [BubbleCell heightForIdateMarginUpOffset:TEST_IDATE] + THEBUBLLE_FOLLOWINGOFFSET, voiceLenth ,BUBBLE_MIN_HEIGHT);
    
    CGRect voice_r = CGRectMake(THEFONT_NEAR_OFFSET, (BUBBLE_MIN_HEIGHT - 28)/2, 18, 28);
    //长度的添加
    CGFloat space_length = 0.0f;
    CGFloat upfor_bubble = 5.0f;
    
    CGRect length_r = CGRectMake(bubble_r.origin.x +bubble_r.size.width + space_length, bubble_r.origin.y + upfor_bubble + 15, 35, 20);
    // 接受信息的布局
    CGRect redlogo_r = CGRectMake(bubble_r.origin.x +bubble_r.size.width + space_length + 10, bubble_r.origin.y + upfor_bubble, 8, 8);
    // 信息发送人的布局
    if (_isSelfSendGlo) {
        voice_r.origin.x = voiceLenth-THEFONT_NEAR_OFFSET-18;
        bubble_r.origin.x = 320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) - voiceLenth;
        length_r.origin.x = bubble_r.origin.x - length_r.size.width-space_length;
        redlogo_r.origin.x = bubble_r.origin.x - length_r.size.width-space_length;
    }
    
    _bubbleImageView.frame = bubble_r;
    // 声音的背景
    _voiceImageView.frame = voice_r;
    // 时间长度
    _lengthLable.frame = length_r;
    [self.contentView viewWithTag:101].frame = redlogo_r;
}
- (void)fillViewWithObject:(id)object{
    [super fillViewWithObject:object];
    //设置
    if (_isSelfSendGlo) {
        _voiceImageView.image = [UIImage imageNamed:@"voice_R0.png"];
    }else{
        _voiceImageView.image = [UIImage imageNamed:@"voice_L0.png"];
    }
    if ([[object attachlist] count]) {
        VChatAttachModel *att = [[object attachlist] objectAtIndex:0];
        if (att.isRead == 0 && ![[object userId] isEqualToString:GET_U_ID]) {
            [self.contentView viewWithTag:101].hidden = NO;
        }
        else{
            [self.contentView viewWithTag:101].hidden = YES;
        }
        if (_lengthLable.text == NULL|_lengthLable.text == nil) {
            _lengthLable.text = @" ";
        }else{
                _lengthLable.text = [NSString stringWithFormat:@"%@\"",att.voiceLength];
        }
    }else{
        _lengthLable.text = @"";
        [self.contentView viewWithTag:101].hidden = YES;
    }
    
#warning set voice playing
}

+ (CGFloat)heightForViewWithObject:(id)object{
    CGFloat height = 0.0f;
    height = HEAD_WIDTH + NAMELABLE_HEIGHT02 +[BubbleCell heightForIdateMarginUpOffset:TEST_IDATE] + THEBUBLLE_FOLLOWINGOFFSET + HEAD_CELL_SPACE_DOWN;
    height = height;
    return height;
}
- (void)clilkVoice:(id)sender{
    _redLogo.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(pageExcBubble:with:)]) {
        if (!_isSelfSendGlo) {
            [_activityIndicatorView startAnimating];
            CGFloat voiceLenth = 60;//最短
            NSString *len = _lengthLable.text;
            voiceLenth += ((float)[len intValue]>10?10:(float)[len intValue])/10.0f*100;
            CGRect bubble_r = CGRectMake(SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS, [BubbleCell heightForIdateMarginUpOffset:TEST_IDATE] + THEBUBLLE_FOLLOWINGOFFSET, voiceLenth ,BUBBLE_MIN_HEIGHT);
            CGFloat upfor_bubble = 5.0f;
            CGFloat space_length = 0.0f;
            _activityIndicatorView.frame = CGRectMake(bubble_r.origin.x +bubble_r.size.width + space_length + 10, bubble_r.origin.y + upfor_bubble-2, 16, 16);
            _activityIndicatorView.alpha = 1;
        }
        if ([[self.object attachlist] count]) {
            NSString *content = [[[self.object attachlist]  objectAtIndex:0] fileurl];
            [_delegate pageExcBubble:self with:content];
        }
    }
    
}
- (void)longClickVoice:(UILongPressGestureRecognizer *)gesture
{
    if (_isSelfSendGlo) {
        if(UIGestureRecognizerStateBegan == gesture.state) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(longPageExcBubb:)]) {
                [self.delegate longPageExcBubb:[self object]];
            }
        }
        
        if(UIGestureRecognizerStateChanged == gesture.state) {
            return;
        }
        
        if(UIGestureRecognizerStateEnded == gesture.state) {
            return;
        }
    }
    else{
        return;
    }

}
- (void)resendTheVoiceMessege:(UIButton *)sender{
    
}
@end

#pragma mark-------------------------------picture--------------------------------
@interface BubbleSubImageCell(){
    UIImageView *_pictureMaskImageView;
    UIActivityIndicatorView *_loadActivityIndicatorView;
}

@end

@implementation BubbleSubImageCell
- (void)dealloc{
    [_pictureImageView sd_setImageWithURL:nil];
    [_pictureImageView release];
    [_pictureMaskImageView release];
    [_loadActivityIndicatorView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildCell];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _pictureImageView.image = nil;
    
    _pictureMaskImageView.frame = CGRectZero;
    _pictureMaskImageView.alpha = 0.0f;
    
    [self.contentView viewWithTag:101].frame = CGRectZero;
    [self.contentView viewWithTag:101].alpha = 0.0f;
    
    _loadActivityIndicatorView.frame = CGRectZero;
    _loadActivityIndicatorView.alpha = 0;
    [_loadActivityIndicatorView stopAnimating];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self  bubble];
}
-(void)buildCell{
    _pictureImageView = [[UIImageView alloc] init];
    _pictureImageView.layer.cornerRadius = 2;
    _pictureImageView.layer.masksToBounds = YES;
    _pictureImageView.userInteractionEnabled = YES;
    [_bubbleImageView addSubview:_pictureImageView];
    _pictureImageView.backgroundColor = [UIColor clearColor];
    
    //[_bubbleImageView addTarget:self action:@selector(clickImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickImage:)];
    
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClickImage:)];
    longPress.allowableMovement = 0.6;
    [_bubbleImageView addGestureRecognizer:tap];
    [_bubbleImageView addGestureRecognizer:longPress];
    [tap release];
    [longPress release];
    
    _pictureMaskImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _pictureMaskImageView.layer.cornerRadius = 2;
    _pictureMaskImageView.layer.backgroundColor = RGBA(100, 100, 100, .8).CGColor;
    _pictureMaskImageView.layer.masksToBounds = YES;
    
    [_senderFaildImageView addTarget:self action:@selector(resendThePicMessegae:) forControlEvents:UIControlEventTouchUpInside];
    
    _loadActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loadActivityIndicatorView.frame = CGRectZero;
    _loadActivityIndicatorView.alpha = 0;
    _loadActivityIndicatorView.color = RGBA(14, 14, 14, .8);
    [_bubbleImageView addSubview:_loadActivityIndicatorView];
}
- (void)bubble{
    float width_image = 0.0f ;//有可能是从网络端获取的
    float height_image = 0.0f;
    UIImage *image = _pictureImageView.image;
    if (!image) {
        width_image = PHOTO_GALLERY_SIZE_WIDTH;
        height_image = PHOTO_GALLERY_SIZE_HEIGHT;
    }else{
        width_image = image.size.width;if (width_image == 0) width_image = 1;
        height_image = image.size.height;if (height_image == 0) height_image = 1;
    }
    //初始化的时候显示的高宽比例
    
    //得出缩放系数
    float margin = 0.0f;
    margin = height_image/PHOTO_GALLERY_SIZE_WIDTH>width_image/PHOTO_GALLERY_SIZE_HEIGHT?height_image/PHOTO_GALLERY_SIZE_WIDTH:width_image/PHOTO_GALLERY_SIZE_HEIGHT;//取其较大的一个
    CGFloat space_image_bublle = 5.0f;
    //    _uphotoImageView.frame = CGRectMake(SPACE_LEFT , HEAD_CELL_SPACE + _idateLable.bounds.size.height, HEAD_WIDTH, HEAD_WIDTH);
    if (margin>1.0f) {
        _pictureImageView.frame = CGRectMake(space_image_bublle + ANGLE_LENTH, space_image_bublle, width_image/margin, height_image/margin);
        //        _pictureImageView.frame = CGRectMake(, space_image_bublle, width_image/margin, height_image/margin);
    }else{
        _pictureImageView.frame = CGRectMake(space_image_bublle + ANGLE_LENTH, space_image_bublle, width_image, height_image);
    }
    _bubbleImageView.frame = CGRectMake(SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS,[BubbleCell heightForIdateMarginUpOffset:TEST_IDATE]+THEBUBLLE_FOLLOWINGOFFSET, _pictureImageView.bounds.size.width + space_image_bublle * 2 + ANGLE_LENTH+SPACE_IMAGE_BUBBLE_SHADOW_RIGHT, _pictureImageView.bounds.size.height + space_image_bublle * 2 + SPACE_IMAGE_BUBBLE_SHADOW);
    if (_isSelfSendGlo) {
        //头像从右边开始
        _pictureImageView.frame = CGRectMake(space_image_bublle, space_image_bublle, _pictureImageView.bounds.size.width, _pictureImageView.bounds.size.height);

        _bubbleImageView.frame = CGRectMake(320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) - _bubbleImageView.frame.size.width, _bubbleImageView.frame.origin.y, _bubbleImageView.frame.size.width, _bubbleImageView.frame.size.height);

    }
    [self layoutSuperBefor];
}
#pragma mark-----
-(void)fillViewWithObject:(id)object{
    [super fillViewWithObject:object];
    
    if ([[object attachlist] count]) {
        NSString *url = [[[object attachlist] firstObject] fileurl];
        UIImage *image;
        if (_isSelfSendGlo) {
            image = [object imgData];
        }
        else{
            image = [UIImage imageNamed:@"imgErrorTwo@2x.png"];
        }
        if ([[object isSend] isEqualToString:ISNOSENT]) {
            NSLog(@"%@",[[[object attachlist] lastObject] filename]);
            [_pictureImageView setImage:[UIImage imageWithContentsOfFile:[[[object attachlist] lastObject] filename]]];
        }
        else{
            [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GLOBAL_URL_FILEGET,url]] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self bubble];
            }];
//        [_pictureImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GLOBAL_URL_FILEGET,url]] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//            
//        }];
        }
    }
    
    
}
- (void)requestStart{
    _loadActivityIndicatorView.alpha = 1;
    _loadActivityIndicatorView.frame = CGRectMake(0, 0, 20, 20);
    _loadActivityIndicatorView.center = _pictureImageView.center;
    [_loadActivityIndicatorView startAnimating];
}
- (void)requestOver{
    _loadActivityIndicatorView.alpha = 0;
    _loadActivityIndicatorView.frame = CGRectZero;
    [_loadActivityIndicatorView stopAnimating];
    [self bubble];
}
+(CGFloat)heightForViewWithObject:(id)object{
    return PHOTO_GALLERY_SIZE_HEIGHT+2*5+[BubbleCell heightForIdateMarginUpOffset:TEST_IDATE] +THEBUBLLE_FOLLOWINGOFFSET+SPACE_IMAGE_BUBBLE_SHADOW+ HEAD_CELL_SPACE_DOWN;
}
// 图片点击事件
- (void)clickImage:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(pageExcBubbleClickImage:)]) {
        [self.delegate pageExcBubbleClickImage:self];
    }
}
- (void)longClickImage:(UILongPressGestureRecognizer *)gesture{
    if (_isSelfSendGlo) {
        if(UIGestureRecognizerStateBegan == gesture.state) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(longPageExcBubbClickImage:)]) {
                [self.delegate longPageExcBubbClickImage:[self object]];
            }
        }
        
        if(UIGestureRecognizerStateChanged == gesture.state) {
            return;
        }
        
        if(UIGestureRecognizerStateEnded == gesture.state) {
            return;
        }
    }
    else{
        return;
    }

}
- (void)resendThePicMessegae:(id)sender{
    
}
@end
// =========share==========
@interface BubbleSubShareCell(){
    UIImageView *_pictureMaskImageView;
    UIActivityIndicatorView *_loadActivityIndicatorView;
    UILabel *_sourceLable;
    UILabel *_contextLable;
}
@property(nonatomic,strong)UILabel *sourceLable;
@property(nonatomic,strong)UILabel *contextLable;
@end
@implementation BubbleSubShareCell
@synthesize sourceLable =_sourceLable;
@synthesize contextLable =_contextLable;
- (void)dealloc{
    [_pictureImageView sd_setImageWithURL:nil];
    [_pictureImageView release];
    [_pictureMaskImageView release];
    [_loadActivityIndicatorView release];
    [super dealloc];
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self buildCell];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
-(void)prepareForReuse{
    [super prepareForReuse];
    _pictureImageView.image = nil;
    
    _pictureMaskImageView.frame = CGRectZero;
    _pictureMaskImageView.alpha = 0.0f;
    
    [self.contentView viewWithTag:101].frame = CGRectZero;
    [self.contentView viewWithTag:101].alpha = 0.0f;
    
    _loadActivityIndicatorView.frame = CGRectZero;
    _loadActivityIndicatorView.alpha = 0;
    [_loadActivityIndicatorView stopAnimating];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self  bubble];
}
-(void)buildCell{
    _pictureImageView = [[UIImageView alloc] init];
    _pictureImageView.layer.cornerRadius = 2;
    _pictureImageView.layer.masksToBounds = YES;
    _pictureImageView.userInteractionEnabled = YES;
    _pictureImageView.backgroundColor = [UIColor clearColor];
    [_bubbleImageView addSubview:_pictureImageView];
    
    
    _sourceLable = [[UILabel alloc]initWithFrame:CGRectZero];
    _sourceLable.layer.cornerRadius = 2;
    [_bubbleImageView addSubview:_sourceLable];
    
    _contextLable = [[UILabel alloc]initWithFrame:CGRectZero];
    _contextLable.backgroundColor = [UIColor clearColor];
    [_bubbleImageView addSubview:_contextLable];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(skipTOcaseAnd:)];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClickImage:)];
    longPress.allowableMovement = 0.6;
    [_bubbleImageView addGestureRecognizer:tap];
    [_bubbleImageView addGestureRecognizer:longPress];
    [tap release];
    [longPress release];
    
    _pictureMaskImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _pictureMaskImageView.layer.cornerRadius = 2;
    _pictureMaskImageView.layer.backgroundColor = RGBA(100, 100, 100, .8).CGColor;
    _pictureMaskImageView.layer.masksToBounds = YES;
    
    [_senderFaildImageView addTarget:self action:@selector(resendThePicMessegae:) forControlEvents:UIControlEventTouchUpInside];
    
    _loadActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _loadActivityIndicatorView.frame = CGRectZero;
    _loadActivityIndicatorView.alpha = 0;
    _loadActivityIndicatorView.color = RGBA(14, 14, 14, .8);
    [_bubbleImageView addSubview:_loadActivityIndicatorView];
}
// 初始化布局
- (void)bubble{
     NSString *url = [[[self.object attachlist] firstObject] fileurl];
if([url hasSuffix:@".jpg"]){
    float width_image = 0.0f ;//有可能是从网络端获取的
    float height_image = 0.0f;
    UIImage *image = _pictureImageView.image;
    if (!image) {
        width_image = PHOTO_GALLERY_SIZE_WIDTH;
        height_image = PHOTO_GALLERY_SIZE_HEIGHT;
    }else{
        width_image = image.size.width;if (width_image == 0) width_image = 1;
        height_image = image.size.height;if (height_image == 0) height_image = 1;
    }
    //初始化的时候显示的高宽比例
    //得出缩放系数
    float margin = 0.0f;
    margin = height_image/PHOTO_GALLERY_SIZE_WIDTH>width_image/PHOTO_GALLERY_SIZE_HEIGHT?height_image/PHOTO_GALLERY_SIZE_WIDTH:width_image/PHOTO_GALLERY_SIZE_HEIGHT;//取其较大的一个
    CGFloat space_image_bublle = 5.0f;
    if (margin>1.0f) {
        _pictureImageView.frame = CGRectMake(space_image_bublle + ANGLE_LENTH, space_image_bublle, width_image/margin, height_image/margin);
    }else{
        _pictureImageView.frame = CGRectMake(space_image_bublle + ANGLE_LENTH, space_image_bublle, width_image, height_image);
    }
        
    _bubbleImageView.frame = CGRectMake(SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS,[BubbleCell heightForIdateMarginUpOffset:TEST_IDATE]+THEBUBLLE_FOLLOWINGOFFSET, _pictureImageView.bounds.size.width + space_image_bublle * 2 + ANGLE_LENTH+SPACE_IMAGE_BUBBLE_SHADOW_RIGHT, _pictureImageView.bounds.size.height + space_image_bublle * 2 + SPACE_IMAGE_BUBBLE_SHADOW);
    if (_isSelfSendGlo) {
        //头像从右边开始
        _pictureImageView.frame = CGRectMake(space_image_bublle, space_image_bublle, _pictureImageView.bounds.size.width, _pictureImageView.bounds.size.height);
        
        _bubbleImageView.frame = CGRectMake(320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) - _bubbleImageView.frame.size.width, _bubbleImageView.frame.origin.y, _bubbleImageView.frame.size.width, _bubbleImageView.frame.size.height);
        
    }
         }
else{
    CGSize resultSize=[SingleInstance customFontHeight:[self.object context] andFontSize:18 andLineWidth:BUBBLE_LABLE_WIGHT];
    CGRect content_r = CGRectMake(THEFONT_NEAR_OFFSET, THEFONTUPDOWNOFFSET-3, resultSize.width, resultSize.height);
    
    CGFloat upMargin = [BubbleCell heightForIdateMarginUpOffset:_isShowDate];
    CGFloat bu_h =(resultSize.height+THEFONTUPDOWNOFFSET*2) - 5;
    CGFloat bubble_h = bu_h>BUBBLE_MIN_HEIGHT?bu_h:BUBBLE_MIN_HEIGHT;
    
    CGRect bubble_r = CGRectMake(SPACE_LEFT  + HEAD_WIDTH + HEADER_BUBBLE_DIS, upMargin + THEBUBLLE_FOLLOWINGOFFSET, resultSize.width + THEFONT_NEAR_OFFSET + THEFONT_FAR_OFFSET, bubble_h);
    
    if (_isSelfSendGlo) {
        content_r.origin.x = THEFONT_FAR_OFFSET;
        bubble_r.origin.x = 320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) -bubble_r.size.width;
    }
    _contextLable.frame = content_r;
    _bubbleImageView.frame = bubble_r;
}
    _sourceLable.frame = CGRectMake(320 - (SPACE_LEFT + HEAD_WIDTH + HEADER_BUBBLE_DIS) - _bubbleImageView.frame.size.width, _bubbleImageView.frame.origin.y + _bubbleImageView.frame.size.height, _bubbleImageView.frame.size.width, 20);
    [self layoutSuperBefor];
}
#pragma mark-----
-(void)fillViewWithObject:(id)object{
    [super fillViewWithObject:object];
    
    if ([[object attachlist] count]) {
        NSString *url = [[[object attachlist] firstObject] fileurl];
        if([url hasSuffix:@".jpg"]){
        
        UIImage *image;
        if (_isSelfSendGlo) {
            image = [object imgData];
        }
        else{
            image = [UIImage imageNamed:@"imgErrorTwo@2x.png"];
        }
        if ([[object isSend] isEqualToString:ISNOSENT]) {
            [_pictureImageView setImage:[UIImage imageWithContentsOfFile:[[[object attachlist] lastObject] filename]]];
        }
        else{
            [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",GLOBAL_URL_FILEGET,url]] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self bubble];
            }];
        }
    }
    }
    else{
        _contextLable.text = [object context];
        
    }
}
- (void)requestStart{
    _loadActivityIndicatorView.alpha = 1;
    _loadActivityIndicatorView.frame = CGRectMake(0, 0, 20, 20);
    _loadActivityIndicatorView.center = _pictureImageView.center;
    [_loadActivityIndicatorView startAnimating];
}
- (void)requestOver{
    _loadActivityIndicatorView.alpha = 0;
    _loadActivityIndicatorView.frame = CGRectZero;
    [_loadActivityIndicatorView stopAnimating];
    [self bubble];
}
+(CGFloat)heightForViewWithObject:(id)object{
    return PHOTO_GALLERY_SIZE_HEIGHT+2*5+[BubbleCell heightForIdateMarginUpOffset:TEST_IDATE] +THEBUBLLE_FOLLOWINGOFFSET+SPACE_IMAGE_BUBBLE_SHADOW+ HEAD_CELL_SPACE_DOWN;
}
// 图片点击事件
- (void)clickImage:(id)sender{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(pageExcBubbleClickImage:)]) {
//        [self.delegate pageExcBubbleClickImage:self];
//    }
}
- (void)longClickImage:(UILongPressGestureRecognizer *)gesture{
    if (_isSelfSendGlo) {
        if(UIGestureRecognizerStateBegan == gesture.state) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(longPageExcBubbClickImage:)]) {
                [self.delegate longPageExcBubbClickImage:[self object]];
            }
        }
        
        if(UIGestureRecognizerStateChanged == gesture.state) {
            return;
        }
        
        if(UIGestureRecognizerStateEnded == gesture.state) {
            return;
        }
    }
    else{
        return;
    }
    
}
- (void)resendThePicMessegae:(id)sender{
    
}
@end


