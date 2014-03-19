//
//  PBAllCell.h
//  PrayBook
//
//  Created by 邱扬 on 14-3-11.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomCellDelegate;

@interface PBAllCell : UITableViewCell<UIGestureRecognizerDelegate>

@property (assign, nonatomic) id<CustomCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *pbAllBtnOut;
@property (weak, nonatomic) IBOutlet UIButton *pbDeleteBtnOut;
@property (weak, nonatomic) IBOutlet UIImageView *pbImgBgOut;
@property (weak, nonatomic) IBOutlet UILabel *pbCellPrayer;
@property (weak, nonatomic) IBOutlet UILabel *pbCellVotive;

@property (weak, nonatomic) IBOutlet UILabel *pbCellTime;
@property (weak, nonatomic) IBOutlet UILabel *pbCellLocation;
@property int pbYnFinish;
@property int pbYnHome;

//@property (weak, nonatomic) UIButton *pbDeleteBtn;
- (IBAction)pbAllBtnAction:(id)sender;
- (IBAction)pbDeleteBtnAction:(id)sender;

@end

@protocol CustomCellDelegate <NSObject>

- (void)deleteDidSelectedCell:(PBAllCell *)aCell;
- (void)swipereload;

@end