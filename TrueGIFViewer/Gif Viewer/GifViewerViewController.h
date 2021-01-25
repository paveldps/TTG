//
//  GifDecompositionViewController.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import <UIKit/UIKit.h>
#import "GifViewerProtocols.h"

#ifndef GifDecompositionViewController_h
#define GifDecompositionViewController_h

@interface GifViewerViewController : UIViewController<GifViewerViewable>

@property (nonatomic, strong) id<GifViewerPresentable> presenter;

@end

#endif /* GifDecompositionViewController_h */

