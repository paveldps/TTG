//
//  GifSearchItem.h
//  TrueGIFViewer
//
//  Created by Pavel Daineka on 1/25/21.
//

#ifndef GifSearchItem_h
#define GifSearchItem_h

#import <Foundation/Foundation.h>

@interface GifSearchItem : NSObject

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong) NSURL* originalUrl;

@end

#endif /* GifSearchItem_h */
