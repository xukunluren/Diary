//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "FirstItemViewController.h"
#import "HomePageCell.h"
#import "RichTextViewController.h"
#import "HomePageIfNoDataView.h"
#import "editDiaryModel.h"
#import <Realm/Realm.h>
#import "CRToast.h"
#import "LoginController.h"
#import "groupModel.h"

#define LAST_RUN_VERSION_KEY @"last_run_version_of_application"
#define kSearchBackgroudViewHeight 40

@interface FirstItemViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *diaryListTableView;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UITableView *historyTableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIView *searchHeaderView;
@property (strong, nonatomic) UIView *searchBackgroudView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong ,nonatomic) NSMutableArray *diaryInfoArray;
@property (strong ,nonatomic) UIView *pageView;


@end

@implementation FirstItemViewController

-(void)viewWillAppear:(BOOL)animated{
    _diaryInfoArray = [[NSMutableArray alloc] init];
    [_diaryInfoArray removeAllObjects];
    RLMResults* tempArray = [editDiaryModel allObjects];
    for (editDiaryModel* model in tempArray) {
        [_diaryInfoArray addObject:model];
    }
    if (_diaryInfoArray.count>0) {
        [_pageView removeFromSuperview];
    }
    [_diaryListTableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    BOOL b = [self isFirstLoad];
    if (!b) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"  登录好记能在多终端书写并查看" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"已阅" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okButton =  [UIAlertAction actionWithTitle:@"去登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            LoginController *vc = [[LoginController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }];
        [alertVC addAction:cancelButton];
        [alertVC addAction:okButton];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
    [self setTitle:@"好记"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDown)];
    _diaryInfoArray = [[NSMutableArray alloc] init];
    RLMResults* tempArray = [editDiaryModel allObjects];
    for (editDiaryModel* model in tempArray) {
        [_diaryInfoArray addObject:model];
    }
    
    [self.view addSubview:self.diaryListTableView];
    [self.view addSubview:self.searchHeaderView];

    if (_diaryInfoArray.count>0) {
    }else{
        [self.view addSubview:self.pageView];
    }
    
    
    
    
    
}

- (BOOL) isFirstLoad{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary]
                                objectForKey:@"CFBundleShortVersionString"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *lastRunVersion = [defaults objectForKey:LAST_RUN_VERSION_KEY];
    
    if (!lastRunVersion) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    else if (![lastRunVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:LAST_RUN_VERSION_KEY];
        return YES;
    }
    return NO;
}


- (UIView *)pageView{
    if (!_pageView) {
        _pageView = [[UIView alloc] initWithFrame:self.view.bounds];
        [_pageView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.45, ScreenWidth, 30)];
        [label setText:@"今天遇到什么好玩的事情了呢？"];
        
        label.contentMode = UIViewContentModeCenter;
        label.textAlignment = NSTextAlignmentCenter;
        [label setTextColor:[UIColor blackColor]];
        [label setFont:[UIFont systemFontOfSize:12.0]];
        [_pageView addSubview:label];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-35, ScreenHeight*0.5, 70, 20)];
        [button setTitle:@"添加日记" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
        [button setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(rightDown) forControlEvents:UIControlEventTouchUpInside];
        [_pageView addSubview:button];
        
    }
    return _pageView;
}
-(void)creatNullPage{
    
    _pageView = [[UIView alloc] initWithFrame:self.view.bounds];
    [_pageView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [self.view addSubview:_pageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight*0.45, ScreenWidth, 30)];
    [label setText:@"今天遇到什么好玩的事情了呢？"];
    [label setTextColor:[UIColor colorFromHexCode:@"6B6B6B"]];

    label.contentMode = UIViewContentModeCenter;
    label.textAlignment = NSTextAlignmentCenter;
    [label setTextColor:[UIColor blackColor]];
    [label setFont:[UIFont systemFontOfSize:14.0]];
    [_pageView addSubview:label];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*0.5-35, ScreenHeight*0.5, 70, 20)];
    [button setTitle:@"添加日记" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:10.0]];
    [button setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(rightDown) forControlEvents:UIControlEventTouchUpInside];
    [_pageView addSubview:button];
    
}
- (void)rightDown
{
 
     RichTextViewController * vc=[[RichTextViewController alloc] init];
 
 
    vc.NewDiary = YES;
    vc.finished=^(id content){
        NSArray * arr=(NSArray *)content;
        NSLog(@"count--%lu",(unsigned long)arr.count);
        NSLog(@"arr--%@",arr);
        if (arr.count>0) {
            
            for (NSDictionary * dict in arr) {
                NSLog(@"title---%@",[dict objectForKey:@"title"]);
                
                //注意这里的lineSpace，有时候取不到
                
            }
        }
    };
   // EditViewController *vc = [[EditViewController alloc] init];
    
    [self.navigationController pushViewController:vc animated:YES];
 
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -------------------------------------------------------------
#pragma mark Init
- (UITableView *)diaryListTableView {
    if (!_diaryListTableView) {
        CGRect rect = CGRectMake(0, CGRectGetMaxY(self.searchHeaderView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight);
        _diaryListTableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
        _diaryListTableView.delegate = self;
        _diaryListTableView.dataSource = self;
        _diaryListTableView.tableHeaderView = nil;
        return _diaryListTableView;
    }
    return _diaryListTableView;
}

- (UITableView *)historyTableView {
    if (!_historyTableView) {
        _historyTableView = [[UITableView alloc] init];
        _historyTableView.frame = CGRectMake(0, CGRectGetMaxY(self.searchBackgroudView.frame), kScreenWidth, kScreenHeight - kNavigationBarHeight);
        _historyTableView.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
        //        _tableView.delegate = self;
        //        _tableView.dataSource = self;
        return _historyTableView;
    }
    return _historyTableView;
}



- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, kNavigationBarHeight, kScreenWidth, 30);
        _searchBar.delegate = self;
        
    }
    return _searchBar;
}

