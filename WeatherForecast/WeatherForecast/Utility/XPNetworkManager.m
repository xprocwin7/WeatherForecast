//
//  XPNetworkManager.m
//  WeatherForecast
//
//  Created by dragon on 16/6/17.
//  Copyright © 2016年 win. All rights reserved.
//

#import "XPNetworkManager.h"
#import "AFNetworking.h"

@implementation XPNetworkManager

+ (void)sendGetRequestWithUrl:(NSString *)urlStr parameters:(NSDictionary *)paramDic success:(successBlock)success failure:(failureBlock)failure {
    //和AFNetworing相关的调用
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //服务器成功返回;responseObject回传控制器
        //相当于函数
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //服务器失败返回;error回传控制器
        //相当于函数
        failure(error);
    }];
}

@end
