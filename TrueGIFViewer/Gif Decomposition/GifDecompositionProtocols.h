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

// MARK: - Presenter
@protocol GifDecompositionPresentable

-(void)setSearch: (NSString*) string;

@end

// MARK: - View
@protocol GifDecompositionViewable

-(void)setIsLoaded;
-(void)setIsLoadingProgress;
-(void)showItems: (NSArray<GifSearchItem*>*) items;
-(void)showNoItemsWith: (NSString*) search;

@end


#endif /* GifDecompositionProtocols_h */
