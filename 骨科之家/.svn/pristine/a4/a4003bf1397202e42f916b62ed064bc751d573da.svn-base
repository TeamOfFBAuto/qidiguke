//
//  TSActionSheet.m
//  TSPopoverDemo
//
//  Created by Saito Takashi on 5/21/12.
//  Copyright (c) 2012 ar.ms. All rights reserved.
//

#import "TSActionSheet.h"
#import "TSPopoverController.h"
#import "UIBarButtonItem+WEPopover.h"

#define CORNER_RADIUS 0
#define BORDER 10
#define TITLE_SHADOW_OFFSET   CGSizeMake(0, -1)
#define BUTTON_HEIGHT 30

@implementation TSActionSheet

@synthesize cornerRadius = _cornerRadius;
@synthesize titleColor = _titleColor;
@synthesize titleFont = _titleFont;
@synthesize popoverBaseColor = _popoverBaseColor;
@synthesize popoverGradient = _popoverGradient;
@synthesize buttonGradient = _buttonGradient;
@synthesize titleShadow = _titleShadow;
@synthesize titleShadowColor = _titleShadowColor;
@synthesize titleShadowOffset = _titleShadowOffset;

- (id)initWithTitle:(NSString *)title 
{
    if ((self = [super init]))
    {
        self.frame = CGRectMake(0,0, 100, 300);
        buttonsMutableArray = [[NSMutableArray alloc] init];
        self.cornerRadius = CORNER_RADIUS;
        self.buttonGradient = YES;
        self.titleShadow = YES;
        self.titleColor = [UIColor whiteColor];
        //self.titleShadowOffset = TITLE_SHADOW_OFFSET;
        self.titleShadowColor = [UIColor clearColor];
        
        popoverController = [[TSPopoverController alloc] init];
        popoverController.titleText = title;
        popoverController.titleFont = [UIFont boldSystemFontOfSize:14];
        popoverController.popoverBaseColor = [UIColor clearColor];
        popoverController.popoverGradient = YES;
    }
    return self;
}
- (id)init
{
    if ((self = [super init]))
    {
        self.frame = CGRectMake(0,0, 100, 300);
        buttonsMutableArray = [[NSMutableArray alloc] init];
        self.cornerRadius = CORNER_RADIUS;
        self.buttonGradient = YES;
        self.titleShadow = YES;
        self.titleColor = [UIColor whiteColor];
        //self.titleShadowOffset = TITLE_SHADOW_OFFSET;
        self.titleShadowColor = [UIColor clearColor];
        
        popoverController = [[TSPopoverController alloc] init];
        popoverController.titleFont = [UIFont boldSystemFontOfSize:14];
        popoverController.popoverBaseColor = [UIColor blackColor];
        popoverController.popoverGradient = YES;
    }
    return self;
}
- (void)addButtonWithTitle:(NSString *)title
                      icon:(NSString *)iconURL
                     color:(UIColor*)color 
                titleColor:(UIColor*)titleColor 
               borderWidth:(NSUInteger)borderWidth 
               borderColor:(UIColor*)borderColor 
                     block:(void (^)())block
{
    [buttonsMutableArray addObject:[NSArray arrayWithObjects:
                                    block ? [block copy] : [NSNull null],
                                    title,
                                    color,
                                    titleColor,
                                    [NSNumber numberWithInteger:borderWidth],
                                    borderColor,
                                    iconURL,
                                    nil]];
}

- (void)addButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor clearColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor clearColor]
                       block:block];
}

- (void)destructiveButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor redColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor clearColor]
                       block:block];
}

- (void)cancelButtonWithTitle:(NSString *)title icon:(NSString *)iconURL block:(void (^)())block
{
    [self addButtonWithTitle:title
                        icon:(NSString *)iconURL
                       color:[UIColor clearColor]
                  titleColor:[UIColor lightGrayColor]
                 borderWidth:0
                 borderColor:[UIColor blackColor]
                       block:block];
}




//- (void)showFromBarButtonItem:(UIBarButtonItem *)item animated:(BOOL)animated
- (void) showWithTouch:(UIEvent*)senderEvent
{
    [self buildButtons];
    [popoverController showPopoverWithTouch:senderEvent];
}

- (void) showWithCell:(UITableViewCell*)senderCell
{
    [self buildButtons];
    [popoverController showPopoverWithCell:senderCell];
}

