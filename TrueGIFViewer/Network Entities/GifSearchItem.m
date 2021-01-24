//
//  GifSearchItem.m
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#import <Foundation/Foundation.h>
#import "GifSearchItem.h"

@implementation GifSearchItem

-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _originalUrl = dictionary[@"original"][@"url"];
    }
    return self;
}

@end
