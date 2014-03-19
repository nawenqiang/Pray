//
//  PBDateBase.m
//  PrayBook
//
//  Created by 邱扬 on 14-3-12.
//  Copyright (c) 2014年 changyou.com. All rights reserved.
//

#import "PBDataBase.h"


@implementation PBText

@end

@implementation PBCount

@end


@implementation PBDataBase {
    FMDatabase *_db;
}

- (bool)pbOpendb {
    //db 不存在会自己创建
    _db = [FMDatabase databaseWithPath:DBPATH];
    if ([_db open]) {
        NSLog(@"db open !");
        [self pbCreateTable];
        return YES;
    } else {
        NSLog(@"db open failure");
        [_db close];
        return NO;
    }
}

- (void)pbCreateTable {
    NSString *pbTextTableSql = @"create table pbTextTable (prayer text, votive text, time text, location text, ynfinish int)";
    BOOL pbTextTableRes = [_db executeUpdate:pbTextTableSql];
    if (!pbTextTableRes) {
        NSLog(@"create pbTextTable error : %@", [_db lastError]);
    } else {
        NSLog(@"create pbTextTable ok");
    }
}

- (void)pbSelectTablePBText {
    if ([self pbOpendb]) {
        _pbTextMA = [[NSMutableArray alloc] initWithCapacity:10];
        _pbCount = [[PBCount alloc] init];
        _pbTextFinishMA = [[NSMutableArray alloc] initWithCapacity:10];
        FMResultSet *pbTextSelectRs = [_db executeQuery:@"select * from pbTextTable"];
        while ([pbTextSelectRs next]) {
            if (!([[pbTextSelectRs columnNameForIndex:0] isEqualToString:@"prayer"] && [[pbTextSelectRs columnNameForIndex:1] isEqualToString:@"votive"])) {
                NSLog(@"select text failer!");
                [_db close];
                return ;
            }
            PBText *pbSelectText = [[PBText alloc] init];
            NSLog(@"%@, %@, %@, %@, %d",[pbTextSelectRs stringForColumn:@"prayer"], [pbTextSelectRs stringForColumn:@"votive"], [pbTextSelectRs stringForColumn:@"time"], [pbTextSelectRs stringForColumn:@"location"], [pbTextSelectRs intForColumn:@"ynfinish"]);
            pbSelectText.prayer = [pbTextSelectRs stringForColumn:@"prayer"];
            pbSelectText.votive = [pbTextSelectRs stringForColumn:@"votive"];
            pbSelectText.time = [pbTextSelectRs stringForColumn:@"time"];
            pbSelectText.location = [pbTextSelectRs stringForColumn:@"location"];
            pbSelectText.ynfinish = [pbTextSelectRs intForColumn:@"ynfinish"];
            [_pbTextMA addObject:pbSelectText];
            ++_pbCount.sum;
            if (1 == pbSelectText.ynfinish) {
                [_pbTextFinishMA addObject:pbSelectText];
                ++_pbCount.yfinish;
            } else {
                ++_pbCount.nfinish;
            }
        }
        [_db close];
        return ;
    } else {
        [_db close];
        return ;
    }
}

- (void)pbInsertPBText:(PBText *)addText {
    if ([self pbOpendb]) {
        bool pbInsertTextRs = [_db executeUpdate:@"insert into pbTextTable (prayer, votive, time, location, ynfinish) values(?, ?, ?, ?, ?)",addText.prayer, addText.votive, addText.time, addText.location, [NSNumber numberWithInt:addText.ynfinish]];
        if (pbInsertTextRs) {
            NSLog(@"insert text ok");
            [_pbTextMA addObject:addText];
            [_db close];
        } else {
            NSLog(@"insert text failer error: %@", [_db lastError]);
            [_db close];
        }
    } else {
        [_db close];
    }
}

//- (bool)pbUpdatePBUser;  //预留密码更改接口

- (void)pbUpdatePBText:(PBText *)updateText {
    if ([self pbOpendb]) {
        bool pbUpdateTextRs = [_db executeUpdate:@"update pbTextTable set ynfinish = ? where time = ?", [NSNumber numberWithInt:updateText.ynfinish], updateText.time];
        if (pbUpdateTextRs) {
            NSLog(@"update text ok");
            
            [_db close];
        } else {
            NSLog(@"update text failer error: %@", [_db lastError]);
            [_db close];
        }
    } else {
        [_db close];
    }
}

- (void)pbDeletePBText:(PBText *)deleteText {
    if ([self pbOpendb]) {
        bool pbDeleteTextRs = [_db executeUpdate:@"delete from pbTextTable where time = ?", deleteText.time];
        if (pbDeleteTextRs) {
            NSLog(@"delete text ok");
            [_pbTextMA removeObject:deleteText];
            --_pbCount.sum;
            if (1 == deleteText.ynfinish) {
                --_pbCount.yfinish;
            } else {
                --_pbCount.nfinish;
            }
            [_db close];
        } else {
            NSLog(@"delete text failer error: %@", [_db lastError]);
            [_db close];
        }
    } else {
        [_db close];
    }
}

//测试  删除所有
- (void)pbDeleteALL {
    if ([self pbOpendb]) {
        [_db executeUpdate:@"delete from pbTextTable"];
    }
}

@end
