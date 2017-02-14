//
//  ViewController.m
//  RemoveTest
//
//  Created by xukun on 2017/2/10.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "ViewController.h"
#import "UzysAssetsPickerController.h"
//#import "XLVideoPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
 @interface ViewController ()<UzysAssetsPickerControllerDelegate>
{
 
}

@end

@implementation ViewController
{
    NSInteger count;
    UIView *viewDelete;
    NSURL *mp4Url;
    UIView *nnview;
    AVPlayer *righrPlayer;
    AVPlayerLayer *rightPlayerLayer;
    AVPlayerItem *rightPlayerItem;
    UIImageView *imagView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initView];
    count = 4;
    
}


-(void)initView{
    
//    for(int i = 1;i<5;i++){
//    viewDelete = [[UIView alloc] initWithFrame:CGRectMake(10, 40*i, 40, 20)];
//    [viewDelete setBackgroundColor:[UIColor redColor]];
//    viewDelete.tag = i;
//    [self.view addSubview:viewDelete];
//    
////    
////    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(10, 80, 40, 20)];
////    [view2 setBackgroundColor:[UIColor redColor]];
////    view2.tag=2;
////    [self.view addSubview:view2];
////    
////    UIView *view3 = [[UIView alloc] initWithFrame:CGRectMake(10, 160, 40, 20)];
////    [view3 setBackgroundColor:[UIColor redColor]];
////    view3.tag = 1;
////    [self.view addSubview:view3];
////    
////    UIView *view4 = [[UIView alloc] initWithFrame:CGRectMake(10, 300, 40, 20)];
////    [view4 setBackgroundColor:[UIColor redColor]];
////    view4.tag=4;
////    [self.view addSubview:view4];
//    }
    // 初始化
  
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 50, 40)];
    [button setTitle:@"选择" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(testRun) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(100, 40, 60, 70)];
    [button1 setTitle:@"播放" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showVideoPlayer) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button1];
    
    
    
    nnview = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 300, 300)];
    
    [self.view addSubview:nnview];
    
    imagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 400, 300, 300)];
    [self.view addSubview:imagView];
    
    
    
    
    
    
}

#pragma mark - lazt loading

- (void)showVideoPlayer{
    
    [righrPlayer pause];
    rightPlayerItem  = nil;
    [rightPlayerLayer removeFromSuperlayer];
    
    
    AVAsset *rightAsset       = [AVAsset assetWithURL:mp4Url];
    rightPlayerItem  = [AVPlayerItem playerItemWithAsset:rightAsset];
    righrPlayer      = [[AVPlayer alloc]init];
    [righrPlayer replaceCurrentItemWithPlayerItem: rightPlayerItem];
    rightPlayerLayer  = [AVPlayerLayer playerLayerWithPlayer:righrPlayer];
    rightPlayerLayer.frame      = CGRectMake(0, 0, 300, 300);
    [nnview.layer addSublayer:rightPlayerLayer];
    rightPlayerLayer.videoGravity = AVLayerVideoGravityResize;
    [righrPlayer play];

}

- (void)testRun
{
 
    
#if 0
    UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
    appearanceConfig.finishSelectionButtonColor = [UIColor blueColor];
    appearanceConfig.assetsGroupSelectedImageName = @"checker.png";
    appearanceConfig.cellSpacing = 1.0f;
    appearanceConfig.assetsCountInALine = 5;
    [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
#endif
    
    UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
    picker.delegate = self;
    
   
        picker.maximumNumberOfSelectionVideo = 2;
        picker.maximumNumberOfSelectionPhoto = 0;
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}



#pragma mark - UzysAssetsPickerControllerDelegate methods
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
         __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
    
            *stop = YES;
        }];
        
        
    }
    else //Video
    {
        ALAsset *alAsset = assets[0];
        
        UIImage *img = [UIImage imageWithCGImage:alAsset.defaultRepresentation.fullResolutionImage
                                           scale:alAsset.defaultRepresentation.scale
                                     orientation:(UIImageOrientation)alAsset.defaultRepresentation.orientation];
        imagView.image = img;
        
        
        ALAssetRepresentation *representation = alAsset.defaultRepresentation;
        
          long long size = representation.size;
        
        
        
        AVAsset *avasset = [AVAsset assetWithURL:alAsset.defaultRepresentation.url];
        NSURL *movieURL = representation.url;
        mp4Url = movieURL;
        NSURL *uploadURL = [NSURL fileURLWithPath:[[NSTemporaryDirectory() stringByAppendingPathComponent:@"test"] stringByAppendingString:@".mp4"]];
    
        AVAsset *asset      = [AVURLAsset URLAssetWithURL:movieURL options:nil];
        AVAssetExportSession *session =
        [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        
        session.outputFileType  = AVFileTypeQuickTimeMovie;
        session.outputURL       = uploadURL;
        
        [session exportAsynchronouslyWithCompletionHandler:^{
            
            if (session.status == AVAssetExportSessionStatusCompleted)
            {
                DLog(@"output Video URL %@",uploadURL);
            }
            
        }];
        
    }
    
}

- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:NSLocalizedStringFromTable(@"Exceed Maximum Number Of Selection", @"UzysAssetsPickerController", nil)
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
