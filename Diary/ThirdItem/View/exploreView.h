//
//  exploreView.h
//  Diary
//
//  Created by xukun on 2017/1/19.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <UIKit/UIKit.h>



#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

@class exploreView;
@protocol ExploreViewDelegate <NSObject>

- (void)bottomButtonEvent:(NSInteger)tag;

/** 移动卡片之后调试显示卡片的位置 **/
-(void)adjustOtherCards;

/*** 滑动卡片调用 **/
/*** @param  cardView  移动的卡片
     @param  isRight   方向        **/
-(void)swipCard:(exploreView *)cardView Direction:(BOOL) isRight;


@end

@interface exploreView : UIView

@property (assign, nonatomic) CGAffineTransform originalTransform;
@property(nonatomic,strong) UITextView *textView;
@property(nonatomic,strong) UIImageView *imageview;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UIButton *supportButton;
@property(nonatomic,strong) UIButton *changeButton;

@property (assign, nonatomic) BOOL canPan;

@property (assign, nonatomic) CGPoint originalPoint;
@property (assign, nonatomic) CGPoint originalCenter;


@property(nonatomic, strong) id<ExploreViewDelegate> delegate;
-(void)loadCardViewWithDictionary:(NSDictionary *)dictionary;


-(void)leftButtonClickAction;
-(void)rightButtonClickAction;

@end
