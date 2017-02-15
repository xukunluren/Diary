//
//  editDiaryModel.h
//  Diary
//
//  Created by xukun on 2017/2/14.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Realm/Realm.h>

@interface editDiaryModel : RLMObject
@property NSString *year;
@property NSString *monthAndDay;
@property NSString *title;
@property NSString *time;
@property NSInteger supportNum;
@property BOOL haveWeatherInfo;
@property BOOL haveVideoInfo;
@property BOOL havePictureInfo;
@property BOOL haveAudioInfo;
@property NSData *diaryInfo;

@property long diaryId;

@end
