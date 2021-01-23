//
//  GifDecompositionPresenter.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import "GifDecompositionPresenter.h"

@implementation GifDecompositionPresenter

- (void)setSearch:(NSString *)string {
    NSLog(@"UPDATE Text search");
    
    [self.view setIsLoadingProgress];
    [self.view setItems: @[]];
    [self.view setIsLoaded];
}

@end
