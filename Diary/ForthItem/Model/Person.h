//
//  Person.h
//  Diary
//
//  Created by xukun on 2017/2/14.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject
@property NSInteger id;
@property NSString *name;
@property NSString *sex;
@end
