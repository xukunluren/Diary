//
//  HttpEngine.m
//  Diary
//
//  Created by Hanser on 2/14/17.
//  Copyright © 2017 xukun. All rights reserved.
//

#import "HttpEngine.h"
#import "AFHTTPSessionManager.h"

@implementation HttpEngine

- (void)postDataInstance:(NSString *)url
               parameter:(NSDictionary *)parameter
                complete:(CompleteRequestBlock)block {
    if (!url) {
        NSLog(@"url是空的");
        return;
    }
    
    NSURL *URL = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:parameter success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//json字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    
    return dic;
    
}

@end

