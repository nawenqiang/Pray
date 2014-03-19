//
//  leftViewController.m
//  MMDrawerControllerKitchenSink
//
//  Created by na on 14-3-13.
//  Copyright (c) 2014年 Mutual Mobile. All rights reserved.
//

#import "leftViewController.h"
#import "LDProgressView.h"
#import "PBTabBarViewController.h"

@interface leftViewController () {
    UILabel *_pbUserLabelYFinish;
    UILabel *_pbUserLabelNFinish;
}

@end

@implementation leftViewController

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

//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(click)];
    //self.navigation
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    int pbCountLeftSum = (int)[pbSaveDefaults integerForKey:@"pbCountSum"];
    int pbCountLeftY = (int)[pbSaveDefaults integerForKey:@"pbCountY"];
    int pbCountLeftN = (int)[pbSaveDefaults integerForKey:@"pbCountN"];
    
    
    _pbUserYSum.text = [[NSString alloc] initWithFormat:@"%d", pbCountLeftSum];
    _pbUserNSum.text = [[NSString alloc] initWithFormat:@"%d", pbCountLeftSum];
    
    double pbPercentY = 0;
    double pbPercentN = 0;
    if (0 != pbCountLeftSum) {
        pbPercentY = (double)pbCountLeftY/(double)pbCountLeftSum;
        pbPercentN = (double)pbCountLeftN/(double)pbCountLeftSum;
    }
    
    _pbUserYPercent.text = [[NSString alloc] initWithFormat:@"%d%%", (int)(pbPercentY * 100)];
    _pbUserNPercent.text = [[NSString alloc] initWithFormat:@"%d%%", (int)(pbPercentN * 100)];
    
    //process
    LDProgressView *pbUserProcessYFinish = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 174, 188, 22)];
    pbUserProcessYFinish.progress = ((double)pbCountLeftY/(double)pbCountLeftSum);
    pbUserProcessYFinish.color = [UIColor colorWithRed:0.80f green:0.00f blue:0.00f alpha:1.00f];
    pbUserProcessYFinish.flat = @YES;
    pbUserProcessYFinish.animate = @YES;
    [self.view addSubview:pbUserProcessYFinish];
    
    _pbUserLabelYFinish = [[UILabel alloc] initWithFrame:CGRectMake(15 + pbPercentY*100*1.8, 155, 29, 21)];
    _pbUserLabelYFinish.text = [[NSString alloc] initWithFormat:@"%d", pbCountLeftY];
    [self.view addSubview:_pbUserLabelYFinish];
    
    LDProgressView *pbUserProcessNFinish = [[LDProgressView alloc] initWithFrame:CGRectMake(20, 244, 188, 22)];
    pbUserProcessNFinish.progress = ((double)pbCountLeftN/(double)pbCountLeftSum);
    pbUserProcessNFinish.color = [UIColor colorWithRed:0.00f green:0.30f blue:0.80f alpha:1.00f];
    pbUserProcessNFinish.flat = @YES;
    pbUserProcessNFinish.animate = @YES;
    [self.view addSubview:pbUserProcessNFinish];
    
    _pbUserLabelNFinish = [[UILabel alloc] initWithFrame:CGRectMake(15 + pbPercentN*100*1.8, 225, 29, 21)];
    _pbUserLabelNFinish.text = [[NSString alloc] initWithFormat:@"%d", pbCountLeftN];
    [self.view addSubview:_pbUserLabelNFinish];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_pbUserLabelYFinish removeFromSuperview];
    [_pbUserLabelNFinish removeFromSuperview];
}

- (void)click
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
