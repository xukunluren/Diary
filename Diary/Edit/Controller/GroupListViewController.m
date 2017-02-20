//
//  GroupListViewController.m
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "GroupListViewController.h"
#import "DiaryGroupViewController.h"
#import "NewGroupViewController.h"

#import <Realm/Realm.h>

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array" //存放数组

#define DIC_TITILESTRING @"title"

#define CELL_HEIGHT 50.0f

@interface GroupListViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong) UITableView *groupTable;
@end

@implementation GroupListViewController

-(void)viewWillAppear:(BOOL)animated{
    
    
        _dataArray = [[NSMutableArray alloc] init];
        [_dataArray removeAllObjects];
        RLMResults* tempArray = [groupModel allObjects];
        for (groupModel* model in tempArray) {
            [_dataArray addObject:model];
        }
        
        [_groupTable reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDataSource];
    [self setBackWithText:@"取消"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    self.title = @"选择分组";
    [self initTableView];
    [self initButtomView];
}
-(void)rightButtonClick{
    NSLog(@"选择保存");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initButtomView{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 40)];
    [button setTitle:@"添加分组" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [button setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [button addTarget:self action:@selector(addGroup:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

}
- (void)returnText:(ReturnText)model{
    self.returnText = model;
}

-(void)addGroup:(id)sender{
    NSLog(@"添加分组");
    NewGroupViewController *new = [[NewGroupViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)initDataSource{
    
    _dataArray = [[NSMutableArray alloc] init];
    RLMResults* tempArray = [groupModel allObjects];
    if (tempArray.count == 0) {
        //数据库操作对象
        RLMRealm *realm = [RLMRealm defaultRealm];
        //打开数据库事务
        [realm transactionWithBlock:^(){
            groupModel *model = [[groupModel alloc] init];
            model.title = @"我的日记";
            model.groupId = 0;
            //添加到数据库
            [realm addObject:model];
            //提交事务
            [realm commitWriteTransaction];
        }];
    }
    for (groupModel *model in tempArray) {
         [_dataArray addObject:model];
    }
}
-(void)initTableView{
    [self.view addSubview:self.groupTable];
}


-(UITableView *)groupTable{
    if (!_groupTable) {
        _groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight)];
        _groupTable.delegate = self;
        _groupTable.dataSource = self;
        _groupTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _groupTable;
}

#pragma mark --------------------------------------------------------------
#pragma mark - UITableViewDelegate && UITableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    if (self.selectedIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    groupModel *model = _dataArray[indexPath.row];
    NSDictionary *rowAndName = @{@(indexPath.row):cell.textLabel.text};
    self.returnText(model);
    
    self.selectedIndexPath = indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    static NSString *allOrderCellIdentifier = @"allOrderCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allOrderCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
        
    }
    if ([self.selectedIndexPath isEqual:indexPath]){
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    groupModel *model = _dataArray[indexPath.row];
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    cell.textLabel.text = model.title;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    return cell;
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
