//
//  GuideView.m
//  Diary
//
//  Created by Hanser on 2/23/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "GuideView.h"
#define PAGECONTROL_WIDTH 100

@interface GuideView()<UIScrollViewDelegate> {
    NSArray *_imageArray;
}

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;


@end

@implementation GuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //scrollView
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        [self addSubview:_scrollView];
        
        [self addSubview:self.pageControl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - lazy load
- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.frame = CGRectMake((kScreenWidth-PAGECONTROL_WIDTH)/2, 600, PAGECONTROL_WIDTH, 50);
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.pageIndicatorTintColor = [UIColor blackColor];
        return  _pageControl;
    }
    return _pageControl;
}

#pragma mark - 设置图片
- (void)setImageArray:(NSArray *)imageArray {
    _imageArray = imageArray;
    NSInteger count = imageArray.count;
    if (imageArray.count > 0) {
        _pageControl.numberOfPages = count;
        self.scrollView.contentSize = CGSizeMake(kScreenWidth * count, kScreenHeight);
        for (NSInteger i=0; i<count; i++) {
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
    _pageControl.currentPage = round(offset.x / kScreenWidth);
}

#pragma mark - tap
- (void)removeSelf {
    if (_pageControl.currentPage == _imageArray.count - 1) {
        if ([_delegate respondsToSelector:@selector(GuideViewDelegate:)]) {
            [_delegate GuideViewDelegate:self];
        }
    }
}

@end
