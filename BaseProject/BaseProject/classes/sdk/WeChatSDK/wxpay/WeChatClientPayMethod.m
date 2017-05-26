//
//  WeChatClientPayMethod.m
//  飓风逍遥
//
//  Created by zxw on 2017/1/5.
//  Copyright © 2017年 青岛吾爷网络科技有限公司. All rights reserved.
//

#import "WeChatClientPayMethod.h"
#import <CommonCrypto/CommonDigest.h>
#import <Availability.h>
#if !__has_feature(objc_arc)
#error This class requires automatic reference counting
#endif

#pragma GCC diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma GCC diagnostic ignored "-Wdirect-ivar-access"
#pragma GCC diagnostic ignored "-Wformat-non-iso"
#pragma GCC diagnostic ignored "-Wgnu"


@interface WeChatClientPayMethod()

@property (nonatomic,strong) NSString *appid;
@property (nonatomic,strong) NSString *mch_id;
@property (nonatomic,strong) NSString *nonce_str;
@property (nonatomic,strong) NSString *partnerkey;
@property (nonatomic,strong) NSString *body;
@property (nonatomic,strong) NSString *out_trade_no;
@property (nonatomic,strong) NSString *total_fee;
@property (nonatomic,strong) NSString *spbill_create_ip;
@property (nonatomic,strong) NSString *notify_url;
@property (nonatomic,strong) NSString *trade_type;

@end

@implementation WeChatClientPayMethod


