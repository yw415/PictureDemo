//
//  TemplateView.m
//  Template
//
//  Created by user on 15-1-29.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "TemplateView.h"
#import "PhotoFrame.h"
#import "UISDK.h"
#import "PhotoAssetManager.h"
@interface TemplateView()
@property(nonatomic,strong)IBOutlet PhotoFrame * photoFrame1;
@property(nonatomic,strong)IBOutlet PhotoFrame * photoFrame2;
@property(nonatomic,strong)IBOutlet PhotoFrame * photoFrame3;
@property(nonatomic,strong)IBOutlet PhotoFrame * photoFrame4;
@property(nonatomic,strong)NSArray * photoFrames;
@property(nonatomic,strong)NSDictionary * photoImgs;
@property(nonatomic,strong)NSDictionary * photoKeys;
@property(nonatomic,strong)UIImageView * selectedPhotoFrame;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger selectedReplaceIndex;
@end
@implementation TemplateView

#pragma mark - 程序生命周期
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        [self addGesture];
        self.selectedIndex=-1;
        self.selectedReplaceIndex=-1;
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

#pragma mark - 手势相关方法
// 添加手势
-(void)addGesture
{
    UIPanGestureRecognizer * panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(panGestureToDo:)];
    [self addGestureRecognizer:panGesture];
    
    UILongPressGestureRecognizer * longPress=[[UILongPressGestureRecognizer alloc]
                                              initWithTarget:self action:@selector(longPressToDo:)];
    longPress.minimumPressDuration=0.5;
    [self addGestureRecognizer:longPress];
}

// 拖动处理
-(void)panGestureToDo:(UIPanGestureRecognizer *)gesture
{
    if(!self.photoFrames)
    {
        return;
    }
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self];
        //NSLog(@"PanX:%f,Y:%f",point.x,point.y);
        // 显示选中图片
        [self getSelectedPhotoFrame:point];
        // 缩放选中图片
        [self showScaleImage:point];
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gesture locationInView:self];
        //NSLog(@"PanX:%f,Y:%f",point.x,point.y);
        self.selectedPhotoFrame.center=point;
        [self getReplacedPhotoFrame:point];
    }
    else if(gesture.state==UIGestureRecognizerStateCancelled)
    {
        //NSLog(@"PanCancel");
        [self clearSelectedPhotoFrame];
    }
    else if(gesture.state==UIGestureRecognizerStateFailed)
    {
        //NSLog(@"PanFail");
        [self clearSelectedPhotoFrame];
    }
    else if(gesture.state==UIGestureRecognizerStateEnded)
    {
        //NSLog(@"PanEnd");
        [self replacePhotoFrame];
        [self clearSelectedPhotoFrame];
    }
}

// 长按处理
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(!self.photoFrames)
    {
        return;
    }
    
    if(gesture.state==UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self];
        //NSLog(@"longPressX:%f,Y:%f",point.x,point.y);
        // 显示选中图片
        [self getSelectedPhotoFrame:point];
        // 缩放选中图片
        [self showScaleImage:point];
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        CGPoint point = [gesture locationInView:self];
        self.selectedPhotoFrame.center=point;
        [self getReplacedPhotoFrame:point];
    }
    else if(gesture.state==UIGestureRecognizerStateCancelled)
    {
        //NSLog(@"LongPressCancel");
        [self clearSelectedPhotoFrame];
    }
    else if (gesture.state==UIGestureRecognizerStateEnded)
    {
        //NSLog(@"LongPressEnded");
        [self replacePhotoFrame];
        [self clearSelectedPhotoFrame];
    }
    else if(gesture.state==UIGestureRecognizerStateFailed)
    {
        //NSLog(@"LongPressFailed");
        [self clearSelectedPhotoFrame];
    }
    
}


