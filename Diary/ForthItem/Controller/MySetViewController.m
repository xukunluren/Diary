//
//  FirstItemViewController.m
//  Diary
//
//  Created by xukun on 2017/1/13.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MySetViewController.h"
#import "MySetHeaderView.h"
#import "MyMeansViewController.h"
#import "LoginController.h"
#import "MyHeaderTableViewCell.h"
#import "AccountSecretViewController.h"
#import "Person.h"
#import <Realm/Realm.h>


const CGFloat BackGroupHeight = 200;
const CGFloat HeadImageHeight= 80;

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
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
    [self searchFromRealmData];
//    //数据库操作对象
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    
//    //打开数据库事务
//    
//    [realm transactionWithBlock:^(){
//        
//        Person* _temp = [[Person alloc] init];
//        
//        
//        
//        _temp.name = @"kevingao";
//        
//        _temp.iD = 44;//计算的当前ID
//        
//        _temp.sex = @"male";
//        
//        //添加到数据库
//        
//        [realm addObject:_temp];
//        
//        //提交事务
//        
//        [realm commitWriteTransaction];
//        
//    }];
    
}

-(void)searchFromRealmData{
    //获得当前所有数据
    
    RLMResults* tempArray = [Person allObjects];
    
    for (Person* model in tempArray) {
        
        //打印数据
       
        
    }
}

 
-(UIView*)loginOutView{
    if (_loginOutView == nil) {
    self.loginOutView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 70)];
    self.loginOutView.backgroundColor = [UIColor clearColor];
    UIButton *loginOutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, ScreenWidth, 35)];
    [loginOutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutButton setBackgroundColor:[UIColor colorFromHexCode:@"12B7F5"]];
    [self.loginOutView addSubview:loginOutButton];
    }
    return _loginOutView;
}
-(void)initData{
    listArray = [[NSMutableArray alloc] initWithObjects:[NSArray arrayWithObjects:@" ",nil],[NSArray arrayWithObjects:@"我的资料",@"我的点赞",nil],[NSArray arrayWithObjects:@"鼓励我们",@"支持我们",@"账号安全",@"版本信息", nil], nil];
}

