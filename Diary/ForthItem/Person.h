//
//  Person.h
//  Diary
//
//  Created by xukun on 2017/1/18.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject
@property NSString *name;      //姓名

@property NSInteger iD;        //年龄

@property NSString *sex;        //性别
@end
