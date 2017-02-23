//
//  videoModel.h
//  Diary
//
//  Created by xukun on 2017/2/21.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface videoModel : RLMObject
@property (nonatomic, assign) NSString *url;
@property (nonatomic, copy) NSString *image;
@property (nonatomic,assign)  NSInteger  textLocation;
@property (nonatomic,assign)  CGFloat  textHeight;
@end
