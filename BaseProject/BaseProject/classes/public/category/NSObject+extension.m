//
//  NSObject+extension.m
//
//  Created by 张晓伟 on 16/6/11.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "NSObject+extension.h"
#import <objc/runtime.h>

@implementation NSObject (extension)

+ (NSArray *)objectsWithArray:(NSArray *)array {
    
    if (array.count == 0) {
        return nil;
    }
    
    // 断言是字典数组
    NSAssert([array[0] isKindOfClass:[NSDictionary class]], @"必须传入字典数组");

    // 0. 获得属性数组
    NSArray *list = [self propertiesList];
    
    // 1. 遍历数组
    NSMutableArray *arrayM = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        
        // 2. 创建对象
        id obj = [self new];
        
        // 3. 遍历字典
        for (NSString *key in dict) {
            // 判断字典中的 key 是否在成员变量中存在
            if (![list containsObject:key]) {
                continue;
            }
            
            [obj setValue:dict[key] forKey:key];
        }
        
        // 4. 将对象添加到数组
        [arrayM addObject:obj];
    }
    
    return arrayM.copy;
}

void *propertiesKey = "cn.xywzxw.propertiesList";

+ (NSArray *)propertiesList {
    
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, propertiesKey);
    
    if (result != nil) {
        return result;
    }
    
    unsigned int count = 0;
    objc_property_t *list = class_copyPropertyList([self class], &count);
    
    // 遍历所有的属性
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (unsigned int i = 0; i < count; i++) {
    
        objc_property_t pty = list[i];
        
        // 获取 ivar 名称
        const char *cName = property_getName(pty);
        NSString *name = [NSString stringWithUTF8String:cName];
        
        [arrayM addObject:name];
    }
    
    free(list);
    
    // 设置关联对象
    objc_setAssociatedObject(self, propertiesKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, propertiesKey);
}

void *ivarsKey = "cn.xywzxw.ivarsList";

+ (NSArray *)ivarsList {
    
    // 获取关联对象
    NSArray *result = objc_getAssociatedObject(self, ivarsKey);
    
    if (result != nil) {
        return result;
    }
    
    unsigned int count = 0;
    Ivar *list = class_copyIvarList([self class], &count);
    
    // 遍历所有的属性
    NSMutableArray *arrayM = [NSMutableArray array];
    
    for (unsigned int i = 0; i < count; i++) {
        
        Ivar ivar = list[i];
        
        // 获取 ivar 名称
        const char *cName = ivar_getName(ivar);
        NSString *name = [NSString stringWithUTF8String:cName];
        
        [arrayM addObject:name];
    }
    
    free(list);
    
    // 设置关联对象
    objc_setAssociatedObject(self, ivarsKey, arrayM, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    return objc_getAssociatedObject(self, ivarsKey);
}
- (void)printModel
{
    Class clazz = [self class];
    u_int count;
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    NSMutableArray* valueArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count ; i++)
    {
        objc_property_t prop=properties[i];
        const char* propertyName = property_getName(prop);
        
        [propertyArray addObject:[NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
        
        
        SEL selector = NSSelectorFromString([NSString stringWithUTF8String:propertyName]);
        
        IMP imp = [self methodForSelector:selector];
        id (*func)(id, SEL) = (void *)imp;
        id value = func(self, selector);
        
        
        if(value ==nil)
            [valueArray addObject:[NSNull null]];
        else {
            [valueArray addObject:value];
        }
    }
    
    free(properties);
    
    NSDictionary* returnDic = [NSDictionary dictionaryWithObjects:valueArray forKeys:propertyArray];
    [returnDic dictToJson];
}
-(NSString *)dictToJson
{
    NSString *jsonString = nil;
    NSError *error;
    if ([self isKindOfClass:[NSDictionary class]])
    {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *json = [NSString stringWithFormat:@"\n-------------JSON字符串start-------------\n%@\n-------------JSON字符串end-------------\n",jsonString];
        return json;
    }else
    {
        NSString *info = @"该数据不是字典类型,无法转换";
        return info;
    }
}
- (UIViewController *)getViewController{
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    UIViewController *result = window.rootViewController;
    while (result.presentedViewController) {
        result = result.presentedViewController;
    }
    if ([result isKindOfClass:[UITabBarController class]]) {
        result = [(UITabBarController *)result selectedViewController];
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        result = [(UINavigationController *)result topViewController];
    }
    return result;
}

/** 返回到根控制器页面 */
- (void)turnToGame{
    UIViewController *viewController = self.getViewController;
    while (viewController.presentingViewController){
        // 直到找到最底层为止
        if ([viewController isMemberOfClass:[UIViewController class]]){
            viewController = viewController.presentingViewController;
        }
        else{
            break;
        }
    }
    if([[[UIDevice currentDevice]systemVersion]floatValue] >=6){
        if (viewController){
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }
    else{
        if (viewController){
            [viewController dismissViewControllerAnimated:YES completion:nil];
        }
    }

}

@end
