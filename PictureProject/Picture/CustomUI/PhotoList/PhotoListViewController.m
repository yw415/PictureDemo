//
//  PhotoListViewController.m
//  Picture
//
//  Created by user on 15-1-20.
//  Copyright (c) 2015年 ios. All rights reserved.
//

#import "PhotoListViewController.h"
#import "PhotoGroupCell.h"
#import "MaskView.h"
#import "PhotoAssetManager.h"
#import "CollectionViewCell.h"
#import "PhotoTemplateViewController.h"
#import "PhotoEditViewController.h"
#define CellHeight 64
@interface PhotoListViewController ()<UITableViewDataSource,
                                        UITableViewDelegate,
                                        UICollectionViewDataSource,
                                        UICollectionViewDelegate>
@property(nonatomic,strong)UITableView * photoTable;
@property(nonatomic,strong)IBOutlet UICollectionView * photoCollect;
@property(nonatomic,strong)IBOutlet UIView * optionView;
@property(nonatomic,strong)IBOutlet UILabel * photoCount;
@property(nonatomic,strong)UIView * maskView;
@property(nonatomic,assign)BOOL show;
@property(nonatomic,strong)NSMutableDictionary * selectedItem;
@property(nonatomic,strong)NSMutableDictionary * selectedKeys;
@end

@implementation PhotoListViewController
#pragma mark - 界面生命周期
-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        self.selectedItem=[NSMutableDictionary dictionary];
        self.selectedKeys=[NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addSubviews];
    
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
    NSLog(@"PhotoListView销毁");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 界面UI相关
//添加子视图
-(void)addSubviews
{
    //改变层级结构
    [self.view bringSubviewToFront:self.optionView];
    
    CGRect rect = CGRectMake(0,
                           ScreenHeight-50,
                            ScreenWidth,
                            self.photoGroups.count*CellHeight);
    //添加列表
    self.photoTable=[[UITableView alloc]initWithFrame:rect];
    [self.photoTable registerNib:[UINib nibWithNibName:@"PhotoGroupCell" bundle:nil]
          forCellReuseIdentifier:@"PhotoGroup"];
    //[self.photoTable registerClass:[PhotoGroupCell class] forCellReuseIdentifier:@"PhotoGroup"];
    self.photoTable.dataSource=self;
    self.photoTable.delegate=self;
    [self.view insertSubview:self.photoTable belowSubview:self.optionView];
    
    self.photoCount.text=[NSString stringWithFormat:@"%d",(int)[PhotoAssetManager Instance].currentPhotos.count];
    
    NSIndexPath * indexPath=[NSIndexPath indexPathForItem:0 inSection:0];
    [self.photoTable selectRowAtIndexPath:indexPath
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionBottom];
    
    self.maskView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.maskView.backgroundColor=[UIColor blackColor];
    self.maskView.alpha=0;
    [self.view insertSubview:self.maskView belowSubview:self.photoTable];
    
}

#pragma mark - 按钮方法
//展示相册
-(IBAction)showPhotoList:(id)sender
{
    self.show=!self.show;
    if(self.show)
    {
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=CGRectMake(self.photoTable.frame.origin.x,
                                   self.photoTable.frame.origin.y-self.photoTable.frame.size.height,
                                   self.photoTable.frame.size.width,
                                   self.photoTable.frame.size.height);
            self.photoTable.frame=rect;
            self.maskView.alpha=0.5;
        }];
    }
    else
    {
        
        [UIView animateWithDuration:0.4 animations:^{
            CGRect rect=CGRectMake(self.photoTable.frame.origin.x,
                                   self.optionView.frame.origin.y,
                                   self.photoTable.frame.size.width,
                                   self.photoTable.frame.size.height);
            self.photoTable.frame=rect;
            self.maskView.alpha=0.0;
        }];
    }

}

//确认选择 返回首页
-(IBAction)confirmSubmit:(id)sender
{
    if(self.nextViewType==PhotoTemplate)
    {
        [self performSegueWithIdentifier:@"ShowPhotoTemplate" sender:nil];
    }
    else
    {
        if(self.selectedItem.count>0)
        {
            [self performSegueWithIdentifier:@"ShowPhotoEdit" sender:nil];
        }
    }

}

