//
//  CollectionViewCell.m
//  Picture
//
//  Created by user on 15-1-27.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()
@property(nonatomic,strong)UIImageView * imgView;
@property(nonatomic,strong)UIView * maskView;
@end

@implementation CollectionViewCell
#pragma mark - 界面生命周期
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self addSubviews];
    }
    return self;
}

#pragma mark - 自定义方法
//添加子视图
-(void)addSubviews
{
    CGRect rect=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.imgView=[[UIImageView alloc]initWithFrame:rect];
    [self addSubview:self.imgView];
    
    self.maskView=[[UIView alloc]initWithFrame:rect];
    self.maskView.backgroundColor=[UIColor whiteColor];
    self.maskView.alpha=0.5;
    self.maskView.hidden=YES;
    [self addSubview:self.maskView];
    
}
//设置预览图
-(void)setThumbnailImage:(UIImage *)img
{
    self.imgView.image=img;
}
//显示选中蒙板
-(void)showMask:(BOOL)show
{
    self.maskView.hidden=!show;
}
@end
