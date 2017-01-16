//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "FirstItemViewController.h"
#import "PublishViewController.h"


#define kSearchBackgroudViewHeight 40

@interface FirstItemViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (strong, nonatomic) UITableView *diaryListTableView;
@property (strong, nonatomic) UITableView *showTableView;
@property (strong, nonatomic) UITableView *historyTableView;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UIView *searchHeaderView;
@property (strong, nonatomic) UIView *searchBackgroudView;

@end

@implementation FirstItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(rightDown)];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    //    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.diaryListTableView];
    [self.view addSubview:self.searchHeaderView];

    
}

- (void)rightDown
{
    PublishViewController *vc = [[PublishViewController alloc] init];
    
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
        [button setTitle:@"手机号/萌店号/昵称" forState:UIControlStateNormal];
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
        searchBar.placeholder = @"手机号/萌店号/昵称";
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


#pragma mark -------------------------------------------------------------
#pragma mark UITableViewDataSource && UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}


#pragma mark -------------------------------------------------------------
#pragma mark UITableViewDataSource && UITableViewDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    [searchBar.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [searchBar.cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
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
@end
