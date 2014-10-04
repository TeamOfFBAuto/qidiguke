//
//  QBShowImagesScrollView.h
//  FBCircle
//
//  Created by soulnear on 14-5-13.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol QBShowImagesScrollViewDelegate <NSObject>

-(void)singleClicked;

@end


typedef enum
{
    QBShowImagesScrollViewTypeLocation=0,
    QBShowImagesScrollViewTypeWeb
    
}QBShowImagesScrollViewType;


@interface QBShowImagesScrollView : UIScrollView<UIScrollViewDelegate>
{
    BOOL _isZoomed;
    
    NSTimer * _tapTimer;
    
    UIButton * placeHolderButton;
    
}


@property(nonatomic,strong)UIImageView * asyImageView;

@property(nonatomic,strong)UIImageView * locationImageView;

@property(nonatomic,assign)QBShowImagesScrollViewType ImageType;

@property(nonatomic,assign)id<QBShowImagesScrollViewDelegate>aDelegate;


-(QBShowImagesScrollView *)initWithFrame:(CGRect)frame WithLocation:(UIImage *)theImage;


-(QBShowImagesScrollView *)initWithFrame:(CGRect)frame WithUrl:(NSString *)theUrl;

-(void)resetImageView:(UIImage *)theImage;

@end
