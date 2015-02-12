//
//  PhotoFrame.h
//  Template
//
//  Created by user on 15-1-29.
//  Copyright (c) 2015年 ios. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void (^TapHandleBlock) (int tag);
@interface PhotoFrame : UIView
// 设置照片
-(void)setPhotoImg:(UIImage *)img;
// 获取照片
-(UIImage *)getPhotoImg;
// 显示蒙板
-(void)showMask:(BOOL)show;
// 显示覆盖蒙板
-(void)showReplacedMask:(BOOL)show;
@property(nonatomic,copy)TapHandleBlock tapHandleBlock;
@end
