//
//  ItemView.m
//  WeiKe
//
//  Created by hsmob on 14/11/20.
//  Copyright (c) 2014年 jing. All rights reserved.
//

#import "ItemView.h"
//#import "UIImageView+WebCache.h"

@implementation ItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _logo = [[UIImageView alloc] init];
        [self addSubview:_logo];
        
        _title = [[UILabel alloc] init];
        _title.backgroundColor = [UIColor clearColor];
        _title.font = [UIFont systemFontOfSize:10.0f];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor colorFromHexCode:@"#666666"];
        [self addSubview:_title];
        
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        CGFloat imageWidth = 24;
        CGFloat titleHeight = 13;
        CGFloat padding = 5;
        _logo.frame = CGRectMake((width - imageWidth) / 2, 20 , imageWidth, imageWidth);
        _title.frame = CGRectMake(5, CGRectGetMaxY(_logo.frame) + padding, width - 10, titleHeight);
        
        _badge = [[UIImageView alloc] init];
        _badge.hidden = YES;
        [self addSubview:_badge];
    }
    return self;
}

- (void)setTitle:(NSString *)title imageName:(NSString *)imageName
{
    _title.text = title;
    _logo.image = [UIImage imageNamed:imageName];
}


- (void)setBadgeImageName:(NSString *)imageName {
    _badge.hidden = imageName == nil ? YES : NO;
    if (!imageName) return;
    UIImage *image = [UIImage imageNamed:imageName];
    CGSize imageSize = image.size;
    CGFloat left = _logo.right - 6;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (left + width >= self.width - 2) {
        width = floorf(self.width - 2 - left);
        height = floorf((width / imageSize.width) * height);
    }
    _badge.frame = CGRectMake(_logo.right - 6, _logo.top - 6, width, height);
    _badge.image = [UIImage imageNamed:imageName];
}

- (void)removeBadge {
    if (_badge) {
        [_badge removeFromSuperview];
        _badge = nil;
    }
}

@end
