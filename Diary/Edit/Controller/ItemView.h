//
//  ItemView.h
//  WeiKe
//
//  Created by hsmob on 14/11/20.
//  Copyright (c) 2014年 jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemView : UIButton{
    UILabel *_title;
    UIImageView *_logo;
    UIImageView *_badge;
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName;
- (void)setTitle:(NSString *)title imageUrl:(NSString *)imageUrl;
- (void)setBadgeImageName:(NSString *)imageName;
- (void)removeBadge;

@end
