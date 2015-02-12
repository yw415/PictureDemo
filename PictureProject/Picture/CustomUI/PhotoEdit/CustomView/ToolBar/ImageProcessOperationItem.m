//
//  VideoProcessOperationItem.m
//  AVVideoExample
//
//  Created by user on 14-9-5.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "ImageProcessOperationItem.h"
#import "UISDK.h"
@implementation ImageProcessOperationItem
#pragma mark - 界面生命周期
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self addSubviews];
    }
    return self;
}

#pragma mark - 自定义方法
-(void)addSubviews
{
    // 通用参数
    CGRect rect=CGRectZero;
    UIFont * font=[UIFont systemFontOfSize:9];
    UIColor * color=[UIColor blackColor];
    
    rect=CGRectMake(0, 5, self.bounds.size.width, self.bounds.size.height-20);
    self.image=[[UIImageView alloc]initWithFrame:rect];
    self.image.backgroundColor=[UIColor whiteColor];
    [self addSubview:self.image];
    
    rect=CGRectMake(0, rect.origin.y+rect.size.height+5, self.bounds.size.width, 9);
    self.title=[[UISDK Instance]addLabel:rect
                                    font:font
                                   color:color
                                    text:nil
                               alignment:NSTextAlignmentCenter
                                    view:self];
    
}
@end
