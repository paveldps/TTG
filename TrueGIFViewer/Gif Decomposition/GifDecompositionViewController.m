//
//  GifDecompositionViewController.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionViewController.h"

@implementation GifDecompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blueColor];
}

-(void)setIsLoaded {
    NSLog(@"View: is loaded");
}

-(void)setIsLoadingProgress {
    NSLog(@"View: is in progress");
}

-(void)setItems: (NSArray<UIImage*>*) items {
    NSLog(@"View: set array");
}

@end
