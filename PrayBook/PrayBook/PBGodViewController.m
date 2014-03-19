//
//  PBGodViewController.m
//  PrayBook
//
//  Created by 邱扬 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import "PBGodViewController.h"

@interface PBGodViewController ()

@end

@implementation PBGodViewController

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
}

- (void)viewWillAppear:(BOOL)animated {
    _pbGodImgOut.image = [UIImage imageNamed:@"godbg1.png"];
    _pbGodBtnflowerOut.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pbGodBtnflower:(id)sender {
    _pbGodBtnflowerOut.hidden = YES;
    _pbGodImgOut.image = [UIImage imageNamed:@"godbg2.png"];
}
@end
