//
//  GifCollectionViewCell.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GifCollectionViewCell : UICollectionViewCell

-(void)updateURL: (NSURL*) url estimatedSize: (CGSize) size;

@end

NS_ASSUME_NONNULL_END
