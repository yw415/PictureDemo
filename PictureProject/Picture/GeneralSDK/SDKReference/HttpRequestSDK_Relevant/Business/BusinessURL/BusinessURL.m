//
//  BusinessURL.m
//  GeneralFrame
//
//  Created by user on 14-4-16.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "BusinessURL.h"

@implementation BusinessURL

//初始化
-(id)init
{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}
//单例模式
+(BusinessURL *)Instance
{
    static BusinessURL * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}

//获取接口地址
-(NSString *) getURLWithRequest:(BusinessRequestType) requestType
{
    switch (requestType) {
            
        case URL_Host:
        {
            return [self URL_Host];
        }
            break;
            
        case URL_User_Login:
        {
            return [self URL_User_Login];
        }

        default:
            break;
    }
    
    return nil;
}

//获取接口名称
-(NSString *) getNameWithRequest:(BusinessRequestType) requestType
{
    switch (requestType) {
            
        case URL_Host:
        {
            return @"URL_Host";
        }
            break;
        case URL_User_Login:
        {
            return @"URL_Login";
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - 接口url
//获取服务器地址
-(NSString *)URL_Host
{
    //  return @"http://10.96.106.19:8087/nsapi/";
    //  return @"http://10.96.106.6:8080/nsapi/";
        return @"http://ns.huatu.com/nsapi/";
    //  return @"http://124.207.23.110:8080/nsapi/";
    //	return @"http://124.207.23.110:8080/nsapi/";
    //	return @"http://10.96.106.251:8080/nsapi/";
    //	return @"http://10.96.106.170:8080/nsapi/";
    //  return @"http://124.207.23.110:8080/nsapi/";
    //    return @"http://211.151.49.9:6789/nsapi/";
    //  return @"http://10.96.106.149:8090/nsapi/";
    //	return @"http://10.96.106.149:8090/nsapi/";
    //  return @"http://122.70.132.89:8080/nsapi/";
}

//获取用户登录接口
-(NSString *)URL_User_Login
{
    NSString * url=[NSString stringWithFormat:@"user/login/new"];
    NSString * sUrl=[NSString stringWithFormat:@"%@%@",[self URL_Host],url];
    return sUrl;
}
@end
