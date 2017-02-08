//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "SecondItemViewController.h"
#import "EditViewController.h"

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
//    NSMutableDictionary *dic=[_dataArray objectAtIndex:section];
    
//    NSArray *array=[dic objectForKey:DIC_ARARRY];
//    
//    //判断是收缩还是展开
//    
//    if ([[dic objectForKey:DIC_EXPANDED] intValue]) {
//        
//        return array.count;
//        
//    }else{
//        return 0;
//    }
    return 10;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    
//    UIView *hView = [[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, CELL_HEIGHT)];
//    
//    hView.backgroundColor=[UIColor whiteColor];
//    
//    UIButton* eButton = [[UIButton alloc] init];
//    
//    //按钮填充整个视图
//    eButton.frame = hView.frame;
//    
//    [eButton addTarget:self action:@selector(expandButtonClicked:)
//     
//      forControlEvents:UIControlEventTouchUpInside];
//    
//    //把节号保存到按钮tag，以便传递到expandButtonClicked方法
//    
//    eButton.tag = section;
//    
//    //设置图标
//    
//    //根据是否展开，切换按钮显示图片
//    
//    if ([self isExpanded:section]){
//        
//        [eButton setImage: [UIImage imageNamed: @"arrow_right_grey" ]forState:UIControlStateNormal];
//    } else {
//        
//        [eButton setImage: [UIImage imageNamed: @"arrow_down_grey" ]forState:UIControlStateNormal];
//    }
//    //设置分组标题
//    
//    [eButton setTitle:[[_dataArray objectAtIndex:section] objectForKey:DIC_TITILESTRING] forState:UIControlStateNormal];
//    
//    [eButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    //设置button的图片和标题的相对位置
//    
//    //4个参数是到上边界，左边界，下边界，右边界的距离
//    
//    eButton.contentHorizontalAlignment =UIControlContentHorizontalAlignmentLeft;
//    
//    [eButton setTitleEdgeInsets:UIEdgeInsetsMake(5,5, 0,0)];
//    
//    [eButton setImageEdgeInsets:UIEdgeInsetsMake(5,self.view.bounds.size.width - 25, 0,0)];
//    
//    //下显示线
//    
//    UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0, hView.frame.size.height-1, hView.frame.size.width,1)];
//    
//    label.backgroundColor = [UIColor grayColor];
//    [hView addSubview:label];
//    
//    [hView addSubview: eButton];
//    
//    return hView;
//}

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
//- (void)expandButtonClicked:(UIButton *)sender {
//    UIButton *btn = (UIButton *)sender;
//    
//    NSInteger section = btn.tag;
//    
//    [self collapseOrExpand:section];
//    
//    //刷新数据
//    [self.groupTable reloadData];
//    
//}
//
//- (void)collapseOrExpand:(NSInteger)section {
//    NSMutableDictionary *dic = [_dataArray objectAtIndex:section];
//    
//    NSInteger expanded = [[dic objectForKey:DIC_EXPANDED] integerValue];
//    
//    if (expanded) {
//        [dic setValue:[NSNumber numberWithInt:0] forKey:DIC_EXPANDED];
//    }else {
//        [dic setValue:[NSNumber numberWithInt:1] forKey:DIC_EXPANDED];
//
//    }
//}
//
//
//- (NSInteger)isExpanded:(NSInteger)section {
//    
//    NSDictionary *dic=[_dataArray objectAtIndex:section];
//    
//    int expanded=[[dic objectForKey:DIC_EXPANDED] intValue];
//    
//    return expanded;
//
//}

@end
