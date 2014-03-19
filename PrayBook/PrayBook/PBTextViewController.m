//
//  PBTextViewController.m
//  PrayBook
//
//  Created by 那文强 on 14-3-10.
//  Copyright (c) 2014年 那文强. All rights reserved.
//

#import "PBTextViewController.h"

#import "PBTabBarViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PBDataBase.h"
#import "PBTabBarViewController.h"

@interface PBTextViewController ()<CLLocationManagerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bkImageView;

@end

@implementation PBTextViewController
{
    CGRect _firstViewRt,_secondViewRt;
    UIImageView *_imageView;
    UILabel *_votiveLb;
    UIButton    *_leftBtn,*_rightBtn;
    UITextView *_upTv,*_downTv;
    UILabel *_upLb,*_downLb,*_dateLb,*_nameLb,*_locationLb;
    CLLocationManager *_locationManager;
    PBDataBase  *_pbDb;
    CGRect  _viewRt;
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
    // Do any additional setup after loading the view from its nib.
    _viewRt = self.view.bounds;
    _locationLb = [[UILabel alloc] initWithFrame:CGRectMake(95.0,270.0,185.0,20.0)];
    _locationLb.textAlignment = NSTextAlignmentRight;
    _nameLb = [[UILabel alloc] initWithFrame:CGRectMake(240.0,230.0,140.0,20.0)];
    _dateLb= [[UILabel alloc] initWithFrame:CGRectMake(145.0,250.0,150.0,20.0)];
    _upLb = [[UILabel alloc] initWithFrame:CGRectMake(15.0,45.0,250.0,0.0)];
    _upLb.text = @"";
    _downLb= [[UILabel alloc] initWithFrame: CGRectMake(15.0,150.0,250.0,0.0)];

    _upTv = [[UITextView alloc] init];
    _downTv =[[UITextView alloc] init];
    _imageView = [[UIImageView alloc] init];
    _firstViewRt = CGRectMake(10.0,70.0,300.0,350.0);
    _secondViewRt = CGRectMake(10.0,70.0,300.0,300.0);
    _leftBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _votiveLb = [[UILabel alloc] init];
    
    [self   renderFirstView];
    [self   renderBtn];
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.distanceFilter = 1000.0f;
    
    _pbDb = [[PBDataBase alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    if([_upLb.text isEqualToString:@""])
    {
        [_upTv becomeFirstResponder];
    }
}

#pragma mark---- location
- (void)startUplocation
{
    if ([CLLocationManager locationServicesEnabled])
    {
        [_locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请开启定位功能！"delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [av show];
    }
}

#pragma mark - CLLocationManagerDelegate
// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    // 获取经纬度
    NSLog(@"纬度:%f",newLocation.coordinate.latitude);
    NSLog(@"经度:%f",newLocation.coordinate.longitude);

    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation: newLocation completionHandler:^(NSArray *array, NSError *error) {
        if (![_upLb.text isEqualToString:@""])
        {
            if (array.count > 0 )
            {
                CLPlacemark *placemark = [array objectAtIndex:0];
                NSString *city = placemark.locality;
                NSString *street = placemark.thoroughfare;
                NSLog(@"%@,%@",city,street);
                NSMutableString *ms = [[NSMutableString alloc] init];
                if (city != nil) {
                    [ms appendString:city];
                }
                if (street != nil) {
                    [ms appendString:street];
                }
                _locationLb.text = ms;
            }
            else
            {
                _locationLb.text = @"find street failed";
            }
        }

    }];
    // 停止位置更新
    [manager stopUpdatingLocation];
}

// 定位失误时触发
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"error:%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark---- render
- (void)renderFirstView
{
    _imageView.frame = _firstViewRt;
    _imageView.image = [UIImage imageNamed:@"first"];
    _imageView.userInteractionEnabled = YES;
    
    UILabel *prayerLb = [[UILabel alloc]init];
    prayerLb.frame = CGRectMake(15.0,20.0,230.0,20.0);
    prayerLb.text = @"Prayer";
    [_imageView addSubview:prayerLb];
    
    _upTv.frame = CGRectMake(15.0,45.0,250.0,60.0);
    _upTv.backgroundColor = [UIColor clearColor];
    _upTv.textColor = [UIColor whiteColor];
    _upTv.delegate = self;
    [_imageView addSubview:_upTv];

    _votiveLb.frame = CGRectMake(15.0,190.0,250.0,20.0);
    _votiveLb.text = @"Votive";
    [_imageView addSubview:_votiveLb];
    
    _downTv.frame = CGRectMake(15.0,215.0,250.0,60.0);
    _downTv.backgroundColor = [UIColor clearColor];
    _downTv.textColor = [UIColor whiteColor];
    _downTv.delegate = self;
    [_imageView addSubview:_downTv];
    
    [_bkImageView addSubview:_imageView];
}

- (void)renderBtn
{
    _leftBtn.frame = CGRectMake(50.0,450.0,50.0,20.0);
    [_leftBtn setTitle:@"祈祷" forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(prayerBtn) forControlEvents:UIControlEventTouchUpInside];

    _rightBtn.frame = CGRectMake(200.0,450.0,50.0,20.0);
    [_rightBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(cancelBtn) forControlEvents:UIControlEventTouchUpInside];
    [_bkImageView addSubview:_leftBtn];
    [_bkImageView addSubview:_rightBtn];
}



- (NSString*)getDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YY/MM/dd HH:mm:ss"];
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    return [formatter stringFromDate:datenow];
}



