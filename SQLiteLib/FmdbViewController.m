//
//  FmdbViewController.m
//  SQLiteLib
//
//  Created by stoicer on 2022/9/19.
//

#import "FmdbViewController.h"

@interface FmdbViewController ()
{
    FMDatabase *_db;
    NSString *dbPath;
}

@end

@implementation FmdbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSString *path = [ NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"fmdb.sqlite3"];
    dbPath = path;
    
    //创建db
    _db = [FMDatabase databaseWithPath:path];
    [_db open];
    
    //先删除
    NSString *deletesql = @"drop table t1";
    if ([_db executeUpdate:deletesql])
    {
        NSLog(@"delete table success.");
    }
    
    //创建
    NSString *sql = @"create table t1 (name VARCHAR (12), age int)";
    if ([_db executeUpdate:sql])
    {
        NSLog(@"create table success.");
    }
    
    
    FMDatabaseQueue *dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
            
        NSString *sql1 = [[NSString alloc] initWithFormat:@"insert into t1 values ('%@',%d)",@"adim",123];
        [db executeUpdate:sql1];
        
        NSString *sql2 = @"select * from t1";
        FMResultSet *set1 = [db executeQuery:sql2];
        while ([set1 next])
        {
            NSString *name = [set1 stringForColumn:@"name"];
            int age = [set1  intForColumn:@"age"];
            NSLog(@"set1--->\n name--->%@, age--->%d",name,age);
        }
        
       
    }];
    
    [dbQueue close];
    
    [dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sql3 = [[NSString alloc] initWithFormat:@"insert into t1 values ('%@',%d)",@"admin",456];
        [db executeUpdate:sql3];
        
        NSString *sql4 = @"select * from t1";
     
        FMResultSet *set2 = [db executeQuery:sql4];
        while ([set2 next])
        {
            NSString *name = [set2 stringForColumn:@"name"];
            int age = [set2  intForColumn:@"age"];
            NSLog(@"set2--->\n name--->%@, age--->%d",name,age);
        }
    }];
    
    [dbQueue close];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