#pragma mark - 模版拖动效果相关
//显示选中图片
-(void)getSelectedPhotoFrame:(CGPoint)point
{
    NSInteger selectedIndex=[self checkSelectedPhotoFrame:point];
    if(selectedIndex==-1)
    {
        return;
    }
    
    self.selectedIndex=selectedIndex;
    
    CGRect selectedFrame=[self getSelectedPhotoFrameSize:selectedIndex];
    UIImage * selectedImage=[self getSelectedPhotoFrameImage:selectedIndex];
    [self showMask:YES index:selectedIndex];
    
    if(self.selectedPhotoFrame)
    {
        [self.selectedPhotoFrame removeFromSuperview];
        self.selectedPhotoFrame=nil;
    }
    self.selectedPhotoFrame=[[UISDK Instance]addBackGround:selectedImage
                                                      rect:selectedFrame
                                                      view:self];
}

//清除选中图片
-(void)clearSelectedPhotoFrame
{
    [self showMask:NO index:self.selectedIndex];
    [self showReplacedMask:NO index:self.selectedReplaceIndex];
    self.selectedIndex=-1;
    self.selectedReplaceIndex=-1;
    if(self.selectedPhotoFrame)
    {
        [self.selectedPhotoFrame removeFromSuperview];
        self.selectedPhotoFrame=nil;
    }
}

//替换图片
-(void)replacePhotoFrame
{
    if(self.selectedReplaceIndex==self.selectedIndex||self.selectedReplaceIndex==-1)
    {
        return;
    }
    
    [self replacePhotoFrameFromIndex:self.selectedIndex
                                               to:self.selectedReplaceIndex];
}

//选中缩小效果
-(void)showScaleImage:(CGPoint)point
{
    //将针对父视图的point坐标转换为要展示的视图坐标
    CGFloat orginX=point.x-self.selectedPhotoFrame.frame.origin.x;
    CGFloat orginY=point.y-self.selectedPhotoFrame.frame.origin.y;
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame=CGRectMake(self.selectedPhotoFrame.frame.origin.x+
                                orginX-40,
                                self.selectedPhotoFrame.frame.origin.y+
                                orginY-40,
                                80,
                                80);
        self.selectedPhotoFrame.frame=frame;
        
    }];
}

//显示覆盖图片
-(void)getReplacedPhotoFrame:(CGPoint)point
{
    NSInteger selectedIndex=[self checkSelectedPhotoFrame:point];
    if(selectedIndex==-1||self.selectedIndex==selectedIndex)
    {
        [self showReplacedMask:NO index:self.selectedReplaceIndex];
        self.selectedReplaceIndex=selectedIndex;
        return;
    }
   // NSLog(@"ReplacedIndex:%d",self.selectedReplaceIndex);
    [self showReplacedMask:NO index:self.selectedReplaceIndex];
    self.selectedReplaceIndex=selectedIndex;
    [self showReplacedMask:YES index:selectedIndex];
}

#pragma mark - 自定义方法
// 设置图片
-(void)setPhotoFramesImg:(NSDictionary *)imgs keys:(NSDictionary *)keys
{
    if(self.photoImgs)
    {
        self.photoImgs=nil;
    }
    self.photoImgs=imgs;
    
    if(self.photoKeys)
    {
        self.photoKeys=nil;
    }
    self.photoKeys=keys;
    
    
    self.photoFrames=[NSArray arrayWithObjects:self.photoFrame1,
                                               self.photoFrame2,
                                               self.photoFrame3,
                                               self.photoFrame4,nil];
    
    for (int i =0;i<keys.count;i++)
    {
        //排序 否则allkeys中顺序不对
        NSArray * sortKeys=[keys keysSortedByValueUsingSelector:@selector(compare:)];
        
      
        NSString * key=[sortKeys objectAtIndex:i];
        UIImage * img = [imgs objectForKey:key];
        PhotoFrame * photoFrame=[self.photoFrames objectAtIndex:i];
        photoFrame.tag=key.intValue;
        [photoFrame setPhotoImg:img];
        photoFrame.tapHandleBlock=^(int tag){
            if(self.photoFrameSelectedBlock)
            {
//                NSString * key=[NSString stringWithFormat:@"%d",tag];
//                UIImage * img = [self.photoImgs objectForKey:key];
//                self.photoFrameSelectedBlock(img,key.integerValue);

            }
        };
    }
}

