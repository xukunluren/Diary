//
//  GroupListViewController.m
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "GroupListViewController.h"
#import "EditViewController.h"
#import "DiaryGroupViewController.h"
#import "NewGroupViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setBackWithText:@"取消"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    self.title = @"选择分组";
    [self initTableView];
    [self initButtomView];
}
-(void)rightButtonClick{
    NSLog(@"选择保存");
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

-(void)addGroup:(id)sender{
    NSLog(@"添加分组");
    NewGroupViewController *new = [[NewGroupViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}
-(void)initDataSource{
    
    _dataArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < 5; i++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int j=0; j < 5; j++) {
            NSString *string = [NSString stringWithFormat:@"第%d组，第%d行",i,j];
            
            [array addObject:string];
        }
        NSString *string = [NSString stringWithFormat:@"第%d组",i];
        
        //创建一个字典存储数据
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:array,DIC_ARARRY,string,DIC_TITILESTRING,[NSNumber numberWithInt:0],DIC_EXPANDED, nil];
        
        [_dataArray addObject:dic];
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
    return 10;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedIndexPath) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
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
    if (indexPath.row == 0) {
        [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
        cell.textLabel.text = @"我的日记";
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }else{
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    cell.textLabel.text = @"分组名";
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    }
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
