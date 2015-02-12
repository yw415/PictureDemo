//
//  PhotoAssetManager.h
//  Picture
//
//  Created by user on 15-1-21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    PhotoThumbnail=0,
    PhotoScreenSize,
    PhotoFullResolution,
    
    
} AssetType;

@interface PhotoAssetManager : NSObject
///单例
+(PhotoAssetManager *)Instance;
///相册种类
@property(nonatomic,strong)NSMutableArray * assetGroups;
///当前选中相册照片
@property(nonatomic,strong)NSMutableArray * currentPhotos;
///当前选中asset
@property(nonatomic,strong)ALAsset * currentAsset;
//获取相册
-(void)getGroupList:(void (^)(NSArray *))result;
//获取指定相册内所有照片
-(void)getPhotosFromGroup:(ALAssetsGroup *)group result:(void (^)(NSArray *))result;
//根据索引选取某个照片
-(UIImage *)getImageWithIndex:(NSInteger)index type:(AssetType)type;
////获取指定相册信息（返回字典类 Name,Count,Thumbnail）
- (NSDictionary *)getGroupInfo:(NSInteger)nIndex;
//根据类型选取某个照片
-(UIImage *)getImageFromAsset:(ALAsset *)asset type:(AssetType)type;
@end
