//
//  AppDelegate.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "AppDelegate.h"
#import "GifViewerProtocols.h"
#import "GifViewerViewController.h"
#import "GifViewerPresenter.h"
#import "GiphyApiClient.h"
#import "ApiClient.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GiphyApiClient *apiClient = [GiphyApiClient new];
    GifViewerViewController* view = [GifViewerViewController new];
    GifViewerPresenter *presenter = [[GifViewerPresenter alloc] initWithApiClient:apiClient view:view];
    
    [view attachPresenter:presenter];
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self.window setRootViewController: navigation];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
