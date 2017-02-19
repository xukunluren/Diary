//
//  DiaryGroupViewController.m
//  Diary
//
//  Created by Hanser on 2/14/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "DiaryGroupViewController.h"
#import "HomePageCell.h"

@interface DiaryGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *diaryListTableView;
@end

@implementation DiaryGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackWithText:@"返回"];
    [self setTitle:self.title];
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(100, 100, 100, 100);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnEvent) forControlEvents:UIControlEventTouchUpInside];
    
     [self.view addSubview:self.diaryListTableView];
}


- (UITableView *)diaryListTableView {
    if (!_diaryListTableView) {
        CGRect rect = CGRectMake(0, KTopHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight-KTopHeight);
        _diaryListTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _diaryListTableView.delegate = self;
        _diaryListTableView.dataSource = self;
        _diaryListTableView.tableHeaderView = nil;
        return _diaryListTableView;
    }
    return _diaryListTableView;
}
- (void)btnEvent {
    NSString *jsonStr = @"";
    
}




#pragma mark -------------------------------------------------------------
#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"HomePageCell";
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
    }
//    editDiaryModel *edit = _diaryInfoArray[indexPath.row];
//    cell.titleLabel.text = edit.title;
//    cell.monthDayLabel.text  = edit.monthAndDay;
//    cell.yearLabel.text = edit.year;
//    cell.timeLabel.text = edit.time;
//    cell.assistNumLabel.text = [NSString stringWithFormat: @"%ld", (long)edit.supportNum];
    cell.titleLabel.text = @"nnn";
    cell.monthDayLabel.text  = @"nnn";
    cell.yearLabel.text = @"nnn";
    cell.timeLabel.text = @"nnn";
    cell.assistNumLabel.text = @"nnn";
    
//    switch (edit.weatherType) {
//        case WeatherEqingtian:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Eqingtian_select"];
//            break;
//        case WeatherEduoyun:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Eduoyun_select"];
//            break;
//        case WeatherEfeng:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Efeng_select"];
//            break;
//        case WeatherExiaoyu:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Exiaoyu_select"];
//            break;
//        case WeatherEdayu:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Edayu_select"];
//            break;
//        case WeatherEshandian:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Eshandian_select"];
//            break;
//        case WeatherExue:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Exue_select"];
//            break;
//        case WeatherEwumai:
//            cell.weatherImageView.image = [UIImage imageNamed:@"Ewumai_select"];
//            break;
//        case WeatherENoSelect://未选择天气情况，设置默认的天气logo
//            cell.weatherImageView.image = [UIImage imageNamed:@"weather_icon"];
//            break;
//            
//        default:
//            break;
//    }
    
    cell.weatherImageView.image = [UIImage imageNamed:@"weather_icon"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
//    editDiaryModel *edit = _diaryInfoArray[indexPath.row];
//    RichTextViewController *rich = [[RichTextViewController alloc] init];
//    rich.NewDiary = NO;
//    rich.diaryData = edit.diaryInfo;
//    rich.diaryId = edit.diaryId;
//    rich.atGroup = edit.atGroup;
//    rich.editDiary = edit;
//    
//    [self.navigationController pushViewController:rich animated:YES];
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView setEditing:YES animated:YES];
    
    return UITableViewCellEditingStyleDelete;
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView setEditing:NO animated:YES];
}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
//        editDiaryModel *edit = _diaryInfoArray[indexPath.row];
//        
//        NSLog(@"点击了删除");
//        [self initAlertControllerWithId:edit];
        tableView.editing = NO;
    }];
    
    
    return @[action1];
}


+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
@end
