//
//  Parser.m
//  GeneralFrame
//
//  Created by user on 14-4-15.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "Parser.h"
#import "RegisterOrLoginInfoModel.h"
@implementation Parser
#pragma mark - 登录模块相关接口解析
//初始化
-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;

}
//单例模式
+(Parser *)Instance
{
    static Parser * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]init];
    });
    
    return instance;
}
//通过请求类型进行解析
-(id)parserWithRequestType:(BusinessRequestType)requestType json:(NSData *)json
{
    if(!json)
    {
        return nil;
    }
    

    NSDictionary * jsonDic=[NSJSONSerialization JSONObjectWithData:json
                                                            options:NSJSONReadingMutableContainers
                                                              error:NULL];
    
    //检查服务器返回的信息码
    NSString * conditionCode=[jsonDic objectForKey:@"code"];
    if(conditionCode.intValue>=0)
    {
        id datas=[jsonDic objectForKey:@"data"];
        
        if(datas)
        {
            switch (requestType)
            {
                case URL_User_Login:
                {
                   return [self getRegisterOrLoginInfo:datas];
                }
                    break;
                default:
                    break;
                    
            }
        }
        NSLog(@"\n数据为空\n");
        return nil;
    }
    else
    {
        switch (conditionCode.intValue) {
            
            case -3:
            {
                NSLog(@"服务器异常");
            }
                break;
            case -6:
            {
                NSString * codeStr=[NSString stringWithFormat:@"%d",-6];
                return [self getRegisterOrLoginInfo:codeStr];
            }
                break;
            case -7:
            {
                NSString * codeStr=[NSString stringWithFormat:@"%d",-7];
                return [self getRegisterOrLoginInfo:codeStr];
            }
                break;
                break;
            default:
                break;
        }
    }


  
    return nil;
}

#pragma mark － 各个接口数据解析
//解析注册或登录返回信息
-(id)getRegisterOrLoginInfo:(id)datas
{
 
    if([datas isKindOfClass:[NSString class]])
    {
        return datas;
    }
    
    NSString * userID=[NSString stringWithFormat:@"%qi",((NSString *)[datas objectForKey:@"userid"]).longLongValue];
    NSString * key=[datas objectForKey:@"key"];
    NSString * areaID=[datas objectForKey:@"areaid"];
    NSString * userName=[datas objectForKey:@"username"];
    NSString * ua=[datas objectForKey:@"ua"];
    
    RegisterOrLoginInfoModel * regOrLoginModel=[[RegisterOrLoginInfoModel alloc]init];
    regOrLoginModel.userID=userID;
    regOrLoginModel.key=key;
    regOrLoginModel.areaID=areaID;
    regOrLoginModel.userName=userName;
    regOrLoginModel.ua=ua;
    
    return (id)regOrLoginModel;
}
@end
