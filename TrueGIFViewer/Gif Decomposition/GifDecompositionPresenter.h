//
//  GifDecompositionPresenter.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifDecompositionViewPresenter_h
#define GifDecompositionViewPresenter_h

#import "GifDecompositionProtocols.h"

@interface GifDecompositionPresenter: NSObject<GifDecompositionPresentable>

@property(weak, nonatomic) id<GifDecompositionViewable> view;

@end

#endif /* GifDecompositionViewPresenter_h */