- (UIView *)searchHeaderView
{
    if (_searchHeaderView == nil) {
        _searchHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, 45)];
        _searchHeaderView.backgroundColor = [UIColor colorFromHexCode:@"f2f2f2"];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 7.5, kScreenWidth - 30, 30)];
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = 6.0f;
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button setTitleColor:[UIColor colorFromHexCode:@"888888"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"btn_sousuo_grey"] forState:UIControlStateNormal];
        [button setTitle:@"搜索" forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [button addTarget:self action:@selector(gotoSearch:) forControlEvents:UIControlEventTouchUpInside];
        [_searchHeaderView addSubview:button];
    }
    
    return _searchHeaderView;
}


- (UIView *)searchBackgroudView{
    if (_searchBackgroudView == nil) {
        _searchBackgroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth, 45)];
        _searchBackgroudView.backgroundColor = [UIColor colorFromHexCode:@"f2f2f2"];
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(5, 10, kScreenWidth-10, kSearchBackgroudViewHeight)];
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        [searchBar setBarTintColor:[UIColor colorFromHexCode:@"f2f2f2"]];
        [searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorFromHexCode:@"f2f2f2"]]];
        [searchBar setBackgroundColor:[UIColor clearColor]];
        searchBar.layer.cornerRadius = 6;
        searchBar.layer.masksToBounds = YES;
        self.searchBar = searchBar;
        [_searchBackgroudView addSubview:searchBar];
        

    }
    return _searchBackgroudView;
}

/** 添加弹框*/
- (void)initAlertControllerWithId:(editDiaryModel *)edit {
    long diaryAtGroup = edit.atGroup;
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请注意" message:@"日记一旦删除，将无法找回!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        /** 确定删除日记*/
        /** 确定删除日记*/
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
         //RLMResults<editDiaryModel *> *model = [editDiaryModel objectsWhere:@"diaryId == %@",@(diaryid)];
        [realm deleteObject:edit];
        [realm commitWriteTransaction];
        [self showToastWithString:@"删除成功"];
        
        //删除成功后对应的分组的日记数量减一
        [self reduceGroupDiaryNumWithGroupId:diaryAtGroup];
        
        [_diaryInfoArray removeAllObjects];
        RLMResults* tempArray = [editDiaryModel allObjects];
        for (editDiaryModel* model in tempArray) {
            [_diaryInfoArray addObject:model];
        }
        if (_diaryInfoArray.count == 0) {
            [self.view addSubview:self.pageView];
        }
        
        [_diaryListTableView reloadData];
        
    }];
    [alertVC addAction:cancelButton];
    [alertVC addAction:okButton];
    [self presentViewController:alertVC animated:YES completion:nil];

}


