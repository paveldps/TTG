//
//  GifCollectionViewCell.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/24/21.
//

#import "GifCollectionViewCell.h"
#import "SDWebImage.h"

@interface GifCollectionViewCell ()

@property (nonatomic, strong) SDAnimatedImageView* imageView;

@end

@implementation GifCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        [self configureUI];
    }
    return self;
}

-(void)configureUI {
    // maxBufferSize
    self.contentView.backgroundColor = UIColor.cyanColor;
    
    SDAnimatedImageView* imageView = [SDAnimatedImageView new];
    [self.contentView addSubview: imageView];
    
    [imageView setTranslatesAutoresizingMaskIntoConstraints: FALSE];
    [imageView setMaxBufferSize: 100 * 1024 * 1024];
    
    [imageView.topAnchor constraintEqualToAnchor: self.contentView.topAnchor].active = TRUE;
    [imageView.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor].active = TRUE;
    [imageView.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor].active = TRUE;
    [imageView.bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor].active = TRUE;
    
    imageView.layer.borderColor = [UIColor colorWithWhite: 151.0/255.0 alpha:1.0].CGColor;
    imageView.layer.borderWidth = 0.5f;
    imageView.backgroundColor = UIColor.lightGrayColor;
    
    self.imageView = imageView;
}

-(void)updateURL:(NSURL *)url estimatedSize:(CGSize)size {
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize thumbnailSize = CGSizeMake(size.width * scale, size.height * scale);
    
    [self.imageView sd_setImageWithURL:url
                      placeholderImage:nil
                               options:SDWebImageProgressiveLoad
                               context:@{SDWebImageContextImageThumbnailPixelSize : @(thumbnailSize)}];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self.imageView sd_cancelCurrentImageLoad];
}

@end
