//
//  ZZViewController.m
//  ZZCategory
//
//  Created by czljcb@163.com on 02/05/2018.
//  Copyright (c) 2018 czljcb@163.com. All rights reserved.
//

#import "ZZViewController.h"

#import "ZViewController.h"
#import "ZZYueYuTV.h"

#import <ZZCategory/ZZCategory.h>

@interface ZZViewController ()<SFSafariViewControllerDelegate>

@end

@implementation ZZViewController
/**
 *  编码
 */
- (NSString *)URLEncodedString:(NSString *)string
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *unencodedString = string;
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  解码
 */
-(NSString *)URLDecodedString:(NSString *)string
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *encodedString = string;
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(kCFStringEncodingGB_2312_80));
    return decodedString;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //%09%09%09%09%e9%ab%98%e6%b8%85m3u8%24%24%e7%ac%ac01%e9%9b%86%24http%3a%2f%2fv.yongjiujiexi.com%3a80%2f20180221%2f3AGl5HOC%2findex.m3u8%24m3u8%23%e7%ac%ac02%e9%9b%86%24http%3a%2f%2fv.yongjiujiexi.com%3a80%2f20180221%2fJoNIFE8g%2findex.m3u8%24m3u8%22
    [self URLDecodedString:@"%u9AD8%u6E05m3u8%24%24%u7B2C01%u96C6%24http%3A%2F%2Fv.yongjiujiexi.com%3A80%2F20180221%2F3AGl5HOC%2Findex.m3u8%24m3u8%23%u7B2C02%u96C6%24http%3A%2F%2Fv.yongjiujiexi.com%3A80%2F20180221%2FJoNIFE8g%2Findex.m3u8%24m3u8"];

    [ZZYueYuTV getHKTVPage:4 block:^(NSArray<NSDictionary *> * obj) {
        NSLog(@"%s", __func__);
    }];
    
    [ZZYueYuTV getTVDetail:@"http://m.yueyuwz.com/ffhd/ffyy168903.html" block:^(NSDictionary *obj) {
        NSLog(@"%s", __func__);
    }];
    
    [ZZYueYuTV getTVM3u8:@"http://m.yueyuwz.com/xunlei/index149017.html?149017-2-2" block:^(NSArray *obj) {
       NSLog(@"%s", __func__);
    }];

    //创建URL
    NSURL * url = [NSURL URLWithString:@"http://m.yueyuwz.com/feifan/feifan7710.html"];
    //创建请求
    //    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    //创建Session
    NSURLSession * session = [NSURLSession sharedSession];
    //创建任务
    NSURLSessionDataTask * task = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSStringEncoding gb2312 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
        
        


        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:gb2312]);
        NSString *searchText = [[NSString alloc] initWithData:data encoding:gb2312];
        

        
        NSString *rString = @"<li><a href=\".*?\" title=\".*?\" class=\"apic\"><img src=\".*?\" alt=\".*?\" /></a><p><a href=\".*?\">.*?</a></p></li>";
        
        NSArray *rs = [self matchString:searchText toRegexString:rString];
            NSLog(@"%s", __func__);
        NSString *rS = @"<li><a href=\"(.*?)\" title=\"(.*?)\" class=\"apic\"><img src=\"(.*?)\" alt=\"(.*?)\" /></a><p><a href=\"(.*?)\">(.*?)</a></p></li>";

        
        for (NSString *r in rs) {
            NSArray *d = [self matchString:r toRegexString:rS];
            NSLog(@"%s--%@", __func__,d);

        }
        
    

    }];
    //开启网络任务
    [task resume];


    
}

- (NSArray *)matchString:(NSString *)string toRegexString:(NSString *)regexStr
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


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZViewController * sf = [[ZViewController alloc] initWithURL:[NSURL URLWithString:@"http://m.yueyuwz.com/feifan/feifan7710.html"]];
    sf.delegate = self;
    sf.preferredBarTintColor = [UIColor orangeColor];
    sf.preferredControlTintColor = [UIColor lightGrayColor];
    if (@available(iOS 11.0, *)) {
        sf.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
    } else {
        // Fallback on earlier versions
    }
    
    [self presentViewController:sf animated:YES completion:nil];
}

//- (NSArray<UIActivity *> *)safariViewController:(SFSafariViewController *)controller activityItemsForURL:(NSURL *)URL title:(nullable NSString *)title{
//
//}

/*! @abstract Allows you to exclude certain UIActivityTypes from the UIActivityViewController presented when the user taps the action button.
 @discussion Called when the view controller is about to show a UIActivityViewController after the user taps the action button.
 @param URL the URL of the current web page.
 @param title the title of the current web page.
 @result Returns an array of any UIActivityType that you want to be excluded from the UIActivityViewController.
 */
//- (NSArray<UIActivityType> *)safariViewController:(SFSafariViewController *)controller excludedActivityTypesForURL:(NSURL *)URL title:(nullable NSString *)title API_AVAILABLE(ios(11.0)){
//
//}

/*! @abstract 当用户点击“完成”按钮时调用委托回调。 在这个调用之后，视图控制器被模态地解除. */
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*! @abstract Invoked when the initial URL load is complete.
 @param didLoadSuccessfully YES if loading completed successfully, NO if loading failed.
 @discussion This method is invoked when SFSafariViewController completes the loading of the URL that you pass
 to its initializer. It is not invoked for any subsequent page loads in the same SFSafariViewController instance.
 */
- (void)safariViewController:(SFSafariViewController *)controller didCompleteInitialLoad:(BOOL)didLoadSuccessfully{
   
    
    if (didLoadSuccessfully) {
        NSLog(@"%s ---- 加载成功", __func__);
        return;
    }
    NSLog(@"%s---加载失败", __func__);
}

/*！ @abstract当第一页加载完成之前浏览器被重定向到另一个URL时调用。@param URL浏览器重定向到的新URL*/
- (void)safariViewController:(SFSafariViewController *)controller initialLoadDidRedirectToURL:(NSURL *)URL API_AVAILABLE(ios(11.0))

{
    NSLog(@"%s ---- 重定向 ---%@", __func__,URL.absoluteString);
}
@end
