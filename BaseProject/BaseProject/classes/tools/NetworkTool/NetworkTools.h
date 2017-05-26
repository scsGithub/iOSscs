//
//  NetworkTools.h
//  网络请求封装
//
//  Created by 张晓伟 on 2016/12/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum DownLoadMethod
{
    GET,
    POST
}DownLoadMethod;

@interface NetworkTools : NSObject
/**
 实例化方法
 
 @return 单例
 */
+ (instancetype)manager;

/**
 *  上传文件
 *
 *  @param urlStr   上传URL
 *  @param parm     参数
 *  @param data     上传的data
 *  @param fileName 上传的data文件的文件名
 *  @param updata   上传完成后调用的block
 *  @param error    上传失败后调用的block
 */
-(void)uploadFileWithURL:(NSString *)urlStr
                parmater:(NSDictionary *)parm
                    data:(NSData*)data
                    name:(NSString *)fileName
                 success:(void(^)(NSData *data))updata
                   error:(void(^)(NSError *error)) error;


/**
 *  文件下载
 *
 *  @param urlStr 文件下载地址
 *  @param data   下载完成后返回的数据
 *  @param error  失败值
 */
-(void)startDownLoadWithURL:(NSString *)urlStr
                    success:(void(^)(NSData *data))data
                      error:(void(^)(NSError *error)) error;

/**
 GET同步请求
 
 @param urlStr URL地址
 @return data 请求结果
 */
-(NSString *)startSyncDownLoadWithURL:(NSString *)urlStr;


/**
 *  POST请求方法
 *
 *  @param urlStr url
 *  @param param  参数
 *  @param data   正确返回的值
 *  @param error  错误返回的值
 */
-(void)startDownLoadWithURL:(NSString *)urlStr
                      param:(NSDictionary *)param
                    success:(void (^)(NSData *))data
                      error:(void (^)(NSError *))error;

/**
 *  GET请求方法
 *
 *  @param urlStr url
 *  @param param  参数
 *  @param data   正确返回的值
 *  @param error  错误返回的值
 */
-(void)startWithURL:(NSString *)urlStr
          withParam:(NSDictionary *)param
            success:(void (^)(NSData *data))data
              error:(void (^)(NSError *error))error;


/**
 封装的网络请求
 
 @param method GET/POST方法
 @param urlStr url地址
 @param param 参数
 @param responseObject 成功回调
 @param error 错误回调
 */
-(void)downLoadWithMethod:(DownLoadMethod)method
                  withURL:(NSString *)urlStr
                withParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))responseObject
                    error:(void (^)(NSError *error))error;
@end
