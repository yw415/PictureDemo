//
//  MaskView.h
//  Picture
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MaskView : UIWindow
+(MaskView *)Instance;
-(void)showMask;
-(void)hideMask;
@end
