//
//  BaseModel.h
//  BaseProject
//
//  Created by 张晓伟 on 16/12/26.
//  Copyright © 2016年 Yiss Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCoding>
/** 字典转模型类方法 */
+ (instancetype)modelWithDict:(NSDictionary *)dict;

/** 字典转模型实例方法 */
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
