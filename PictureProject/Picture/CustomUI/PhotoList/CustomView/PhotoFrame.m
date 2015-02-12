//
//  PhotoFrame.m
//  Template
//
//  Created by user on 15-1-29.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PhotoFrame.h"
#import "UISDK.h"
@interface PhotoFrame()
@property(nonatomic,strong)UIImageView * photo;
@property(nonatomic,strong)UIView * maskView;
@property(nonatomic,strong)UIView * replacedMaskView;
@end
@implementation PhotoFrame

#pragma mark - 程序生命周期
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self addSubviews];
        [self addGesture];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - UI相关方法
// 添加子视图
-(void)addSubviews
{
    CGRect rect=CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.photo=[[UISDK Instance]addBackGround:nil rect:rect view:self];
    self.photo.layer.masksToBounds=YES;
    self.maskView=[[UIView alloc]initWithFrame:rect];
    self.maskView.alpha=0.5;
    self.maskView.hidden=YES;
    [self addSubview:self.maskView];
    
    self.replacedMaskView=[[UIView alloc]initWithFrame:rect];
    self.replacedMaskView.backgroundColor=[UIColor blueColor];
    self.replacedMaskView.alpha=0.5;
    self.replacedMaskView.hidden=YES;
    [self addSubview:self.replacedMaskView];
}

// 显示蒙板
-(void)showMask:(BOOL)show
{
    self.maskView.backgroundColor=[UIColor whiteColor];
    self.maskView.hidden=!show;
}

// 显示覆盖蒙板
-(void)showReplacedMask:(BOOL)show
{
    self.replacedMaskView.hidden=!show;
}

#pragma mark - 功能方法
// 设置照片
-(void)setPhotoImg:(UIImage *)img
{
    self.photo.image=img;
}

// 获取照片
-(UIImage *)getPhotoImg
{
    return self.photo.image;
}


#pragma mark - 手势相关
//添加手势
-(void)addGesture
{
    UITapGestureRecognizer * tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(tapGestureToDo:)];
    [self addGestureRecognizer:tapGesture];
}

//手势处理
-(void)tapGestureToDo:(UIPanGestureRecognizer *)gesture
{
    if(self.tapHandleBlock)
    {
        self.tapHandleBlock(self.tag);
    }
}

@end
