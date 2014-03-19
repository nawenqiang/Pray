//
//  PBTabBarViewController.m
//  PrayBook
//
//  Created by 邱扬， 那文强 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import "PBTabBarViewController.h"
#import "JSBadgeView.h"
#import "leftPush/UIViewController+MMDrawerController.h"
#import "PBDataBase.h"

@interface PBTabBarViewController ()

@end

@implementation PBTabBarViewController
{
    JSBadgeView *_badgeView;
    UIButton    *_leftBtn;
    PBDataBase  *_pbDb;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //na wen qiang
    _leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [self renderNv];
    _pbDb = [[PBDataBase alloc] init];
    [_pbDb pbSelectTablePBText];
    [self setBadgeText:_pbDb.pbCount.sum];
    // qiu yang
    pbSaveDefaults = [NSUserDefaults standardUserDefaults];
    [pbSaveDefaults setInteger:1 forKey:@"home"];
    [pbSaveDefaults setInteger:0 forKey:@"ynfinish"];
    [pbSaveDefaults synchronize];
    //[self showEnergy];
    //隐藏tabbar
    [self hideExistingTabBar];
    [self customTabBar:0];
    
    self.selectedIndex = 2;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark----viewDidAppear
- (void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //_tabBarBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tabbar.jpg"]];
    
    //NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"PBTabBarView" owner:self options:nil];
    //self.customTabBarView = [nibObjects objectAtIndex:0];
    //[_customTabBarView setDelegate:self];
    
    //[self.view addSubview:self.customTabBarView];

}

#pragma mark----custom tabbar
- (void)hideExistingTabBar {
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[UITabBar class]]) {
            view.hidden = YES;
            break;
        }
    }
}

//绘制 tabbar button    +navigation
- (void)customTabBar:(NSInteger)index {
    UIImageView *imgView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:[[NSString alloc] initWithFormat:@"tabbar%d.png", (int)index]]];
    imgView.frame = CGRectMake(0, 515, imgView.image.size.width / 2, imgView.image.size.height / 2);
    [self.view addSubview:imgView];
    
    [self customTabBarButton];
}


- (void)customTabBarButton {
    //创建按钮
    for (int i = 0; i < 3; ++i) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(15 + i * 105, 520, 80, 45);
        [btn addTarget:self action:@selector(selectedTabBar:) forControlEvents:UIControlEventTouchUpInside];
        //btn.backgroundColor = [UIColor colorWithRed:200 green:0 blue:0 alpha:1];
        //NSString *imgstr = [[NSString alloc] initWithFormat:@"bar%d.jpg", i];
        //[btn setBackgroundImage:[UIImage imageNamed:imgstr] forState:UIControlStateNormal] ;
        [_buttons addObject:btn];
        [self.view addSubview:btn];
    }
}

//选择button 更换img
//- (void)selectedTabBarImg:(UIButton *)button forAdd:(NSInteger)add {
//    NSString *selectimgbtn = [[NSString alloc] initWithFormat:@"bar%d.jpg", (int)(button.tag + add)];
//    [button setBackgroundImage:[UIImage imageNamed:selectimgbtn] forState:UIControlStateNormal];
//}

- (void)selectedTabBar:(UIButton *)button {
    //重新绘制
    [self customTabBarButton];
    
    //设置此时button的img
    [self customTabBar:(button.tag + 1)];
    [pbSaveDefaults setInteger:1 forKey:@"ynfinish"];
    [pbSaveDefaults setInteger:0 forKey:@"home"];
    [pbSaveDefaults synchronize];
    //[self customTabBar:0];
    
    
    self.selectedIndex = 0;
    self.currentSelectedIndex = (int)button.tag;
    NSLog(@"bar button:%d", self.currentSelectedIndex);
    self.selectedIndex = button.tag;
    
    //na wen qiang
    [self setNVBtn:@"nvLeftBtn2.png"];
}

#pragma mark----render navigation
- (void)setNVBtn:(NSString*) imName
{
    _leftBtn.frame=CGRectMake(0, 0, 30, 30);
    [_leftBtn setBackgroundImage:[UIImage imageNamed:imName] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem= [[UIBarButtonItem alloc] initWithCustomView: _leftBtn];
}

- (void)renderNv
{
    
    UIImage *backgroundImage = [UIImage imageNamed:@"nv.png"];  //获取图片
    CGRect rt = self.navigationController.navigationBar.frame = CGRectMake(0, 0, 320, 64);
    
    backgroundImage = [self scaleToSize:backgroundImage rt:rt];//设置图片的大小与Navigation Bar相同
    
    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];  //设置背景
    //设置背景样式可用通过设置tintColor来设置
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:50/255.0 green:138/255.0 blue:233/255.0 alpha:1.0];//改变navigation的背景颜色
    
    [self setNVBtn:@"nvLeftBtn.png"];
    [_leftBtn addTarget:self action:@selector(showEnergy) forControlEvents:UIControlEventTouchUpInside];
    [self setRightBtn];
    
}
- (void)setRightBtn
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(0, 0, 30, 30);
    [btn setBackgroundImage:[UIImage imageNamed:@"nvRightBtn.png" ] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    _badgeView  = [[JSBadgeView alloc ] initWithParentView:btn alignment:JSBadgeViewAlignmentTopRight];
    _badgeView.badgeText = @"0";
    [btn addTarget:self action:@selector(showTv) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showTv
{
    self.selectedIndex = 0;
    [pbSaveDefaults setInteger:0 forKey:@"ynfinish"];
    [pbSaveDefaults synchronize];
    [self customTabBar:0];
    self.selectedIndex = 2;
    [self setNVBtn:@"nvLeftBtn.png"];

}

- (UIImage *)scaleToSize:(UIImage *)img rt:(CGRect)rt
{
    UIGraphicsBeginImageContext(CGSizeMake(rt.size.width, rt.size.height+20) );
    [img drawInRect:rt];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//响应返回home
- (void)showEnergy
{
    // qiu yang
    [pbSaveDefaults setInteger:1 forKey:@"home"];
    
    //na wen qiang
    if(self.selectedIndex == 2 &&  0 == (int)[pbSaveDefaults integerForKey:@"ynfinish"])
    {
        //show energy
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }
    else //back
    {
        [self setNVBtn:@"nvLeftBtn.png"];
        [pbSaveDefaults setInteger:0 forKey:@"ynfinish"];
        [self customTabBar:0];
        self.selectedIndex = 1;
        self.selectedIndex = 2;
    }
    [pbSaveDefaults synchronize];
    
}
- (void)setBadgeText:(int) i
{
    _badgeView.badgeText = [NSString stringWithFormat:@"%d",i];
}

@end