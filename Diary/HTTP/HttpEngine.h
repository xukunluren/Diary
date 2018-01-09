//
//  HttpEngine.h
//  Diary
//
//  Created by Hanser on 2/14/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^CompleteRequestBlock)(NSDictionary *requestDic,NSError *error);

@interface HttpEngine : NSObject

/**  
 
    @url                 请地址
    @parameter           入参
    @block               执行完方法之后处理数据
 **/
- (void)postDataInstance:(NSString *)url
               parameter:(NSDictionary *)parameter
                complete:(CompleteRequestBlock)block;

@end
