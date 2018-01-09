//
//  groupModel.h
//  Diary
//
//  Created by xukun on 2017/2/16.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Realm/Realm.h>

@interface groupModel : RLMObject
@property NSString *title;
@property long groupId;
@property long diaryNum;
@end
