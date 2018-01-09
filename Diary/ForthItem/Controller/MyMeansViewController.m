//
//  MyMeansViewController.m
//  Diary
//
//  Created by xukun on 2017/1/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "MyMeansViewController.h"
#import "MyMeansTableViewCell.h"
#import "alterNameViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "STPhotoKitController.h"
#import "UIImagePickerController+ST.h"
#import "STConfig.h"

#import <Realm/Realm.h>
#import "Person.h"
typedef NS_ENUM(NSInteger, PhotoType)
{
    PhotoTypeIcon,
    PhotoTypeRectangle,
    PhotoTypeRectangle1
};

@interface MyMeansViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UIActionSheetDelegate,STPhotoKitDelegate>
@property (nonatomic, assign) PhotoType type;
@end

@implementation MyMeansViewController
{
    UITableView *_meanTable;
    UIImage *headerImage;
  
}
- (void)viewWillAppear:(BOOL)animated{
     self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorFromHexCode:@"EFEFF4"];
    [self setBackWithImage];
    [self setTitle:@"我的资料"];
    [self initView];
    
    //数据库操作对象
    RLMRealm *realm = [RLMRealm defaultRealm];
    //打开数据库事务
    [realm transactionWithBlock:^(){
        Person* _temp = [[Person alloc] init];
        _temp.id = 1;//计算的当前ID
        _temp.name = @"kevingao";
        _temp.sex = @"man";
        //添加到数据库
        [realm addObject:_temp];
        //提交事务
        [realm commitWriteTransaction];
        
    }];

    
    [self searchFromRealmData];
    
}

-(void)searchFromRealmData{
    //获得当前所有数据
    
    RLMResults* tempArray = [Person allObjects];
    
    for (Person* model in tempArray) {
        
        //打印数据
        
      NSLog(@"ID : %ld, name : %@, age : %@ ",(long)model.id,model.name,model.sex);
        
    }
}

-(void)initView{
    headerImage = [UIImage imageNamed:@"user_icon_default.png"];
    _meanTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + KTopHeight , ScreenWidth, 120) style:UITableViewStylePlain];
    _meanTable.scrollEnabled = NO;
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
        cell.headerImage.image = headerImage;
        return cell;
    }
    if (indexPath.row == 1) {
        cell.titleLabel.text = @"我的昵称";
        cell.detailLabel.text = _nameString;
 
        return cell;
    }
    return nil;
 
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        self.type = PhotoTypeIcon;
        [self editImageSelected];
    }
    if (indexPath.row == 1) {
        alterNameViewController *alter = [[alterNameViewController alloc] init];
        [alter returnText:^(NSString *name) {
          self.nameString = name;
          [_meanTable reloadData];
        }];
        [self.navigationController pushViewController:alter animated:YES];
    }
    
    
    
}
#pragma mark - --- delegate 视图委托 ---

#pragma mark - 1.STPhotoKitDelegate的委托

- (void)photoKitController:(STPhotoKitController *)photoKitController resultImage:(UIImage *)resultImage
{
   
            headerImage = resultImage;
           // self.imageIcon.image = resultImage;
    [_meanTable reloadData];
}


#pragma mark - 2.UIImagePickerController的委托

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        STPhotoKitController *photoVC = [STPhotoKitController new];
        [photoVC setDelegate:self];
        [photoVC setImageOriginal:imageOriginal];
        [photoVC setSizeClip:CGSizeMake(100, 100)];
        [self presentViewController:photoVC animated:YES completion:nil];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}


#pragma mark - --- event response 事件相应 ---
- (void)editImageSelected
{
    UIAlertController *alertController = [[UIAlertController alloc]init];
    
    UIAlertAction *action0 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        
        if ([controller isAvailableCamera] && [controller isSupportTakingPhotos]) {
            [controller setDelegate:self];
            [self presentViewController:controller animated:YES completion:nil];
        }else {
            NSLog(@"%s %@", __FUNCTION__, @"相机权限受限");
        }
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *controller = [UIImagePickerController imagePickerControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [controller setDelegate:self];
        if ([controller isAvailablePhotoLibrary]) {
            [self presentViewController:controller animated:YES completion:nil];
        }    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:action0];
    [alertController addAction:action1];
    [alertController addAction:action2];
    
    [self presentViewController:alertController animated:YES completion:nil];
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
