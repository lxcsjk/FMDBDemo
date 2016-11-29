//
//  ViewController.m
//  RecordTest
//
//  Created by LXC on 2016/11/25.
//  Copyright © 2016年 LXC. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "FMDB.h"

@interface ViewController ()
{
    NSString *fileName;
    BOOL isTableExist;
    int count;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject];
    
    fileName = [doc stringByAppendingPathComponent:@"downCourse.sqlite"];
    
    DLog(@"sql文件路径 ： %@",fileName);
    UIButton *createTableBtn = [[UIButton alloc]init];
    [createTableBtn setTitle:@"创建表" forState:UIControlStateNormal];
    createTableBtn.layer.cornerRadius = 6.0;
    createTableBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    createTableBtn.titleLabel.textColor = [UIColor whiteColor];
    [createTableBtn addTarget:self action:@selector(createTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createTableBtn];
    [createTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    
    UIButton *addDataBtn = [[UIButton alloc]init];
    [addDataBtn setTitle:@"添加数据" forState:UIControlStateNormal];
    addDataBtn.layer.cornerRadius = 6.0;
    addDataBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    addDataBtn.titleLabel.textColor = [UIColor whiteColor];
    [addDataBtn addTarget:self action:@selector(addData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addDataBtn];
    [addDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(createTableBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    
    UIButton *selectDataBtn = [[UIButton alloc]init];
    [selectDataBtn setTitle:@"查询数据" forState:UIControlStateNormal];
    selectDataBtn.layer.cornerRadius = 6.0;
    selectDataBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    selectDataBtn.titleLabel.textColor = [UIColor whiteColor];
    [selectDataBtn addTarget:self action:@selector(selectData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectDataBtn];
    [selectDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addDataBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    
    UIButton *updateDataBtn = [[UIButton alloc]init];
    [updateDataBtn setTitle:@"更新 id = 3 数据" forState:UIControlStateNormal];
    updateDataBtn.layer.cornerRadius = 6.0;
    updateDataBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    updateDataBtn.titleLabel.textColor = [UIColor whiteColor];
    [updateDataBtn addTarget:self action:@selector(updateData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:updateDataBtn];
    [updateDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(selectDataBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    
    UIButton *deleteDataBtn = [[UIButton alloc]init];
    [deleteDataBtn setTitle:@"删除 id = 2 数据" forState:UIControlStateNormal];
    deleteDataBtn.layer.cornerRadius = 6.0;
    deleteDataBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    deleteDataBtn.titleLabel.textColor = [UIColor whiteColor];
    [deleteDataBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:deleteDataBtn];
    [deleteDataBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(updateDataBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    
    UIButton *dropTableBtn = [[UIButton alloc]init];
    [dropTableBtn setTitle:@"删除表" forState:UIControlStateNormal];
    dropTableBtn.layer.cornerRadius = 6.0;
    dropTableBtn.backgroundColor = [UIColor colorWithRed:88/255.0 green:144/255.0 blue:255/255.0 alpha:1.0];
    dropTableBtn.titleLabel.textColor = [UIColor whiteColor];
    [dropTableBtn addTarget:self action:@selector(dropTable) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dropTableBtn];
    [dropTableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(deleteDataBtn.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(50);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view.frame.size.width - 100);
    }];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)createTable{
    //    NSFileManager * fileManager = [NSFileManager defaultManager];
    //    if ([fileManager fileExistsAtPath:fileName] == NO) {
    if (!isTableExist) {
        FMDatabase *db = [FMDatabase databaseWithPath:fileName];
        if ([db open]){
            //  创建表
            BOOL result = [db executeUpdate:@"CREATE TABLE 't_down_course' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'courseId' INTEGER, 'downPath' VARCHAR(255))"];
            if (result){
                DLog(@"创建表成功");
                isTableExist = YES;
                [self showAlertWithMessage:@"创建表 --- 成功" completion:nil];
            }else{
                [self showAlertWithMessage:@"创建表 --- 失败" completion:nil];
            }
            [db close];
        }else{
            [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
        }
    }
    //    }
}

-(void)addData{
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        NSString *insertSql = @"insert into 't_down_course'(courseId,downPath) values(?,?)";
        BOOL result = [db executeUpdate:insertSql,[NSString stringWithFormat:@"%d",count],fileName];
        if (result){
            DLog(@"添加数据成功");
            [self showAlertWithMessage:@"添加数据 --- 成功" completion:nil];
        }else{
            DLog(@"添加数据失败");
            [self showAlertWithMessage:@"添加数据 --- 失败" completion:nil];
        }
        count++;
        [db close];
    }else{
        [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
    }
}

-(void)selectData{
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        NSString *selectSql = @"select * from t_down_course";
        FMResultSet * rs = [db executeQuery:selectSql];
        while ([rs next]) {
            int course = [rs intForColumn:@"id"];
            NSString * courseId = [rs stringForColumn:@"courseId"];
            NSString * downPath = [rs stringForColumn:@"downPath"];
            DLog(@"course id = %d, courseId = %@, downPath = %@", course, courseId, downPath);
        }
        [db close];
    }else{
        [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
    }
}

-(void)updateData{
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        BOOL result = [db executeUpdate:@"update t_down_course set downPath = '更新的数据' where id = 3"];
        if (result){
            DLog(@"更新数据成功");
            [self showAlertWithMessage:@"更新数据 --- 成功" completion:nil];
        }else{
            DLog(@"更新数据失败");
            [self showAlertWithMessage:@"更新数据 --- 失败" completion:nil];
        }
        
        [db close];
    }else{
        [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
    }
}

-(void)deleteData{
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        BOOL result = [db executeUpdate:@"delete from t_down_course where id = 2"];
        if (result){
            DLog(@"删除数据成功");
            [self showAlertWithMessage:@"删除数据 --- 成功" completion:nil];
        }else{
            DLog(@"删除数据失败");
            [self showAlertWithMessage:@"删除数据 --- 失败" completion:nil];
        }
        
        [db close];
    }else{
        [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
    }
}

-(void)dropTable{
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    if ([db open]){
        BOOL result = [db executeUpdate:@"drop table t_down_course"];
        if (result){
            DLog(@"删除表成功");
            isTableExist = NO;
            [self showAlertWithMessage:@"删除表 --- 成功" completion:nil];
        }else{
            DLog(@"删除表失败");
            [self showAlertWithMessage:@"删除表 --- 失败" completion:nil];
        }
        
        [db close];
    }else{
        [self showAlertWithMessage:@"打开数据库 --- 失败" completion:nil];
    }
}


- (void)showAlertWithMessage:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