#pragma mark - 产生随机字符串
/** 生成随机数算法 */
- (NSString *)generateTradeNO {
    
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    
    //  srand函数是初始化随机数的种子，为接下来的rand函数调用做准备。
    //  time(0)函数返回某一特定时间的小数值。
    //  这条语句的意思就是初始化随机数种子，time函数是为了提高随机的质量（也就是减少重复）而使用的。
    
    //　srand(time(0)) 就是给这个算法一个启动种子，也就是算法的随机种子数，有这个数以后才可以产生随机数,用1970.1.1至今的秒数，初始化随机数种子。
    //　Srand是种下随机种子数，你每回种下的种子不一样，用Rand得到的随机数就不一样。为了每回种下一个不一样的种子，所以就选用Time(0)，Time(0)是得到当前时时间值（因为每时每刻时间是不一样的了）。
    
    srand((int)time(0)); // 此行代码有警告:
    
    for (int i = 0; i < kNumber; i++)
    {
        
        unsigned index = rand() % [sourceStr length];
        
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

#pragma makr - 懒加载

- (NSMutableDictionary *)dic
{
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

#pragma mark - Config

-(instancetype)initWithAppid:(NSString *)appid_key
                      mch_id:(NSString *)mch_id_key
                   nonce_str:(NSString *)noce_str_key
                  partner_id:(NSString *)partner_id
                        body:(NSString *)body_key
               out_trade_no :(NSString *)out_trade_no_key
                   total_fee:(NSString *)total_fee_key
            spbill_create_ip:(NSString *)spbill_create_ip_key
                  notify_url:(NSString *)notify_url_key
                  trade_type:(NSString *)trade_type_key
{
    if (self = [super init]) {
        
        _appid          = appid_key;
        _mch_id         = mch_id_key;
        _nonce_str      = noce_str_key;
        _partnerkey     = partner_id;
        _body           = body_key;
        _out_trade_no   = out_trade_no_key;
        _total_fee      = total_fee_key;
        _spbill_create_ip = spbill_create_ip_key;
        _notify_url     = notify_url_key;
        _trade_type     = trade_type_key;
        
        [self.dic setValue:_appid forKey:@"appid"];
        [self.dic setValue:_mch_id forKey:@"mch_id"];
        [self.dic setValue:_nonce_str forKey:@"nonce_str"];
        [self.dic setValue:_body forKey:@"body"];
        [self.dic setValue:_out_trade_no forKey:@"out_trade_no"];
        [self.dic setValue:_total_fee forKey:@"total_fee"];
        [self.dic setValue:_spbill_create_ip forKey:@"spbill_create_ip"];
        [self.dic setValue:_notify_url forKey:@"notify_url"];
        [self.dic setValue:_trade_type forKey:@"trade_type"];
        
        [self createMd5Sign:self.dic];
    }
    
    return self;
}


//创建签名
//签名算法
//签名生成的通用步骤如下：
//第一步，设所有发送或者接收到的数据为集合M，将集合M内非空参数值的参数按照参数名ASCII码从小到大排序（字典序），使用URL键值对的格式（即key1=value1&key2=value2…）拼接成字符串stringA。
//特别注意以下重要规则：
//◆ 参数名ASCII码从小到大排序（字典序）；
//◆ 如果参数的值为空不参与签名；
//◆ 参数名区分大小写；
//◆ 验证调用返回或微信主动通知签名时，传送的sign参数不参与签名，将生成的签名与该sign值作校验。
//◆ 微信接口可能增加字段，验证签名时必须支持增加的扩展字段
//第二步，在stringA最后拼接上key得到stringSignTemp字符串，并对stringSignTemp进行MD5运算，再将得到的字符串所有字符转换为大写，得到sign值signValue。
//key设置路径：微信商户平台(pay.weixin.qq.com)-->账户设置-->API安全-->密钥设置

-(void)createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    
    NSArray *keys = [dict allKeys];
    
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![[dict objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[dict objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
    }
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@",_partnerkey];
    
    //MD5 获取Sign签名
    NSString *md5Sign =[contentString MD5Hash];
    
    //
    md5Sign = [md5Sign uppercaseString];
    [self.dic setValue:md5Sign forKey:@"sign"];
    
}


//创建发起支付时的sign签名
-(NSString *)createMD5SingForPay:(NSString *)appid_key partnerid:(NSString *)partnerid_key prepayid:(NSString *)prepayid_key package:(NSString *)package_key noncestr:(NSString *)noncestr_key timestamp:(UInt32)timestamp_key{
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject:appid_key forKey:@"appid"];
    [signParams setObject:noncestr_key forKey:@"noncestr"];
    [signParams setObject:package_key forKey:@"package"];
    [signParams setObject:partnerid_key forKey:@"partnerid"];
    [signParams setObject:prepayid_key forKey:@"prepayid"];
    [signParams setObject:[NSString stringWithFormat:@"%u",(unsigned int)timestamp_key] forKey:@"timestamp"];
    
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [signParams allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[signParams objectForKey:categoryId] isEqualToString:@""]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"sign"]
            && ![[signParams objectForKey:categoryId] isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [signParams objectForKey:categoryId]];
        }
    }
    
    
    //添加商户密钥key字段
    [contentString appendFormat:@"key=%@", WX_PartnerKey];
    
    NSString *result = [contentString MD5Hash];
    
    return result;
}


@end




//-----------------------------
@interface XMLDictionaryParser () <NSXMLParserDelegate>

@property (nonatomic, strong) NSMutableDictionary *root;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableString *text;

@end


@implementation XMLDictionaryParser