- (void) showWithRect:(CGRect)senderRect
{
    [self buildButtons];
    [popoverController showPopoverWithRect:senderRect];
    
}

- (void) buildButtons
{
    NSUInteger i = 1;
    NSUInteger buttonHeight = BUTTON_HEIGHT;
    NSUInteger buttonY = 5;
    for (NSArray *button in buttonsMutableArray)
    {
        NSString *title = [button objectAtIndex:1];
        UIColor *titleColor = [button objectAtIndex:3];
        NSString *iconUrl = [button objectAtIndex:6];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, buttonY, self.bounds.size.width, buttonHeight)];
        bgView.layer.borderWidth  = 0;
        
        UIImage *image = [UIImage imageNamed:iconUrl];
        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
        imgView.frame = CGRectMake(3, 5, 20, 20);
        [bgView addSubview:imgView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20, 5, bgView.bounds.size.width-20, 20);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.backgroundColor = [UIColor clearColor];
        button.tag = i++;
        
        [button setTitleColor:titleColor forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.accessibilityLabel = title;
        
        if(self.titleShadow){
            [button setTitleShadowColor:self.titleShadowColor forState:UIControlStateNormal];
            button.titleLabel.shadowOffset = self.titleShadowOffset;
        }
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        [self addSubview:bgView];
        bgView = nil;
        buttonY += buttonHeight + BORDER;
        
    }
    CGRect frame = self.frame;
    frame.size.height = buttonY;
    self.frame = frame;
    
    popoverController.contentView = self;
    popoverController.cornerRadius = self.cornerRadius;
    popoverController.popoverBaseColor = self.popoverBaseColor;
    popoverController.popoverGradient = self.popoverGradient;
    popoverController.titleColor = self.titleColor;
}


- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated 
{
    if (buttonIndex >= 0 && buttonIndex < [buttonsMutableArray count])
    {
        id obj = [[buttonsMutableArray objectAtIndex: buttonIndex] objectAtIndex:0];
        if (![obj isEqual:[NSNull null]])
        {
            ((void (^)())obj)();
        }
    }
    
    if (animated)
    {
        [popoverController dismissPopoverAnimatd:YES];
        [self removeFromSuperview];
    }
    else
    {
        [popoverController dismissPopoverAnimatd:NO];
        [self removeFromSuperview];
    }
}

#pragma mark - Action

- (void)buttonClicked:(id)sender 
{
    /* Run the button's block */
    NSInteger buttonIndex = [sender tag] - 1;
    [self dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark - UIImage

-(UIImage*)buttonImage:(UIColor*)color borderWidth:(NSUInteger)borderWidth borderColor:(UIColor*)borderColor
{
    
    //Size
    float buttonWidth = self.frame.size.width - (BORDER*2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(buttonWidth, BUTTON_HEIGHT), NO, 0);
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects: 
                               (id)[UIColor colorWithWhite:1.0 alpha:0.4].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.3].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.2].CGColor, 
                               (id)[UIColor clearColor].CGColor, 
                               (id)[UIColor colorWithWhite: 1.0 alpha: 0.1].CGColor, 
                               (id)[UIColor colorWithWhite:1.0 alpha:0.2].CGColor, nil];
    CGFloat gradientLocations[] = {0, 0.1, 0.49, 0.5, 0.51, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)gradientColors, gradientLocations);
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, buttonWidth, BUTTON_HEIGHT) cornerRadius: self.cornerRadius];
    [color setFill];
    [roundedRectanglePath fill];
    
    
    if(self.buttonGradient){
        //// GradientPath Drawing
        UIBezierPath* gradientPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, buttonWidth, BUTTON_HEIGHT) cornerRadius: self.cornerRadius];
        CGContextSaveGState(context);
        [gradientPath addClip];
        CGContextDrawLinearGradient(context, gradient, CGPointMake(buttonWidth/2, 0), CGPointMake(buttonWidth/2, BUTTON_HEIGHT), 0);
        CGContextRestoreGState(context);
    }
    
    
    if(borderWidth >0)
    {
        if(!borderColor) borderColor = [UIColor blackColor];
        [borderColor setStroke];
        roundedRectanglePath.lineWidth = borderWidth;
        [roundedRectanglePath stroke];
    }
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return output;
}

@end
