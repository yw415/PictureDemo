//
//  ImageProcessItem.m
//  Picture
//
//  Created by user on 15-2-3.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "ImageProcessItem.h"
#import "UISDK.h"
#define FontSize1 13
@interface ImageProcessItem()
@property(nonatomic,strong)UILabel * label;
@end

@implementation ImageProcessItem


#pragma mark - 界面生命周期
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor blackColor];
        [self addSubviews];
    }
    return self;
}

#pragma mark - UI相关
/// 添加子视图
-(void)addSubviews
{
    // 通用参数
    CGRect rect=CGRectZero;
    UIFont * font=[UIFont systemFontOfSize:FontSize1];
    UIColor * color=[UIColor whiteColor];
    // 添加label
    rect=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.label=[[UISDK Instance]addLabel:rect
                                    font:font
                                   color:color
                                    text:nil
                               alignment:NSTextAlignmentCenter
                                    view:self];

}

#pragma mark - 功能方法
/// 设置Label文字
-(void)setLabelText:(NSString *)text
{
    self.label.text=text;
}

/// 设置选中
-(void)setSelected:(BOOL)selected
{
    if(selected)
    {
        self.label.textColor=[UIColor redColor];
    }
    else
    {
        self.label.textColor=[UIColor whiteColor];
    }
}

@end
