//
//  audioModel.h
//  Diary
//
//  Created by xukun on 2017/2/6.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface audioModel : NSObject
@property (nonatomic, copy) NSString *soundFilePath;
@property (nonatomic, assign) NSTimeInterval seconds;
@end
