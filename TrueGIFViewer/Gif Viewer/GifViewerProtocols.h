//
//  GifDecompositionProtocols.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifViewerProtocols_h
#define GifViewerProtocols_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GifSearchItem.h"
#import "GifViewerProtocols.h"

#pragma mark - Presenter
@protocol GifViewerPresentable

-(void)setSearch: (NSString*) string;
-(void)loadNextPage;

@end

#pragma mark - View
@protocol GifViewerViewable

-(void)attachPresenter: (id<GifViewerPresentable>) presenter;
-(void)setIsLoaded;
-(void)setIsLoadingProgress;
-(void)showItems: (NSArray<GifSearchItem*>*) items;
-(void)addNextItems: (NSArray<GifSearchItem*>*) items;
-(void)showNoItemsWith: (NSString*) search;

@end

#endif /* GifDecompositionProtocols_h */
