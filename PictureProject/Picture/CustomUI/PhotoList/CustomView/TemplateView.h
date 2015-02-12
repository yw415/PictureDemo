//
//  TemplateView.h
//  Template
//
//  Created by user on 15-1-29.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PhotoFrameSelectedBlock) (UIImage * img,NSInteger selectedIndex);
@interface TemplateView : UIView
// 设置图片
-(void)setPhotoFramesImg:(NSDictionary *)imgs keys:(NSDictionary *)keys;
// 决定选中相框
-(NSInteger)checkSelectedPhotoFrame:(CGPoint)point;
// 返回选中相框Frame
-(CGRect)getSelectedPhotoFrameSize:(NSInteger)index;
// 返回选中相框Image
-(UIImage *)getSelectedPhotoFrameImage:(NSInteger)index;
// 显示蒙板
-(void)showMask:(BOOL)show index:(NSInteger)index;
// 显示覆盖蒙板
-(void)showReplacedMask:(BOOL)show index:(NSInteger)index;
//  更替相框图片
-(void)replacePhotoFrameFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex;
@property(nonatomic,copy)PhotoFrameSelectedBlock photoFrameSelectedBlock;
@end
