//
//  General_ViewController.m
//  GeneralFrame
//
//  Created by user on 14-4-11.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "General_ViewController.h"
#import "UtilitySDK.h"
@interface General_ViewController ()
{
   
}
@property(nonatomic,strong)UIImageView * bgView;
@end

@implementation General_ViewController

#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)init
{
    self=[super init];
    
    if(self)
    {
        
    }
    
    return self;
};

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:NO];
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*开始添加消息监视*/
    //显示等待框监视
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showWait)
                                                name:@"ShowWait"
                                              object:nil];
    //隐藏提示框监视
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(hideWait)
                                                name:@"HideWait"
                                              object:nil];
    //网络连接失败监视
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(showNetFail)
                                                name:@"NetFail"
                                              object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /*开始删除消息监视*/
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ShowWait" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"HideWait" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"NetFail" object:nil];
    /*结束删除消息监视*/
}

//显示等待框
-(void)showWait
{
    [[UISDK Instance] showWait:@"请稍候" view:self.view.window];
}
//隐藏等待框
-(void)hideWait
{
    [[UISDK Instance] hideWait:self.view.window];
}
//网络连接失败
-(void)showNetFail
{
    [[UISDK Instance] showTextHud:@"网络连接失败" view:self.view.window];
}
@end
