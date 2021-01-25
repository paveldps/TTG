//
//  GifSearchItem.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#import <Foundation/Foundation.h>
#import "GifSearchItem.h"

@implementation GifSearchItem

-(instancetype)initWithOriginalUrl:(NSURL *)url {
    if (self = [super init]) {
        _originalUrl = url;
    }
    return self;
}

@end
