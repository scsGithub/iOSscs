//
//  NSString+extension.m
//
//  Created by 张晓伟 on 16/6/7.
//  Copyright © 2016年 xywzxw. All rights reserved.
//

#import "NSString+extension.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (extension)
    
+ (NSString *)stringDisposeWithFloatStringValue:(NSString *)floatStringValue {
    NSString *str = floatStringValue;
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
        break;
        else {
            if ([str rangeOfString:@"."].location != NSNotFound) {
                str = [str substringToIndex:[str length]-1];
            } else {
                break;
            }
        }
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}
    
    //此方法去掉2.0000这样的浮点后面多余的0
    //传人一个浮点字符串,需要保留几位小数则保留好后再传
+ (NSString *)stringDisposeWithFloatValue:(float)floatNum {
    
    NSString *str = [NSString stringWithFormat:@"%.2f",floatNum];
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
        break;
        else
        str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}
    
+ (NSString *)itemThousandPointsFromNumString:(NSString *)numString {
    NSString *str = numString;
    
    NSString *preStr = @"";
    if ([str rangeOfString:@"-"].location != NSNotFound) {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        preStr = @"-";
    }
    
    NSString *lastStr = @"";
    if ([str rangeOfString:@"."].location != NSNotFound) {
        NSArray *array = [str componentsSeparatedByString:@"."];
        if (array.count > 1) {
            str = array[0];
            lastStr = [NSString stringWithFormat:@".%@",array[1]];
        }
    }
    
    NSUInteger len = [str length];
    NSUInteger x = len % 3;
    NSUInteger y = len / 3;
    NSUInteger dotNumber = y;
    
    if (x == 0) {
        dotNumber -= 1;
        x = 3;
    }
    NSMutableString *rs = [@"" mutableCopy];
    
    [rs appendString:[str substringWithRange:NSMakeRange(0, x)]];
    
    for (int i = 0; i < dotNumber; i++) {
        [rs appendString:@","];
        [rs appendString:[str substringWithRange:NSMakeRange(x + i * 3, 3)]];
    }
    rs = [NSMutableString stringWithFormat:@"%@%@",preStr,rs];
    [rs appendString:lastStr];
    return rs;
}
    
- (CGSize)ex_sizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size
    {
        CGSize resultSize;
        if ([self respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(boundingRectWithSize:options:attributes:context:)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:@selector(boundingRectWithSize:options:attributes:context:)];
            NSDictionary *attributes = @{ NSFontAttributeName:font };
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
            NSStringDrawingContext *context;
            [invocation setArgument:&size atIndex:2];
            [invocation setArgument:&options atIndex:3];
            [invocation setArgument:&attributes atIndex:4];
            [invocation setArgument:&context atIndex:5];
            [invocation invoke];
            CGRect rect;
            [invocation getReturnValue:&rect];
            resultSize = rect.size;
        } else {
            NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:@selector(sizeWithFont:constrainedToSize:)];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:self];
            [invocation setSelector:@selector(sizeWithFont:constrainedToSize:)];
            [invocation setArgument:&font atIndex:2];
            [invocation setArgument:&size atIndex:3];
            [invocation invoke];
            [invocation getReturnValue:&resultSize];
        }
        
        return resultSize;
    }
    
+ (BOOL)isVaildString:(NSString *)value
{
    return (value && ![@"" isEqualToString:value] && ![value isKindOfClass:[NSNull class]] && ![@"(null)" isEqualToString:value] && ![@"<null>" isEqualToString:value]);
}

- (NSString *)base64Encode {
    
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64Decode {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (uint32_t)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}
/** 文字竖排显示 */
- (NSString *)verticalString{
    NSMutableString * str = [[NSMutableString alloc] initWithString:self];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2 - 1];
    }
    return str;
}
/** 时间戳转时间 */
- (NSString *)dateTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //[NSTimeZone knownTimeZoneNames]所有时区
    //本地的时区
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    return confromTimespStr;
}

@end
