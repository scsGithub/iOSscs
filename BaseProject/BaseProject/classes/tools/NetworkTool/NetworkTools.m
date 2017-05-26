//
//  NetworkTools.m
//  网络请求封装
//
//  Created by 张晓伟 on 2016/12/14.
//  Copyright © 2016年 飓风逍遥. All rights reserved.
//

#import "NetworkTools.h"
#import <AFHTTPSessionManager.h>
#import "HUDShow.h"

#define TEST_FORM_BOUNDARY @"ABCD1234"
#define TYEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]


@interface NetworkTools ()

@property (nonatomic, copy) void(^data)(NSData *data);
@property (nonatomic, copy) void(^error)(NSError *error);
@property (nonatomic, copy) void(^responseObject)(id responseObject);
@end
@implementation NetworkTools


-(void)netLoding{
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeCustom];
    [NSTimer scheduledTimerWithTimeInterval:6 repeats:NO block:^(NSTimer * _Nonnull timer) {
        [self netEnd];
    }];
}
-(void)netEnd{
    [SVProgressHUD dismiss];
}

+ (instancetype)manager
{
    static NetworkTools *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    return manager;
}

/**
 *  上传文件
 *
 *  @param urlStr   上传URL
 *  @param parm     参数
 *  @param data     上传的data
 *  @param fileName 上传的data文件的文件名
 *  @param updata   上传完成后调用的block
 *  @param error  上传失败后调用的block
 */
-(void)uploadFileWithURL:(NSString *)urlStr parmater:(NSDictionary *)parm data:(NSData*)data name:(NSString *)fileName success:(void(^)(NSData *data))updata error:(void(^)(NSError *error)) error
{
    self.data = updata;
    self.error = error;
    
    [self netLoding];
    //初始化要上传的数据
    NSMutableData *dataM = [NSMutableData data];
    
    
    //遍历一遍字典参数，用block形式执行，会自动分配到多核cpu上运行
    [parm enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        //参数开始的标志
        NSString *boundry = [NSString stringWithFormat:@"--%@\r\n",TEST_FORM_BOUNDARY];
        [dataM appendData:TYEncode(boundry)];
        
        NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key];
        
        [dataM appendData:TYEncode(disposition)];
        [dataM appendData:TYEncode(@"\r\n")];
        [dataM appendData:TYEncode(obj)];
        [dataM appendData:TYEncode(@"\r\n")];
    }];
    
    //准备工作(规定好了的格式)，事先规定好分隔符TEST_FORM_BOUNDARY
    NSString *strTop=[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\nContent-Type: %@\r\n",TEST_FORM_BOUNDARY,fileName,@"image/png"];
    
    [dataM appendData:TYEncode(strTop)];
    [dataM appendData:TYEncode(@"\r\n")];
    [dataM appendData:data];
    [dataM appendData:TYEncode(@"\r\n")];
    
    
    //尾部的分隔符
    NSString *strBottom = [NSString stringWithFormat:@"--%@--\r\n",TEST_FORM_BOUNDARY];
    
    [dataM appendData:TYEncode(strBottom)];
    
    //请求设置
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:dataM];
    
    
    //设置上传数据的长度及格式
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)dataM.length] forHTTPHeaderField:@"Content-Length"];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@",TEST_FORM_BOUNDARY] forHTTPHeaderField:@"Content-Type"];
    
    //上传
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionUploadTask *task = [session uploadTaskWithRequest:request fromData:dataM completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && data) {
                [self netEnd];
                self.data(data);
            }else{
                [self netEnd];
                self.error(error);
            }
        });

    }];
    [task resume];
}

/**
 *  文件下载
 *
 *  @param urlStr 文件下载地址
 *  @param data   下载完成后返回的数据
 *  @param error  失败值
 */
-(void)startDownLoadWithURL:(NSString *)urlStr success:(void(^)(NSData *data))data error:(void(^)(NSError *error)) error
{
    self.data = data;
    self.error = error;
    [self netLoding];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                              {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      if (!error && data) {
                                          [self netEnd];
                                          self.data(data);
                                      }
                                      else
                                      {
                                          [self netEnd];
                                          self.error(error);
                                      }
                                      
                                  });
                              }];
    [task resume];
    
}


/**
 GET同步请求

 @param urlStr URL地址
 @return data 请求结果
 */
-(NSString *)startSyncDownLoadWithURL:(NSString *)urlStr{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //第二步，通过URL创建网络请求
    //NSURLRequest初始化方法第一个参数：请求访问路径，第二个参数：缓存协议，第三个参数：网络请求超时时间（秒）
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *data = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    return data;
}

/**
 *  POST请求方法
 *
 *  @param urlStr url
 *  @param param  参数
 *  @param data   正确返回的值
 *  @param error  错误返回的值
 */
