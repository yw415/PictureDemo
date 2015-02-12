//
//  MainViewController.m
//  GeneralFramework
//
//  Created by user on 14-8-5.
//  Copyright (c) 2014年 ios. All rights reserved.
//

#import "PhotoTemplateViewController.h"
#import "ConfigSDK.h"
#import "HttpRequestSDK.h"
#import "UtilitySDK.h"
#import "RegisterOrLoginInfoModel.h"
#import "PhotoListViewController.h"
#import "PhotoEditViewController.h"
#import "PhotoAssetManager.h"
#import "TemplateView.h"

#define MaxPhotoCount 4

@interface PhotoTemplateViewController ()
@property(nonatomic,strong)TemplateView * templateView;
@property(nonatomic,strong)UIImage * pushImg;
@property(nonatomic,assign)NSInteger pushIndex;
@end

@implementation PhotoTemplateViewController

#pragma mark - 界面生命周期
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self=[super initWithCoder:aDecoder];
    
    if(self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addSubviews];
    [self.templateView setPhotoFramesImg:self.selectedImgs
                                    keys:self.selectedKeys];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI相关
//添加子视图
-(void)addSubviews
{
    __weak PhotoTemplateViewController * tempView=self;
    NSArray * xibs=[[NSBundle mainBundle]loadNibNamed:@"TemplateView" owner:nil options:nil];
    self.templateView=[xibs objectAtIndex:0];
    self.templateView.frame=CGRectMake(0,
                                       64,
                                       self.templateView.frame.size.width,
                                       self.templateView.frame.size.height);
    self.templateView.photoFrameSelectedBlock=^(UIImage * img,NSInteger selectedIndex){
        tempView.pushImg=img;
        tempView.pushIndex=selectedIndex;
        [tempView performSegueWithIdentifier:@"ShowPhotoChange" sender:nil];
    };
    [self.view addSubview:self.templateView];
}

#pragma mark - 按钮方法
-(IBAction)saveToPhoto:(id)sender
{
    UIImage * img = [[UtilitySDK Instance]capture:self.templateView];
    [[UISDK Instance]showWait:@"请稍候" view:self.view.window];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImageWriteToSavedPhotosAlbum(img,
                                       self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    });
    
}

// 保存完成回调
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    [[UISDK Instance]hideWait:self.view.window];
    
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        [[UISDK Instance]showTextHud:@"保存失败" view:self.view.window];
    }
    else  // No errors
    {
        // Show message image successfully saved
        [[UISDK Instance]showTextHud:@"保存成功" view:self.view.window];
    }
}


#pragma mark - Table Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"PhotoGroup";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text=@"Test";
    return cell;
}

@end
