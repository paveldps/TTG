//
//  GifDecompositionViewController.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#ifndef GifDecompositionViewController_h
#define GifDecompositionViewController_h

#import "GifDecompositionProtocols.h"

@interface GifDecompositionViewController: UIViewController<GifDecompositionViewable>

@property(nonatomic) id<GifDecompositionPresentable> presenter;

@end

#endif /* GifDecompositionViewController_h */
