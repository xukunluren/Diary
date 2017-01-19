//
//  MyMeansViewController.m
//  Diary
//
//  Created by xukun on 2017/1/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MyMeansViewController.h"
#import "MyMeansTableViewCell.h"
//#import <Realm/Realm.h>
//#import "Person.h"

@interface MyMeansViewController ()<UITableViewDelegate,UITableViewDataSource>
@end

@implementation MyMeansViewController
{
    UITableView *_meanTable;
}
- (void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    [self setBack];
    [self setTitle:@"我的资料"];
    [self initView];
   // [self searchFromRealmData];
    
}

//-(void)searchFromRealmData{
//    //获得当前所有数据
//    
//    RLMResults* tempArray = [Person allObjects];
//    
//    for (Person* model in tempArray) {
//        
//        //打印数据
//        
//      NSLog(@"ID : %ld, name : %@, age : %@ ",model.iD,model.name,model.sex);
//        
//    }
//}

-(void)initView{
   
        
    _meanTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, 180) style:UITableViewStylePlain];
    _meanTable.dataSource = self;
    _meanTable.delegate = self;
    _meanTable.backgroundColor = [UIColor colorFromHexCode:@"eeeeee"];
    [self.view  insertSubview:_meanTable belowSubview:self.navigationController.navigationBar];
        
 
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *allOrderCellIdentifier = @"MyMeans";
    MyMeansTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:allOrderCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyMeansTableViewCell" owner:nil options:nil] firstObject];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"我的头像";
        cell.detailLabel.hidden = YES;
        cell.headerImage.hidden = NO;
        return cell;
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"我的昵称";
        cell.detailLabel.text = @"xukunluren";
 
        return cell;
    }
    return nil;
 
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
