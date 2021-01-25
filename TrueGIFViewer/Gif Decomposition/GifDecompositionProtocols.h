//
//  GifDecompositionProtocols.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifDecompositionProtocols_h
#define GifDecompositionProtocols_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GifSearchItem.h"

#pragma mark - Presenter
@protocol GifDecompositionPresentable

-(void)setSearch: (NSString*) string;
-(void)loadNextPage;

@end

#pragma mark - View
@protocol GifDecompositionViewable

-(void)setIsLoaded;
-(void)setIsLoadingProgress;
-(void)showItems: (NSArray<GifSearchItem*>*) items;
-(void)addNextItems: (NSArray<GifSearchItem*>*) items;
-(void)showNoItemsWith: (NSString*) search;

@end

#endif /* GifDecompositionProtocols_h */
