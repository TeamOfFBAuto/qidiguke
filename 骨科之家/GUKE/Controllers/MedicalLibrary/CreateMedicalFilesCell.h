//
//  CreateMedicalFilesCell.h
//  GUKE
//
//  Created by soulnear on 14-10-3.
//  Copyright (c) 2014年 qidi. All rights reserved.
//
/*
 **显示文件cell
 */
#import <UIKit/UIKit.h>

@class CreateMedicalFilesCell;
@protocol CreateMedicalFilesCellDelegate <NSObject>

@optional
-(void)deleteFilesTap:(CreateMedicalFilesCell *)cell;
-(void)filesImageViewTap:(CreateMedicalFilesCell *)cell;

@end

@interface CreateMedicalFilesCell : UITableViewCell


@property(nonatomic,assign)id<CreateMedicalFilesCellDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIButton *delete_button;

@property (strong, nonatomic) IBOutlet UIImageView *Files_imageView;

@property (strong, nonatomic) IBOutlet UIImageView *voiceIcon;

@property (strong, nonatomic) IBOutlet UITextView *content_textView;

@property (strong, nonatomic) IBOutlet UILabel *filesSize_label;



- (IBAction)deleteButtonTap:(id)sender;
- (IBAction)filesImageViewTap:(id)sender;

@end
