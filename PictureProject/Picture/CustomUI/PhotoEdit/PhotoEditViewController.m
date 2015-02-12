//
//  PhotoChangeViewController.m
//  Picture
//
//  Created by user on 15-2-3.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PhotoEditViewController.h"
#import "PhotoAssetManager.h"
#import "CustomToolBar.h"
#import "ImageProcessItem.h"
#import "ImageProcessOperationView.h"
@interface PhotoEditViewController ()<CustomToolBarDelegate>
@property(nonatomic,strong)IBOutlet UIImageView * editedPhoto;
@property(nonatomic,strong)IBOutlet CustomToolBar * toolBar;
@property(nonatomic,strong)IBOutlet ImageProcessOperationView * operationView;
@property(nonatomic,strong)NSArray * toolTitles;
@property(nonatomic,assign)NSInteger selectedIndex;
@end

@implementation PhotoEditViewController

#pragma mark - 界面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak PhotoEditViewController * tempView=self;
    self.toolTitles=[NSArray arrayWithObjects:@"滤镜",@"水印", nil];
    self.operationView.sourceImg=self.photo;
    self.operationView.editedImg=self.photo;
    self.operationView.selectedBlock=^(UIImage * img)
    {
        tempView.editedPhoto.image=img;
    };
    
    [self.operationView configureData:0];
    self.editedPhoto.image=self.photo;
    [self.toolBar reloadData];
    [self.toolBar selectedItem:0];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    NSLog(@"PhotoChangeViewController销毁");
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 导航栏相关
//保存图片到相册
-(IBAction)saveToPhoto:(id)sender
{
    UIImage * img=self.editedPhoto.image;
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
#pragma mark - 工具栏相关方法

/// 显示操作视图
-(void)showOperationView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.operationView.frame=CGRectMake(0,
                                            self.operationView.frame.origin.y-100,
                                            self.operationView.frame.size.width,
                                            self.operationView.frame.size.height);
    }];
}
/// 隐藏操作视图
-(void)hideOperationView:(int)index
{
    if(self.selectedIndex==index)
    {
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.operationView.frame=CGRectMake(0,
                                            self.operationView.frame.origin.y+100,
                                            self.operationView.frame.size.width,
                                            self.operationView.frame.size.height);
    } completion:^(BOOL finished) {
        [self.operationView configureData:index];
        [self showOperationView];
    }];
}



#pragma mark - 自定义工具栏相关委托 CustomToolBarDelegate
/// 工具栏项总数
-(int)itemCount
{
    return 2;
}

/// 工具栏视图
-(UIView *)itemView:(int)index
{
    ImageProcessItem * item=[[ImageProcessItem alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 60)];
    NSString * title=[self.toolTitles objectAtIndex:index];
    [item setLabelText:title];
    return item;
}

/// 选中工具栏项
-(void)selectedItem:(UIView *)selectedView index:(int)selectedIndex
{
    ImageProcessItem * item=(ImageProcessItem *)selectedView;
    [item setSelected:YES];
    [self hideOperationView:selectedIndex];
    self.selectedIndex=selectedIndex;
}

/// 取消选中工具栏项
-(void)unselectedItem:(UIView *)unselectedView index:(int)unselectedIndex
{
    ImageProcessItem * item=(ImageProcessItem *)unselectedView;
    [item setSelected:NO];
}

@end
