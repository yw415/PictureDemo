//
//  PhotoListViewController.h
//  Picture
//
//  Created by user on 15-1-20.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "General_ViewController.h"

typedef enum
{
    PhotoTemplate,
    PhotoEdit
}NextViewControllerType;


typedef void (^GetSelectedImage) (NSDictionary * imgs,NSDictionary * keys);

@interface PhotoListViewController : General_ViewController
@property(nonatomic,strong)NSArray * photoGroups;
@property(nonatomic,assign)NSInteger maxPhototCount;
@property(nonatomic,assign)NextViewControllerType nextViewType;
@end
