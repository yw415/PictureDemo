//
//  PhotoAssetManager.m
//  Picture
//
//  Created by user on 15-1-21.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PhotoAssetManager.h"
@interface PhotoAssetManager()
@property(nonatomic,strong)ALAssetsLibrary * assetsLibrary;
@property(nonatomic,strong)UITableView * photoTable;
//根据类型选取某个照片
-(UIImage *)getImageFromAsset:(ALAsset *)asset type:(AssetType)type;
@end

@implementation PhotoAssetManager
///初始化
-(id)init
{
    self=[super init];
    if(self)
    {
        self.assetsLibrary=[[ALAssetsLibrary alloc]init];
        self.assetGroups=[[NSMutableArray alloc]init];
        self.currentPhotos=[[NSMutableArray alloc]init];
    }
    return self;
}

///单例
+(PhotoAssetManager *)Instance
{
    static PhotoAssetManager * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

//获取相册
-(void)getGroupList:(void (^)(NSArray *))result
{
    if(self.assetGroups)
    {
        [self.assetGroups removeAllObjects];
    }
    //迭代相册 到末尾时调用result块
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                                          if(group)
                                          {
                                              [self.assetGroups addObject:group];
                                          }
                                          else
                                          {
                                              result(self.assetGroups);
                                              return;
                                          }
                                      }
                                    failureBlock:^(NSError *error) {
                                        NSLog(@"Error:%@",error.description);
                                    }];
}

//获取指定相册内所有照片
-(void)getPhotosFromGroup:(ALAssetsGroup *)group
                   result:(void (^)(NSArray *))result
{
    if(self.currentPhotos)
    {
        [self.currentPhotos removeAllObjects];
    }
    //迭代指定相册内的照片 到末尾时调用result块
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    [group enumerateAssetsUsingBlock:^(ALAsset *photoAsset, NSUInteger index, BOOL *stop) {
        if(photoAsset==nil)
        {
            result(self.currentPhotos);
            return;
        }
        else
        {
            [self.currentPhotos addObject:photoAsset];
        }
    }];
}

//根据类型选取某个照片
-(UIImage *)getImageFromAsset:(ALAsset *)asset type:(AssetType)type
{
    CGImageRef iRef=nil;
    //返回缩略图
    if(type==PhotoThumbnail)
    {
        iRef=[asset thumbnail];
    }
    //返回等屏图
    else if(type==PhotoScreenSize)
    {
        iRef=[asset.defaultRepresentation fullScreenImage];
    }
    //返回原图
    else if(type==PhotoFullResolution)
    {
        NSString *strXMP = asset.defaultRepresentation.metadata[@"AdjustmentXMP"];
        NSData *dXMP = [strXMP dataUsingEncoding:NSUTF8StringEncoding];
        
        CIImage *image = [CIImage imageWithCGImage:asset.defaultRepresentation.fullResolutionImage];
        
        NSError *error = nil;
        NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:dXMP
                                                     inputImageExtent:image.extent
                                                                error:&error];
        if (error) {
            NSLog(@"Error during CIFilter creation: %@", [error localizedDescription]);
        }
        
        
        for (CIFilter *filter in filterArray) {
            [filter setValue:image forKey:kCIInputImageKey];
            image = [filter outputImage];
        }
        
        UIImage *iImage = [UIImage imageWithCIImage:image scale:1.0 orientation:(UIImageOrientation)asset.defaultRepresentation.orientation];
        
        return iImage;

        
    }

    return [UIImage imageWithCGImage:iRef];
}

//根据索引选取某个照片
-(UIImage *)getImageWithIndex:(NSInteger)index type:(AssetType)type
{
    
    ALAsset * asset=[self.currentPhotos objectAtIndex:index];
    return [self getImageFromAsset:asset type:type];
}


//获取相册详细信息
-(NSDictionary *)getGroupInfo:(NSInteger)nIndex
{
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    ALAssetsGroup * group=[self.assetGroups objectAtIndex:nIndex];
    [group setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSString * name=[group valueForProperty:ALAssetsGroupPropertyName];
    NSString * count=[NSString stringWithFormat:@"%d",(int)[group numberOfAssets]];
    UIImage * img=[UIImage imageWithCGImage:[group posterImage]];
    
    [dic setObject:name forKey:@"Name"];
    [dic setObject:count forKey:@"Count"];
    [dic setObject:img forKey:@"Thumbnial"];
    
    return dic;
}

@end
