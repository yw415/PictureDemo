//
//  VideoProcessOperationView.m
//  AVVideoExample
//
//  Created by user on 14-9-4.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "ImageProcessOperationView.h"
#import "ImageProcessOperationItem.h"
#import "UtilitySDK.h"
#import "UISDK.h"
#import "PhotoAssetManager.h"
#import "ImageProcess.h"
@interface ImageProcessOperationView()
@property(nonatomic,strong)CustomHorizontalTable * horizontalTable;
@property(nonatomic,strong)NSMutableArray * data;
@property(nonatomic,assign)int tag;
@end
@implementation ImageProcessOperationView
#pragma mark - 界面生命周期
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.data=[NSMutableArray array];
        [self addSubviews];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    if(self)
    {
        self.data=[NSMutableArray array];
        [self addSubviews];
    }
    return self;
}

#pragma mark - 自定义方法
/// 添加子视图
-(void)addSubviews
{
    CGRect rect=CGRectMake(0, 0, self.bounds.size.width, 60);
    self.horizontalTable=[[CustomHorizontalTable alloc]initWithFrame:rect];
    self.horizontalTable.delegate=self;
    [self addSubview:self.horizontalTable];
}

/// 配置数据
-(void)configureData:(int)tag
{
    self.tag=tag;
    switch (tag) {
        case 0:
        {
            [self configureFilter];
            [self.horizontalTable reloadData];
        }
            break;
        case 1:
        {
            [self configurePrint];
            [self.horizontalTable reloadData];
        }
            break;
        default:
            break;
    }
}

/// 配置滤镜数据
-(void)configureFilter
{
    [self.data removeAllObjects];
    NSDictionary * plistDic=[self getFilterList];
    NSDictionary * filterList=[plistDic objectForKey:@"Filters"];
    
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"原图" forKey:@"Title"];
    [dic setObject:@"Source" forKey:@"FilterName"];
    [self.data addObject:dic];
    
    for(NSString * key in filterList.allKeys)
    {
        
        NSString * title=key;
        NSString * filterName=[filterList objectForKey:key];
        
        NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
        [dic setObject:title forKey:@"Title"];
        [dic setObject:filterName forKey:@"FilterName"];
        [self.data addObject:dic];
    }

}

/// 配置水印
-(void)configurePrint
{
    [self.data removeAllObjects];
    
    NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"原图" forKey:@"Title"];
    [self.data addObject:dic];
    
    
    for(int i=0;i<5;i++)
    {
        NSString * title=nil;
        switch (i) {
            case 0:
            {
                title=@"水印上";
            }
                break;
            case 1:
            {
                 title=@"水印右";
            }
                break;
            case 2:
            {
                 title=@"水印下";
            }
                break;
            case 3:
            {
                 title=@"水印左";
            }
                break;
            case 4:
            {
                 title=@"水印中";
            }
                break;
            default:
                break;
        }
        

        NSMutableDictionary * dic=[[NSMutableDictionary alloc]init];
        [dic setObject:title forKey:@"Title"];
        [self.data addObject:dic];
    }
}


/// 获取FilterList的plist文件
-(NSDictionary *)getFilterList
{
    NSString * plistPath=[[NSBundle mainBundle]pathForResource:@"Filter" ofType:@"plist"];
    NSDictionary * plistDic=[NSDictionary dictionaryWithContentsOfFile:plistPath];
    return plistDic;
}

#pragma mark - CustomHorizontalTableDelegate
-(int)itemCount
{
   return (int)self.data.count;
}
-(float)itemMargin
{
    return 15.0;
}
-(UIView *)itemView:(int)index
{
    NSDictionary * dic=[self.data objectAtIndex:index];
    
    NSString * title=[dic objectForKey:@"Title"];
    
    CGRect rect=CGRectMake(0, 0, 50, 60);
    ImageProcessOperationItem * item=[[ImageProcessOperationItem alloc]initWithFrame:rect];
    item.title.text=title;
    item.image.image=nil;
    return item;
}

-(void)selectedItem:(UIView *)selectedView
              index:(int)selectedIndex
{
    UIImage * retImg=nil;
    switch (self.tag) {
        case 0:
        {
            NSLog(@"当前选择为滤镜");
            // 滤镜名
            NSDictionary * dic=[self.data objectAtIndex:selectedIndex];
            NSString * filterName = [dic objectForKey:@"FilterName"];
            NSLog(@"滤镜名:%@",filterName);
            if(![filterName isEqualToString:@"Source"])
            {
                retImg = [[ImageProcess Instance]addFilter:filterName toImg:self.editedImg];
            }
            else
            {
                retImg=self.sourceImg;
            }
            
        }
            break;
        case 1:
        {
            NSLog(@"当前选择为水印");
            NSDictionary * dic=[self.data objectAtIndex:selectedIndex];
            NSString * printName = [dic objectForKey:@"Title"];
            if(![printName isEqualToString:@"原图"])
            {
                UIImage * img=[[UISDK Instance]getImg:@"star.png"];
                retImg = [[ImageProcess Instance]addPrint:img toImg:self.editedImg];
                
            }
            else
            {
                retImg=self.sourceImg;
            }
    
        }
            break;
        default:
            break;
    }

    if(self.selectedBlock&&retImg)
    {
        self.editedImg=retImg;
        self.selectedBlock(retImg);
    }
}
@end
