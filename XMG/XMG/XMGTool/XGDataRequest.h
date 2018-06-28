//
//  XGDataRequest.h
//  XMG
//
//  Created by 小马哥 on 2017/9/18.
//  Copyright © 2017年 小马哥. All rights reserved.
//

#import "YTKBaseRequest.h"

@interface XGDataRequest : YTKBaseRequest

/**
 *  请求封装    method 请求方法 GET = 0, POST = 1, HEAD = 2, PUT = 3, DELETE = 4, PATCH  = 5
 *
 *  @param url    请求路径
 *  @param method 请求方法
 *          YTKRequestMethodGET    = 0,
 *          YTKRequestMethodPOST   = 1,
 *          YTKRequestMethodHEAD   = 2,
 *          YTKRequestMethodPUT    = 3,
 *          YTKRequestMethodDELETE = 4,
 *          YTKRequestMethodPATCH  = 5
 *  @param params  要传的参数
 *
 */
+ (void)requestWithUrl:(NSString *)url withMethod:(NSInteger)method withParams:(NSDictionary *)params withSuccessBlock:(void(^)(NSInteger code, NSString * msg, NSString * loginToken, id jsonData))successBlock withErrorBlock:(void(^)(NSError * error))errorBlock;

///处理加密
+ (NSDictionary *)getParamsWith:(NSDictionary *)params;

///处理解密
+ (id)DecodeResponseDataWithResponse:(NSDictionary *)response;

@end
