//
//  NewGroupViewController.m
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "NewGroupViewController.h"
#import "groupModel.h"
#import <Realm/Realm.h>
#import "CRToast.h"


@interface NewGroupViewController ()
@property(nonatomic,strong)UITextField *textField;

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"EFEFF4"];
    [self setBackWithText:@"取消"];
    self.title = @"新增分类";
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonClick)];
    [self initView];
    
}

-(void)initView{
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 100, ScreenWidth, 40)];
    _textField.placeholder = @"分类名称";
    _textField.backgroundColor = [UIColor whiteColor];
    _textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    _textField.leftViewMode = UITextFieldViewModeAlways;
    [_textField setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:_textField];
}
-(void)rightButtonClick{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self dataStore];//数据保存数据库
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showToastWithString:@"保存成功"];
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
    
    
}



-(void)dataStore{
    NSInteger  dId;
    RLMResults* tempArray = [[groupModel allObjects] sortedResultsUsingKeyPath:@"groupId" ascending:NO];
    if (tempArray.count == 0) {
        dId = 0;
    }else{
        groupModel *model = tempArray.firstObject;
        dId = model.groupId +1;
    }
    //数据库操作对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    //打开数据库事务
    [realm transactionWithBlock:^(){
        groupModel *model = [[groupModel alloc] init];
        model.title = _textField.text;
        model.groupId = dId;
        //添加到数据库
        [realm addObject:model];
        //提交事务
        [realm commitWriteTransaction];
    }];
    
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
