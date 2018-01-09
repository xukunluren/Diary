//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "SecondItemViewController.h"
#import "DiaryGroupViewController.h"
#import "groupModel.h"
#import <Realm/Realm.h>
#import "NewGroupViewController.h"

#define DIC_EXPANDED @"expanded" //是否是展开 0收缩 1展开

#define DIC_ARARRY @"array" //存放数组

#define DIC_TITILESTRING @"title"

#define CELL_HEIGHT 50.0f



@interface SecondItemViewController ()<UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong) UITableView *groupTable;

@end

@implementation SecondItemViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"你好");
     [self initDataSource];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDown)];
    [self initTableView];
}

-(void)rightDown{
    NewGroupViewController *new = [[NewGroupViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];

}
-(void)initDataSource{
    
    _dataArray = [[NSMutableArray alloc] init];
    RLMResults* tempArray = [groupModel allObjects];
    for (groupModel *model in tempArray) {
        [_dataArray addObject:model];
    }
    [_groupTable reloadData];

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
    groupModel *model = _dataArray[indexPath.row];
    DiaryGroupViewController *vc = [[DiaryGroupViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = model.title;
    vc.groupId = model.groupId;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *allOrderCellIdentifier = @"allOrderCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allOrderCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone; 
    }
    groupModel *model = _dataArray[indexPath.row];
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    cell.textLabel.text = model.title;
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%ld",model.diaryNum] ;
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0f]];
    
    return cell;
}


#pragma mark --------------------------------------------------------------
#pragma mark - Action

@end
