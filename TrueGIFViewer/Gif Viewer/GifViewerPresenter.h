//
//  GifViewerPresenter.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifViewerPresenter_h
#define GifViewerPresenter_h

#import "GifViewerProtocols.h"
#import "ApiClient.h"

@interface GifViewerPresenter: NSObject<GifViewerPresentable>

@property (nonatomic, weak, readonly) id<GifViewerViewable> view;

-(instancetype)initWithApiClient: (id<ApiClient>) apiClient
                            view: (id<GifViewerViewable>) view;

@end

#endif /* GifDecompositionViewPresenter_h */