- (void)showMainView
{
    PBTabBarViewController*  tb = (PBTabBarViewController*)self.parentViewController;
    [pbSaveDefaults setInteger:0 forKey:@"ynfinish"];
    [pbSaveDefaults synchronize];
    [(PBTabBarViewController*)self.parentViewController customTabBar:0];
    tb.selectedIndex = 2;
    [self renderFirstView];
    [self renderBtn];
    _upTv.text = @"";
    _downTv.text = @"";
    _upTv.hidden = NO;
    _downTv.hidden = NO;
    _upLb.text = @"";
    _downLb.text = @"";
    _dateLb.text = @"";
    _nameLb.text = @"";
    _locationLb.text = @"";
}

- (void)addDataToDatabase
{
    PBText *pt = [[PBText alloc] init];
    pt.prayer = _upLb.text;
    pt.votive = _downLb.text;
    pt.time   = _dateLb.text;
    pt.location = _locationLb.text;
    [_pbDb pbInsertPBText:pt];
}


#pragma mark---- btn handler
- (void)cancelBtn
{
    [(PBTabBarViewController*)self.parentViewController setNVBtn:@"nvLeftBtn.png"];
    
    if([_rightBtn.currentTitle isEqualToString:@"删除"])
    {
        [self showMainView];
        return ;
    }
    PBTabBarViewController*  tb = (PBTabBarViewController*)self.parentViewController;

    tb.selectedIndex = 2;

    _upTv.text = @"";
    _downTv.text = @"";
    [(PBTabBarViewController*)self.parentViewController customTabBar:0];
    [_downTv resignFirstResponder];
}

- (void)prayerBtn
{
    if([_upTv.text isEqualToString:@""] )
    {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"Prayer不能都为空"delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    if([_leftBtn.currentTitle isEqualToString:@"完成"])
    {
        [self addDataToDatabase];
        [self showMainView];
        [(PBTabBarViewController*)self.parentViewController setNVBtn:@"nvLeftBtn.png"];
        _pbDb = [[PBDataBase alloc] init];
        [_pbDb pbSelectTablePBText];
        [(PBTabBarViewController*)self.parentViewController setBadgeText:_pbDb.pbCount.sum];
        return ;
    }
    [self startUplocation];
    [_downTv resignFirstResponder];
    self.view.bounds = _viewRt;

    _upTv.hidden = YES;
    _downTv.hidden = YES;
    _imageView.frame = _secondViewRt;
    _imageView.image = [UIImage imageNamed:@"second"];
    _imageView.userInteractionEnabled = YES;
    
    _votiveLb.frame = CGRectMake(15.0,120.0,230.0,20.0);
    
    _leftBtn.frame = CGRectMake(50.0,390.0,50.0,20.0);
    [_leftBtn setTitle:@"完成" forState:UIControlStateNormal];

    _rightBtn.frame = CGRectMake(200.0,390.0,50.0,20.0);
    [_rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    
    _upLb.textColor = [UIColor whiteColor];
    _upLb.font = [UIFont systemFontOfSize:12.0];
    _upLb.numberOfLines = 0;
    _upLb.text = _upTv.text;
    [_upLb sizeToFit];
    [_imageView addSubview:_upLb];

    _downLb.textColor = [UIColor whiteColor];
    _downLb.font = [UIFont systemFontOfSize:12.0];
    _downLb.numberOfLines = 0;
    _downLb.text = _downTv.text;
    [_downLb sizeToFit];
    [_imageView addSubview:_downLb];
    
    _dateLb.text = [self getDate];
    [_imageView addSubview:_dateLb];

    _nameLb.text = @"大猫";
    [_imageView addSubview:_nameLb];

    [_imageView addSubview:_locationLb];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == _bkImageView || view == _imageView)
    {
        [_upTv resignFirstResponder];
        [_downTv resignFirstResponder];
    }
    self.view.bounds = _viewRt;
}

#pragma mark---- textview delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView == _downTv)
    {
        [UIView beginAnimations:@"Curl"context:nil];//动画开始
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationDelegate:self];
        self.view.bounds = CGRectMake(0.0, 0.0, _viewRt.size.width,_viewRt.size.height+300);
        [UIView commitAnimations];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView.contentSize.height >60)
    {
        //删除最后一行的第一个字符，以便减少一行。
        textView.text = [textView.text substringToIndex:[textView.text length]-1];
        return NO;
    }
    
    return YES;
}

@end
