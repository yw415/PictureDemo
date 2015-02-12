//
//  CollectionViewCell.h
//  Picture
//
//  Created by user on 15-1-27.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell
-(void)setThumbnailImage:(UIImage *)img;
-(void)showMask:(BOOL)show;
@end
