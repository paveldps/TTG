//
//  GifDecompositionViewController.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/23/21.
//

#import <UIKit/UIKit.h>
#import "GifDecompositionProtocols.h"

@interface GifDecompositionViewController : UIViewController<GifDecompositionViewable>

@property (nonatomic, strong) id<GifDecompositionPresentable> presenter;

@end
