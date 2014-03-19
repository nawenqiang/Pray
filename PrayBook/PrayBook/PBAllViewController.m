//
//  PBAllViewController.m
//  PrayBook
//
//  Created by 邱扬 on 14-3-10.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import "PBAllViewController.h"
#import "PBTabBarViewController.h"
#import "PBTabBarViewController.h"

@interface PBAllViewController ()

@end

@implementation PBAllViewController

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
    //半圆角
    
    UIImageView *pbMainTableViewBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainbg.png"]];
    pbMainTableViewBg.frame = self.view.bounds;
    pbMainTableViewBg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_pbAllTableView setBackgroundView:pbMainTableViewBg];
    _pbAllTableView.layer.cornerRadius = 5.0;
    
    self.tabBarController.automaticallyAdjustsScrollViewInsets = NO;
    self.pbAllTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}


- (void)viewWillAppear:(BOOL)animated {
    _pbYnFinish = (int)[pbSaveDefaults integerForKey:@"ynfinish"];
    NSLog(@"ynfinish :%d", _pbYnFinish);
    _pbDataBase = [[PBDataBase alloc] init];
    [_pbDataBase pbSelectTablePBText];
    int pbCountSum = _pbDataBase.pbCount.sum;
    int pbCountY = _pbDataBase.pbCount.yfinish;
    int pbCountN = _pbDataBase.pbCount.nfinish;
    [pbSaveDefaults setInteger:pbCountSum forKey:@"pbCountSum"];
    [pbSaveDefaults setInteger:pbCountY forKey:@"pbCountY"];
    [pbSaveDefaults setInteger:pbCountN forKey:@"pbCountN"];
    [pbSaveDefaults setInteger:0 forKey:@"pbDelete"];
    if (1 == _pbYnFinish) {
        _pbCellMA = [[NSMutableArray alloc] initWithCapacity:10];
        _pbCellMA = _pbDataBase.pbTextFinishMA;
    } else {
        _pbCellMA = [[NSMutableArray alloc] initWithCapacity:10];
        _pbCellMA = _pbDataBase.pbTextMA;
    }
    //[_pbDataBase pbDeleteALL];
//    PBText *pbTemp = [[PBText alloc] init];
//    for (int i = 20; i < 40; ++i) {
//        pbTemp.prayer = @"123";
//        pbTemp.votive = @"123";
//        pbTemp.time = [[NSString alloc] initWithFormat:@"%d", i*10];
//        pbTemp.location = @"213";
//        pbTemp.ynfinish = 1;
//        [_pbDataBase pbInsertPBText:pbTemp];
//    }
    
    [self.pbAllTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- pballtablevc
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_pbCellMA count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifyId = @"pbAllCell";
    PBAllCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyId];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"PBAllCell" bundle:nil] forCellReuseIdentifier:cellIdentifyId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyId];
        //cell = [[PBAllCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyId];
        
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    cell.tag = indexPath.row;
    cell.delegate = self;
    //根据数据库记录绘制pbAllBtnOut的背景图
    //cell.pbAllBtnOut.backgroundColor = [UIColor redColor];
    cell.pbAllBtnOut.tag = indexPath.row;
    cell.pbDeleteBtnOut.tag = indexPath.row;
    //[cell.pbDeleteBtnOut setImage:[UIImage imageNamed:@"delete1.png"] forState:UIControlStateNormal];
    NSString *cellimgstr = [[NSString alloc] initWithFormat:@"cell%d.png", (int)(indexPath.row % 5)];
    [cell.pbImgBgOut setImage:[UIImage imageNamed:cellimgstr]];
    cell.layer.cornerRadius = 5.0;
    
    //添加记录信息
    PBText *pbAddCellInfo = [[PBText alloc] init];
    int pbICount= (int)[_pbCellMA count];
    pbAddCellInfo = [_pbCellMA objectAtIndex:(pbICount - 1 - indexPath.row)];
    cell.pbCellPrayer.text = pbAddCellInfo.prayer;
    cell.pbCellVotive.text = pbAddCellInfo.votive;
    cell.pbCellTime.text = pbAddCellInfo.time;
    cell.pbCellLocation.text = pbAddCellInfo.location;
    cell.pbYnFinish = pbAddCellInfo.ynfinish;
    if (0 == pbAddCellInfo.ynfinish) {
        [cell.pbAllBtnOut setImage:[UIImage imageNamed:@"ok0.png"] forState:UIControlStateNormal];
    } else {
        [cell.pbAllBtnOut setImage:[UIImage imageNamed:@"ok1.png"] forState:UIControlStateNormal];
    }
//    NSString *cellIdentifyId = @"pbAllCell";
//    PBAllCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifyId];
//    if (!cell) {
//        cell = [[PBAllCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifyId];
//        
//    }
    
    return cell;
}

//设Cell可编辑
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}

//定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //[tableView setEditing:YES animated:YES];
//    return UITableViewCellEditingStyleDelete;
//}

//进入编辑模式，按下出现的编辑按钮后
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView setEditing:NO animated:YES];
//}

//设置字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"123";
//}

//设置cell在编辑状态 不缩进
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cell selected at index path %ld", indexPath.row);
}


#pragma mark ---- customcelldelegate deleteDidSelectedcell 
- (void)deleteDidSelectedCell:(PBAllCell *)aCell
{
    NSLog(@"deleteDidSelectedcell:%d  %@", (int)aCell.tag, aCell.pbCellPrayer.text);
    PBText *pbDeleteTextCell = [[PBText alloc] init];
    pbDeleteTextCell.time = aCell.pbCellTime.text;
    [_pbDataBase pbDeletePBText:pbDeleteTextCell];
    if (pbDeleteTextCell.ynfinish == 1) {
        int pbCountYVC = (int)[pbSaveDefaults integerForKey:@"pbCountY"];
        --pbCountYVC;
        [pbSaveDefaults setInteger:pbCountYVC forKey:@"pbCountY"];
    } else {
        int pbCountNVC = (int)[pbSaveDefaults integerForKey:@"pbCountN"];
        --pbCountNVC;
        [pbSaveDefaults setInteger:pbCountNVC forKey:@"pbCountN"];
    }
    int pbCountSumVC = (int)[pbSaveDefaults integerForKey:@"pbCountSum"];
    --pbCountSumVC;
    [pbSaveDefaults setInteger:pbCountSumVC forKey:@"pbCountSum"];
    [self viewWillAppear:YES];
    
    [(PBTabBarViewController*)self.parentViewController setBadgeText:_pbDataBase.pbCount.sum];
}

- (void)swipereload {
    [self viewWillAppear:YES];
}

@end