- (void) initView{

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(shareEvent)];
    //[self setNavigtionBarTransparent:YES];
    mySettingTableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [mySettingTableView setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    mySettingTableView.delegate = self;
    mySettingTableView.dataSource = self;
    mySettingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mySettingTableView.contentInset = UIEdgeInsetsMake(BackGroupHeight, 0, 0, 0);
    [self.view insertSubview:mySettingTableView belowSubview:self.navigationController.navigationBar];
    
    mySettingTableView.tableFooterView = self.loginOutView;
    [mySettingTableView setTableHeaderView:[[UIView alloc] initWithFrame:CGRectZero]];
    _imageBG = [[UIImageView alloc]init];
    _imageBG.frame = CGRectMake(0, -BackGroupHeight, ScreenWidth, BackGroupHeight);
    _imageBG.image = [UIImage imageNamed:@"BG.jpg"];
    [mySettingTableView addSubview:_imageBG];
    //
    _BGView = [[UIView alloc]init];
    _BGView.backgroundColor=[UIColor clearColor];
    _BGView.frame=CGRectMake(0, -BackGroupHeight, ScreenWidth, BackGroupHeight);
    
    [mySettingTableView addSubview:_BGView];
    
    //
    _headImageView=[[UIImageView alloc]init];
    _headImageView.image=[UIImage imageNamed:@"myheadimage.jpeg"];
    _headImageView.frame=CGRectMake((ScreenWidth-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
    _headImageView.layer.cornerRadius = HeadImageHeight/2;
    _headImageView.clipsToBounds = YES;
    [_BGView addSubview:_headImageView];
    
    _nameLabel=[[UIButton alloc]init];
    [_nameLabel setTitle:@"登录/注册" forState:UIControlStateNormal];
    [_nameLabel addTarget:self action:@selector(loginEvent) forControlEvents:UIControlEventTouchUpInside];
    [_nameLabel setContentMode:UIViewContentModeCenter];
    _nameLabel.frame=CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+10, ScreenWidth, 40);
    [_nameLabel.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    [_BGView addSubview:_nameLabel];
    
    

    
    // 个人中心顶部背景图写死
    [self.settingHeaderNewView.setBackImage setImage:[UIImage imageNamed:@"backgroundImage.png"]];
    
}


-(void)shareEvent{
//分享按钮
    
    
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *allOrderCellIdentifier = @"MyHeader";
        MyHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyHeaderTableViewCell" owner:nil options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
    }
    
    static NSString *allOrderCellIdentifier = @"allOrderCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:allOrderCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell.textLabel setFont:[UIFont systemFontOfSize:13.0]];
    [cell addSubview:[self drawThreadWithFram:CGRectMake(15, 45.5, ScreenWidth-30, 0.5) andColor:[UIColor colorFromHexCode:@"e7e7e7"]]];
    cell.textLabel.text = [[listArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (indexPath.section == 2&& indexPath.row == 3) {
         cell.detailTextLabel.text = @"V1.0";
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 50;
    }
    
    return 46;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   

    if (indexPath.section == 1 && indexPath.row == 0 ) {
        MyMeansViewController *means = [[MyMeansViewController alloc] init];
        [self.navigationController pushViewController:means animated:YES];
    }
    if (indexPath.section == 1 && indexPath.row == 1 ) {
        LoginController *means = [[LoginController alloc] init];
        [self.navigationController pushViewController:means animated:YES];
    }
    if (indexPath.section == 2 && indexPath.row == 2) {
        AccountSecretViewController *account = [[AccountSecretViewController alloc] init];
        [self.navigationController pushViewController:account animated:YES];
    }

}


- (MySetHeaderView *)settingHeaderNewView{
    if (_settingHeaderNewView == nil)
    {
        CGRect frame = CGRectMake(0, 0, ScreenWidth, 280);
        _settingHeaderNewView = [[MySetHeaderView alloc] initWithFrame:frame];
       // _settingHeaderNewView.delegate = self;
    }
    return _settingHeaderNewView;
}



-(void)loginEvent{
    LoginController *means = [[LoginController alloc] init];
    [self.navigationController pushViewController:means animated:YES];
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _nameLabel.hidden = NO;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + BackGroupHeight)/2;
    _nameLabel.hidden = YES;
    if (yOffset < -BackGroupHeight) {
        
        CGRect rect = _imageBG.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = ScreenWidth + fabs(xOffset)*2;
        _imageBG.frame = rect;
        CGRect HeadImageRect = CGRectMake((ScreenWidth-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
        HeadImageRect.origin.y = _headImageView.frame.origin.y;
        HeadImageRect.size.height =  HeadImageHeight + fabs(xOffset)*0.5 ;
        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
        HeadImageRect.size.width = HeadImageHeight + fabs(xOffset)*0.5;
        _headImageView.frame = HeadImageRect;
        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
        _headImageView.clipsToBounds = YES;
        
        CGRect NameRect = CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
        NameRect.origin.y = CGRectGetMaxY(_headImageView.frame)+5;
        NameRect.size.height =  40 + fabs(xOffset)*0.5 ;
        NameRect.size.width = ScreenWidth;
        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
        
        _nameLabel.titleLabel.font=[UIFont systemFontOfSize:14+fabs(xOffset)*0.2];
        
        _nameLabel.frame = NameRect;
        
        
    }else{
      
        CGRect HeadImageRect = CGRectMake((ScreenWidth-HeadImageHeight)/2, 40, HeadImageHeight, HeadImageHeight);
        HeadImageRect.origin.y = _headImageView.frame.origin.y;
        HeadImageRect.size.height =  HeadImageHeight - fabs(xOffset)*0.5 ;
        HeadImageRect.origin.x = self.view.center.x - HeadImageRect.size.height/2;
        HeadImageRect.size.width = HeadImageHeight - fabs(xOffset)*0.5;
        _headImageView.frame = HeadImageRect;
        _headImageView.layer.cornerRadius = HeadImageRect.size.height/2;
        _headImageView.clipsToBounds = YES;
        
        CGRect NameRect = CGRectMake(0, CGRectGetMaxY(_headImageView.frame)+5, HeadImageHeight, 20);
        NameRect.origin.y = CGRectGetMaxY(_headImageView.frame)+5;
        NameRect.size.height =  40;
        NameRect.size.width = ScreenWidth;
        NameRect.origin.x = self.view.center.x - NameRect.size.width/2;
        
        _nameLabel.titleLabel.font=[UIFont systemFontOfSize:14-fabs(xOffset)*0.2];
        
        _nameLabel.frame = NameRect;
        
    }
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
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
