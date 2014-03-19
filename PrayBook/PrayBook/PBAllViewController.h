//
//  PBAllViewController.h
//  PrayBook
//
//  Created by 邱扬 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBAllCell.h"
#import "PBDataBase.h"

@interface PBAllViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CustomCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *pbAllTableView;

@property (nonatomic, strong) PBDataBase *pbDataBase;
@property (nonatomic, strong) NSMutableArray *pbCellMA;
@property int pbYnFinish;

@end
