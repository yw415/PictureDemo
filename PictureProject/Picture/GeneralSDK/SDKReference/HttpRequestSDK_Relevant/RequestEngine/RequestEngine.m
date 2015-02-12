//
//  RequestEngine.m
//  GeneralFrame
//
//  Created by user on 14-4-16.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "RequestEngine.h"
#import "BusinessURL.h"
#pragma mark - AFNetWorking单例
@interface RequestEngine()
@property(nonatomic,strong)NSArray * requestOperations;
@end

@implementation RequestEngine
static NSString * const BaseURL = @"https://api.app.net/";
//单例模式
+(instancetype)Instance
{
    static RequestEngine * instance=nil;
    static dispatch_once_t onceToken=0;
    dispatch_once(&onceToken, ^{
        instance=[[self alloc]initWithBaseURL:[NSURL URLWithString:BaseURL]];
        instance.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        [instance.reachabilityManager startMonitoring];
    });
    
    return instance;
}

-(void)setDefaultHeader:(NSString *)field value:(NSString *)value
{
    [self.requestSerializer setValue:value forHTTPHeaderField:field];
}

//处理相关请求
-(void)requestWithURL:(NSString *)url
           parameters:(NSDictionary *)parameters
         successBlock:(void(^)(id data))successBlock
            failBlock:(void(^)(void))failBlock;
{
    //开始请求
    [self POST:url
          parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             successBlock(responseObject);
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             failBlock();
         }
     ];
}

//创建单个请求
-(id)createRequest:(NSString *)urlStr
        parameters:(NSDictionary *)parameters
      successBlock:(void (^)(NSString * taskURL, id responseObject))successBlock
         failBlock:(void (^)(NSString * taskURL, NSError *error))failBlock
{
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:@"POST" URLString:[[NSURL URLWithString:urlStr relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
    
    AFHTTPRequestOperation * task=[self HTTPRequestOperationWithRequest:request
                                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                    if(successBlock)
                                                                    {
                                                                        NSString * url=operation.request.URL.absoluteString;
                                                                        successBlock(url,responseObject);
                                                                    }
                                                                }
                                                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                    if(failBlock)
                                                                    {
                                                                        NSString * url=operation.request.URL.absoluteString;
                                                                        failBlock(url,error);
                                                                    }
                                                                }];
    

    [task setThreadPriority:1000];
    return (id)task;

}

//创建单个下载请求
-(id)createDownLoadRequest:(NSString *)urlStr
              successBlock:(void (^)(NSString * taskURL, id responseObject))successBlock
                 failBlock:(void (^)(NSString * taskURL, NSError *error))failBlock
              downLoadPath:(NSString *)path
             downLoadBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))downLoadBlock
           expireTimeBlock:(void (^)(void))expireTimeBlock
{
    NSURL * url=[NSURL URLWithString:urlStr];
    NSURLRequest * request=[[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:100000];
    
    AFHTTPRequestOperation * task=[self HTTPRequestOperationWithRequest:request
                                                                success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                    if(successBlock)
                                                                    {
                                                                        NSString * url=operation.request.URL.absoluteString;
                                                                        successBlock(url,responseObject);
                                                                    }
                                                                }
                                                                failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                    if(failBlock)
                                                                    {
                                                                        NSString * url=operation.request.URL.absoluteString;
                                                                        failBlock(url,error);
                                                                    }
                                                                }];
    
         task.outputStream=[NSOutputStream outputStreamToFileAtPath:path append:NO];
        [task setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            
            if(downLoadBlock)
            {
                downLoadBlock(bytesRead,totalBytesRead,totalBytesExpectedToRead);
            }
        }];
    [task setThreadPriority:1];
    
    if(expireTimeBlock)
    {
         [task setShouldExecuteAsBackgroundTaskWithExpirationHandler:expireTimeBlock];
    }


    return (id)task;
    
}


//进行队列请求
-(void)requestWithQueue:(NSArray *)operations
              queueType:(QueueType)queueType
   queueCompletionBlock:(void(^)(NSArray *operations))queueCompletionBlock;
{
    if(queueType==DonwLoadQueue)
    {
        self.requestOperations=operations;
    }
    
    NSLog(@"\n请求队列开始运行\n");
    
   NSArray * ops=[AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
        NSLog(@"\n当前已经完成%d个请求\n",(int)numberOfFinishedOperations);
        NSLog(@"\n当前需要完成的请求数：%d\n",(int)totalNumberOfOperations);
        
    } completionBlock:^(NSArray *operations) {
        
        NSLog(@"请求队列已完成");
        self.requestOperations=nil;
        if(queueCompletionBlock)
        {
            queueCompletionBlock(operations);
        }

    }];
    
    [self.operationQueue addOperations:ops waitUntilFinished:NO];
}

//暂停整个下载请求队列
-(void)pauseAllOperations
{
    for(AFHTTPRequestOperation * operation in self.requestOperations)
    {
        [operation pause];
    }
}
//恢复整个下载请求队列
-(void)resumeAllOperations
{
    for(AFHTTPRequestOperation * operation in self.requestOperations)
    {
        [operation resume];
    }
}
//取消整个下载请求队列
-(void)concelAllOperations
{
    for(AFHTTPRequestOperation * operation in self.requestOperations)
    {
        [operation cancel];
    }
}

@end
