//
//  editDiaryModel.m
//  Diary
//
//  Created by xukun on 2017/2/14.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import "editDiaryModel.h"
#import <Realm/Realm.h>

@implementation editDiaryModel


+(NSString*)primaryKey{
    return @"diaryId";
}
@end
