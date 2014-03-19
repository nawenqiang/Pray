//
//  PBAllCell.m
//  PrayBook
//
//  Created by 邱扬 on 14-3-11.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import "PBAllCell.h"
#import "PBTabBarViewController.h"
#import "PBDataBase.h"
#import "PBAllViewController.h"
#import "SGAlertMenu.h"

@implementation PBAllCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    //_pbAllBtnOut = [UIButton buttonWithType:UIButtonTypeCustom];
    //_pbAllBtnOut.backgroundColor = [UIColor redColor];
    // Configure the view for the selected state
//    _pbDeleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_pbDeleteBtn setBackgroundImage:[UIImage imageNamed:@"delete.jpg"] forState:UIControlStateNormal];
//    [_pbDeleteBtn setFrame:CGRectMake(245, 25, 30, 30)];
    
    //向左滑动
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    //向右滑动
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    
    [swipeLeft setNumberOfTouchesRequired:1];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setNumberOfTouchesRequired:1];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:swipeLeft];
    [self addGestureRecognizer:swipeRight];
    _pbDeleteBtnOut.hidden = YES;
    _pbAllBtnOut.hidden = NO;
    
    _pbCellVotive.hidden = YES;
}

//改变笔记本状态，已读
- (IBAction)pbAllBtnAction:(id)sender {
    _pbYnHome = (int)[pbSaveDefaults integerForKey:@"home"];
    if (0 == _pbYnFinish) {
        [_pbAllBtnOut setImage:[UIImage imageNamed:@"ok1.png"] forState:UIControlStateNormal];
        PBDataBase *pbUpdateDb = [[PBDataBase alloc] init];
        PBText *pbUpdateText = [[PBText alloc] init];
        pbUpdateText.ynfinish = 1;
        pbUpdateText.time = _pbCellTime.text;
        [pbUpdateDb pbUpdatePBText:pbUpdateText];
        
        int pbUpdateCountY = (int)[pbSaveDefaults integerForKey:@"pbCountY"];
        int pbUpdateCountN = (int)[pbSaveDefaults integerForKey:@"pbCountN"];
        ++pbUpdateCountY;
        --pbUpdateCountN;
        [pbSaveDefaults setInteger:pbUpdateCountY forKey:@"pbCountY"];
        [pbSaveDefaults setInteger:pbUpdateCountN forKey:@"pbCountN"];
    }
    NSLog(@"btntag:%d", (int)_pbAllBtnOut.tag);
    //_pbAllBtnOut.backgroundColor = [UIColor blueColor];
    
    //改变此记录  标记
}

//删除
- (IBAction)pbDeleteBtnAction:(id)sender {
    NSLog(@"btndeletetag:%d", (int)_pbDeleteBtnOut.tag);
    _pbDeleteBtnOut.hidden = YES;
    _pbAllBtnOut.hidden = NO;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"是否删除祈祷" delegate:self cancelButtonTitle:@"我想好了" otherButtonTitles:@"再考虑一下", nil];
    [alertView show];
}

//识别侧滑
- (void)handleSwipe:(UISwipeGestureRecognizer *)gestureRecognizer {
    //CGPoint location = [gestureRecognizer locationInView:self];
    if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"right %d", (int)[pbSaveDefaults integerForKey:@"pbDelete"]);
        //识别 是否处于删除当中
        if (1 == (int)[pbSaveDefaults integerForKey:@"pbDelete"]) {
            [pbSaveDefaults setInteger:0 forKey:@"pbDelete"];
            [self.delegate swipereload];
        } else {
            [pbSaveDefaults setInteger:1 forKey:@"pbDelete"];
        }
        NSString *pbDeleteBtnBgStr = [[NSString alloc] initWithFormat:@"delete%d.png", (int)((_pbDeleteBtnOut.tag + 5) % 5)];
        [_pbDeleteBtnOut setImage:[UIImage imageNamed:pbDeleteBtnBgStr] forState:UIControlStateNormal];
        _pbAllBtnOut.hidden = YES;
        _pbDeleteBtnOut.hidden = NO;
    } else if (gestureRecognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        _pbAllBtnOut.hidden = NO;
        _pbDeleteBtnOut.hidden = YES;
        [pbSaveDefaults setInteger:0 forKey:@"pbDelete"];
    }

}

//单击识别
- (void)handleSingleTap:(UITapGestureRecognizer *)gestureRecognizer {
//    [UIView animateWithDuration:0.5 animations:^{
//        [_pbDeleteBtn setFrame:CGRectMake(320, 10, 30, 30)];
//    }];
//    PBTabBarViewController *pbTabBarVC = [[PBTabBarViewController alloc] init];
//    pbTabBarVC.selectedIndex = 1;
    //[SGActionView sharedActionView].style = SGActionViewStyleDark;
    [SGActionView showAlertWithTitle:@"祈祷信息"
                             message:[[NSString alloc] initWithFormat:@"Prayer\n  %@ \n\nVotive\n  %@ \n\n\n", _pbCellPrayer.text, _pbCellVotive.text]
                         buttonTitle:nil
                      selectedHandle:nil];
    NSLog(@"handle 1");
}

//按钮响应
//- (void)del:(UIButton *)button {
//    NSLog(@"%d", (int)button.tag);
//    
//}

#pragma mark UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"确定删除%d",(int)buttonIndex);
        if ([self.delegate respondsToSelector:@selector(deleteDidSelectedCell:)])
        {
            [self.delegate deleteDidSelectedCell:self];
        }
    }
    else
    {
        NSLog(@"不删%d",(int)buttonIndex);
    }
}

@end
