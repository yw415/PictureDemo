//
//  VideoProcessOperationView.h
//  AVVideoExample
//
//  Created by user on 14-9-4.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomHorizontalTable.h"
typedef void (^SelectedBlock)(UIImage * img);
@interface ImageProcessOperationView : UIView<CustomHorizontalTableDelegate>
@property(nonatomic,assign)id<CustomHorizontalTableDelegate>delegate;
@property(nonatomic,copy)SelectedBlock selectedBlock;
@property(nonatomic,strong)UIImage * sourceImg;
@property(nonatomic,strong)UIImage * editedImg;
/// 配置数据
-(void)configureData:(int)tag;
@end
