//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MySetViewController.h"
#import "PublishViewController.h"
#import "MySetHeaderView.h"
#import "MyMeansViewController.h"
#import "LoginViewController.h"

@interface MySetViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)MySetHeaderView *settingHeaderNewView;
@property(nonatomic,strong)UIView *loginOutView;
@end

@implementation MySetViewController
{
    UITableView *mySettingTableView;
    NSMutableArray *listArray;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = YES;
    //[self prefersStatusBarHidden];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
    
    
}
-(UIView*)loginOutView{
    if (_loginOutView == nil) {
    self.loginOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    UIButton *loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 35)];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutButton setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [self.loginOutView addSubview:loginOutButton];
    }
    return _loginOutView;
}
-(void)initData{
    listArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithObjects:@"我的资料",@"我的点赞",nil],[NSArray arrayWithObjects:@"鼓励我们",@"支持我们",@"账号安全",@"版本信息", nil], nil];
}
- (BOOL)prefersStatusBarHidden{
    return YES;
}
- (void) initView{

    [self setNavigtionBarTransparent:YES];
    mySettingTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50) style: UITableViewStyleGrouped];
    mySettingTableView.maximumZoomScale = 1.3;
    mySettingTableView.dataSource = self;
    mySettingTableView.delegate = self;
    mySettingTableView.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    mySettingTableView.tableHeaderView = self.settingHeaderNewView;
    [self.view insertSubview:mySettingTableView belowSubview:self.navigationController.navigationBar];
    mySettingTableView.tableFooterView = self.loginOutView;

    // 个人中心顶部背景图写死
    [self.settingHeaderNewView.setBackImage setImage:[UIImage imageNamed:@"backgroundImage.png"]];
    
}

#pragma marks  --  tableDelegate
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = [listArray objectAtIndex:section];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *allOrderCellIdentifier = @"allOrderCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allOrderCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    cell.textLabel.text = [[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 1&& indexPath.row == 3) {
         cell.detailTextLabel.text = @"V1.0";
    }
   
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 46;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 20;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        MyMeansViewController *means = [[MyMeansViewController alloc] init];
        [self.navigationController pushViewController:means animated:YES];
    }
    if (indexPath.section == 0 && indexPath.row == 1 ) {
        LoginViewController *means = [[LoginViewController alloc] init];
        [self.navigationController pushViewController:means animated:YES];
    }

}
- (MySetHeaderView *)settingHeaderNewView{
    if (_settingHeaderNewView == nil)
    {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, 228);
        _settingHeaderNewView = [[MySetHeaderView alloc] initWithFrame:frame];
       // _settingHeaderNewView.delegate = self;
    }
    return _settingHeaderNewView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
