//
//  PhotoGroupCell.m
//  Picture
//
//  Created by user on 15-1-26.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PhotoGroupCell.h"
#import "UISDK.h"
@interface PhotoGroupCell()
@property(nonatomic,strong)IBOutlet UILabel * grounpName;
@property(nonatomic,strong)IBOutlet UILabel * phototCount;
@property(nonatomic,strong)IBOutlet UIImageView * thumbnail;
@end

@implementation PhotoGroupCell
#pragma mark - 界面生命周期

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 自定义方法
-(void)setThumbanilView:(UIImage *)img
{
    self.thumbnail.image=img;
}

-(void)setGrounpnameText:(NSString *)text
{
    self.grounpName.text=text;
}

-(void)setPhototCountText:(NSString *)text
{
    self.phototCount.text=text;
}
@end
