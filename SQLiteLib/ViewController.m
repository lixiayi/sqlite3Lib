//
//  ViewController.m
//  SQLiteLib
//
//  Created by stoicer on 2022/9/16.
//

#import "ViewController.h"
#import "FmdbViewController.h"
#import <sqlite3.h>

@interface ViewController ()
{
    sqlite3 *_db;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //打开DB
    [self openDB];
    
    //创建表
    [self createTable];
    
    //插入数据
    [self insertTable];
    
    //查询表
    [self selectTable];

    //删除表数据集
//    [self dropData];
    
    //更新表
    [self updateTableWithName:@"xxx" age:10];
    
    [self enterfmdb];
}

- (void)enterfmdb
{
    [self fmdbBtn];
}

- (UIButton *)fmdbBtn
{
    if(_fmdbBtn == nil)
    {
        _fmdbBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 300, 120, 44)];
        [_fmdbBtn setTitle:@"fmdb" forState:UIControlStateNormal];
        _fmdbBtn.backgroundColor = [UIColor redColor];
        _fmdbBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_fmdbBtn addTarget:self
                       action:@selector(fmdbAction)
             forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_fmdbBtn];
    }
    return _fmdbBtn;
}

- (void)fmdbAction
{
    FmdbViewController *vc = [[FmdbViewController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (void)openDB
{
    //数据库文件路径
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *dbPath = [filePath stringByAppendingPathComponent:@"1.db"];
    NSLog(@"dbPath--->%@",dbPath);
    
    //数据库已经存在则打开，否则创建
    if (sqlite3_open(dbPath.UTF8String, &_db) == SQLITE_OK)
    {
        NSLog(@"创建数据库ok");
    }
    else
    {
        NSLog(@"创建数据库failed");
    }
}

- (void)createTable
{
    //创建表
    const char *sql = "create table tbl1 (name VARCHAR(20),age integer);";
    char *error = NULL;
    sqlite3_exec(_db, sql, NULL, NULL, &error);
    if (error == nil) {
        NSLog(@"创建tbl1成功");
    }
    else
    {
        NSLog(@"创建tbl1失败");
    }
}

-(void)insertTable
{
    NSString *randomName = [NSString stringWithFormat:@"lixiaoyi%ud",arc4random() % 100];
    int randomAge = arc4random() % 80;
    
    NSString *sql = [NSString stringWithFormat:@"insert into tbl1 values('%@',%d);",randomName,randomAge];
    
    char *error = NULL;
    sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error);
    if (error == nil) {
        NSLog(@"插入tbl1成功");
    }
    else
    {
        NSLog(@"插入tbl1失败");
    }
}

- (void)selectTable
{
    const char *sql = "select * from tbl1 where age < 25";
    sqlite3_stmt *stmt;
    int result = sqlite3_prepare_v2(_db, sql, -1, &stmt, NULL);
    if (result == SQLITE_OK)
    {
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            //绑定参数
            unsigned char *name = (unsigned char *) sqlite3_column_text(stmt, 0);
            int age= sqlite3_column_int(stmt, 1);
            NSLog(@"name--->%s,age--->%d",name,age);
        }
    }
}

- (void)dropData
{
    const char *sql = "delete from tbl1";
    char *error = NULL;
    
    sqlite3_exec(_db, sql, NULL, NULL, &error);
    if (error == NULL)
    {
        NSLog(@"删除表成功");
    }
    else
    {
        NSLog(@"删除表失败");
    }
}


- (void)updateTableWithName:(NSString *)name age:(int)age
{
    NSString *sql = [NSString stringWithFormat:@"update tbl1 set name = '%@' where age = 10",name];
    char *error = NULL;

    if (sqlite3_exec(_db, sql.UTF8String, NULL, NULL, &error) == SQLITE_OK)
    {
        NSLog(@"更新表成功");
    }
    else
    {
        NSLog(@"更新表失败");
    }
}


@end
