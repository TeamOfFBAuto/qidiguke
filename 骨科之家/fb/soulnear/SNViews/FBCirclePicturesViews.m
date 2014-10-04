//
//  FBCirclePicturesViews.m
//  FBCircle
//
//  Created by soulnear on 14-5-21.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FBCirclePicturesViews.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UserArticleListAttachListModel.h"

@implementation FBCirclePicturesViews
@synthesize isReply = _isReply;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setthebloc:(FBCirclePicturesViewsBlocs)thechuanbloc{

    _mybloc=thechuanbloc;
}


-(void)doTap:(UITapGestureRecognizer *)sender
{
    
    _mybloc(sender.view.tag);

    
}

#pragma mark-zkingChangge
-(void)setimageArr:(NSArray *)imgarr withSize:(int)size isjuzhong:(BOOL)juzhong
{
    NSArray * array = [[NSArray alloc] init];
    
    array = imgarr;
    
    int row = 0;
    
    int number = 0;
    
    
    int iii = 9;
    
    if (array.count < 9)
    {
        iii = array.count;
    }
    
    
    for (int i = 0;i < array.count;i++)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake((size+3)*number,(size + 3)*row,size,size)];
        
        if (juzhong)
        {
            if (array.count == 1)
            {
                imageView.frame = CGRectMake(self.frame.size.width/2-size/2,(size + 3)*row,size,size);
            }else if(array.count == 2)
            {
                imageView.frame = CGRectMake((self.frame.size.width-size*2-4)/2 + (size+3)*number,(size + 3)*row,size,size);
            }
        }
        
        imageView.tag = i+1;
        imageView.userInteractionEnabled = YES;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.backgroundColor = [UIColor grayColor];
        UserArticleListAttachListModel * model = [array objectAtIndex:i];
        [imageView sd_setImageWithURL:[SNTools returnUrl:model.fileurl] placeholderImage:nil];
        
        [self addSubview:imageView];
        
        number++;
        
        if (i%3 >= 2)
        {
            row++;
            number = 0;
        }
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [imageView addGestureRecognizer:tap];
    }    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
