//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "FirstItemViewController.h"
#import "EditViewController.h"
#import "HomePageCell.h"
#import "HomePageIfNoDataView.h"


#define kSearchBackgroudViewHeight 40

@interface FirstItemViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *diaryListTableView;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UITableView *historyTableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIView *searchHeaderView;
@property (strong, nonatomic) UIView *searchBackgroudView;

@property (strong, nonatomic) NSMutableArray *dataArray;


@end

@implementation FirstItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    
    [self setTitle:@"好记"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDown)];
    
    /** 自动滚动调整 */
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addSubview:self.diaryListTableView];
    [self.view addSubview:self.searchHeaderView];

    
}

- (void)rightDown
{
    EditViewController *vc = [[EditViewController alloc] init];
    
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
- (void)initAlertController {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请注意" message:@"日记一旦删除，将无法找回!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        /** 确定删除日记*/
    }];
    [alertVC addAction:cancelButton];
    [alertVC addAction:okButton];
    [self presentViewController:alertVC animated:YES completion:nil];

}


#pragma mark -------------------------------------------------------------
#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld",(long)indexPath.row);
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
        NSLog(@"点击了删除");
        [self initAlertController];
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
