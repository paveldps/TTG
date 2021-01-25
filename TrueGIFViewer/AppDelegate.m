//
//  AppDelegate.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "AppDelegate.h"
#import "GifDecompositionProtocols.h"
#import "GifDecompositionViewController.h"
#import "GifDecompositionPresenter.h"
#import "GiphyApiClient.h"
#import "ApiClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    id<ApiClient> apiClient = [GiphyApiClient new];
    
    GifDecompositionViewController *view = [[GifDecompositionViewController alloc] init];
    GifDecompositionPresenter *presenter = [[GifDecompositionPresenter alloc] initWithApiClient:apiClient view:view];
    
    view.presenter = presenter;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self.window setRootViewController: navigation];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
