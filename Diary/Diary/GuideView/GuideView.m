//
//  GuideView.m
//  Diary
//
//  Created by Hanser on 2/23/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "GuideView.h"
#import "CustomPageControl.h"


//#define PAGECONTROL_WIDTH 100


@interface GuideView()<UIScrollViewDelegate> {
    NSArray *_imageArray;
    NSInteger _index;
    NSInteger _count;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) CustomPageControl *customPageControl;

@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count {
    self = [super initWithFrame:frame];
    if (self) {
        _count = count;
        //scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        [self addSubview:self.customPageControl];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - lazy load

- (CustomPageControl *)customPageControl {
    if (!_customPageControl) {
        CGFloat width = _count * (PAGECONTROL_SPACE + PAGECONTROL_WIDTH) - PAGECONTROL_SPACE;
        CGRect rect = CGRectMake((kScreenWidth - width)/2, kScreenHeight - 35, width, 35);
        _customPageControl = [[CustomPageControl alloc] initWithFrame:rect pageCount:3];
        return _customPageControl;
    }
    return _customPageControl;
}

#pragma mark - 设置图片
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    _count = imageArray.count;
    if (imageArray.count > 0) {
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * _count, kScreenHeight);
        for (NSInteger i=0; i<_count; i++) {
            NSString *imageStr = imageArray[i];
            UIImage *image = [UIImage imageNamed:imageStr];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            imageView.frame = CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight);
            [self.scrollView addSubview:imageView];
        }
    }
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    _index = offset.x / kScreenWidth;

    [_customPageControl changePageControlColor:_index];
}

#pragma mark - tap
- (void)removeSelf {
    if (_index == _imageArray.count - 1) {
        if ([_delegate respondsToSelector:@selector(GuideViewDelegate:)]) {
            [_delegate GuideViewDelegate:self];
        }
    }
}

@end
