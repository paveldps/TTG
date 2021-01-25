//
//  GifCollectionViewCell.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/24/21.
//

#import <UIKit/UIKit.h>

@interface GifCollectionViewCell: UICollectionViewCell

-(void)updateURL:(NSURL*)url estimatedSize:(CGSize)size;

@end
