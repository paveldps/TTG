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

// MARK: - Presenter
@protocol GifDecompositionPresentable

-(void)setSearch: (NSString*) string;

@end

// MARK: - View
@protocol GifDecompositionViewable

-(void)setIsLoaded;
-(void)setIsLoadingProgress;
-(void)setItems: (NSArray<NSURL*>*) items;

@end


#endif /* GifDecompositionProtocols_h */
