//
//  ImageProcess.m
//  AVVideo
//
//  Created by user on 14-11-2.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "ImageProcess.h"
@interface ImageProcess()
@property(nonatomic,strong)CIContext * context;
@property(nonatomic,strong)CIFilter * filter;
@end

@implementation ImageProcess
///单例
+(ImageProcess *)Instance
{
    static ImageProcess * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

///初始化
-(id)init
{
    self=[super init];
    if(self)
    {
        self.context=[CIContext contextWithOptions:nil];
    }
    return self;
}

/**
 *给图片添加滤镜
 *@pargm filterName 要添加的滤镜名称
 *@pargm sourceImg 要添加滤镜的图片
 *@return UIImage 加工后的图片
 */
-(UIImage *)addFilter:(NSString *)filterName
                toImg:(UIImage *)sourceImg
{

    CIImage * ciImg=[CIImage imageWithCGImage:sourceImg.CGImage];
    self.filter=[CIFilter filterWithName:filterName
                           keysAndValues:kCIInputImageKey,
                                         ciImg,
                 nil];
    CIImage * outPutImage=[self.filter outputImage];
    CGImageRef cgImg=[self.context createCGImage:outPutImage fromRect:outPutImage.extent];
    UIImage * newImage=[UIImage imageWithCGImage:cgImg];
    CGImageRelease(cgImg);
    return newImage;
}

/**
 *给图片添加透明水印
 *@pargm printImg 要添加的水印
 *@pargm sourceImg 要添加水印的图片
 *@return UIImage 加工后的图片
 */
-(UIImage *)addPrint:(UIImage *) printImg
               toImg:(UIImage *)sourceImg
{
    UIImage * printOverlay=[self creatOverlayImage:printImg Size:sourceImg.size];
    CIImage * print=[[CIImage alloc]initWithImage:printOverlay];
    CIImage * source=[[CIImage alloc]initWithImage:sourceImg];
    
    CIFilter * alphaFilter=[CIFilter filterWithName:@"CIColorMatrix"];
    CIVector * alphaVector=[CIVector vectorWithX:0 Y:0.7 Z:0 W:0];
    [alphaFilter setValue:alphaVector forKey:@"inputAVector"];
    [alphaFilter setValue:print forKey:@"inputImage"];
    print=[alphaFilter outputImage];
    
    CIFilter * blendFilter=[CIFilter filterWithName:@"CISourceAtopCompositing"];
    [blendFilter setValue:print forKey:@"inputImage"];
    [blendFilter setValue:source forKey:@"inputBackgroundImage"];
    CIImage * blendOutput=[blendFilter outputImage];
    
    CIContext * context=[CIContext contextWithOptions:nil];
    CGImageRef outputCGImage=[context createCGImage:blendOutput fromRect:[blendOutput extent]];
    UIImage * retImg=[UIImage imageWithCGImage:outputCGImage];
    CGImageRelease(outputCGImage);
    return retImg;
}

/// 创建浮层图片
-(UIImage *)creatOverlayImage:(UIImage *)img Size:(CGSize)inputSize
{
    CGFloat imageAspect=img.size.width/img.size.height;
    NSInteger targetWidth=inputSize.width*0.25;
    
    CGSize ghostSize = CGSizeMake(targetWidth, targetWidth/imageAspect);
    CGPoint ghostOrigin = CGPointMake(inputSize.width*0.5, inputSize.height*0.2);
    CGRect ghostRect = {ghostOrigin,ghostSize};
    // 创建图形上下文
    UIGraphicsBeginImageContext(inputSize);
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    // 转换座标绘制
    CGAffineTransform flip = CGAffineTransformMakeScale(1.0, -1.0);
    CGAffineTransform flipThenShift = CGAffineTransformTranslate(flip,0,-inputSize.height);
    CGContextConcatCTM(context, flipThenShift);
    CGRect transformedGhostRect = CGRectApplyAffineTransform(ghostRect, flipThenShift);
    CGContextDrawImage(context, transformedGhostRect, img.CGImage);
    
    UIImage * rImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rImg;
}

@end