+ (XMLDictionaryParser *)sharedInstance
{
    static dispatch_once_t once;
    static XMLDictionaryParser *sharedInstance;
    dispatch_once(&once, ^{
        
        sharedInstance = [[XMLDictionaryParser alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    if ((self = [super init]))
    {
        _collapseTextNodes = YES;
        _stripEmptyNodes = YES;
        _trimWhiteSpace = YES;
        _alwaysUseArrays = NO;
        _preserveComments = NO;
        _wrapRootNode = NO;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    XMLDictionaryParser *copy = [[[self class] allocWithZone:zone] init];
    copy.collapseTextNodes = _collapseTextNodes;
    copy.stripEmptyNodes = _stripEmptyNodes;
    copy.trimWhiteSpace = _trimWhiteSpace;
    copy.alwaysUseArrays = _alwaysUseArrays;
    copy.preserveComments = _preserveComments;
    copy.attributesMode = _attributesMode;
    copy.nodeNameMode = _nodeNameMode;
    copy.wrapRootNode = _wrapRootNode;
    return copy;
}

- (NSDictionary *)dictionaryWithParser:(NSXMLParser *)parser
{
    [parser setDelegate:self];
    [parser parse];
    id result = _root;
    _root = nil;
    _stack = nil;
    _text = nil;
    return result;
}

- (NSDictionary *)dictionaryWithData:(NSData *)data
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    return [self dictionaryWithParser:parser];
}

- (NSDictionary *)dictionaryWithString:(NSString *)string
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [self dictionaryWithData:data];
}

- (NSDictionary *)dictionaryWithFile:(NSString *)path
{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [self dictionaryWithData:data];
}

+ (NSString *)XMLStringForNode:(id)node withNodeName:(NSString *)nodeName
{
    if ([node isKindOfClass:[NSArray class]])
    {
        NSMutableArray *nodes = [NSMutableArray arrayWithCapacity:[node count]];
        for (id individualNode in node)
        {
            [nodes addObject:[self XMLStringForNode:individualNode withNodeName:nodeName]];
        }
        return [nodes componentsJoinedByString:@"\n"];
    }
    else if ([node isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *attributes = [(NSDictionary *)node attributes];
        NSMutableString *attributeString = [NSMutableString string];
        for (NSString *key in [attributes allKeys])
        {
            [attributeString appendFormat:@" %@=\"%@\"", [[key description] XMLEncodedString], [[attributes[key] description] XMLEncodedString]];
        }
        
        NSString *innerXML = [node innerXML];
        if ([innerXML length])
        {
            return [NSString stringWithFormat:@"<%1$@%2$@>%3$@</%1$@>", nodeName, attributeString, innerXML];
        }
        else
        {
            return [NSString stringWithFormat:@"<%@%@/>", nodeName, attributeString];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"<%1$@>%2$@</%1$@>", nodeName, [[node description] XMLEncodedString]];
    }
}

- (void)endText
{
    if (_trimWhiteSpace)
    {
        _text = [[_text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] mutableCopy];
    }
    if ([_text length])
    {
        NSMutableDictionary *top = [_stack lastObject];
        id existing = top[XMLDictionaryTextKey];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:_text];
        }
        else if (existing)
        {
            top[XMLDictionaryTextKey] = [@[existing, _text] mutableCopy];
        }
        else
        {
            top[XMLDictionaryTextKey] = _text;
        }
    }
    _text = nil;
}

- (void)addText:(NSString *)text
{
    if (!_text)
    {
        _text = [NSMutableString stringWithString:text];
    }
    else
    {
        [_text appendString:text];
    }
}

- (void)parser:(__unused NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [self endText];
    
    NSMutableDictionary *node = [NSMutableDictionary dictionary];
    switch (_nodeNameMode)
    {
        case XMLDictionaryNodeNameModeRootOnly:
        {
            if (!_root)
            {
                node[XMLDictionaryNodeNameKey] = elementName;
            }
            break;
        }
        case XMLDictionaryNodeNameModeAlways:
        {
            node[XMLDictionaryNodeNameKey] = elementName;
            break;
        }
        case XMLDictionaryNodeNameModeNever:
        {
            break;
        }
    }
    
    if ([attributeDict count])
    {
        switch (_attributesMode)
        {
            case XMLDictionaryAttributesModePrefixed:
            {
                for (NSString *key in [attributeDict allKeys])
                {
                    node[[XMLDictionaryAttributePrefix stringByAppendingString:key]] = attributeDict[key];
                }
                break;
            }
            case XMLDictionaryAttributesModeDictionary:
            {
                node[XMLDictionaryAttributesKey] = attributeDict;
                break;
            }
            case XMLDictionaryAttributesModeUnprefixed:
            {
                [node addEntriesFromDictionary:attributeDict];
                break;
            }
            case XMLDictionaryAttributesModeDiscard:
            {
                break;
            }
        }
    }
    
    if (!_root)
    {
        _root = node;
        _stack = [NSMutableArray arrayWithObject:node];
        if (_wrapRootNode)
        {
            _root = [NSMutableDictionary dictionaryWithObject:_root forKey:elementName];
            [_stack insertObject:_root atIndex:0];
        }
    }
    else
    {
        NSMutableDictionary *top = [_stack lastObject];
        id existing = top[elementName];
        if ([existing isKindOfClass:[NSArray class]])
        {
            [existing addObject:node];
        }
        else if (existing)
        {
            top[elementName] = [@[existing, node] mutableCopy];
        }
        else if (_alwaysUseArrays)
        {
            top[elementName] = [NSMutableArray arrayWithObject:node];
        }
        else
        {
            top[elementName] = node;
        }
        [_stack addObject:node];
    }
}

- (NSString *)nameForNode:(NSDictionary *)node inDictionary:(NSDictionary *)dict
{
    if (node.nodeName)
    {
        return node.nodeName;
    }
    else
    {
        for (NSString *name in dict)
        {
            id object = dict[name];
            if (object == node)
            {
                return name;
            }
            else if ([object isKindOfClass:[NSArray class]] && [object containsObject:node])
            {
                return name;
            }
        }
    }
    return nil;
}

- (void)parser:(__unused NSXMLParser *)parser didEndElement:(__unused NSString *)elementName namespaceURI:(__unused NSString *)namespaceURI qualifiedName:(__unused NSString *)qName
{
    [self endText];
    
    NSMutableDictionary *top = [_stack lastObject];
    [_stack removeLastObject];
    
    if (!top.attributes && !top.childNodes && !top.comments)
    {
        NSMutableDictionary *newTop = [_stack lastObject];
        NSString *nodeName = [self nameForNode:top inDictionary:newTop];
        if (nodeName)
        {
            id parentNode = newTop[nodeName];
            if (top.innerText && _collapseTextNodes)
            {
                if ([parentNode isKindOfClass:[NSArray class]])
                {
                    parentNode[[parentNode count] - 1] = top.innerText;
                }
                else
                {
                    newTop[nodeName] = top.innerText;
                }
            }
            else if (!top.innerText && _stripEmptyNodes)
            {
                if ([parentNode isKindOfClass:[NSArray class]])
                {
                    [parentNode removeLastObject];
                }
                else
                {
                    [newTop removeObjectForKey:nodeName];
                }
            }
            else if (!top.innerText && !_collapseTextNodes && !_stripEmptyNodes)
            {
                top[XMLDictionaryTextKey] = @"";
            }
        }
    }
}

- (void)parser:(__unused NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [self addText:string];
}

- (void)parser:(__unused NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    [self addText:[[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding]];
}

- (void)parser:(__unused NSXMLParser *)parser foundComment:(NSString *)comment
{
    if (_preserveComments)
    {
        NSMutableDictionary *top = [_stack lastObject];
        NSMutableArray *comments = top[XMLDictionaryCommentsKey];
        if (!comments)
        {
            comments = [@[comment] mutableCopy];
            top[XMLDictionaryCommentsKey] = comments;
        }
        else
        {
            [comments addObject:comment];
        }
    }
}

@end


@implementation NSDictionary(XMLDictionary)

+ (NSDictionary *)dictionaryWithXMLParser:(NSXMLParser *)parser
{
    return [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithParser:parser];
}

+ (NSDictionary *)dictionaryWithXMLData:(NSData *)data
{
    return [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithData:data];
}

+ (NSDictionary *)dictionaryWithXMLString:(NSString *)string
{
    return [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithString:string];
}

+ (NSDictionary *)dictionaryWithXMLFile:(NSString *)path
{
    return [[[XMLDictionaryParser sharedInstance] copy] dictionaryWithFile:path];
}

- (NSDictionary *)attributes
{
    NSDictionary *attributes = self[XMLDictionaryAttributesKey];
    if (attributes)
    {
        return [attributes count]? attributes: nil;
    }
    else
    {
        NSMutableDictionary *filteredDict = [NSMutableDictionary dictionaryWithDictionary:self];
        [filteredDict removeObjectsForKeys:@[XMLDictionaryCommentsKey, XMLDictionaryTextKey, XMLDictionaryNodeNameKey]];
        for (NSString *key in [filteredDict allKeys])
        {
            [filteredDict removeObjectForKey:key];
            if ([key hasPrefix:XMLDictionaryAttributePrefix])
            {
                filteredDict[[key substringFromIndex:[XMLDictionaryAttributePrefix length]]] = self[key];
            }
        }
        return [filteredDict count]? filteredDict: nil;
    }
    return nil;
}

- (NSDictionary *)childNodes
{
    NSMutableDictionary *filteredDict = [self mutableCopy];
    [filteredDict removeObjectsForKeys:@[XMLDictionaryAttributesKey, XMLDictionaryCommentsKey, XMLDictionaryTextKey, XMLDictionaryNodeNameKey]];
    for (NSString *key in [filteredDict allKeys])
    {
        if ([key hasPrefix:XMLDictionaryAttributePrefix])
        {
            [filteredDict removeObjectForKey:key];
        }
    }
    return [filteredDict count]? filteredDict: nil;
}

- (NSArray *)comments
{
    return self[XMLDictionaryCommentsKey];
}

- (NSString *)nodeName
{
    return self[XMLDictionaryNodeNameKey];
}

- (id)innerText
{
    id text = self[XMLDictionaryTextKey];
    if ([text isKindOfClass:[NSArray class]])
    {
        return [text componentsJoinedByString:@"\n"];
    }
    else
    {
        return text;
    }
}

- (NSString *)innerXML
{
    NSMutableArray *nodes = [NSMutableArray array];
    
    for (NSString *comment in [self comments])
    {
        [nodes addObject:[NSString stringWithFormat:@"<!--%@-->", [comment XMLEncodedString]]];
    }
    
    NSDictionary *childNodes = [self childNodes];
    for (NSString *key in childNodes)
    {
        [nodes addObject:[XMLDictionaryParser XMLStringForNode:childNodes[key] withNodeName:key]];
    }
    
    NSString *text = [self innerText];
    if (text)
    {
        [nodes addObject:[text XMLEncodedString]];
    }
    
    return [nodes componentsJoinedByString:@"\n"];
}

- (NSString *)XMLString
{
    
    if ([self count] == 1 && ![self nodeName])
    {
        //ignore outermost dictionary
        return [self innerXML];
    }
    else
    {
        return [XMLDictionaryParser XMLStringForNode:self withNodeName:[self nodeName] ?: @"xml"];
    }
}

- (NSArray *)arrayValueForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if (value && ![value isKindOfClass:[NSArray class]])
    {
        return @[value];
    }
    return value;
}

- (NSString *)stringValueForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if ([value isKindOfClass:[NSArray class]])
    {
        value = [value count]? value[0]: nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return [(NSDictionary *)value innerText];
    }
    return value;
}

- (NSDictionary *)dictionaryValueForKeyPath:(NSString *)keyPath
{
    id value = [self valueForKeyPath:keyPath];
    if ([value isKindOfClass:[NSArray class]])
    {
        value = [value count]? value[0]: nil;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return @{XMLDictionaryTextKey: value};
    }
    return value;
}

@end


@implementation NSString (XMLDictionary)

- (NSString *)XMLEncodedString
{	
    return [[[[[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
               stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
              stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"]
             stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
            stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"];
}

@end


