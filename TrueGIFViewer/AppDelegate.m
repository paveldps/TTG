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

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    GifDecompositionViewController *view = [[GifDecompositionViewController alloc] init];
    GifDecompositionPresenter *presenter = [[GifDecompositionPresenter alloc] init];
    
    view.presenter = presenter;
    presenter.view = view;
    
    [self.window setRootViewController: view];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
