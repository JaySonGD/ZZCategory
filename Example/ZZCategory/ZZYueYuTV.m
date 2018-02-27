//
//  ZZYueYuTV.m
//  ZZCategory_Example
//
//  Created by Jay on 2018/2/26.
//  Copyright © 2018年 czljcb@163.com. All rights reserved.
//

#import "ZZYueYuTV.h"


@implementation ZZYueYuTV

+ (void)getTVM3u8:(NSString *)urlStr block: (void(^)(NSArray *))block{
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36

    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        
        
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        
        
        NSString *dataRegex = @"<div class=\"player\"><script type=\"text/javascript\" src=\"(.*?)\">.*?</div>";
        NSString *dataStr = [self matchString:searchText toRegexString:dataRegex].lastObject;
        NSString *url = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", dataStr];
        
        NSString *m3u8 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:gb2312 error:NULL];
        
        
        NSString *hlsRegex = @"\\$.*?\\$";
        NSArray *hls = [self matchString:m3u8 toRegexString:hlsRegex];
        NSString *hlssRegex = @"\\$(.*?)\\$";

        NSMutableArray *temp = [NSMutableArray array];
        for (NSString *string in hls) {
            NSString *hlsString = [self matchString:string toRegexString:hlssRegex].lastObject;
            [temp addObject:hlsString];
        }

        
        !(block)? : block(temp);
        
        
    }];
    //开启网络任务
    [task resume];
    
}

+ (void)getTVDetail:(NSString *)urlStr block: (void(^)(NSDictionary *))block{
    
    
    NSURL * url = [NSURL URLWithString:urlStr];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        
        
        
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        
        
        NSString *iconRegex = @"<img src=\"(.*?)\" alt=\".*?\" class=\"pic l\" />";
        NSString *icon = [self matchString:searchText toRegexString:iconRegex].lastObject;
        
        NSString *nameRegex = @"<h1>(.*?)</h1>";
        NSString *name = [self matchString:searchText toRegexString:nameRegex].lastObject;

        NSString *mainShow = @"<a href=\".*?\">(.*?)</a>&nbsp;&nbsp;";
        NSArray *mains = [self matchString:searchText toRegexString:mainShow];

        NSMutableString *main = [NSMutableString string];
        for (NSInteger i = 1;i < mains.count; i+=2) {
            [main appendString:mains[i]];
        }
        
        
        NSString *statusRegex = @"<font class=\"note\">(.*?)</font>";
        NSString *status = [self matchString:searchText toRegexString:statusRegex].lastObject;
        

        NSString *typeRegex = @"<p>类型：(.*?)</p>";
        NSString *type = [self matchString:searchText toRegexString:typeRegex].lastObject;
        
        NSString *desRegex = @"<div class=\"description\">&nbsp;(.*?)</div>";
        NSString *des = [self matchString:searchText toRegexString:desRegex].lastObject;

        
        NSString *hlsRegex = @"<li><a .?title=\'.*?\' href=\'.*?\' target=\"_self\">.*?</a>";
        NSString *m3u8Regex = @"<li><a .?title=\'(.*?)\' href=\'(.*?)\' target=\"_self\">.*?</a>";
        NSArray *hlss = [self matchString:searchText toRegexString:hlsRegex];
        
        NSMutableArray *m3u8s = [NSMutableArray array];
        for (NSString *hlsHtml in hlss) {
            NSArray *urls = [self matchString:hlsHtml toRegexString:m3u8Regex];
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"title"] = urls[1];
            dict[@"url"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", urls[2]];
            [m3u8s addObject:dict];
        }

        
        
        
        NSLog(@"%s", __func__);
        
        
        
        NSDictionary *obj = @{
                              @"icon":icon?icon : @"",
                              @"name":name?name : @"",
                              @"status":status? status : @"",
                              @"type":type?type : @"",
                              @"des":des? des : @"",
                              @"hls":m3u8s? m3u8s : @[],
                              @"main" : main? main:@"",


                              };
        !(block)? : block(obj);
        
        
    }];
    //开启网络任务
    [task resume];
    
}


+ (void)getHKTVPage:(NSInteger)page block: (void(^)(NSArray <NSDictionary *>*))block{
    
    
    NSString *str = @"http://m.yueyuwz.com/feifan/feifan7710.html";
    if (page > 1) {
        str = [NSString stringWithFormat:@"http://m.yueyuwz.com/feifan/feifan7710_%ld.html",(long)page];
    }
    
    NSURL * url = [NSURL URLWithString:str];
    //创建请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //    User-Agent: Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36
    
    [request setValue:@"Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/63.0.3239.132 Mobile Safari/537.36" forHTTPHeaderField:@"User-Agent"];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        
        
        
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:gb2312]);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        
        
        
        NSString *rString = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\".*?\" alt=\".*?\" /></a><p><a href=\".*?\">.*?</a></p></li>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
        NSLog(@"%s", __func__);
        NSString *rS = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\"(.*?)\" alt=\".*?\" /></a><p><a href=\"(.*?)\">(.*?)</a></p></li>";
        
        
        NSMutableArray *temps = [NSMutableArray array];
        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            if (d.count < 4) {
                continue;
            }
            NSLog(@"%s--%@", __func__,d);
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[@"icon"] = d[1];
            dict[@"url"] = [NSString stringWithFormat:@"http://m.yueyuwz.com%@", d[2]];
            dict[@"name"] = d[3];
            [temps addObject:dict];

            
        }
        
        !(block)? : block(temps);

        
    }];
    //开启网络任务
    [task resume];

}

+ (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
{
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //match: 所有匹配到的字符,根据() 包含级
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSTextCheckingResult *match in matches) {
        
        for (int i = 0; i < [match numberOfRanges]; i++) {
            //以正则中的(),划分成不同的匹配部分
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            
            [array addObject:component];
            
        }
        
    }
    
    return array;
}


@end
