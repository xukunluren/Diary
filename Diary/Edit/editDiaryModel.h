//
//  editDiaryModel.h
//  Diary
//
//  Created by xukun on 2017/2/14.
//  Copyright © 2017年 xukun. All rights reserved.
//

#import <Realm/Realm.h>
#import "videoModel.h"
#import "audioModel.h"


RLM_ARRAY_TYPE(audioModel)
RLM_ARRAY_TYPE(videoModel)
@interface editDiaryModel : RLMObject
@property NSString *year;
@property NSString *monthAndDay;
@property NSString *title;
@property NSString *time;
@property NSInteger supportNum;
@property NSInteger pictureLocation;//图片所在位置
@property BOOL haveWeatherInfo;
@property BOOL haveVideoInfo;
@property BOOL havePictureInfo;
@property BOOL haveAudioInfo;
@property BOOL openOrNo;//是否公开日记
@property NSData *diaryInfo;
@property long weatherType;//天气类型
@property long atGroup;//所在分组
@property NSString *atGroupTitle;//所在分组
@property long diaryId;
@property RLMArray<videoModel *><videoModel>  *videoDataModel;//视频模型数据
@property RLMArray<audioModel *><audioModel> *audioDataModel;//音频模型数据

@end