// 决定选中相框
-(NSInteger)checkSelectedPhotoFrame:(CGPoint)point
{
    //通过point检测当前位置属于第几象限
    if(point.x>=self.photoFrame1.frame.origin.x&&
       point.x<=self.photoFrame1.frame.origin.x+self.photoFrame1.frame.size.width)
    {
        //NSLog(@"二三象限");
        //检测当前位置属于哪个相框
        if(point.y>=self.photoFrame1.frame.origin.y
           &&point.y<=self.photoFrame1.frame.origin.y+self.photoFrame1.frame.size.height)
        {
           //NSLog(@"选中第一相框");
            return 0;
        }
        else if(point.y>=self.photoFrame3.frame.origin.y
                &&point.y<=self.photoFrame3.frame.origin.y+self.photoFrame3.frame.size.height)
        {
           //NSLog(@"选中第三相框");
            return 2;
        }
        else
        {
           //NSLog(@"未选中");
            return -1;
        }
    }
    else if (point.x>=self.photoFrame2.frame.origin.x&&
             point.x<=self.photoFrame2.frame.origin.x+self.photoFrame2.frame.size.width)
    {
        //NSLog(@"一四象限");
        if(point.y>=self.photoFrame2.frame.origin.y
           &&point.y<=self.photoFrame2.frame.origin.y+self.photoFrame2.frame.size.height)
        {
            //NSLog(@"选中第二相框");
            return 1;
        }
        else if(point.y>=self.photoFrame4.frame.origin.y
                &&point.y<=self.photoFrame4.frame.origin.y+self.photoFrame4.frame.size.height)
        {
            //NSLog(@"选中第四相框");
            return 3;
        }
        else
        {
            //NSLog(@"未选中");
            return -1;
        }
    }
    else
    {
        //NSLog(@"未选中");
        return -1;
    }
}

// 返回选中相框Frame
-(CGRect)getSelectedPhotoFrameSize:(NSInteger)index
{
    if(index==-1)
    {
        return CGRectZero;
    }
    
    PhotoFrame * photoFrame=[self.photoFrames objectAtIndex:index];
    return photoFrame.frame;
}

// 返回选中相框Image
-(UIImage *)getSelectedPhotoFrameImage:(NSInteger)index
{
    if(index==-1)
    {
        return nil;
    }
    
    PhotoFrame * photoFrame=[self.photoFrames objectAtIndex:index];
    return [photoFrame getPhotoImg];
}

// 显示蒙板
-(void)showMask:(BOOL)show index:(NSInteger)index;
{
    if(index==-1)
    {
        return;
        
    }
    
//    NSLog(@"ShowMaskIndex:%d",self.selectedIndex);
//    NSLog(@"ShowMaskReplacedIndex:%d",self.selectedReplaceIndex);
    PhotoFrame * photoFrame=[self.photoFrames objectAtIndex:index];
    [photoFrame showMask:show];
}

// 显示覆盖蒙板
-(void)showReplacedMask:(BOOL)show index:(NSInteger)index;
{
    if(index==-1)
    {
        return;
    }
    PhotoFrame * photoFrame=[self.photoFrames objectAtIndex:index];
    [photoFrame showReplacedMask:show];
}

//  更替相框图片
-(void)replacePhotoFrameFromIndex:(NSInteger)fromIndex to:(NSInteger)toIndex
{
    if(fromIndex==-1||toIndex==-1)
    {
        return;
    }
    
    //NSLog(@"FromIndex:%d and ToIndex:%d",fromIndex,toIndex);
    PhotoFrame * fromFrame=[self.photoFrames objectAtIndex:fromIndex];
    UIImage * fromImg=[fromFrame getPhotoImg];
    PhotoFrame * toFrame=[self.photoFrames objectAtIndex:toIndex];
    UIImage * toImg=[toFrame getPhotoImg];
    
    [fromFrame setPhotoImg:toImg];
    [toFrame setPhotoImg:fromImg];
}
@end
