//
//  DPImagePickerVC.h
//  DPImagePicker
//
//  Created by duanpeng on 16/10/24.
//  Copyright © 2016年 duanpeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DPImagePickerVC;

@protocol DPImagePickerDelegate <NSObject>

@optional
- (void)getCutImage:(UIImage *)image;
//传出的是NSdata数组
- (void)getImageArray:(NSMutableArray *)arrayImage;

@end

@interface DPImagePickerVC : UIViewController

@property (nonatomic, assign)id<DPImagePickerDelegate>delegate;

//YES多选，NO 单选
@property (nonatomic,assign)BOOL isDouble;




@end
