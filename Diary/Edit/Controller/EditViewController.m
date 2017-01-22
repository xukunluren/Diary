//
//  PublishViewController.m
//  ProjectGenericFramework
//
//  Created by joe on 2016/12/14.
//  Copyright © 2016年 joe. All rights reserved.
//

#import "EditViewController.h"
#import "AdaptionTextView.h"
#import "RichTextViewController.h"

@interface EditViewController ()

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackWithText:@"取消"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    RichTextViewController * vc=[RichTextViewController ViewController];
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
    
    
    [self.view addSubview:vc.view];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//}


@end
