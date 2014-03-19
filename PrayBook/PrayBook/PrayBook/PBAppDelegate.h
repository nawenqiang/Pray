//
//  PBAppDelegate.h
//  PrayBook
//
//  Created by 邱扬 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBTabBarViewController.h"

@interface PBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet PBTabBarViewController *pbTabBarVC;

@end
