//
//  MainViewController.m
//  Picture
//
//  Created by user on 15-2-10.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "MainViewController.h"
#import "PhotoAssetManager.h"
#import "PhotoListViewController.h"
@interface MainViewController ()
@property(nonatomic,strong)IBOutlet UIButton * editBut;
@property(nonatomic,strong)IBOutlet UIButton * templateBut;
@end

@implementation MainViewController

#pragma mark - 界面生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 按钮方法
-(IBAction)editPicture:(id)sender
{
    [self pushToPhotoList:sender];
}

-(IBAction)templatePicture:(id)sender
{
    [self pushToPhotoList:sender];
}

#pragma mark - 跳转相关
-(void)pushToPhotoList:(id)sender
{
    [[PhotoAssetManager Instance]getGroupList:^(NSArray * results) {
        ALAssetsGroup * group=[[PhotoAssetManager Instance].assetGroups objectAtIndex:0];
        [[PhotoAssetManager Instance]getPhotosFromGroup:group result:^(NSArray * results) {
            [self performSegueWithIdentifier:@"PresentPhotoList" sender:sender];
        }];
    }];

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual:@"PresentPhotoList"])
    {
        NSInteger tag=((UIButton *)sender).tag;
        PhotoListViewController * photoList=(PhotoListViewController *)segue.destinationViewController;
        if(tag==0)
        {
            photoList.maxPhototCount=4;
        }
        else
        {
            photoList.maxPhototCount=1;
        }
        
        photoList.nextViewType=tag;
        if([PhotoAssetManager Instance].assetGroups)
        {
            photoList.photoGroups=[PhotoAssetManager Instance].assetGroups;
        }

    }
}
@end
