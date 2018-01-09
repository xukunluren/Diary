//
//  DPImagePickerVC.h
//  DPImagePicker
//
//  Created by duanpeng on 16/10/24.
//  Copyright © 2016年 duanpeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@import UIKit;

typedef void(^SaveImageCompletion)(NSError* error);

@interface ALAssetsLibrary(CustomPhotoAlbum)

-(void)saveImage:(UIImage*)image toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;
-(void)addAssetURL:(NSURL*)assetURL toAlbum:(NSString*)albumName withCompletionBlock:(SaveImageCompletion)completionBlock;

@end