#pragma mark - 跳转相关
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController * obj = segue.destinationViewController;
    if([obj class] ==[UINavigationController class])
    {
        UINavigationController * nav=(UINavigationController *)obj;
        if([segue.identifier isEqualToString:@"ShowPhotoTemplate"])
        {
            PhotoTemplateViewController * templateView=[nav.viewControllers objectAtIndex:0];
            templateView.selectedImgs=self.selectedItem;
            templateView.selectedKeys=self.selectedKeys;
            
        }
        else
        {
            PhotoEditViewController * photoEdit=[nav.viewControllers objectAtIndex:0];
            NSString * key=[self.selectedItem.allKeys objectAtIndex:0];
            UIImage * img=[self.selectedItem objectForKey:key];
            photoEdit.photo=img;
        }
    }
    else
    {
        if([segue.identifier isEqualToString:@"ShowPhotoTemplate"])
        {
            PhotoTemplateViewController * templateView=
            (PhotoTemplateViewController *)segue.destinationViewController;
            templateView.selectedImgs=self.selectedItem;
            templateView.selectedKeys=self.selectedKeys;
            
        }
        else
        {
            PhotoEditViewController * photoEdit=
            (PhotoEditViewController *)segue.destinationViewController;
            NSString * key=[self.selectedItem.allKeys objectAtIndex:0];
            UIImage * img=[self.selectedItem objectForKey:key];
            photoEdit.photo=img;
        }
    }

}

#pragma mark - Table Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CellHeight;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.photoGroups.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"PhotoGroup";
    PhotoGroupCell * cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor=UICOLOR_RGB_Alpha(0x4cd3ff, 1);
    
    NSDictionary * detail=[[PhotoAssetManager Instance]getGroupInfo:indexPath.row];
    [cell setThumbanilView:[detail objectForKey:@"Thumbnail"]];
    [cell setGrounpnameText:[detail objectForKey:@"Name"]];
    [cell setPhototCountText:[detail objectForKey:@"Count"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ALAssetsGroup * group=[[PhotoAssetManager Instance].assetGroups objectAtIndex:indexPath.row];
    [[PhotoAssetManager Instance]getPhotosFromGroup:group result:^(NSArray * results) {
        self.photoCount.text=[NSString stringWithFormat:@"%d",(int)results.count];
        [self showPhotoList:nil];
        [self.photoCollect reloadData];
        [self.selectedItem removeAllObjects];
    }];
}

#pragma mark - CollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [PhotoAssetManager Instance].currentPhotos.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell=(CollectionViewCell *)[self.photoCollect
                                                     dequeueReusableCellWithReuseIdentifier:@"PhotoCell"
                                                                               forIndexPath:indexPath];
    UIImage * thumbnailImg=[[PhotoAssetManager Instance]getImageWithIndex:indexPath.row
                                                                 type:PhotoThumbnail];
    [cell setThumbnailImage:thumbnailImg];
    
    NSString * key=[NSString stringWithFormat:@"%d",(int)indexPath.row];
    if([self.selectedItem.allKeys containsObject:key])
    {
        [cell showMask:YES];
    }
    else
    {
        [cell showMask:NO];
        
    }

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell * cell=(CollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString * key=[NSString stringWithFormat:@"%d",(int)indexPath.row];
    
    if([self.selectedKeys.allKeys containsObject:key])
    {
        [cell showMask:NO];
        [self.selectedItem removeObjectForKey:key];
        [self.selectedKeys removeObjectForKey:key];
    }
    else
    {
        if(self.selectedKeys.count>=self.maxPhototCount)
        {
            [[UISDK Instance]showTextHud:@"已达到最大选择数" view:self.view.window];
            return;
        }
        [cell showMask:YES];
        
        NSString * count=[NSString stringWithFormat:@"%d",(int)self.selectedItem.count];
        UIImage * img=[[PhotoAssetManager Instance]getImageWithIndex:indexPath.row
                                                                type:PhotoScreenSize];
        [self.selectedKeys setValue:count forKey:key];
        [self.selectedItem setValue:img forKey:key];
  
    }
}



@end
