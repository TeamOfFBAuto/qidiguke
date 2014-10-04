//
//  ContactsListCell.m
//  VColleagueChat
//
//  Created by lqy on 4/26/14.
//  Copyright (c) 2014 laimark.com. All rights reserved.
//

#import "ContactsListCell.h"
#import "ContactsItem.h"
#import "UIImageView+WebCache.h"
@interface ContactsListCell(){
    UIButton *checkView;
    UIImageView *proImgView;
    UILabel *zh_lab;
    UILabel *en_lab;
}

@end
@implementation ContactsListCell

- (void)dealloc{
    SSRCRelease(zh_lab);
    SSRCRelease(en_lab);
    SSRCRelease(proImgView);
    SSRCSuperDealloc;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

#define margin_s 5.0f
#define side_h 40.0f
#define side_c 23.0f
#define margin_c_l 10.0f
- (void)layoutSubviews{
    [super layoutSubviews];
    checkView.frame = CGRectMake(margin_c_l, (side_h-side_c)/2.0f, side_c, side_c);
    proImgView.frame = CGRectMake(margin_c_l*2+side_c, margin_s, side_h, side_h);
    
    CGSize size = CGSizeZero;
    CGFloat maxWidth = 100.0f;
    if (!IsIOS7) {
        size = [zh_lab.text boundingRectWithSize:CGSizeMake(maxWidth, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:zh_lab.font,NSFontAttributeName, nil] context:nil].size;
    }else{
        size =  [zh_lab.text sizeWithFont:zh_lab.font constrainedToSize:CGSizeMake(maxWidth, self.bounds.size.height) lineBreakMode:zh_lab.lineBreakMode];
    }
    zh_lab.frame = CGRectMake(proImgView.frame.origin.x + side_h+margin_c_l, margin_s, size.width, 20);
    en_lab.frame = CGRectMake(zh_lab.frame.origin.x+zh_lab.bounds.size.width+2, zh_lab.frame.origin.y, 100, 20);
    
}
- (void)initialization{
    checkView = [[UIButton alloc] initWithFrame:CGRectZero];
    checkView.userInteractionEnabled = YES;
    [checkView setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:checkView];
    
    proImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    proImgView.userInteractionEnabled = YES;
    [self.contentView addSubview:proImgView];
    
    
    zh_lab = [[UILabel alloc] initWithFrame:CGRectZero];
    zh_lab.textColor = [UIColor orangeColor];
    zh_lab.textAlignment = NSTextAlignmentLeft;
    zh_lab.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:zh_lab];
    
    en_lab = [[UILabel alloc] initWithFrame:CGRectZero];
    en_lab.textColor = [UIColor grayColor];
    en_lab.textAlignment = NSTextAlignmentLeft;
    en_lab.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:en_lab];
}

- (void)fillViewWithObject:(id)object{
    zh_lab.text = [object fullName];
    en_lab.text = @"englishname";
    proImgView.backgroundColor = [UIColor grayColor];
    [proImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",GLOBAL_URL_FILEGET,[object icon]]] placeholderImage:[UIImage imageNamed:@"imgError.png"]];
    
}
- (void)setSureSelect:(BOOL)sureSelect{
    _sureSelect = sureSelect;
    if (sureSelect) {
        [checkView setImage:[UIImage imageNamed:@"check_on.png"] forState:UIControlStateNormal];
    }else{
        [checkView setImage:[UIImage imageNamed:@"check_off.png"] forState:UIControlStateNormal];
    }
}
+ (CGFloat)heightForCell{
    return (margin_s*2+side_h);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
