//
//  PBTabBarViewController.h
//  PrayBook
//
//  Created by 邱扬， 那文强 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NSUserDefaults *pbSaveDefaults;

@interface PBTabBarViewController : UITabBarController

@property (nonatomic, strong) NSMutableArray *buttons;
@property int currentSelectedIndex;  //上一个index

- (void)hideExistingTabBar;
- (void)customTabBar:(NSInteger)index;
- (void)customTabBarButton;
- (void)selectedTabBar:(UIButton *)button;
- (void)setNVBtn:(NSString*) imName;
- (void)setBadgeText:(int) i;

@end