-(void)startDownLoadWithURL:(NSString *)urlStr param:(NSDictionary *)param success:(void (^)(NSData *))data error:(void (^)(NSError *))error
{
    self.data = data;
    self.error = error;
    [self netLoding];
    //1.构造URL
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.构造Request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //(1)设置为POST请求
    [request setHTTPMethod:@"POST"];
    
    //(2)超时
    [request setTimeoutInterval:60];
    
    //(3)设置请求头
    //[request setAllHTTPHeaderFields:nil];
    
    //(4)设置请求体
    NSMutableString *tmp = [NSMutableString string];
    for (NSString *key in param)
    {
        NSString *tmpStr = [NSString stringWithFormat:@"%@=%@&",key,param[key]];
        [tmp appendString:tmpStr];
    }
    NSString *bodyStr = [tmp substringWithRange:NSMakeRange(0, tmp.length - 1)];
    NSData *bodyData = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置请求体
    [request setHTTPBody:bodyData];
    
    
    
    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.task
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [self netEnd];
                self.error(error);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self netEnd];
                    self.data(data);
                });
            }
            
        });
    }];
    
    //5.执行任务
    [task resume];
    
}

/**
 *  GET请求方法
 *
 *  @param urlStr url
 *  @param param  参数
 *  @param data   正确返回的值
 *  @param error  错误返回的值
 */
-(void)startWithURL:(NSString *)urlStr withParam:(NSDictionary *)param success:(void (^)(NSData *data))data error:(void (^)(NSError *error))error
{
    self.data = data;
    self.error = error;
    [self netLoding];
    //GET请求, 也可以给服务器发送信息, 也有参数(微博用户名,用户id)
    //1.构造URL, 参数直接拼接在url连接后
    NSURL *url = [NSURL URLWithString:urlStr];
    
    //2.构造Request
    //把get请求的请求头保存在request里
    //NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 参数
    // (1)url
    // (2)缓存策略
    // (3)超时的时间, 经过120秒之后就放弃这次请求
    //NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120];
    //NSURLRequest 不可变,不能动态的添加请求头信息
    
    //可变的对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //(1)设置请求方式
    [request setHTTPMethod:@"GET"];
    
    //(2)超时时间
    [request setTimeoutInterval:120];
    
    //(3)缓存策略
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    
    //(4)设置请求头其他内容
    //    [request setValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>];
    //    [request addValue:<#(NSString *)#> forHTTPHeaderField:<#(NSString *)#>];
    [request setAllHTTPHeaderFields:param];
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; //告诉服务,返回的数据需要压缩
    
    
    //3.构造Session
    NSURLSession *session = [NSURLSession sharedSession];
    
    //4.构造要执行的任务task
    /**
     * task
     *
     * data 返回的数据
     * response 响应头
     * error 错误信息
     *
     */
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (error == nil && data) {
            /*
             NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             SLLog(@"data: %@", dataStr);
             */
            
            //json --> data
            //NSJSONSerialization *jsonData = [NSJSONSerialization dataWithJSONObject:<#(id)#> options:<#(NSJSONWritingOptions)#> error:<#(NSError *__autoreleasing *)#>]
            /*
             options:
             1.读取reading
             NSJSONReadingMutableContainers 生成可变的对象,不设置这个option,默认是创建不可变对象
             NSJSONReadingMutableLeaves 生成可变的字符串MutableString(iOS7+有bug)
             NSJSONReadingAllowFragments 允许json数据最外层不是字典或者数组
             2.写入writing
             NSJSONWritingPrettyPrinted 生成json数据是格式化的,有换行,可读性高
             */
            //data --> json
            //            NSString *dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //            SLLog(@"data: %@", dataStr);
            [self netEnd];
            self.data(data);
        }else {
            [self netEnd];
self.error(error);
        }
    }];
    
    //5.
    [task resume];
}

-(void)downLoadWithMethod:(DownLoadMethod)method
                  withURL:(NSString *)urlStr
                withParam:(NSDictionary *)param
                  success:(void (^)(id responseObject))responseObject
                    error:(void (^)(NSError *error))error
{
    [self netLoding];
    self.error = error;
    self.responseObject = responseObject;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 此处设置content-Type
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html",@"text/plain",nil];
    
    //加载HTTPS证书
//    manager.securityPolicy = [AFSafeCert getSecurityPolity];
    
    //重新序列化requestSerializer
//    manager.requestSerializer = [AFHTTPRequestSerializer new];
    
    if (method == GET) {
        [manager GET:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            self.responseObject(responseObject);
            [self netEnd];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self dealError:error];
            [self netEnd];
        }];
    }else if (method == POST){
        [manager POST:urlStr parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self netEnd];
            self.responseObject(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self netEnd];
            [self dealError:error];
        }];
    }
}

/**
 错误码解释说明
 
 @param error 错误对象
 */
-(void)dealError:(NSError *)error{
    [HUDShow showError:error];
    self.error(error);
}
@end
