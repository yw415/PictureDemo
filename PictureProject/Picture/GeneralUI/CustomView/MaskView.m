//
//  MaskView.m
//  Picture
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MaskView.h"
@interface MaskView()
@property(nonatomic,strong)UIView * backgroundView;
@end

@implementation MaskView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(MaskView *)Instance
{
    static dispatch_once_t pred = 0;
    __strong static id instance = nil;
    dispatch_once(&pred, ^{
        instance = [[self alloc]init];
    });
    return instance;
}

-(id)init
{
    self = [super init];
    if (self) {
        CGRect frame=CGRectMake(0, 0, ScreenWidth, ScreenHeight-242);
        self.frame=frame;
        self.windowLevel=UIWindowLevelStatusBar+1;
        self.hidden=NO;
        self.backgroundView=[[UIView alloc]initWithFrame:frame];
        self.backgroundView.backgroundColor=[UIColor blackColor];
        self.backgroundView.alpha=0;
        [self addSubview:self.backgroundView];
        
    }
    
    return self;
}

-(void)showMask
{
     self.hidden=NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha=0.5;
    }];
}

-(void)hideMask
{
    [UIView animateWithDuration:0.3 animations:^{
        self.backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        self.hidden=YES;
    }];
}

@end
