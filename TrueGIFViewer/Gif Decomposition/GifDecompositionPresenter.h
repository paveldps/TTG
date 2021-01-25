//
//  GifDecompositionPresenter.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifDecompositionViewPresenter_h
#define GifDecompositionViewPresenter_h

#import "GifDecompositionProtocols.h"
#import "ApiClient.h"

@interface GifDecompositionPresenter: NSObject<GifDecompositionPresentable>

@property (nonatomic, weak, readonly) id<GifDecompositionViewable> view;

-(instancetype)initWithApiClient: (id<ApiClient>) apiClient
                            view: (id<GifDecompositionViewable>) view;

@end

#endif /* GifDecompositionViewPresenter_h */
