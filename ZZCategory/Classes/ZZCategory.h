
#import <Foundation/Foundation.h>

#import "MBProgressHUD+iShare.h"
#import "UIView+Block.h"
#import "UIView+Loading.h"
#import "NSError+Message.h"
#import "UIButton+Block.h"
#import "UINavigationController+FullscreenPopGesture.h"
#import "UITabBar+CustomBadge.h"
#import "CALayer+PauseAimate.h"

#import "UIColor+Color.h"

#import "UIDevice+Device.h"
#import "UIImage+Image.h"
#import "UIAlertController+Block.h"

#import "UIView+PulseView.h"









#define ZZSingletonH(ClassName) +(instancetype) share##ClassName;


#define ZZSingletonM(ClassName) static id _instance;\
\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
\
return _instance;\
}\
\
\
+(instancetype)share##ClassName\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
\
return _instance;\
}\
\
\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
\
- (id)mutableCopyWithZone:(nullable NSZone *)zone\
{\
return _instance;\
}