-(void)reduceGroupDiaryNumWithGroupId:(long)groupId{
    
    NSString *grouptitle;
    long _groupdiaryNum = 0;
    RLMRealm *realm = [RLMRealm defaultRealm];
    RLMResults<groupModel *> *groupM = [groupModel   objectsWhere:@"groupId == %@",@(groupId)];
    for (groupModel *modelaa in groupM) {
        grouptitle = modelaa.title;
        _groupdiaryNum = modelaa.diaryNum;
    }
    
    groupModel *model1 = [[groupModel alloc] init];
    
    model1.groupId = groupId;
    model1.title = grouptitle;
    if (_groupdiaryNum == 0) {
        model1.diaryNum = 0;
    }else{
        model1.diaryNum = _groupdiaryNum-1;
    }
    // 通过 id = 1 更新该书籍
    [realm beginWriteTransaction];
    [groupModel createOrUpdateInRealm:realm withValue:model1];
    [realm commitWriteTransaction];
}




#pragma mark -------------------------------------------------------------
#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _diaryInfoArray.count;
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
    editDiaryModel *edit = _diaryInfoArray[indexPath.row];
    cell.titleLabel.text = edit.title;
    cell.monthDayLabel.text  = edit.monthAndDay;
    cell.yearLabel.text = edit.year;
    cell.timeLabel.text = edit.time;
    cell.assistNumLabel.text = [NSString stringWithFormat: @"%ld", (long)edit.supportNum];
    if (!edit.haveAudioInfo) {
        cell.soundsImageView.hidden = YES;
    }
    if (!edit.haveVideoInfo) {
        cell.videoImageView.hidden = YES;
    }
    if (!edit.havePictureInfo) {
        cell.pictureImageView.hidden = YES;
    }
    switch (edit.weatherType) {
        case WeatherEqingtian:
            cell.weatherImageView.image = [UIImage imageNamed:@"Eqingtian_select"];
            break;
        case WeatherEduoyun:
            cell.weatherImageView.image = [UIImage imageNamed:@"Eduoyun_select"];
            break;
        case WeatherEfeng:
            cell.weatherImageView.image = [UIImage imageNamed:@"Efeng_select"];
            break;
        case WeatherExiaoyu:
            cell.weatherImageView.image = [UIImage imageNamed:@"Exiaoyu_select"];
            break;
        case WeatherEdayu:
            cell.weatherImageView.image = [UIImage imageNamed:@"Edayu_select"];
            break;
        case WeatherEshandian:
            cell.weatherImageView.image = [UIImage imageNamed:@"Eshandian_select"];
            break;
        case WeatherExue:
            cell.weatherImageView.image = [UIImage imageNamed:@"Exue_select"];
            break;
        case WeatherEwumai:
            cell.weatherImageView.image = [UIImage imageNamed:@"Ewumai_select"];
            break;
        case WeatherENoSelect://未选择天气情况，设置默认的天气logo
            cell.weatherImageView.image = [UIImage imageNamed:@"weather_icon"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
    editDiaryModel *edit = _diaryInfoArray[indexPath.row];
    RichTextViewController *rich = [[RichTextViewController alloc] init];
    rich.NewDiary = NO;
    rich.diaryData = edit.diaryInfo;
    rich.diaryId = edit.diaryId;
    rich.atGroup = edit.atGroup;
    rich.groupTitle = edit.atGroupTitle;
    rich.editDiary = edit;
    
    [self.navigationController pushViewController:rich animated:YES];
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
        
        editDiaryModel *edit = _diaryInfoArray[indexPath.row];
        
        NSLog(@"点击了删除");
        [self initAlertControllerWithId:edit];
        tableView.editing = NO;
    }];
    
    
    return @[action1];
}

#pragma mark -------------------------------------------------------------
#pragma mark UISearchDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    [searchBar.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchBar.cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
//    self.searchResultsTableView.hidden = YES;
    [searchBar resignFirstResponder];
    //[self toggleSearchBarColor:YES];
//    self.searchMasterPageConfig = PageConfigMake(0, 20, YES,NSNotFound,NSNotFound);
//    self.tableViewShow = TableViewShowRecommend;
    self.navigationController.navigationBar.hidden = NO;
    [self.historyTableView removeFromSuperview];
    
}

#pragma mark -------------------------------------------------------------
#pragma mark Event
- (void)gotoSearch:(id)sender {
    [self.view addSubview:self.searchBackgroudView];
    self.navigationController.navigationBar.hidden = YES;
    [self.searchBar becomeFirstResponder];
    [self.view addSubview:self.historyTableView];
}

#pragma mark -------------------------------------------------------------
#pragma mark other



@end
