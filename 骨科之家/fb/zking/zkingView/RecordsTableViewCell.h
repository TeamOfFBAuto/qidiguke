//
//  RecordsTableViewCell.h
//  GUKE
//
//  Created by szk on 14-9-30.
//  Copyright (c) 2014年 qidi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordsTableViewCell : UITableViewCell<UITextFieldDelegate>


typedef void(^FbRegistCellBloc)(int tag ,NSInteger indexpathofrow,NSString *stringtext);


typedef enum{
    FbRegistCellTypeNormal=0,//普通类型
    FbRegistCellTypeofButton=1,
    FbRegistCellTypePassWord=2,
    
}FbRegistCellType;


@property(nonatomic,strong)UITextField *inputField;

@property(nonatomic,strong)UILabel *titleLabel;


@property(nonatomic,copy)FbRegistCellBloc mybloc;



-(void)setFbRegistCellType:(FbRegistCellType)_type placeHolderText:(NSString *)_plcaeText str_img:(NSString *)_str_img fbregistbloc:(FbRegistCellBloc)_bloc row:(NSInteger )alarow;

@end
