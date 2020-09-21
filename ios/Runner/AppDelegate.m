#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "FlutterNativeSignPlugin.h"
#import "ChannelPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.

    [self registFlutterNativePlugin];

    UIViewController *rootViewController = self.window.rootViewController;
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    nav.navigationBar.hidden = YES;
    self.window.rootViewController = nav;

    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}


/**
* 注册Flutter—Native通信
 */
- (void)registFlutterNativePlugin{
    FlutterViewController *controller = (FlutterViewController *)self.window.rootViewController;
    [[ChannelPlugin shareInstance] registMethod:controller];//获取channel
    [[FlutterNativeSignPlugin shareInstance] registMethod:controller];//电签
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    if (self.allowRotation) {// 支持的屏幕旋转方向
        return UIInterfaceOrientationMaskLandscapeRight;// 如果还要支持其他方向可以 并在后面 ||UIInterfaceOrientationMaskLandscapeRight  如果支持所有的方向，则直接 UIInterfaceOrientationMaskAll
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局仅支持竖屏
}

@end
