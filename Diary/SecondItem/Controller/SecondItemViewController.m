//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "SecondItemViewController.h"
#import "EditViewController.h"
#import "DiaryGroupViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableView];
   // [self initDataSource];
    
 
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
    DiaryGroupViewController *vc = [[DiaryGroupViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *allOrderCellIdentifier = @"allOrderCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allOrderCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
//    NSDictionary *dic = [_dataArray objectAtIndex:indexPath.section];
//    NSArray *array = [dic objectForKey:DIC_ARARRY];
//    
//    NSInteger row = indexPath.row;
    
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    cell.textLabel.text = @"分组名";
    [cell.textLabel setFont:[UIFont systemFontOfSize:14.0f]];
    cell.detailTextLabel.text = @"12";
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0f]];
    return cell;
}


#pragma mark --------------------------------------------------------------
#pragma mark - Action

@end
