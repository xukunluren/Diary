//
//  functionKeyView.h
//  Diary
//
//  Created by xukun on 2017/2/18.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "BaseView.h"


@protocol sendClickEvent <NSObject>

-(void)sendswitchAction:(id)sender;
-(void)sendFunctionClick:(id)sender;

@end

@interface functionKeyView : BaseView
@property(nonatomic,weak)id<sendClickEvent>delegate;
@property(nonatomic,strong) UIButton *weatherBT;
@property(nonatomic,strong) UISwitch *openOrNotButton;
@property(nonatomic,assign) long weatherIcon;

-(void)setweatherIconPicture:(long)icon;

//-(void)setWeatherBTPicture:(UIButton *)weatherBT
@end
