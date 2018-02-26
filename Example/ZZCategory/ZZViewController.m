//
//  ZZViewController.m
//  ZZCategory
//
//  Created by czljcb@163.com on 02/05/2018.
//  Copyright (c) 2018 czljcb@163.com. All rights reserved.
//

#import "ZZViewController.h"

#import "ZViewController.h"

#import <ZZCategory/ZZCategory.h>

@interface ZZViewController ()<SFSafariViewControllerDelegate>

@end

@implementation ZZViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    ZViewController * sf = [[ZViewController alloc] initWithURL:[NSURL URLWithString:@"http://m.91kds.net/jiemu_gdty.html"]];
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
