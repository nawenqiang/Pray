//
//  PBDateBase.h
//  PrayBook
//
//  Created by 邱扬 on 14-3-12.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

#define DBPATH @"/tmp/PB.db"

#pragma mark --- PBUSer  - pbUserTable
//用户表数据
//@interface PBUser : NSObject
//
//@property int uid;
//@property (nonatomic, strong) NSString *uname;
//@property (nonatomic, strong) NSString *upassword;
//
//@end

#pragma mark --- PBText  -pbTextTable
//笔记内容表数据
@interface PBText : NSObject

//@property int uid;
@property (nonatomic, strong) NSString *prayer;
@property (nonatomic, strong) NSString *votive;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *location;
@property int ynfinish;

@end

#pragma mark  --- PBCount
//数据统计
@interface PBCount : NSObject

@property int sum;
@property int yfinish;
@property int nfinish;

@end

#pragma mark --- PBDateBase
@interface PBDataBase : NSObject

@property (nonatomic, strong) NSMutableArray *pbTextMA;
@property (nonatomic, strong) NSMutableArray *pbTextFinishMA;
@property (nonatomic, strong) PBCount *pbCount;

//封装数据库操纵方法
- (bool)pbOpendb;
- (void)pbCreateTable;
- (void)pbSelectTablePBText;
- (void)pbInsertPBText:(PBText *)addText;
- (void)pbUpdatePBText:(PBText *)updateText;
- (void)pbDeletePBText:(PBText *)deleteText;
- (void)pbDeleteALL;

@end

